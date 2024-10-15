package search

import (
	"context"
	"flag"
	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/log"
	"github.com/rs/zerolog"
	"github.com/stretchr/testify/assert"
	"os"
	"testing"
)

var elasticTestsEnabled = false

func TestMain(m *testing.M) {
	flag.BoolVar(&elasticTestsEnabled, "elastic", false, "Enable elastic tests (Requires a local server)")
	flag.Parse()

	log.ConfigureGlobalLogger(zerolog.DebugLevel)

	os.Exit(m.Run())
}

func Test_ElasticQueryBasic(t *testing.T) {
	if !elasticTestsEnabled {
		t.Skip("Ealstic tests not enabled. Enable with -elastic flag")
	}

	ctx := context.Background()
	client := newElasticClient(ctx, ElasticConfig{
		URL:      "http://localhost:9200/",
		Username: "elastic",
		Password: "bccm123",
	})

	limit := 10
	searchType := "episode"

	res, err := doElasticSearch(ctx, client,
		common.SearchQuery{
			Query: "jesus",
			Limit: &limit,
			Type:  &searchType,
		},
		[]string{
			"bcc-members",
		},
		[]string{
			"no", "en", "de",
		},
	)

	assert.NoError(t, err)
	assert.NotNil(t, res)
	assert.Equal(t, 6, res.HitCount)

	// If you want to see the results in detail in terminal
	//spew.Dump(res)
}
