package imagor

import (
	"fmt"
	"io"

	"github.com/ansel1/merry/v2"
	"github.com/cshum/imagor/imagorpath"
	"github.com/go-resty/resty/v2"
)

type ImagorService struct {
	resty   *resty.Client
	baseUrl string
	secret  string
}

// NewImagorService creates a new ImagorService
func NewImagorService(baseUrl, secret string) *ImagorService {
	restyClient := resty.New().SetBaseURL(baseUrl).SetRetryCount(2)
	return &ImagorService{
		baseUrl: baseUrl,
		secret:  secret,
		resty:   restyClient,
	}
}

type GenerateImageForUrlParams struct {
	VideoUrl string
	Seconds  float64
	// if true, the image will be generated from the exact frame at the specified time, instead of avoiding black frames etc
	ExactFrame bool
}

// GenerateImageForUrl generates an image from a video URL
//
// IMPORTANT: the caller is responsible for closing the returned io.ReadCloser
func (i *ImagorService) GenerateImageForUrl(params GenerateImageForUrlParams) (io.ReadCloser, error) {
	var filters []imagorpath.Filter

	filterName := "seek"
	if params.ExactFrame {
		filterName = "frame"
	}

	filters = append(filters, imagorpath.Filter{
		Name: filterName,
		Args: fmt.Sprintf("%.2fs", params.Seconds),
	})

	p := imagorpath.Params{
		Image:   params.VideoUrl,
		Filters: filters,
	}

	resp, err := i.executeWithParams(p)
	if err != nil {
		return nil, merry.Wrap(err)
	}
	return resp.RawBody(), nil
}

func (i *ImagorService) executeWithParams(params imagorpath.Params) (*resty.Response, error) {
	var path string
	if i.secret == "" {
		path = imagorpath.GenerateUnsafe(params)
	} else {
		path = imagorpath.Generate(params, imagorpath.NewDefaultSigner(i.secret))
	}

	resp, err := i.resty.R().SetDoNotParseResponse(true).Get(path)
	if err != nil {
		return nil, merry.Wrap(err)
	}

	if !resp.IsSuccess() {
		return nil, fmt.Errorf("unexpected status code: %d", resp.StatusCode())
	}

	return resp, nil
}
