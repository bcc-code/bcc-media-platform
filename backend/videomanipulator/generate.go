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
func NewVideoManipulatorService(baseUrl, apiKey string) *VideoManipulatorService {
	restyClient := resty.New().
		SetRetryCount(2).
		SetBaseURL(baseUrl).
		SetHeader("x-api-key", apiKey)
	return &VideoManipulatorService{
		baseUrl: baseUrl,
		secret:  apiKey,
		resty:   restyClient,
	}
}

type GenerateImageForUrlParams struct {
	VideoUrl string  `json:"video_url"`
	Seconds  float64 `json:"seconds"`
}

type GenerateImageForUrlResult struct {
	Reader      io.ReadCloser
	ContentType string
}

// GenerateImageForUrl generates an image from a video URL
//
// IMPORTANT: the caller is responsible for closing the returned io.ReadCloser
func (i *VideoManipulatorService) GenerateImageForUrl(params GenerateImageForUrlParams) (*GenerateImageForUrlResult, error) {
	resp, err := i.resty.R().SetDoNotParseResponse(true).SetBody(params).Post("/image")
	if err != nil {
		return nil, merry.Wrap(err)
	}

	if !resp.IsSuccess() {
		return nil, fmt.Errorf("unexpected status code: %d", resp.StatusCode())
	}

	return &GenerateImageForUrlResult{
		Reader:      resp.RawBody(),
		ContentType: resp.Header().Get("Content-Type"),
	}, nil
}
