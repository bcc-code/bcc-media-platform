package elastic

import (
	"context"
	"encoding/json"
	"fmt"
	"github.com/ansel1/merry/v2"
	"github.com/bcc-code/mediabank-bridge/log"
	"io"
	"strings"
)

// ErrSearch is an error related to search
var ErrSearch = merry.New("error with search", merry.WithUserMessage("Couldn't complete search"))

// SearchResult contains results and metadata
type SearchResult struct {
	Took     int  `json:"took"`
	TimedOut bool `json:"timed_out"`
	Shards   struct {
		Total      int `json:"total"`
		Successful int `json:"successful"`
		Skipped    int `json:"skipped"`
		Failed     int `json:"failed"`
	} `json:"_shards"`
	Hits struct {
		Total struct {
			Value    int    `json:"value"`
			Relation string `json:"relation"`
		} `json:"total"`
		MaxScore float64 `json:"max_score"`
		Hits     []struct {
			Index     string              `json:"_index"`
			Id        string              `json:"_id"`
			Score     float64             `json:"_score"`
			Highlight map[string][]string `json:"highlight"`
		} `json:"hits"`
	} `json:"hits"`
}

// Search queries the elastic instance.
func (c *Client) Search(ctx context.Context, index string, query string) (SearchResult, error) {
	es := c.es

	res, err := es.Search(
		es.Search.WithContext(ctx),
		es.Search.WithIndex(index),
		es.Search.WithBody(strings.NewReader(toSearchQuery(query))),
	)
	var result SearchResult
	if err != nil {
		return result, err
	}

	if res.IsError() {
		b, _ := io.ReadAll(res.Body)
		log.L.Error().Msg(fmt.Sprint(b))
		return result, ErrSearch
	}

	err = json.NewDecoder(res.Body).Decode(&result)
	return result, err
}
