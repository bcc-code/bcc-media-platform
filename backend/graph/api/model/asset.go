package model

import (
	"context"
	"net/url"
	"path"
	"strconv"
	"time"

	"github.com/aws/aws-sdk-go/service/cloudfront/sign"
	"github.com/bcc-code/bcc-media-platform/backend/common"
)

type signatureProvider interface {
	SignCloudfrontURL(string, string, time.Duration) (string, error)
	SignWithPolicy(string, *sign.Policy) (string, error)
}

type cdnConfig interface {
	GetVOD2Domain() string
}

// FileFrom converts AssetFile rows to the GQL equivalents
func FileFrom(_ context.Context, signer signatureProvider, cdnDomain string, file *common.File) *File {
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

// StreamFrom converts AssetFile rows to the GQL equivalents
func StreamFrom(_ context.Context, signer signatureProvider, cdn cdnConfig, stream *common.Stream) (*Stream, error) {
	signedURL, err := signer.SignCloudfrontURL(stream.Path, cdn.GetVOD2Domain(), streamUrlExpiresAfter)
	if err != nil {
		return nil, err
	}

	expiresAt := time.Now().Add(streamUrlExpiresAfter)

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
