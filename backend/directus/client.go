package directus

import (
	"context"
	"fmt"

	"github.com/ansel1/merry/v2"
	"github.com/go-resty/resty/v2"
	"go.opencensus.io/trace"
)

// New client for Directus
//
// Note: Setting debug to `true` will dump all data sent and recieved as logs
// This may include tokens and other sensitive information. Please only use locally
func New(url, key string, debug bool) *resty.Client {
	rest := resty.New().
		SetBaseURL(url).
		SetAuthToken(key).
		SetRetryCount(5).
		EnableTrace().
		SetDebug(false)
	return rest
}

// DSItem objects provide an id
type DSItem interface {
	UID() int
	TypeName() string
	ForUpdate() interface{}
}

// SaveItem into Directus system
func SaveItem[t DSItem](ctx context.Context, c *resty.Client, i t, unmashall bool) (*t, error) {
	ctx, span := trace.StartSpan(ctx, "directus.SaveItem")
	defer span.End()

	// Define the wrapper structure as DS returns a `{ data: {}}` json
	x := struct {
		Data t
	}{}

	req := c.R()

	if unmashall {
		req.SetResult(x)
	}

	var err error
	var res *resty.Response

	if i.UID() != 0 {
		path := fmt.Sprintf("/items/%s/%d", i.TypeName(), i.UID())
		req.SetBody(i.ForUpdate())
		res, err = req.Patch(path)
	} else {
		path := fmt.Sprintf("/items/%s", i.TypeName())
		req.SetBody(i)
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

// CRUDArrays are a special wrapper in directus for creating and updating many-many relations
type CRUDArrays[t any] struct {
	Create []t   `json:"create"`
	Update []t   `json:"update"`
	Delete []int `json:"delete"`
}
