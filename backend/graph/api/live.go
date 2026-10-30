package graph

import (
	"context"
	"net/url"
	"slices"
	"strconv"
	"strings"
	"time"

	cache "github.com/Code-Hex/go-generics-cache"
	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/graph/api/model"
	"github.com/bcc-code/bcc-media-platform/backend/log"
	"github.com/bcc-code/bcc-media-platform/backend/memorycache"
	"github.com/bcc-code/bcc-media-platform/backend/streamtoken"
	"github.com/bcc-code/bcc-media-platform/backend/user"
	"github.com/bcc-code/bcc-media-platform/backend/utils"
	"github.com/samber/lo"
)

// livestreamURLExpiry is how long a signed livestream manifest URL stays valid.
// On the proxy path this is the *advertised* expiry — the point at which the
// client should refresh — not the token's lifetime: streamtoken.SignLiveURL
// mints the JWT with extra headroom on top (see its doc comment).
const livestreamURLExpiry = 6 * time.Hour

// maxLivestreamStartAge caps how far in the past the MediaPackage start-over
// `start` tag may point. A program that began earlier than this is joined from
// the cutoff instead, keeping the request inside the origin's start-over window
// (requesting a `start` older than the retained window returns an error).
const maxLivestreamStartAge = 90 * time.Minute

// liveURL is the cached, signed livestream URL plus its expiry. It is not
// user-specific: the stream and signing key are global, so a single cache entry
// serves every permitted caller.
type liveURL struct {
	URL       string
	ExpiresAt string
}

// signedLiveURL signs the configured livestream manifest URL and, when a
// calendar entry is currently in progress — or ended less than bufferLeadOut
// ago, matching the replay buffer's padded view of the program window —
// inserts the AWS Elemental MediaPackage start-over `start` path element so
// playback joins from the program's start (clamped to at most
// maxLivestreamStartAge in the past). The URL is valid for livestreamURLExpiry;
// the returned ExpiresAt is earlier than the token's real expiry (see
// signLiveManifest).
func (r *Resolver) signedLiveURL(ctx context.Context, livestreamURL string) (*liveURL, error) {
	now := time.Now()
	entry, err := r.Queries.GetCurrentCalendarEntry(ctx, now.Add(-bufferLeadOut))
	if err != nil {
		log.L.Error().Err(err).Msg("signedLiveURL: failed to get current calendar entry")
		return nil, err
	}

	var start *time.Time
	if entry != nil {
		s := clampStart(entry.Start, now)
		start = &s
	}

	signedURL, expiresAt, err := r.signLiveManifest(livestreamURL, livestreamURLExpiry, r.pickLiveProvider(ctx))
	if err != nil {
		log.L.Error().Err(err).Str("livestreamURL", livestreamURL).Msg("signedLiveURL: failed to sign livestream URL")
		return nil, err
	}

	if start != nil {
		signedURL = appendTimeShiftTags(signedURL, *start, nil)
	}

	return &liveURL{
		URL:       signedURL,
		ExpiresAt: expiresAt.Format(time.RFC3339),
	}, nil
}

// liveBannerCacheTTL is how long the live banner's calendar lookups are cached.
// The banner is requested on every page load, and a broadcast showing up or
// ending this much late is not noticeable.
const liveBannerCacheTTL = 30 * time.Second

// liveBannerReplayLookback is how far back to look for broadcasts whose
// recording may still be in the Live app. Entries are found by start time, so
// it is the longest buffer window plus a day for the broadcast itself.
const liveBannerReplayLookback = (maxBufferAvailableHours + 24) * time.Hour

// liveBanner points active BCC members to the Live app: "live" while a calendar
// entry is on air and the stream is online, otherwise "replay" while a recently
// ended entry's buffer is still available there (bufferWindowForEntry — the same
// gate the Live app's replay relies on). Nil when neither applies.
func (r *Resolver) liveBanner(ctx context.Context) (*model.LiveBanner, error) {
	if r.LiveAppURL == "" {
		return nil, nil
	}
	ginCtx, err := utils.GinCtx(ctx)
	if err != nil {
		return nil, err
	}
	if u := user.GetFromCtx(ginCtx); u == nil || !u.IsActiveBCC() {
		return nil, nil
	}

	conf, err := withCacheAndTimestamp(ctx, "global_config", r.Queries.GetGlobalConfig, time.Second*30, nil)
	if err != nil {
		return nil, err
	}

	now := time.Now()
	if conf.LiveOnline {
		current, err := memorycache.GetOrSet(ctx, "live_banner:current", func(ctx context.Context) (*common.CalendarEntry, error) {
			return r.Queries.GetCurrentCalendarEntry(ctx, time.Now())
		}, cache.WithExpiration(liveBannerCacheTTL))
		if err != nil {
			return nil, err
		}
		// The cached entry may have ended since it was fetched.
		if current != nil && now.Before(current.End) {
			return r.newLiveBanner(ctx, model.LiveBannerStateLive, current.ID)
		}
	}

	ids, err := memorycache.GetOrSet(ctx, "live_banner:replay_candidates", func(ctx context.Context) ([]int, error) {
		now := time.Now()
		return r.Queries.GetCalendarEntriesForPeriod(ctx, now.Add(-liveBannerReplayLookback), now)
	}, cache.WithExpiration(liveBannerCacheTTL))
	if err != nil {
		return nil, err
	}
	entries, err := r.FilteredLoaders(ctx).CalendarEntryLoader.GetMany(ctx, ids)
	if err != nil {
		return nil, err
	}
	for _, entry := range endedNewestFirst(entries, now) {
		window, err := r.bufferWindowForEntry(ctx, strconv.Itoa(entry.ID))
		if err != nil {
			return nil, err
		}
		if window != nil {
			return r.newLiveBanner(ctx, model.LiveBannerStateReplay, entry.ID)
		}
	}
	return nil, nil
}

// endedNewestFirst returns the entries that have ended by now, most recently
// ended first, skipping nil entries the loader could not find.
func endedNewestFirst(entries []*common.CalendarEntry, now time.Time) []*common.CalendarEntry {
	ended := lo.Filter(entries, func(e *common.CalendarEntry, _ int) bool {
		return e != nil && !now.Before(e.End)
	})
	slices.SortFunc(ended, func(a, b *common.CalendarEntry) int {
		return b.End.Compare(a.End)
	})
	return ended
}

// newLiveBanner loads the calendar entry as the caller sees it (translated
// title etc.) and links it to the Live app. Nil if the entry can't be loaded.
func (r *Resolver) newLiveBanner(ctx context.Context, state model.LiveBannerState, entryID int) (*model.LiveBanner, error) {
	entry, err := r.GetFilteredLoaders(ctx).CalendarEntryLoader.Get(ctx, entryID)
	if err != nil {
		return nil, err
	}
	if entry == nil {
		return nil, nil
	}
	link, err := liveBannerURL(r.LiveAppURL, state, entryID)
	if err != nil {
		return nil, err
	}
	return &model.LiveBanner{
		State: state,
		Entry: model.CalendarEntryFrom(ctx, entry),
		URL:   link,
	}, nil
}

// episodeLiveAppURL is the Live app URL to redirect a meeting episode to while
// its calendar entry is on air or within its buffer window. Nil otherwise.
func (r *Resolver) episodeLiveAppURL(ctx context.Context, episodeID int) (*string, error) {
	if r.LiveAppURL == "" {
		return nil, nil
	}
	ginCtx, err := utils.GinCtx(ctx)
	if err != nil {
		return nil, err
	}
	if u := user.GetFromCtx(ginCtx); u == nil || !u.IsActiveBCC() {
		return nil, nil
	}

	entryIDs, err := r.Loaders.EpisodeCalendarEntriesLoader.Get(ctx, episodeID)
	if err != nil {
		return nil, err
	}
	now := time.Now()
	for _, entryID := range common.MappingValues(entryIDs) {
		window, err := r.bufferWindowForEntry(ctx, strconv.Itoa(entryID))
		if err != nil {
			return nil, err
		}
		if window == nil {
			continue
		}
		state := model.LiveBannerStateReplay
		if now.Before(window.entry.End) {
			state = model.LiveBannerStateLive
		}
		link, err := liveBannerURL(r.LiveAppURL, state, entryID)
		if err != nil {
			return nil, err
		}
		return &link, nil
	}
	return nil, nil
}

// liveBannerURL is the Live app page for the banner state: the live player, or
// the replay of the given calendar entry.
func liveBannerURL(liveAppURL string, state model.LiveBannerState, entryID int) (string, error) {
	if state == model.LiveBannerStateReplay {
		return url.JoinPath(liveAppURL, "replay", strconv.Itoa(entryID))
	}
	return url.JoinPath(liveAppURL, "live")
}

// signedBufferURL signs the configured livestream manifest URL for a specific,
// already-aired calendar entry and inserts the AWS Elemental MediaPackage
// start-over `start` and `end` query parameters so playback is scoped to exactly
// that entry's window. Unlike signedLiveURL it does not clamp the start: the
// buffer is meant to replay the real program window, and the origin's start-over
// retention is expected to cover it.
func (r *Resolver) signedBufferURL(livestreamURL string, start, end, expiresAt time.Time, provider streamtoken.Provider) (string, error) {
	signedURL, _, err := r.signLiveManifest(livestreamURL, time.Until(expiresAt), provider)
	if err != nil {
		log.L.Error().Err(err).Str("livestreamURL", livestreamURL).Msg("signedBufferURL: failed to sign livestream URL")
		return "", err
	}
	return appendTimeShiftTags(signedURL, start, &end), nil
}

// signLiveManifest signs the livestream manifest URL for ttl as a stream-proxy
// URL (multi-CDN via the proxy; provider names the upstream identity, see
// pickLiveProvider). It returns the signed URL and its advertised expiry, before
// any MediaPackage time-shift tags are appended by the caller. That expiry is
// deliberately earlier than the JWT's `exp` claim (see streamtoken.SignLiveURL).
//
// The JWT authorizes the manifest's directory, not the exact query, so the
// caller can safely append `start`/`end` time-shift params to the returned URL
// (see appendTimeShiftTags); the proxy forwards them to the upstream manifest.
func (r *Resolver) signLiveManifest(livestreamURL string, ttl time.Duration, provider streamtoken.Provider) (string, time.Time, error) {
	u, err := url.Parse(livestreamURL)
	if err != nil {
		return "", time.Time{}, err
	}
	return r.StreamURLSigner.SignLiveURL(u.Path, ttl, provider)
}

// clampStart caps start so it points at most maxLivestreamStartAge before now.
// A program that began earlier is joined from the cutoff instead, keeping the
// `start` tag inside the origin's retained start-over window.
func clampStart(start, now time.Time) time.Time {
	if earliest := now.Add(-maxLivestreamStartAge); start.Before(earliest) {
		return earliest
	}
	return start
}

// appendTimeShiftTags appends the AWS Elemental MediaPackage start-over `start`
// query parameter (Unix epoch seconds) to a manifest URL and, when end is
// non-nil, the `end` parameter too — bounding playback to a fixed window, e.g.
//
//	.../out/v1/<id>/index.m3u8  ->  .../out/v1/<id>/index.m3u8?start=1513717228
//	                            ->  ...?start=1513717228&end=1513720828
//
// MediaPackage v2 endpoints accept time-shift only as a query parameter — the
// path-element form (.../start/<time>/index.m3u8) returns 400 there (verified
// against the live egress endpoint). The values are concatenated raw so the
// existing `jwt` query parameter is left untouched; the token authorizes the
// manifest's directory, not the query, so the extra params do not invalidate it.
func appendTimeShiftTags(signedURL string, start time.Time, end *time.Time) string {
	sep := "?"
	if strings.Contains(signedURL, "?") {
		sep = "&"
	}
	out := signedURL + sep + "start=" + strconv.FormatInt(start.Unix(), 10)
	if end != nil {
		out += "&end=" + strconv.FormatInt(end.Unix(), 10)
	}
	return out
}
