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
	Title           common.LocaleString    `json:"title"`
	Header          string                 `json:"header"`
	Description     common.LocaleString    `json:"description"`
	ShowID          int                    `json:"showID"`
	ShowTitle       common.LocaleString    `json:"showTitle"`
	SeasonID        int                    `json:"seasonID"`
	SeasonTitle     common.LocaleString    `json:"seasonTitle"`
	Image           string                 `json:"image"`
	HighlightResult map[string]interface{} `json:"_highlightResult"`
}

func (service *Service) Search(ctx *gin.Context, query common.SearchQuery) (searchResult common.SearchResult, err error) {

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

	languages := user.GetLanguagesFromCtx(ctx)

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
		if value := hit.Description.Get(languages); value != "" {
			item.Description = &value
		}
		if value := hit.Header; value != "" {
			item.Header = &value
		}
		if value := hit.ShowID; value != 0 {
			item.ShowID = &value
		}
		if value := hit.ShowTitle.Get(languages); value != "" {
			item.Show = &value
		}
		if value := hit.SeasonID; value != 0 {
			item.SeasonID = &value
		}
		if value := hit.SeasonTitle.Get(languages); value != "" {
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
