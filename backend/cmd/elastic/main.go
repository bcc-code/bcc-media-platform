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
	index := os.Getenv("ELASTIC_INDEX")

	req := esapi.IndicesCreateRequest{
		Index: index,
		Body:  strings.NewReader(indexSettings),
	}

	ctx := context.Background()

	res, err := req.Do(ctx, es)
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
}

func segmentsToText(segments []segment) string {
	var result string

	for _, s := range segments {
		result = result + fmt.Sprintf(" {%d}", s.ID) + s.Text
	}

	return result
}
