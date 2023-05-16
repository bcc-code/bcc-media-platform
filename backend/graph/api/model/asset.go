package model

import (
	"context"
	"net/url"
	"path"
	"strconv"
	"time"

	"github.com/aws/aws-sdk-go/service/cloudfront/sign"
	"github.com/bcc-code/brunstadtv/backend/common"
)

type signatureProvider interface {
	SignAzureURL(*url.URL, string) (string, error)
	SignCloudfrontURL(string, string) (string, error)
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

	policy := sign.NewCannedPolicy(u.String(), time.Now().Add(time.Hour))

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

// StreamFrom converts AssetFile rows to the GQL equivalents
func StreamFrom(_ context.Context, signer signatureProvider, cdn cdnConfig, stream *common.Stream) (*Stream, error) {
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
		signedURL, err = signer.SignCloudfrontURL(stream.Path, cdn.GetVOD2Domain())
	}

	if err != nil {
		return nil, err
	}

	return &Stream{
		ID:                strconv.Itoa(stream.ID),
		URL:               signedURL,
		AudioLanguages:    stream.AudioLanguages,
		SubtitleLanguages: stream.SubtitleLanguages,
		Type:              StreamType(stream.Type),
	}, nil
}
