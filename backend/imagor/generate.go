package imagor

import (
	"fmt"
	"io"
	"net/http"

	"github.com/ansel1/merry/v2"
	"github.com/cshum/imagor/imagorpath"
)

type ImagorService struct {
	baseUrl    string
	signingKey string
}

// NewImagorService creates a new ImagorService
//
// baseUrl: the base URL of the Imagor service
// signingKey: the key used to sign URLs
func NewImagorService(baseUrl, signingKey string) *ImagorService {
	return &ImagorService{
		baseUrl:    baseUrl,
		signingKey: signingKey,
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

	return resp.Body, nil
}

func (i *ImagorService) executeWithParams(params imagorpath.Params) (*http.Response, error) {
	var path string
	if i.signingKey == "" {
		path = imagorpath.GenerateUnsafe(params)
	} else {
		path = imagorpath.Generate(params, imagorpath.NewDefaultSigner(i.signingKey))
	}
	imagorUrl := fmt.Sprintf("%s/%s", i.baseUrl, path)
	req, err := http.NewRequest("GET", imagorUrl, nil)
	if err != nil {
		return nil, merry.Wrap(err)
	}

	client := http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		return nil, merry.Wrap(err)
	}

	if resp.StatusCode != http.StatusOK {
		return nil, fmt.Errorf("unexpected status code: %d", resp.StatusCode)
	}

	return resp, nil
}
