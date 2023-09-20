package search

import (
	"github.com/algolia/algoliasearch-client-go/v3/algolia/opt"
	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/user"
	"github.com/gin-gonic/gin"
	"strconv"
	"strings"
)

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
