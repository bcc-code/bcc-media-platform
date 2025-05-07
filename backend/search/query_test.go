package search

import (
	"bytes"
	"context"
	"encoding/json"
	"flag"
	"fmt"
	"github.com/ansel1/merry/v2"
	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/log"
	"github.com/elastic/go-elasticsearch/v8"
	"github.com/rs/zerolog"
	"github.com/samber/lo"
	"github.com/stretchr/testify/suite"
	"gopkg.in/guregu/null.v4"
	"io"
	"os"
	"testing"
	"time"
)

var elasticTestsEnabled = false

func TestMain(m *testing.M) {
	flag.BoolVar(&elasticTestsEnabled, "elastic", false, "Enable elastic tests (Requires a local server)")
	flag.Parse()

	log.ConfigureGlobalLogger(zerolog.DebugLevel)

	if !elasticTestsEnabled {
		return
	}

	os.Exit(m.Run())
}

type ElasticDocument struct {
	Index    string                 `json:"index"`
	ID       string                 `json:"id"`
	Document map[string]interface{} `json:"document"`
}

func importElasticDocuments(ctx context.Context, client *elasticsearch.TypedClient, filePath string) error {

	for _, index := range Indices.Members() {
		// Delete existing index
		_, _ = client.Indices.Delete(index.Value).Do(ctx)

		indexTemplate := &bytes.Buffer{}

		err := templates.ExecuteTemplate(indexTemplate, "indices.json.tmpl", nil)
		if err != nil {
			return merry.Wrap(err)
		}
		_, err = client.Indices.Create(index.Value).Raw(indexTemplate).Do(ctx)
		if err != nil {
			return fmt.Errorf("failed to create index: %v", err)
		}
	}

	// Open the JSON file
	file, err := os.Open(filePath)
	if err != nil {
		return fmt.Errorf("failed to open file: %v", err)
	}
	defer file.Close()

	// Read the file content
	bytes, err := io.ReadAll(file)
	if err != nil {
		return fmt.Errorf("failed to read file: %v", err)
	}

	// Parse the JSON content
	var documents ImportData
	err = json.Unmarshal(bytes, &documents)
	if err != nil {
		return fmt.Errorf("failed to unmarshal json: %v", err)
	}

	// Index each document
	for _, doc := range documents.Hits.Hits {
		_, err := client.Index(doc.Index).
			Id(doc.ID).
			Request(doc.Source).
			Do(ctx)
		if err != nil {
			return fmt.Errorf("failed to index document: %v", err)
		}
		print(".")
	}

	// Let elasticsearch catch up
	time.Sleep(time.Second * 10)

	return nil
}

func TestElastic(t *testing.T) {
	suite.Run(t, new(ElasticQueryTestSuite))
}

type ElasticQueryTestSuite struct {
	suite.Suite
	client *elasticsearch.TypedClient
	ctx    context.Context
}

func (s *ElasticQueryTestSuite) SetupSuite() {
	s.ctx = context.Background()
	s.client = newElasticClient(s.ctx, ElasticConfig{
		URL:      "http://localhost:9200/",
		Username: "elastic",
		Password: "bccm123",
	})

	//return

	err := importElasticDocuments(s.ctx, s.client, "./testdata/elastic_bccm_dump.json")
	if err != nil {
		log.L.Fatal().Msgf("Failed to import elastic documents: %v", err)
	}

	err = s.insertObject(IndexEpisodes, &common.Permissions[int]{
		ItemID: 1,
		Availability: common.Availability{
			Unlisted:    false,
			Published:   true,
			From:        time.Now().Add(-time.Hour * 24),
			To:          time.Now().Add(time.Hour * 24),
			PublishedOn: time.Now(),
		},
		Roles: common.Roles{
			Access:      []string{"bcc-members"},
			Download:    []string{"bcc-members"},
			EarlyAccess: []string{},
		},
	}, searchItem{
		ID:        "test-1",
		Published: true,
		Type:      "episode",
		Tags:      []string{"tag1", "tag2"},
		Image:     nil,
		Title: common.LocaleString{
			"en": null.StringFrom("The Jesus Episode"),
			"de": null.StringFrom("Test Titel"),
		},
		Description: common.LocaleString{
			"en": null.StringFrom("Test Description"),
			"de": null.StringFrom("Test Beschreibung"),
		},
		Header:        nil,
		AgeRating:     nil,
		Duration:      nil,
		AvailableFrom: 0,
		AvailableTo:   0,
		ShowID:        nil,
		ShowTitle:     nil,
		SeasonID:      nil,
		SeasonTitle:   nil,
		ElasticID:     "ep-1",
	})

	if err != nil {
		s.T().Fatal(err)
	}

	err = s.insertObject(IndexEpisodes, &common.Permissions[int]{
		ItemID: 2,
		Availability: common.Availability{
			Unlisted:    false,
			Published:   true,
			From:        time.Now().Add(-time.Hour * 24),
			To:          time.Now().Add(time.Hour * 24),
			PublishedOn: time.Now(),
		},
		Roles: common.Roles{
			Access:      []string{"bcc-members"},
			Download:    []string{"bcc-members"},
			EarlyAccess: []string{},
		},
	}, searchItem{
		ID:        "test-2",
		Published: true,
		Type:      "episode",
		Tags:      []string{"tag1", "tag2"},
		Image:     nil,
		Title: common.LocaleString{
			"en": null.StringFrom("8e7a6a3b-6e14-4c2d-a47a-bf306d958bd9"),
			"de": null.StringFrom("Test Titel"),
		},
		Description: common.LocaleString{
			"en": null.StringFrom("Test Description"),
			"de": null.StringFrom("Eröffnungsversammlung 7. März"),
			"no": null.StringFrom("BCC Søstrestevnet\n\nSe utdrag fra søstrestevnet med taler av Kåre J. Smith, flere appeller og oppbyggelige innslag."),
		},
		Header:        nil,
		AgeRating:     nil,
		Duration:      nil,
		AvailableFrom: 0,
		AvailableTo:   0,
		ShowID:        nil,
		ShowTitle:     nil,
		SeasonID:      nil,
		SeasonTitle:   nil,
		ElasticID:     "ep-2",
	})

	if err != nil {
		s.T().Fatal(err)
	}

}

func (s *ElasticQueryTestSuite) insertObject(index elasticIndex, perm *common.Permissions[int], obj searchItem) error {
	// The common.Show is just a placeholder as the actual inserted object is returned by the lambda
	return indexObjectElastic(s.ctx, s.client, index, common.Show{}, perm, func(ctx context.Context, show common.Show) (searchItem, error) {
		return obj, nil
	})
}

func (s *ElasticQueryTestSuite) Test_JesusQuery() {
	limit := 10
	searchType := "episode"

	res, err := doElasticSearch(s.ctx, s.client,
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

	s.Assert().NoError(err)
	s.Assert().NotNil(res)
	s.Assert().True(res.HitCount > 200, fmt.Sprintf("Expected more than 200 results, got %d", res.HitCount))
}

func (s *ElasticQueryTestSuite) Test_NoPermissions() {

	// Validate that if we have the role, we can actually access the doc.
	res, err := doElasticSearch(s.ctx, s.client,
		common.SearchQuery{
			Query: "8e7a6a3b-6e14-4c2d-a47a-bf306d958bd9",
		},
		[]string{
			"bcc-members",
		},
		[]string{
			"no", "en", "de",
		})

	s.Assert().NoError(err)
	s.Assert().NotNil(res)
	s.Assert().Equal(1, res.HitCount)

	// Check that we can't access the doc if we don't have the role
	res, err = doElasticSearch(s.ctx, s.client,
		common.SearchQuery{
			Query: "8e7a6a3b-6e14-4c2d-a47a-bf306d958bd9",
		},
		[]string{},
		[]string{
			"no", "en", "de",
		})

	s.Assert().NoError(err)
	s.Assert().NotNil(res)
	s.Assert().Equal(0, res.HitCount)
}

func (s *ElasticQueryTestSuite) Test_ø() {
	res, err := doElasticSearch(s.ctx, s.client,
		common.SearchQuery{
			Query: "sostrestevne",
		},
		[]string{
			"bcc-members",
		},
		[]string{
			"no", "en", "de",
		},
	)

	s.Assert().NoError(err)
	s.Assert().True(res.HitCount > 200)

	show := "show"
	res, err = doElasticSearch(s.ctx, s.client,
		common.SearchQuery{
			Query: "sostrestevne",
			Type:  &show,
		},
		[]string{
			"bcc-members",
		},
		[]string{
			"no", "en", "de",
		},
	)

	s.Assert().NoError(err)
	s.Assert().Equal("BCC Søstrestevnet", res.Result[0].Title)

	episode := "episode"
	res, err = doElasticSearch(s.ctx, s.client,
		common.SearchQuery{
			Query: "sostrestevne",
			Type:  &episode,
		},
		[]string{
			"bcc-members",
		},
		[]string{
			"no", "en", "de",
		},
	)

	s.Assert().NoError(err)

	// Expect the first 8 episodes to be from this show
	for i := 0; i < 8; i++ {
		s.Assert().Equal("BCC Søstrestevnet", *res.Result[i].Show)
	}

}

func (s *ElasticQueryTestSuite) Test_EensureExistingGoodResults() {
	type TestCase struct {
		query                       string
		expectedShows               []string
		expectedEpisodes            []int
		expectedEpisodesInFirstShow int
		languages                   []string
		expectShows                 bool
		expectEpisodes              bool
	}

	tests := []TestCase{
		{
			query: "intro",
			expectedShows: []string{
				"Intro",
			},
			expectedEpisodes:            []int{},
			expectedEpisodesInFirstShow: 10,
			languages: []string{
				"no", "en", "de",
			},
			expectEpisodes: true,
			expectShows:    true,
		},
		{
			query:          "David",
			expectShows:    false,
			expectEpisodes: true,
			languages: []string{
				"no",
			},
			expectedEpisodes: []int{1377, 1945, 1039},
		},
		{
			query:            "Paulus",
			languages:        []string{"no", "en", "de"},
			expectShows:      true,
			expectEpisodes:   true,
			expectedEpisodes: []int{},
			expectedShows: []string{
				"Kampen om Menigheten",
				"Hvem er du Herre?",
			},
		},
		{
			query:            "paske",
			languages:        []string{"no", "en", "de"},
			expectShows:      true,
			expectEpisodes:   true,
			expectedEpisodes: []int{},
			expectedShows: []string{
				"BCC Påskestevnet",
				"BUK Påskecamp",
			},
		},
		{
			query:                       "kampen",
			languages:                   []string{"no"},
			expectShows:                 true,
			expectedShows:               []string{"Kampen om Menigheten"},
			expectEpisodes:              true,
			expectedEpisodes:            nil,
			expectedEpisodesInFirstShow: 2,
		},
		{
			query:                       "det som",
			languages:                   []string{"no"},
			expectShows:                 true,
			expectedShows:               []string{"Det som endret alt"},
			expectEpisodes:              true,
			expectedEpisodes:            nil,
			expectedEpisodesInFirstShow: 4,
		},
	}

	show := "show"
	episode := "episode"

	for _, test := range tests {
		res, err := doElasticSearch(s.ctx, s.client,
			common.SearchQuery{
				Query: test.query,
				Type:  &show,
			},
			[]string{
				"bcc-members",
			},
			test.languages,
		)

		s.Assert().NoError(err)

		var firstShow *common.SearchResultItem
		if test.expectShows {
			s.Assert().True(res.HitCount > 0, fmt.Sprintf("Expected more than 0 results, got %d", res.HitCount))
			firstShow = &res.Result[0]
		}

		expectedCount := 0
		for _, result := range res.Result {
			if len(test.expectedShows) >= expectedCount {
				break
			}

			if lo.Contains(test.expectedShows, result.Title) {
				expectedCount++
			}
		}

		res, err = doElasticSearch(s.ctx, s.client,
			common.SearchQuery{
				Query: test.query,
				Type:  &episode,
			},
			[]string{
				"bcc-members",
			},
			test.languages,
		)

		s.Assert().NoError(err)

		if test.expectEpisodes {
			s.Assert().True(res.HitCount > 0, fmt.Sprintf("Expected more than 0 results, got %d", res.HitCount))
		}

		if firstShow != nil {
			for i := 0; i < test.expectedEpisodesInFirstShow; i++ {
				s.Assert().Contains(firstShow.Title, *res.Result[i].Show)
			}
		}

		for i := 0; i < len(test.expectedEpisodes); i++ {
			s.Assert().Contains(test.expectedEpisodes, res.Result[i].ID)
		}
	}
}

/// IMPORT TYPES:

type ImportData struct {
	Hits Hits `json:"hits"`
}

type Total struct {
	Value    int    `json:"value"`
	Relation string `json:"relation"`
}

type Source struct {
	AgeRating     string   `json:"ageRating"`
	AvailableFrom int      `json:"availableFrom"`
	AvailableTo   int64    `json:"availableTo"`
	DescriptionDa string   `json:"description_da"`
	DescriptionDe string   `json:"description_de"`
	DescriptionEn string   `json:"description_en"`
	DescriptionFr string   `json:"description_fr"`
	DescriptionHu string   `json:"description_hu"`
	DescriptionIt string   `json:"description_it"`
	DescriptionNl string   `json:"description_nl"`
	DescriptionNo string   `json:"description_no"`
	DescriptionPt string   `json:"description_pt"`
	DescriptionRo string   `json:"description_ro"`
	DescriptionTr string   `json:"description_tr"`
	Duration      int      `json:"duration"`
	Header        string   `json:"header"`
	Image         string   `json:"image"`
	LegacyID      int      `json:"legacyID"`
	ObjectID      string   `json:"objectID"`
	Published     bool     `json:"published"`
	Roles         []string `json:"roles"`
	SeasonID      int      `json:"seasonID"`
	SeasonTitleDa string   `json:"seasonTitle_da"`
	SeasonTitleDe string   `json:"seasonTitle_de"`
	SeasonTitleEn string   `json:"seasonTitle_en"`
	SeasonTitleFr string   `json:"seasonTitle_fr"`
	SeasonTitleHu string   `json:"seasonTitle_hu"`
	SeasonTitleIt string   `json:"seasonTitle_it"`
	SeasonTitleNl string   `json:"seasonTitle_nl"`
	SeasonTitleNo string   `json:"seasonTitle_no"`
	SeasonTitlePl string   `json:"seasonTitle_pl"`
	SeasonTitlePt string   `json:"seasonTitle_pt"`
	SeasonTitleRo string   `json:"seasonTitle_ro"`
	SeasonTitleTr string   `json:"seasonTitle_tr"`
	ShowID        int      `json:"showID"`
	ShowTitleDa   string   `json:"showTitle_da"`
	ShowTitleDe   string   `json:"showTitle_de"`
	ShowTitleEn   string   `json:"showTitle_en"`
	ShowTitleFr   string   `json:"showTitle_fr"`
	ShowTitleHu   string   `json:"showTitle_hu"`
	ShowTitleIt   string   `json:"showTitle_it"`
	ShowTitleNl   string   `json:"showTitle_nl"`
	ShowTitleNo   string   `json:"showTitle_no"`
	ShowTitlePl   string   `json:"showTitle_pl"`
	ShowTitlePt   string   `json:"showTitle_pt"`
	ShowTitleRo   string   `json:"showTitle_ro"`
	ShowTitleTr   string   `json:"showTitle_tr"`
	Tags          []string `json:"tags"`
	TitleDa       string   `json:"title_da"`
	TitleDe       string   `json:"title_de"`
	TitleEn       string   `json:"title_en"`
	TitleFr       string   `json:"title_fr"`
	TitleHu       string   `json:"title_hu"`
	TitleIt       string   `json:"title_it"`
	TitleNl       string   `json:"title_nl"`
	TitleNo       string   `json:"title_no"`
	TitlePt       string   `json:"title_pt"`
	TitleRo       string   `json:"title_ro"`
	TitleTr       string   `json:"title_tr"`
	Type          string   `json:"type"`
}
type Hit struct {
	Index  string `json:"_index"`
	ID     string `json:"_id"`
	Source Source `json:"_source,omitempty"`
}
type Hits struct {
	Hits []Hit `json:"hits"`
}
