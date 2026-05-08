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

type proxyHandler struct {
	validator       *jwtValidator
	cfSigner        *signing.Signer
	ioriverSigner   *signing.Signer
	httpc           *http.Client
	cfDomain        string
	ioriverDomain   string
	defaultProvider streamtoken.Provider
	cacheTTL        time.Duration
	signTTL         time.Duration
}

func newProxyHandler(
	validator *jwtValidator,
	cfSigner *signing.Signer,
	ioriverSigner *signing.Signer,
	httpc *http.Client,
	cfg envConfig,
) *proxyHandler {
	return &proxyHandler{
		validator:       validator,
		cfSigner:        cfSigner,
		ioriverSigner:   ioriverSigner,
		httpc:           httpc,
		cfDomain:        cfg.CDNDomainCloudFront,
		ioriverDomain:   cfg.CDNDomainIoriver,
		defaultProvider: cfg.DefaultProvider,
		cacheTTL:        cfg.CacheTTL,
		signTTL:         cfg.SignTTL,
	}
}

// resolveProvider picks the (signer, host) pair the request must use. The JWT
// `provider` claim wins; if absent, fall back to the configured default.
func (h *proxyHandler) resolveProvider(claimProvider streamtoken.Provider) (*signing.Signer, string, error) {
	provider := claimProvider
	if provider == streamtoken.ProviderUnspecified {
		provider = h.defaultProvider
	}
	switch provider {
	case streamtoken.ProviderCloudFront:
		return h.cfSigner, h.cfDomain, nil
	case streamtoken.ProviderIoriver:
		return h.ioriverSigner, h.ioriverDomain, nil
	default:
		return nil, "", fmt.Errorf("unknown provider %q", provider)
	}
}

func (h *proxyHandler) handle(c *gin.Context) {
	token := c.Query("jwt")
	if token == "" {
		c.String(http.StatusBadRequest, "missing jwt query parameter")
		return
	}

	base, claimProvider, err := h.validator.validate(token)
	if err != nil {
		log.L.Debug().Err(err).Msg("jwt validation failed")
		c.String(http.StatusUnauthorized, "invalid jwt")
		return
	}

	signer, host, err := h.resolveProvider(claimProvider)
	if err != nil {
		log.L.Warn().Err(err).Str("provider_claim", string(claimProvider)).Msg("provider resolution failed")
		c.String(http.StatusBadRequest, err.Error())
		return
	}

	reqPath := c.Request.URL.Path
	if !pathUnderBase(reqPath, base) {
		c.String(http.StatusForbidden, "path not under jwt base claim")
		return
	}

	cleaned, upstreamURL, err := h.fetchAndClean(c.Request.Context(), signer, host, reqPath)
	if err != nil {
		log.L.Warn().Err(err).Str("path", reqPath).Str("url", upstreamURL).Msg("failed to fetch playlist from cdn")
		c.String(http.StatusBadGateway, "upstream fetch failed")
		return
	}

	auth, err := h.authStringFor(signer, host, reqPath, token)
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

	c.Data(http.StatusOK, "application/vnd.apple.mpegurl", body)
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

func (h *proxyHandler) fetchAndClean(ctx context.Context, signer *signing.Signer, host, reqPath string) ([]byte, string, error) {
	// Cache key includes the host so a path served by both providers does not
	// collide between the two upstreams.
	cacheKey := "stream-proxy:" + host + ":" + reqPath
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
		cdnURL := exactURL + "?" + query
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
	}, cache.WithExpiration(h.cacheTTL))
	return body, attemptedURL, err
}

func (h *proxyHandler) authStringFor(signer *signing.Signer, host, reqPath, token string) (string, error) {
	if path.Base(reqPath) == indexFilename {
		// Master playlist: keep variant requests routed through this proxy
		// with the same JWT.
		return "jwt=" + url.QueryEscape(token), nil
	}

	// Variant playlists embed segment URLs that the client fetches directly
	// from the CDN. Sign a wildcard for the playlist's containing directory so
	// one signature covers every segment.
	dir := path.Dir(reqPath)
	if !strings.HasSuffix(dir, "/") {
		dir += "/"
	}
	resource := "https://" + host + dir + "*"

	q, err := signer.SignRawQuery(resource, h.signTTL)
	if err != nil {
		return "", err
	}
	if q == "" {
		return "", errors.New("signed query string is empty")
	}
	return q, nil
}
