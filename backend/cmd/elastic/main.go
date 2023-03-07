package main

import (
	"bytes"
	"context"
	_ "embed"
	"encoding/json"
	"fmt"
	"github.com/davecgh/go-spew/spew"
	"github.com/elastic/go-elasticsearch/v8"
	"github.com/elastic/go-elasticsearch/v8/esapi"
	"github.com/elastic/go-elasticsearch/v8/esutil"
	"log"
	"os"
	"strings"
)

type document struct {
	Text     string    `json:"text"`
	Segments []segment `json:"segments"`
	Language string    `json:"language"`
}

type segment struct {
	ID               int     `json:"id"`
	Seek             int     `json:"seek"`
	Start            float64 `json:"start"`
	End              float64 `json:"end"`
	Text             string  `json:"text"`
	Tokens           []int   `json:"tokens"`
	Temperature      float64 `json:"temperature"`
	AvgLogprob       float64 `json:"avg_logprob"`
	CompressionRatio float64 `json:"compression_ratio"`
	NoSpeechProb     float64 `json:"no_speech_prob"`
}

type indexDocument struct {
	Text string `json:"text"`
}

//go:embed index_settings.json
var indexSettings string

func main() {
	es, err := elasticsearch.NewClient(elasticsearch.Config{
		APIKey: os.Getenv("ELASTIC_APIKEY"),
		Addresses: []string{
			os.Getenv("ELASTIC_HOST"),
		},
	})
	if err != nil {
		panic(err)
	}
	ctx := context.Background()

	index := os.Getenv("ELASTIC_INDEX")

	res, err := esapi.IndicesDeleteRequest{
		Index: []string{index},
	}.Do(ctx, es)
	if err != nil {
		panic(err)
	}

	res, err = esapi.IndicesCreateRequest{
		Index: index,
		Body:  strings.NewReader(indexSettings),
	}.Do(ctx, es)
	if err != nil {
		panic(err)
	}

	spew.Dump(res)

	dir, err := os.ReadDir("data")
	if err != nil {
		panic(err)
	}

	bi, err := esutil.NewBulkIndexer(esutil.BulkIndexerConfig{
		Index:  index,
		Client: es,
	})
	if err != nil {
		panic(err)
	}

	for _, e := range dir {
		if !strings.HasSuffix(e.Name(), ".json") {
			continue
		}
		var contents []byte
		contents, err = os.ReadFile(fmt.Sprintf("data/%s", e.Name()))
		if err != nil {
			panic(err)
		}
		var doc document
		_ = json.Unmarshal(contents, &doc)

		marshalled, _ := json.Marshal(indexDocument{
			Text: segmentsToText(doc.Segments),
		})

		err = bi.Add(ctx, esutil.BulkIndexerItem{
			Action:     "index",
			DocumentID: e.Name(),
			Body:       bytes.NewReader(marshalled),
		})
		if err != nil {
			panic(err)
		}
	}

	err = bi.Close(ctx)
	if err != nil {
		panic(err)
	}

	doSearch(ctx, es, index)
}

type searchResult struct {
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
			Index     string  `json:"_index"`
			Id        string  `json:"_id"`
			Score     float64 `json:"_score"`
			Highlight struct {
				Text []string `json:"text"`
			} `json:"highlight"`
		} `json:"hits"`
	} `json:"hits"`
}

func doSearch(ctx context.Context, es *elasticsearch.Client, index string) {
	res, err := es.Search(
		es.Search.WithBody(
			strings.NewReader(
				fmt.Sprintf(`{
	"_source": false,
	"query": {
	    "bool": {
	        "should": [
	           {
	               "match": {
	                   "text": {
	                       "query": "%s",
	                       "boost": 3
	                   }
	               }
	           },
	           {
	               "match": {
	                   "text": {
	                       "query": "%s",
	                       "fuzziness": "AUTO",
	                       "boost": 2
	                   }
	               }
	           }
            ]
	    }
	},
	"size": 10,
	"from": 0,
	"highlight": {
		"order": "score",
		"type": "fvh",
		"boundary_scanner": "word",
		"fields": {
			"text": {}
		}
	}
}`, "gjerrighet", "gjerrighet"),
			),
		),
		es.Search.WithIndex(index),
		es.Search.WithPretty(),
	)

	if err != nil {
		panic(err)
	}
	if res.IsError() {
		var e map[string]interface{}
		if err := json.NewDecoder(res.Body).Decode(&e); err != nil {
			log.Fatalf("Error parsing the response body: %s", err)
		} else {
			// Print the response status and error information.
			log.Fatalf("[%s] %s: %s",
				res.Status(),
				e["error"].(map[string]interface{})["type"],
				e["error"].(map[string]interface{})["reason"],
			)
		}
	}

	fmt.Println(res)

	//var r searchResult
	//
	//_ = json.NewDecoder(res.Body).Decode(&r)
	//
	//spew.Dump(r)
}

func segmentsToText(segments []segment) string {
	var result string

	for _, s := range segments {
		result = result + fmt.Sprintf(" {%d}", s.ID) + s.Text
	}

	return result
}
