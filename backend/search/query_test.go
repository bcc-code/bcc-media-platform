package search

import (
	"context"
	"flag"
	"fmt"
	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/log"
	"github.com/elastic/go-elasticsearch/v8/typedapi/types"
	"github.com/rs/zerolog"
	"github.com/stretchr/testify/assert"
	"gopkg.in/guregu/null.v4"
	"math/rand"
	"os"
	"testing"
	"time"
)

var elasticTestsEnabled = false

func TestMain(m *testing.M) {
	flag.BoolVar(&elasticTestsEnabled, "elastic", false, "Enable elastic tests (Requires a local server)")
	flag.Parse()

	log.ConfigureGlobalLogger(zerolog.DebugLevel)

	os.Exit(m.Run())
}

// https://github.com/bcc-code/bcc-media-platform/pull/1021
func Test_ElasticQueryBasic(t *testing.T) {
	rand.Seed(time.Now().UnixNano())
	randomNumber := rand.Intn(1000000000000000)
	testIndexName := fmt.Sprintf("bccm-integration-test-%d", randomNumber)

	ctx := context.Background()
	client := newElasticClient(ctx, ElasticConfig{
		CloudID: CloudId,
		ApiKey:  ApiKey,
	})

	mapping := types.NewNestedProperty()
	mapping.Properties = map[string]types.Property{
		"total": types.NewIntegerNumberProperty(),
		"free":  types.NewIntegerNumberProperty(),
		"used":  types.NewIntegerNumberProperty(),
	}

	client.Indices.Create(testIndexName).Do(ctx)
	//client.Indices.PutMapping(testIndexName).Request(&putmapping.Request{Properties: map[string]types.Property{
	//	"title": mapping,
	//}})

	item := searchItem{
		ID:            "123",
		LegacyID:      nil,
		Published:     true,
		Type:          "",
		Roles:         nil,
		Tags:          nil,
		Image:         nil,
		Title:         common.LocaleString{"en": null.NewString("Jesus", true)},
		Description:   nil,
		Header:        nil,
		AgeRating:     nil,
		Duration:      nil,
		AvailableFrom: 0,
		AvailableTo:   0,
		ShowID:        nil,
		ShowTitle:     nil,
		SeasonID:      nil,
		SeasonTitle:   nil,
	}

	_, err := client.Index(testIndexName).Id(item.ID).Request(item.toSearchObject()).Do(ctx)

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
		testIndexName,
	)

	client.Indices.Delete(testIndexName).Do(ctx)

	assert.NoError(t, err)
	assert.NotNil(t, res)
	assert.Equal(t, 6, res.HitCount)

	t.Skip(fmt.Sprintf("should use %d as index name", randomNumber))

	// If you want to see the results in detail in terminal
	//spew.Dump(res)
}
