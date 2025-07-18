package search

import (
	"bytes"
	"context"
	"embed"
	"encoding/json"
	"html/template"
	"math"
	"strconv"
	"strings"
	"time"

	"github.com/algolia/algoliasearch-client-go/v3/algolia/opt"
	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/log"
	"github.com/bcc-code/bcc-media-platform/backend/user"
	"github.com/elastic/go-elasticsearch/v8"
	"github.com/gin-gonic/gin"
)

//go:embed templates/*.json.tmpl
var templateFS embed.FS

var templates *template.Template

func init() {
	t, err := template.ParseFS(templateFS, "templates/*.json.tmpl")

	if err != nil {
		log.L.Fatal().Err(err).Msg("Failed to parse templates")
	}

	templates = t
}

type rankingInfo struct {
	UserScore int `json:"userScore"`
}

type searchHit struct {
	ID              string                 `json:"objectID"`
	Type            string                 `json:"type"`
	LegacyID        *int                   `json:"legacyID"`
	AgeRating       *string                `json:"ageRating"`
	Duration        *int                   `json:"duration"`
	Title           common.LocaleString    `json:"title"`
	Header          string                 `json:"header"`
	Description     common.LocaleString    `json:"description"`
	ShowID          int                    `json:"showID"`
	ShowTitle       common.LocaleString    `json:"showTitle"`
	SeasonID        int                    `json:"seasonID"`
	SeasonTitle     common.LocaleString    `json:"seasonTitle"`
	Image           string                 `json:"image"`
	HighlightResult map[string]interface{} `json:"_highlightResult"`
	RankingInfo     rankingInfo            `json:"_rankingInfo"`
}

// Search sends a search query to the engine and returns related results
func (service *Service) Search(ctx *gin.Context, query common.SearchQuery, userToken string) (searchResult common.SearchResult, err error) {
	roles := user.GetRolesFromCtx(ctx)

	if len(roles) == 0 {
		return
	}

	filterString, err := service.getFiltersForRoles(roles, query.Type)
	if err != nil {
		return
	}

	languages := user.GetLanguagesFromCtx(ctx)

	var highlightFields []string
	for _, field := range getPrimaryTranslatableFields() {
		for _, l := range languages {
			highlightFields = append(highlightFields, field+"_"+l)
		}
	}

	opts := []interface{}{
		opt.Filters(filterString),
		opt.AttributesToHighlight(highlightFields...),
		opt.GetRankingInfo(true),
		opt.UserToken(userToken),
	}
	if query.Limit != nil {
		opts = append(opts, opt.Length(*query.Limit))
	} else {
		opts = append(opts, opt.Length(20))
	}
	if query.Offset != nil {
		opts = append(opts, opt.Offset(*query.Offset))
	} else {
		opts = append(opts, opt.Offset(0))
	}

	result, err := service.index.Search(query.Query,
		opts...,
	)
	if err != nil {
		return
	}
	var hits []searchObject

	err = result.UnmarshalHits(&hits)
	if err != nil {
		return
	}

	searchResult.HitCount = result.NbHits
	searchResult.Page = result.Page
	searchResult.PageCount = result.NbPages
	searchResult.Result = []common.SearchResultItem{}

	for _, rawHit := range hits {
		hit, e := rawHit.toSearchHit()
		if e != nil {
			err = e
			return
		}
		parts := strings.Split(hit.ID, "-")
		model := parts[0]
		id, e := strconv.ParseInt(parts[1], 0, 64)
		if e != nil {
			err = e
			return
		}

		if query.MinScore != nil {
			if hit.RankingInfo.UserScore < *query.MinScore {
				continue
			}
		}

		// TODO: Implement permission checking here as well
		//if !hasAccess() {
		//	continue
		//}

		item := common.SearchResultItem{
			ID:         int(id),
			Collection: model,
		}

		for _, opts := range hit.HighlightResult {
			values := opts.(map[string]interface{})
			if matchLevel := values["matchLevel"]; matchLevel != nil && matchLevel != "none" {
				value := values["value"].(string)
				if item.Highlight != nil {
					str := *item.Highlight + "\n" + value
					item.Highlight = &str
				} else {
					item.Highlight = &value
				}
			}
		}

		if value := hit.Title.Get(languages); value != "" {
			item.Title = value
		}
		if value := hit.Description.GetValueOrNil(languages); value != nil {
			item.Description = value
		}
		if value := hit.Header; value != "" {
			item.Header = &value
		}
		if value := hit.ShowID; value != 0 {
			item.ShowID = &value
		}
		if value := hit.ShowTitle.GetValueOrNil(languages); value != nil {
			item.Show = value
		}
		if value := hit.SeasonID; value != 0 {
			item.SeasonID = &value
		}
		if value := hit.SeasonTitle.GetValueOrNil(languages); value != nil {
			item.Season = value
		}

		item.Url = getUrl(model, int(id))
		if value := hit.Image; value != "" {
			item.Image = &value
		}

		item.LegacyID = hit.LegacyID

		item.Duration = hit.Duration

		searchResult.ResultCount++
		searchResult.Result = append(searchResult.Result, item)
	}
	return
}

type elasticQueryParams struct {
	Roles       []string
	QueryString template.HTML
	Limit       int
	Offset      int
	TimeNow     int64
	Languages   []string

	// AuxLanguages allows to search with the non-primary languages with a lower priority.
	// An example use case is if the user has "BG" as their search language but they search for norwegian words
	// The order of the languages does not matter
	AuxLanguages []string
}

var typeToIndexMap = map[string]string{
	"episode": "bccm-episodes",
	"season":  "bccm-seasons",
	"show":    "bccm-shows",
	"":        "bccm-*",
	"any":     "bccm-*",
}

// doElasticSearch is its own function so that we don't have to deal with gin.Context when testing.
func doElasticSearch(ctx context.Context, client *elasticsearch.TypedClient, query common.SearchQuery, roles []string, languages []string) (common.SearchResult, error) {
	now := time.Now().Unix()

	if len(roles) == 0 {
		// Ensure there is always at least one role, otherwise the part of the query
		// gets ignored and unwanted results are returned
		roles = []string{"guest"}
	}

	templateParams := &elasticQueryParams{
		Roles:        roles,
		QueryString:  template.HTML(template.JSEscapeString(query.Query)),
		TimeNow:      now,
		Offset:       0,
		Limit:        hitsPerPage,
		Languages:    languages,
		AuxLanguages: []string{"no", "de", "en"},
	}

	if query.Limit != nil {
		templateParams.Limit = *query.Limit
	}

	if query.Offset != nil {
		templateParams.Offset = *query.Offset
	}

	jsonQuery := &bytes.Buffer{}

	err := templates.ExecuteTemplate(jsonQuery, "main-elastic.json.tmpl", templateParams)

	searchResult := common.SearchResult{}

	if err != nil {
		log.L.Error().Err(err).Send()
		return common.SearchResult{}, err
	}

	indexName := "bccm-*"
	if query.Type != nil {
		indexName = typeToIndexMap[*query.Type]
	}

	qResult, err := client.Search().Index(indexName).Raw(jsonQuery).Do(ctx)
	if err != nil {
		log.L.Error().Err(err).Send()
		return common.SearchResult{}, err
	}

	searchResult.HitCount = int(qResult.Hits.Total.Value)
	searchResult.Page = int(math.Ceil(float64(templateParams.Offset) / float64(templateParams.Limit)))
	searchResult.PageCount = int(qResult.Hits.Total.Value) / templateParams.Limit
	searchResult.Result = []common.SearchResultItem{}

	for i, rawHit := range qResult.Hits.Hits {
		if i == 0 && rawHit.Score_ != nil {
			searchResult.TopScore = int(*rawHit.Score_)
		}

		obj := &searchObject{}
		err = json.Unmarshal(rawHit.Source_, obj)
		if err != nil {
			return searchResult, err
		}

		hit, err := obj.toSearchHit()
		if err != nil {
			return searchResult, err
		}

		parts := strings.Split(*rawHit.Id_, "-")
		model := parts[0]
		id, err := strconv.ParseInt(parts[1], 0, 64)
		if err != nil {
			return searchResult, err
		}

		item := common.SearchResultItem{
			ID:         int(id),
			Collection: model,
		}

		/*
			// Unsure if this is needed in the short term, I don't know of any place this is used actively

			for _, opts := range hit.HighlightResult {
				values := opts.(map[string]interface{})
				if matchLevel := values["matchLevel"]; matchLevel != nil && matchLevel != "none" {
					value := values["value"].(string)
					if item.Highlight != nil {
						str := *item.Highlight + "\n" + value
						item.Highlight = &str
					} else {
						item.Highlight = &value
					}
				}
			}*/

		if value := hit.Title.Get(languages); value != "" {
			item.Title = value
		}
		if value := hit.Description.GetValueOrNil(languages); value != nil {
			item.Description = value
		}
		if value := hit.Header; value != "" {
			item.Header = &value
		}
		if value := hit.ShowID; value != 0 {
			item.ShowID = &value
		}
		if value := hit.ShowTitle.GetValueOrNil(languages); value != nil {
			item.Show = value
		}
		if value := hit.SeasonID; value != 0 {
			item.SeasonID = &value
		}
		if value := hit.SeasonTitle.GetValueOrNil(languages); value != nil {
			item.Season = value
		}

		item.Url = getUrl(model, int(id))
		if value := hit.Image; value != "" {
			item.Image = &value
		}

		item.LegacyID = hit.LegacyID

		item.Duration = hit.Duration

		searchResult.ResultCount++
		searchResult.Result = append(searchResult.Result, item)
	}

	return searchResult, err
}

// SearchElastic sends a search query to the engine and returns related results
func (service *Service) SearchElastic(ctx *gin.Context, query common.SearchQuery, userToken string) (searchResult common.SearchResult, err error) {
	roles := user.GetRolesFromCtx(ctx)

	if len(roles) == 0 {
		return
	}

	languages := user.GetLanguagesFromCtx(ctx)

	return doElasticSearch(ctx, service.elasticClient, query, roles, languages)
}
