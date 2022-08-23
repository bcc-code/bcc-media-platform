package gqlmodel

import (
	"context"
	"net/url"
	"path"
	"regexp"
	"strconv"
	"time"

	"github.com/aws/aws-sdk-go/service/cloudfront/sign"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/samber/lo"
)

type signatureProvider interface {
	SignWithPolicy(string, *sign.Policy) (string, error)
}

// FileFrom converts Assetfile rows to the GQL equvivalents
func FileFrom(ctx context.Context, signer signatureProvider, cdnDomain string, file *common.File) *File {
	var subLang *Language
	if file.SubtitleLanguage.Valid {
		l := Language(file.SubtitleLanguage.String)
		subLang = &l
	}

	url := url.URL{
		Path:   file.Path,
		Host:   cdnDomain,
		Scheme: "https",
	}

	policy := sign.NewCannedPolicy(url.String(), time.Now().Add(time.Hour))

	signed, err := signer.SignWithPolicy(url.String(), policy)
	if err != nil {
		panic(err)
	}

	return &File{
		ID:               strconv.Itoa(file.ID),
		URL:              signed,
		FileName:         path.Base(file.Path),
		AudioLanguage:    Language(file.AudioLanguage.String),
		SubtitleLanguage: subLang,
		MimeType:         file.MimeType,
	}
}

// signedStreamURL takes the path and the domain and returns a string with the following properties:
// * HTTPS
// * Unchanged path
// * QueryParameter "EncodedPolicy" with a url encoded string representing full signature parameters,
//   needed for signed urls. The URL specified in the canned policy is truncated to the first 2 folders
//   after the /out/v1/ part
//
// For example: https://CLOUDFLARE-CDN.com/out/v1/2da6f0ab51344ff4a1048741da66d6df/1b5a8f5803a4459eb1bb430f8a79e524/2e0c61ef235f4945813fc7490745c8ff/index.m3u8?EncodedPolicy=<URL ENCODED POLICY>
func signedStreamURL(signer signatureProvider, path string, domain string) (string, error) {
	// We need to sign the directory, else other parts of the stream will not be downloadable
	// In order to do this we chop off everything after the first 4 folders

	// /alksjd/alksdjl/kajshdl/lkajdlkjw/laksjdlkas/laksjdlkajsd/index.m3u8

	re := regexp.MustCompile(`(/out/v1/[a-z0-9]+/[a-z0-9]+)`)
	pathToSign := re.FindString(path)

	// /alksjd/alksdjl/kajshdl/

	urlToSign := url.URL{
		Path:   pathToSign,
		Host:   domain,
		Scheme: "https",
	}

	// https://cdn.com/alksjd/alksdjl/kajshdl/

	// The policy needs to be valid for all sub-documents, that's why the * is added
	// If we add it as part of the path, golang will encode it and the policy will be invalid
	policy := sign.NewCannedPolicy(urlToSign.String()+"/*", time.Now().Add(6*time.Hour))
	signed, err := signer.SignWithPolicy(urlToSign.String(), policy)
	if err != nil {
		return "", err
	}

	// https://cdn.com/alksjd/alksdjl/kajshdl/?Policy=<BASE64>KeyID=lkajsdlkj

	// Extract the query string
	signedURL, err := url.Parse(signed)
	if err != nil {
		return "", err
	}

	// https://cdn.com/alksjd/alksdjl/kajshdl/?Policy=<BASE64>KeyID=lkajsdlkj

	// Add the query string as "EncodedPolicy" parameter to the original path + domain
	url := url.URL{
		RawQuery: "EncodedPolicy=" + url.QueryEscape(signedURL.RawQuery),
		Path:     path,
		Host:     domain,
		Scheme:   "https",
	}

	// https://cdn.com/alksjd/alksdjl/kajshdl/?EncodedPolicy=URLENCODE(Policy=<BASE64>KeyID=lkajsdlkj)

	return url.String(), nil
}

// StreamFrom converts Assetfile rows to the GQL equvivalents
func StreamFrom(ctx context.Context, signer signatureProvider, vod2domain string, stream *common.Stream) (*Stream, error) {
	signedURL, err := signedStreamURL(signer, stream.Path, vod2domain)
	if err != nil {
		return nil, err
	}

	return &Stream{
		ID:                strconv.Itoa(stream.ID),
		URL:               signedURL,
		AudioLanguages:    lo.Map(stream.AudioLanguages, func(s string, _ int) Language { return Language(s) }),
		SubtitleLanguages: lo.Map(stream.SubtitleLanguages, func(s string, _ int) Language { return Language(s) }),
		Type:              StreamType(stream.Type),
	}, nil
}
