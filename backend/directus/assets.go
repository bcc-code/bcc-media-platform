package directus

import (
	"fmt"
	"net/url"
	"strconv"

	"github.com/bcc-code/brunstadtv/backend/common"

	"github.com/ansel1/merry/v2"
	"github.com/go-resty/resty/v2"
)

var (
	// ErrNotFound an error for not finding objects
	ErrNotFound = merry.Sentinel("No object was found")
)

// Asset item in the DB
type Asset struct {
	ID              int           `json:"id,omitempty"`
	Name            string        `json:"name"`
	Duration        int64         `json:"duration"`
	MediabankenID   string        `json:"mediabanken_id"`
	EncodingVersion string        `json:"encoding_version"`
	MainStoragePath string        `json:"main_storage_path"`
	Status          common.Status `json:"status"`
	ARN             string        `json:"aws_arn"`
}

// ForUpdate prepares a copy of the struct for Directus update op
func (a Asset) ForUpdate() interface{} {
	return a
}

// UID returns the id of the Asset
func (a Asset) UID() string {
	if a.ID == 0 {
		return ""
	}
	return strconv.Itoa(a.ID)
}

// TypeName of the item. Statically set to "asset"
func (Asset) TypeName() string {
	return "assets"
}

// FindAssetByAWSArn finds the asset with the specified ARN
func FindAssetByAWSArn(c *resty.Client, arn string) (*Asset, error) {
	q := url.URL{}
	q.Path = "items/assets"

	// Just the newest one
	qq := q.Query()
	qq.Add("limit", "1")
	qq.Add("page", "1")

	qq.Add("fields[]", "id")
	qq.Add("fields[]", "name")
	qq.Add("fields[]", "duration")
	qq.Add("fields[]", "mediabanken_id")
	qq.Add("fields[]", "encoding_version")
	qq.Add("fields[]", "main_storage_path")
	qq.Add("fields[]", "status")
	qq.Add("fields[]", "aws_arn")

	qq.Add("filter", fmt.Sprintf(`{"_and":[{"aws_arn":{"_contains":"%s"}}]}`, arn))

	x := struct {
		Data []Asset
	}{}

	q.RawQuery = qq.Encode()
	req := c.R().SetResult(x)

	res, err := req.Get(q.String())
	if err != nil {
		return nil, merry.Wrap(err)
	}

	assetList := res.Result().(*struct{ Data []Asset })

	if len(assetList.Data) == 0 {
		return nil, merry.Wrap(ErrNotFound, merry.WithValue("arn", arn))
	}

	return &assetList.Data[0], nil
}

// FindNewestAssetByMediabankenID in directus
func FindNewestAssetByMediabankenID(c *resty.Client, mediabankenID string) (*Asset, error) {
	q := url.URL{}
	q.Path = "items/assets"

	// Just the newest one
	qq := q.Query()
	qq.Add("limit", "1")
	qq.Add("page", "1")
	qq.Add("sort", "-date_created") // Newest first

	qq.Add("fields[]", "id")
	qq.Add("fields[]", "main_storage_path")

	qq.Add("filter", fmt.Sprintf(`{"_and":[{"mediabanken_id":{"_eq":"%s"}}, {"status": {"_eq": "%s"}}]}`, mediabankenID, common.StatusPublished))

	x := struct {
		Data []Asset
	}{}

	q.RawQuery = qq.Encode()
	req := c.R().SetResult(x)

	res, err := req.Get(q.String())
	if err != nil {
		return nil, merry.Wrap(err)
	}

	assetList := res.Result().(*struct{ Data []Asset })

	if len(assetList.Data) == 0 {
		return nil, merry.Wrap(ErrNotFound, merry.WithValue("mediabankenID", mediabankenID))
	}

	return &assetList.Data[0], nil
}
