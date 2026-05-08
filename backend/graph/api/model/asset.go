package model

import (
	"context"
	"net/url"
	"path"
	"strconv"
	"time"

	"github.com/aws/aws-sdk-go/service/cloudfront/sign"
	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/streamtoken"
)

type fileSigner interface {
	SignWithPolicy(string, *sign.Policy) (string, error)
}

type streamURLSigner interface {
	SignURL(streamPath string, ttl time.Duration, provider streamtoken.Provider) (string, time.Time, error)
}

// FileFrom converts AssetFile rows to the GQL equivalents
func FileFrom(_ context.Context, signer fileSigner, cdnDomain string, file *common.File) *File {
	var subLang *string
	if file.SubtitleLanguage.Valid {
		l := file.SubtitleLanguage.String
		subLang = &l
	}

	u := url.URL{
		Path:   file.Path,
		Host:   cdnDomain,
		Scheme: "https",
	}

	policy := sign.NewCannedPolicy(u.String(), time.Now().Add(3*time.Hour))

	signed, err := signer.SignWithPolicy(u.String(), policy)
	if err != nil {
		panic(err)
	}

	return &File{
		ID:               strconv.Itoa(file.ID),
		URL:              signed,
		FileName:         path.Base(file.Path),
		AudioLanguage:    file.AudioLanguage.String,
		SubtitleLanguage: subLang,
		MimeType:         file.MimeType,
		Resolution:       &file.Resolution,
		Size:             file.Size,
	}
}

const streamUrlExpiresAfter = 6 * time.Hour

// StreamFrom converts AssetFile rows to the GQL equivalents. The signer mints
// a stream-proxy URL with an HS256 JWT; the proxy validates the JWT and signs
// the upstream CDN request itself.
func StreamFrom(_ context.Context, signer streamURLSigner, stream *common.Stream) (*Stream, error) {
	signedURL, expiresAt, err := signer.SignURL(stream.Path, streamUrlExpiresAfter, streamtoken.ProviderUnspecified)
	if err != nil {
		return nil, err
	}

	return &Stream{
		ID:                strconv.Itoa(stream.ID),
		URL:               signedURL,
		ExpiresAt:         expiresAt.Format(time.RFC3339),
		AudioLanguages:    stream.AudioLanguages,
		SubtitleLanguages: stream.SubtitleLanguages,
		Type:              StreamType(stream.Type),
		Downloadable:      stream.Service == "mediapackage",
		PrimaryMediaType:  PrimaryMediaType(stream.PrimaryMediaType),
	}, nil
}
