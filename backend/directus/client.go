package directus

import (
	"context"
	"fmt"
	"time"

	"strconv"

	"github.com/ansel1/merry/v2"
	"github.com/go-resty/resty/v2"
	"go.opencensus.io/trace"
)

// ErrRequestFailed error for failed requests
var ErrRequestFailed = merry.Sentinel("Request failed")

func ensureSuccess(res *resty.Response) (err error) {
	if res.IsError() {
		err = merry.Wrap(ErrRequestFailed, merry.WithHTTPCode(res.StatusCode()), merry.WithMessage(res.String()))
	}
	return
}

// New client for Directus
//
// Note: Setting debug to `true` will dump all data sent and received as logs
// This may include tokens and other sensitive information. Please only use locally
func New(url, key string, debug bool) *resty.Client {
	rest := resty.New().
		SetBaseURL(url).
		SetAuthToken(key).
		SetRetryCount(10).
		SetRetryMaxWaitTime(15 * time.Second).
		EnableTrace().
		SetDebug(false)
	return rest
}

// NewHandler returns a new Handler with resty.Client in struct
func NewHandler(c *resty.Client) *Handler {
	handler := Handler{
		c,
	}
	return &handler
}

// Handler for handling directus requests
type Handler struct {
	c *resty.Client
}

// DSItem objects provide an id
type DSItem interface {
	UID() string
	TypeName() string
	ForUpdate() interface{}
}

// GetItem by collection and id
func GetItem[t DSItem](ctx context.Context, c *resty.Client, collection string, id int) (item t, err error) {
	ctx, span := trace.StartSpan(ctx, "directus.ListItems")
	defer span.End()

	path := fmt.Sprintf("/items/%s/%d", collection, id)

	req := c.R()
	req.SetResult(struct{ Data t }{})
	res, err := req.Get(path)
	if err != nil {
		return
	}
	err = ensureSuccess(res)
	if err == nil {
		item = res.Result().(*struct{ Data t }).Data
	}
	return
}

// ListItems in collection with optional query params
func ListItems[t DSItem](ctx context.Context, c *resty.Client, collection string, queryParams map[string]string) (items []t, err error) {
	ctx, span := trace.StartSpan(ctx, "directus.ListItems")
	defer span.End()

	path := fmt.Sprintf("/items/%s", collection)

	limit := 100
	offset := 0

	for {
		req := c.R()
		req.SetResult(struct{ Data []t }{})
		req.SetQueryParams(map[string]string{
			"limit":  strconv.Itoa(limit),
			"offset": strconv.Itoa(offset),
		})
		if queryParams != nil {
			for key, value := range queryParams {
				req.SetQueryParam(key, value)
			}
		}
		res, err := req.Get(path)
		if err != nil {
			return nil, err
		}
		err = ensureSuccess(res)
		if err != nil {
			return nil, err
		}

		resultItems := res.Result().(*struct{ Data []t }).Data
		items = append(items, resultItems...)

		if len(resultItems) == limit {
			offset += limit
			continue
		}
		break
	}
	return
}

// CRUDArrays are a special wrapper in directus for creating and updating many-many relations
type CRUDArrays[t any] struct {
	Create []t   `json:"create"`
	Update []t   `json:"update"`
	Delete []int `json:"delete"`
}
