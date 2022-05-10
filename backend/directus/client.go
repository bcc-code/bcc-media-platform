package directus

import (
	"fmt"

	"github.com/ansel1/merry"
	"github.com/go-resty/resty/v2"
)

// New client for Directus
func New(url, key string) *resty.Client {
	rest := resty.New().
		SetBaseURL(url).
		SetAuthToken(key).
		SetRetryCount(5).
		EnableTrace()
	return rest
}

// DSItem objects provide an id
type DSItem interface {
	UID() int
	TypeName() string
}

// SaveItem into Directus system
func SaveItem[t DSItem](c *resty.Client, i t, unmashall bool) (*t, error) {

	// Define the wrapper structure as DS returns a `{ data: {}}` json
	x := struct {
		Data t
	}{}

	// Set up and perform the request
	req := c.R().
		SetBody(i)

	if unmashall {
		req.SetResult(x)
	}

	path := fmt.Sprintf("/items/%s", i.TypeName())

	var err error
	var res *resty.Response

	if i.UID() != 0 {
		res, err = req.Patch(path)
	} else {
		res, err = req.Post(path)
	}

	if err != nil {
		return nil, err
	} else if res.IsError() {
		return nil, merry.New(string(res.Body()))
	}

	if unmashall {
		// Convert the result into a strong type and extract what we actually need
		return &res.Result().(*struct{ Data t }).Data, nil
	}

	return nil, nil
}

// Asset item in the DB
type Asset struct {
	ID              int    `json:"id,omitempty"`
	Name            string `json:"name"`
	Duration        int    `json:"duration"`
	MediabankenID   string `json:"mediabanken_id"`
	EncodingVersion string `json:"encoding_version"`
}

// UID returns the id of the Asset
func (a Asset) UID() int {
	return a.ID
}

// TypeName of the item. Statically set to "asset"
func (Asset) TypeName() string {
	return "assets"
}

// Assetfile item in the DB
type Assetfile struct {
	ID               int    `json:"id,omitempty"`
	Path             string `json:"path"`
	Storage          string `json:"storage"`
	Type             string `json:"type"`
	MimeType         string `json:"mime_type"`
	AssetID          int    `json:"asset_id"`
	ExtraMetadata    string `json:"extra_metadata,omitempty"`
	AudioLanguge     string `json:"audio_language"`
	SubtitleLanguage string `json:"subtitle_language"`
}

// UID returns the id of the Asset
func (a Assetfile) UID() int {
	return a.ID
}

// TypeName of the item. Statically set to "asset"
func (Assetfile) TypeName() string {
	return "assetfiles"
}

// AssetStream item in the DB
type AssetStream struct {
	ID                int                            `json:"id,omitempty"`
	Status            string                         `json:"status,omitempty"`
	Type              string                         `json:"type"`
	URL               string                         `json:"url"`
	Path              string                         `json:"path"`
	Service           string                         `json:"service"`
	AudioLanguges     CRUDArrays[AssetStreamLanguge] `json:"audio_languages"`
	SubtitleLanguages CRUDArrays[AssetStreamLanguge] `json:"subtitle_languages"`
	AssetID           int                            `json:"asset_id"`
}

type CRUDArrays[t any] struct {
	Create []t `json:"create"`
	Update []t `json:"update"`
	Delete []t `json:"delete"`
}

type LanguagesCode struct {
	Code string `json:"code"`
}

type AssetStreamLanguge struct {
	AssetStreamID string        `json:"assetstreams_id"`
	LanguagesCode LanguagesCode `json:"languages_code"`
}

// UID returns the id of the Asset
func (a AssetStream) UID() int {
	return a.ID
}

// TypeName of the item. Statically set to "asset"
func (AssetStream) TypeName() string {
	return "assetstreams"
}

// Stream types
const (
	HLSCmaf = "hls-cmaf"
	HLSTs   = "hls-ts"
	Dash    = "dash"
)
