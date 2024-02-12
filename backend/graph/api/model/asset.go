package model

import (
	"context"
	"net/url"
	"path"
	"strconv"
	"strings"
	"time"

	"github.com/aws/aws-sdk-go/service/cloudfront/sign"
	"github.com/bcc-code/bcc-media-platform/backend/common"
)

type signatureProvider interface {
	SignAzureURL(*url.URL, string) (string, error)
	SignCloudfrontURL(string, string, time.Duration) (string, error)
	SignWithPolicy(string, *sign.Policy) (string, error)
}

type cdnConfig interface {
	GetLegacyVODDomain() string
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
func StreamFrom(_ context.Context, signer signatureProvider, cdn cdnConfig, stream *common.Stream, isShort bool) (*Stream, error) {
	signedURL := ""
	var err error

	if stream.Service == common.StreamServiceAzureMedia {
		streamURL, err := url.Parse(stream.Url)
		if err != nil {
			return nil, err
		}

		streamURL.Host = cdn.GetLegacyVODDomain()
		streamURL.Scheme = "https"

		// This is intentionally hardcoded for now
		manifestURL, _ := url.Parse("https://proxy.brunstad.tv/api/vod/toplevelmanifest")

		q := manifestURL.Query()
		q.Add("playbackUrl", streamURL.String())
		manifestURL.RawQuery = q.Encode()

		signedURL, err = signer.SignAzureURL(manifestURL, stream.EncryptionKeyID.ValueOrZero())
	} else {
		path := stream.Path
		if isShort {
			path = strings.Replace(path, "ab9e7540a3e34bee86ec6af8c7cdc342/1467e3c2761c4947ae7dc7a6c162747f", "7c011f242c6f4875a52e400061ef784a/8df0de9a956c4df9a33b130fe8dbd460", 1)
		}
		signedURL, err = signer.SignCloudfrontURL(path, cdn.GetVOD2Domain(), streamUrlExpiresAfter)
	}

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
	}, nil
}
