package graph

import (
	"context"
	"strconv"
	"strings"
	"time"

	cache "github.com/Code-Hex/go-generics-cache"
	"github.com/bcc-code/bcc-media-platform/backend/memorycache"
)

// livestreamURLExpiry is how long a signed livestream manifest URL stays valid.
const livestreamURLExpiry = 6 * time.Hour

// maxLivestreamStartAge caps how far in the past the MediaPackage start-over
// `start` tag may point. A program that began earlier than this is joined from
// the cutoff instead, keeping the request inside the origin's start-over window
// (requesting a `start` older than the retained window returns an error).
const maxLivestreamStartAge = 90 * time.Minute

// maxLivestreamURLAgeFromStart caps how long after the (clamped) start time a
// signed URL stays valid. It bounds the URL's lifetime to the relevant program
// window rather than the full livestreamURLExpiry.
//
// This is because manifests > 2h grow over the lambda limit.
const maxLivestreamURLAgeFromStart = 2 * time.Hour

// liveURL is the cached, signed livestream URL plus its expiry. It is not
// user-specific: the stream and signing key are global, so a single cache entry
// serves every permitted caller.
type liveURL struct {
	URL       string
	ExpiresAt string
}

// signedLiveURL signs the configured livestream manifest URL and, when a
// calendar entry is currently in progress, inserts the AWS Elemental
// MediaPackage start-over `start` path element so playback joins from the
// program's start (clamped to at most maxLivestreamStartAge in the past). The
// URL's validity is capped at maxLivestreamURLAgeFromStart past that start. The
// result is cached in memory for 2 minutes.
func (r *Resolver) signedLiveURL(ctx context.Context, livestreamURL string) (liveURL, error) {
	return memorycache.GetOrSet(ctx, "live_url", func(ctx context.Context) (liveURL, error) {
		entry, err := r.Queries.GetCurrentCalendarEntry(ctx)
		if err != nil {
			return liveURL{}, err
		}

		now := time.Now()
		var start *time.Time
		if entry != nil {
			s := clampStart(entry.Start, now)
			start = &s
		}

		ttl := livestreamExpiresAt(start, now).Sub(now)
		signedURL, expiresAt, err := r.LivestreamSigner.SignURLCanned(livestreamURL, ttl)
		if err != nil {
			return liveURL{}, err
		}

		if start != nil {
			signedURL = appendStartTag(signedURL, *start)
		}

		return liveURL{
			URL:       signedURL,
			ExpiresAt: expiresAt.Format(time.RFC3339),
		}, nil
	}, cache.WithExpiration(2*time.Minute))
}

// livestreamExpiresAt returns when the signed URL should expire: at most
// livestreamURLExpiry from now and, when a program is in progress, at most
// maxLivestreamURLAgeFromStart from its (clamped) start time.
func livestreamExpiresAt(start *time.Time, now time.Time) time.Time {
	expiresAt := now.Add(livestreamURLExpiry)
	if start != nil {
		if capped := start.Add(maxLivestreamURLAgeFromStart); capped.Before(expiresAt) {
			expiresAt = capped
		}
	}
	return expiresAt
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

// appendStartTag appends the AWS Elemental MediaPackage start-over `start` query
// parameter (Unix epoch seconds) to a manifest URL, e.g.
//
//	.../out/v1/<id>/index.m3u8  ->  .../out/v1/<id>/index.m3u8?start=1513717228
//
// MediaPackage v2 endpoints accept time-shift only as a query parameter — the
// path-element form (.../start/<time>/index.m3u8) returns 400 there (verified
// against the live egress endpoint). The value is concatenated raw rather than
// via url.Values.Encode(), which would double-encode the already
// percent-encoded CloudFront `EncodedPolicy`. The CloudFront canned policy signs
// the resource path, not the query, so the extra param does not invalidate the
// signature.
func appendStartTag(signedURL string, start time.Time) string {
	sep := "?"
	if strings.Contains(signedURL, "?") {
		sep = "&"
	}
	return signedURL + sep + "start=" + strconv.FormatInt(start.Unix(), 10)
}
