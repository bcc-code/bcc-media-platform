package main

import (
	"context"
	"errors"
	"fmt"
	"io"
	"net/http"
	"net/url"
	"path"
	"strings"
	"time"

	cache "github.com/Code-Hex/go-generics-cache"
	"github.com/bcc-code/bcc-media-platform/backend/log"
	"github.com/bcc-code/bcc-media-platform/backend/memorycache"
	"github.com/bcc-code/bcc-media-platform/backend/signing"
	"github.com/bcc-code/bcc-media-platform/backend/streamtoken"
	"github.com/gin-gonic/gin"
)

const indexFilename = "index.m3u8"

// cdnTarget bundles the (signer, host) pairs for one origin's two provider
// identities. The proxy holds one target for VOD and one for live — live is a
// separate MediaPackage origin behind its own CDN distributions / ioriver
// stream, so it needs its own key material and hostnames.
type cdnTarget struct {
	cfSigner      *signing.Signer
	cfDomain      string
	ioriverSigner *signing.Signer
	ioriverDomain string
}

// resolve picks the (signer, host) pair for provider within this target,
// falling back to defaultProvider when the claim is unspecified.
func (t cdnTarget) resolve(provider, defaultProvider streamtoken.Provider) (*signing.Signer, string, error) {
	if provider == streamtoken.ProviderUnspecified {
		provider = defaultProvider
	}
	switch provider {
	case streamtoken.ProviderCloudFront:
		return t.cfSigner, t.cfDomain, nil
	case streamtoken.ProviderIoriver:
		return t.ioriverSigner, t.ioriverDomain, nil
	default:
		return nil, "", fmt.Errorf("unknown provider %q", provider)
	}
}

type proxyHandler struct {
	validator       *jwtValidator
	vod             cdnTarget
	live            cdnTarget
	httpc           *http.Client
	defaultProvider streamtoken.Provider
	cacheTTL        time.Duration
	liveCacheTTL    time.Duration
	signTTL         time.Duration
}

func newProxyHandler(
	validator *jwtValidator,
	vod cdnTarget,
	live cdnTarget,
	httpc *http.Client,
	cfg envConfig,
) *proxyHandler {
	return &proxyHandler{
		validator:       validator,
		vod:             vod,
		live:            live,
		httpc:           httpc,
		defaultProvider: cfg.DefaultProvider,
		cacheTTL:        cfg.CacheTTL,
		liveCacheTTL:    cfg.LiveCacheTTL,
		signTTL:         cfg.SignTTL,
	}
}

func (h *proxyHandler) handle(c *gin.Context) {
	token := c.Query("jwt")
	if token == "" {
		c.String(http.StatusBadRequest, "missing jwt query parameter")
		return
	}

	cl, err := h.validator.validate(token)
	if err != nil {
		log.L.Debug().Err(err).Msg("jwt validation failed")
		c.String(http.StatusUnauthorized, "invalid jwt")
		return
	}

	// Live is a separate origin with its own signers and hosts; the VOD target
	// is used otherwise.
	target := h.vod
	if cl.live {
		target = h.live
	}
	signer, host, err := target.resolve(cl.provider, h.defaultProvider)
	if err != nil {
		log.L.Warn().Err(err).Str("provider_claim", string(cl.provider)).Msg("provider resolution failed")
		c.String(http.StatusBadRequest, err.Error())
		return
	}

	reqPath := c.Request.URL.Path
	if !pathUnderBase(reqPath, cl.base) {
		c.String(http.StatusForbidden, "path not under jwt base claim")
		return
	}

	// Live manifests are rewritten every segment. Forward the MediaPackage
	// start-over params to the upstream (they change the manifest content), key
	// the cache by them, and cache only briefly — see fetchAndClean and the
	// no-store header below. For VOD timeShift is "" and behavior is unchanged.
	var timeShift string
	if cl.live {
		timeShift = timeShiftParams(c)
	}

	cleaned, upstreamURL, err := h.fetchAndClean(c.Request.Context(), signer, host, reqPath, cl.live, timeShift)
	if err != nil {
		log.L.Warn().Err(err).Str("path", reqPath).Str("url", upstreamURL).Msg("failed to fetch playlist from cdn")
		c.String(http.StatusBadGateway, "upstream fetch failed")
		return
	}

	auth, err := h.authStringFor(signer, host, reqPath, token, cl.base)
	if err != nil {
		log.L.Error().Err(err).Str("path", reqPath).Msg("failed to compute auth replacement")
		c.String(http.StatusInternalServerError, "internal error")
		return
	}

	body := []byte(strings.ReplaceAll(string(cleaned), Placeholder, auth))

	// Variant playlists embed segment URLs that the client must fetch directly
	// from the CDN, so the relative URIs need to be rewritten to absolute CDN
	// URLs. The master playlist's variant URIs stay relative — they need to
	// resolve back to the proxy so the JWT can be re-verified per request.
	if path.Base(reqPath) != indexFilename {
		dir := path.Dir(reqPath)
		if !strings.HasSuffix(dir, "/") {
			dir += "/"
		}
		body = absolutizeURIs(body, "https://"+host+dir)
	}

	// Carry the start-over window onto the master playlist's child-manifest
	// (.m3u8) URIs so the variant request reaches the proxy with the same window
	// and it forwards it upstream. Only manifests get the window — segment
	// (.mp4/.ts) requests don't need it (and it would just fragment the cache).
	if cl.live && timeShift != "" && path.Base(reqPath) == indexFilename {
		body = appendTimeShiftToManifestURIs(body, timeShift)
	}

	// Never let a live manifest be cached downstream — the client must re-poll
	// to follow the live edge. VOD keeps the default (no header).
	if cl.live {
		c.Header("Cache-Control", "no-store, max-age=0")
	}

	c.Data(http.StatusOK, "application/vnd.apple.mpegurl", body)
}

// timeShiftParams extracts the MediaPackage start-over params (`start`, `end`)
// from the request as a raw query fragment in a fixed order (so it is stable as
// a cache-key component). Only these two params are forwarded upstream; the
// `jwt` param and anything else are dropped. Returns "" when neither is present.
func timeShiftParams(c *gin.Context) string {
	var parts []string
	if v := c.Query("start"); v != "" {
		parts = append(parts, "start="+url.QueryEscape(v))
	}
	if v := c.Query("end"); v != "" {
		parts = append(parts, "end="+url.QueryEscape(v))
	}
	return strings.Join(parts, "&")
}

// pathUnderBase checks that reqPath is contained by the base prefix. The base
// claim is treated as a path prefix; rejecting `..` in the request path keeps
// us from being tricked into escaping it.
func pathUnderBase(reqPath, base string) bool {
	if strings.Contains(reqPath, "..") {
		return false
	}
	if !strings.HasSuffix(base, "/") {
		base += "/"
	}
	if !strings.HasSuffix(reqPath, "/") && reqPath == strings.TrimSuffix(base, "/") {
		return true
	}
	return strings.HasPrefix(reqPath, base)
}

func (h *proxyHandler) fetchAndClean(ctx context.Context, signer *signing.Signer, host, reqPath string, live bool, timeShift string) ([]byte, string, error) {
	// Cache key includes the host so a path served by both providers does not
	// collide between the two upstreams, and the time-shift window so different
	// start-over windows are cached separately.
	cacheKey := "stream-proxy:" + host + ":" + reqPath
	if timeShift != "" {
		cacheKey += "?" + timeShift
	}
	cacheTTL := h.cacheTTL
	if live {
		cacheTTL = h.liveCacheTTL
	}
	// attemptedURL is set only on cache miss (the closure runs only then), which
	// is also the only path that can produce a non-nil error — so cache-hit
	// callers get "" and never log it.
	var attemptedURL string
	body, err := memorycache.GetOrSet(ctx, cacheKey, func(ctx context.Context) ([]byte, error) {
		exactURL := "https://" + host + reqPath
		query, err := signer.SignRawQuery(exactURL, h.signTTL)
		if err != nil {
			return nil, fmt.Errorf("sign upstream url: %w", err)
		}
		// The CDN signature signs the resource path, not the query, so
		// appending the time-shift params does not invalidate it.
		cdnURL := exactURL + "?" + query
		if timeShift != "" {
			cdnURL += "&" + timeShift
		}
		attemptedURL = cdnURL

		req, err := http.NewRequestWithContext(ctx, http.MethodGet, cdnURL, nil)
		if err != nil {
			return nil, err
		}
		resp, err := h.httpc.Do(req)
		if err != nil {
			return nil, err
		}
		defer resp.Body.Close()

		if resp.StatusCode != http.StatusOK {
			return nil, fmt.Errorf("cdn responded %d", resp.StatusCode)
		}

		raw, err := io.ReadAll(resp.Body)
		if err != nil {
			return nil, err
		}
		return cleanPlaylist(raw), nil
	}, cache.WithExpiration(cacheTTL))
	return body, attemptedURL, err
}

func (h *proxyHandler) authStringFor(signer *signing.Signer, host, reqPath, token, base string) (string, error) {
	if path.Base(reqPath) == indexFilename {
		// Master playlist: keep variant requests routed through this proxy
		// with the same JWT. The live start-over window is appended separately
		// (only to child-manifest URIs) by appendTimeShiftToManifestURIs.
		return "jwt=" + url.QueryEscape(token), nil
	}

	// Sign the asset-root wildcard the JWT already authorizes. MediaPackage
	// scatters segments across sibling directories under <base>, so signing
	// the variant playlist's own path.Dir is too narrow and produces CF 403s
	// on segments that resolve outside that directory.
	resource := "https://" + host + base + "*"

	q, err := signer.SignRawQuery(resource, h.signTTL)
	if err != nil {
		return "", err
	}
	if q == "" {
		return "", errors.New("signed query string is empty")
	}
	return q, nil
}
