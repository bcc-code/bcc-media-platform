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

// CRUDArrays are a special wrapper in directus for creating and updating many-many relations
type CRUDArrays[t any] struct {
	Create []t   `json:"create"`
	Update []int `json:"update"`
	Delete []t   `json:"delete"`
}
