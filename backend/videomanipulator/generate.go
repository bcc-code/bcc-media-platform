package videomanipulator

import (
	"fmt"
	"io"

	"github.com/ansel1/merry/v2"
	"github.com/go-resty/resty/v2"
)

type VideoManipulatorService struct {
	resty   *resty.Client
	baseUrl string
	secret  string
}

// NewVideoManipulatorService creates a new VideoManipulatorService
func NewVideoManipulatorService(baseUrl, secret string) *VideoManipulatorService {
	restyClient := resty.New().SetBaseURL(baseUrl).SetRetryCount(2)
	return &VideoManipulatorService{
		baseUrl: baseUrl,
		secret:  secret,
		resty:   restyClient,
	}
}

type GenerateImageForUrlParams struct {
	VideoUrl string
	Seconds  float64
}

// GenerateImageForUrl generates an image from a video URL
//
// IMPORTANT: the caller is responsible for closing the returned io.ReadCloser
func (i *VideoManipulatorService) GenerateImageForUrl(params GenerateImageForUrlParams) (io.ReadCloser, error) {
	resp, err := i.resty.R().SetDoNotParseResponse(true).SetBody(params).Post("/image")
	if err != nil {
		return nil, merry.Wrap(err)
	}

	if !resp.IsSuccess() {
		return nil, fmt.Errorf("unexpected status code: %d", resp.StatusCode())
	}

	return resp.RawBody(), nil
}
