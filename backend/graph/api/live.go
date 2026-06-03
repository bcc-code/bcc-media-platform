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

// liveURL is the cached, signed livestream URL plus its expiry. It is not
// user-specific: the stream and signing key are global, so a single cache entry
// serves every permitted caller.
type liveURL struct {
	URL       string
	ExpiresAt string
}

// signedLiveURL signs the configured livestream manifest URL and, when a
// calendar entry is currently in progress, appends the AWS Elemental
// MediaPackage start-over `start` parameter so playback joins from the program's
// start. The result is cached in memory for 2 minutes.
func (r *Resolver) signedLiveURL(ctx context.Context, livestreamURL string) (liveURL, error) {
	return memorycache.GetOrSet(ctx, "live_url", func(ctx context.Context) (liveURL, error) {
		signedURL, expiresAt, err := r.LivestreamSigner.SignURLCanned(livestreamURL, livestreamURLExpiry)
		if err != nil {
			return liveURL{}, err
		}

		entry, err := r.Queries.GetCurrentCalendarEntry(ctx)
		if err != nil {
			return liveURL{}, err
		}
		if entry != nil {
			signedURL = appendStartTag(signedURL, entry.Start)
		}

		return liveURL{
			URL:       signedURL,
			ExpiresAt: expiresAt.Format(time.RFC3339),
		}, nil
	}, cache.WithExpiration(2*time.Minute))
}

// appendStartTag appends the AWS Elemental MediaPackage start-over `start` query
// parameter (epoch seconds) to a manifest URL. It concatenates raw rather than
// re-encoding the query string, which would double-encode the already
// percent-encoded CloudFront `EncodedPolicy` value. The CloudFront canned policy
// signs the resource path (not the query), so the appended param does not
// invalidate the signature.
func appendStartTag(signedURL string, start time.Time) string {
	sep := "?"
	if strings.Contains(signedURL, "?") {
		sep = "&"
	}
	return signedURL + sep + "start=" + strconv.FormatInt(start.Unix(), 10)
}
