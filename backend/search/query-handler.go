package search

import (
	"fmt"
	"github.com/algolia/algoliasearch-client-go/v3/algolia/opt"
	"github.com/bcc-code/brunstadtv/backend/base"
	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/samber/lo"
	"strconv"
	"strings"
	"time"
)

type QueryHandler struct {
	user    any
	service *Service
}

func (service *Service) GetQueryHandler(user any) base.ISearchQueryHandler {
	return &QueryHandler{
		user:    user,
		service: service,
	}
}

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

// TODO: Get user roles
func getUserRoles() []string {
	return []string{"test-group-1"}
}

// TODO: Get user default language
func getUserLanguage() string {
	return defaultLanguage
}

func (h *QueryHandler) Search(query *base.SearchQuery) (*base.SearchResult, error) {
	now := time.Now().Unix()

	userRoles := getUserRoles()
	language := getUserLanguage()

	if len(userRoles) == 0 {
		// No roles == no permissions == no results
		return &base.SearchResult{
			Result: []base.SearchResultItem{},
		}, nil
	}

	var filters = []string{
		strings.Join(lo.Map(userRoles, func(role string, _ int) string {
			return fmt.Sprintf("%s:%s", rolesField, role)
		}), " OR "),
		fmt.Sprintf("%s < %d", publishedAtField, now),
		fmt.Sprintf("%[1]s = 0 OR %[1]s < %[2]d", availableFromField, now),
		fmt.Sprintf("%[1]s = 0 OR %[1]s > %[2]d", availableToField, now),
		fmt.Sprintf("%s:%s", statusField, base.StatusPublished),
	}

	filterString := "(" + strings.Join(filters, ") AND (") + ")"

	result, err := h.service.index.Search(query.Query,
		opt.Filters(filterString),
		opt.Page(query.Page),
		opt.AttributesToHighlight(h.service.getTextFields()...),
	)
	if err != nil {
		log.L.Error().Err(err).Msg("Search failed")
		return nil, err
	}
	var searchResult base.SearchResult
	var hits []searchObject

	err = result.UnmarshalHits(&hits)
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to unmarshal hits")
		return nil, err
	}

	searchResult.HitCount = result.NbHits
	searchResult.Page = result.Page
	searchResult.PageCount = result.NbPages
	searchResult.Result = []base.SearchResultItem{}

	for _, rawHit := range hits {
		hit := h.service.convertToSearchHit(&rawHit)
		parts := strings.Split(hit.ID, "-")
		model := parts[0]
		id, err := strconv.ParseInt(parts[1], 0, 64)
		if err != nil {
			log.L.Error().Err(err).Msg("Failed to parse int")
			return nil, err
		}

		// TODO: Implement permission checking here as well
		//if !hasAccess() {
		//	continue
		//}

		item := base.SearchResultItem{
			Id:    int(id),
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

	return &searchResult, nil
}
