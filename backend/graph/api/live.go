package graph

import (
	"context"
	"strconv"
	"strings"
	"time"

	"github.com/bcc-code/bcc-media-platform/backend/log"
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
// URL's validity is capped at maxLivestreamURLAgeFromStart past that start.
func (r *Resolver) signedLiveURL(ctx context.Context, livestreamURL string) (liveURL, error) {
	entry, err := r.Queries.GetCurrentCalendarEntry(ctx)
	if err != nil {
		log.L.Error().Err(err).Msg("signedLiveURL: failed to get current calendar entry")
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
		log.L.Error().Err(err).Str("livestreamURL", livestreamURL).Msg("signedLiveURL: failed to sign livestream URL")
		return liveURL{}, err
	}

	if start != nil {
		signedURL = appendTimeShiftTags(signedURL, *start, nil)
	}

	return liveURL{
		URL:       signedURL,
		ExpiresAt: expiresAt.Format(time.RFC3339),
	}, nil
}

// signedBufferURL signs the configured livestream manifest URL for a specific,
// already-aired calendar entry and inserts the AWS Elemental MediaPackage
// start-over `start` and `end` query parameters so playback is scoped to exactly
// that entry's window. Unlike signedLiveURL it does not clamp the start: the
// buffer is meant to replay the real program window, and the origin's start-over
// retention is expected to cover it.
//
// Note: a window (end-start) longer than ~2h hits the same origin/lambda
// manifest-size limit described on maxLivestreamURLAgeFromStart. Entries are
// almost always shorter; revisit (e.g. chunked playback) if long buffers are
// needed rather than truncating the window here.
func (r *Resolver) signedBufferURL(livestreamURL string, start, end, expiresAt time.Time) (string, error) {
	now := time.Now()
	signedURL, _, err := r.LivestreamSigner.SignURLCanned(livestreamURL, expiresAt.Sub(now))
	if err != nil {
		log.L.Error().Err(err).Str("livestreamURL", livestreamURL).Msg("signedBufferURL: failed to sign livestream URL")
		return "", err
	}
	return appendTimeShiftTags(signedURL, start, &end), nil
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

// appendTimeShiftTags appends the AWS Elemental MediaPackage start-over `start`
// query parameter (Unix epoch seconds) to a manifest URL and, when end is
// non-nil, the `end` parameter too — bounding playback to a fixed window, e.g.
//
//	.../out/v1/<id>/index.m3u8  ->  .../out/v1/<id>/index.m3u8?start=1513717228
//	                            ->  ...?start=1513717228&end=1513720828
//
// MediaPackage v2 endpoints accept time-shift only as a query parameter — the
// path-element form (.../start/<time>/index.m3u8) returns 400 there (verified
// against the live egress endpoint). The values are concatenated raw rather than
// via url.Values.Encode(), which would double-encode the already
// percent-encoded CloudFront `EncodedPolicy`. The CloudFront canned policy signs
// the resource path, not the query, so the extra params do not invalidate the
// signature.
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
