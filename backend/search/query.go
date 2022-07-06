package search

import (
	"github.com/algolia/algoliasearch-client-go/v3/algolia/opt"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/user"
	"github.com/gin-gonic/gin"
	"strconv"
	"strings"
)

type searchHit struct {
	ID              string                 `json:"objectID"`
	Title           localeString           `json:"title"`
	Header          string                 `json:"header"`
	Description     localeString           `json:"description"`
	ShowID          int                    `json:"showID"`
	ShowTitle       localeString           `json:"showTitle"`
	SeasonID        int                    `json:"seasonID"`
	SeasonTitle     localeString           `json:"seasonTitle"`
	Image           string                 `json:"image"`
	HighlightResult map[string]interface{} `json:"_highlightResult"`
}

// TODO: Get user default language
func getUserLanguage() string {
	return defaultLanguage
}

func (service *Service) Search(ctx *gin.Context, query common.SearchQuery) (searchResult common.SearchResult, err error) {
	language := getUserLanguage()

	u := user.GetFromCtx(ctx)

	if len(u.Roles) == 0 {
		return
	}

	filterString, err := service.getFiltersForUser(u)
	if err != nil {
		return
	}

	result, err := service.index.Search(query.Query,
		opt.Filters(filterString),
		opt.Page(query.Page),
		opt.AttributesToHighlight(service.getTextFields()...),
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
		hit, e := service.convertToSearchHit(rawHit)
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

		// TODO: Implement permission checking here as well
		//if !hasAccess() {
		//	continue
		//}

		item := common.SearchResultItem{
			ID:    int(id),
			Model: model,
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

		if value := hit.Title.get(language); value != "" {
			item.Title = value
		}
		if value := hit.Description.get(language); value != "" {
			item.Description = &value
		}
		if value := hit.Header; value != "" {
			item.Header = &value
		}
		if value := hit.ShowID; value != 0 {
			item.ShowID = &value
		}
		if value := hit.ShowTitle.get(language); value != "" {
			item.Show = &value
		}
		if value := hit.SeasonID; value != 0 {
			item.SeasonID = &value
		}
		if value := hit.SeasonTitle.get(language); value != "" {
			item.Season = &value
		}

		item.Url = getUrl(model, int(id))
		if value := hit.Image; value != "" {
			item.Image = &value
		}

		searchResult.ResultCount++
		searchResult.Result = append(searchResult.Result, item)
	}
	return
}
