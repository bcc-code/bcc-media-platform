package graph

import (
	"context"
	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/graph/api/model"
	"github.com/bcc-code/bcc-media-platform/backend/ratelimit"
	"github.com/bcc-code/bcc-media-platform/backend/utils"
	"strconv"
)

func gqlShowFromSearchResultItem(i common.SearchResultItem) model.ShowSearchItem {
	var legacyID *string
	if i.LegacyID != nil {
		str := strconv.Itoa(*i.LegacyID)
		legacyID = &str
	}

	id := strconv.Itoa(i.ID)

	return model.ShowSearchItem{
		ID:          id,
		LegacyID:    legacyID,
		Collection:  i.Collection,
		Title:       i.Title,
		Description: i.Description,
		Header:      i.Header,
		Image:       i.Image,
		Highlight:   i.Highlight,
		URL:         i.Url,
	}
}

func gqlSeasonFromSearchResultItem(i common.SearchResultItem) model.SeasonSearchItem {
	showID := strconv.Itoa(*i.ShowID)
	show := &model.Show{
		ID: showID,
	}

	var legacyID *string
	if i.LegacyID != nil {
		str := strconv.Itoa(*i.LegacyID)
		legacyID = &str
	}

	var ageRating = "A"
	if i.AgeRating != nil {
		ageRating = *i.AgeRating
	}

	return model.SeasonSearchItem{
		ID:          strconv.Itoa(i.ID),
		LegacyID:    legacyID,
		Collection:  i.Collection,
		Title:       i.Title,
		Description: i.Description,
		Header:      i.Header,
		Image:       i.Image,
		Highlight:   i.Highlight,
		URL:         i.Url,
		Show:        show,
		ShowID:      showID,
		ShowTitle:   *i.Show,
		AgeRating:   ageRating,
	}
}

func gqlEpisodeFromSearchResultItem(i common.SearchResultItem) model.EpisodeSearchItem {
	var showID *string
	var show *model.Show
	if i.ShowID != nil {
		strID := strconv.Itoa(*i.ShowID)
		showID = &strID
		show = &model.Show{
			ID: strID,
		}
	}
	var seasonID *string
	var season *model.Season
	if i.ShowID != nil {
		strID := strconv.Itoa(*i.SeasonID)
		seasonID = &strID
		season = &model.Season{
			ID: strID,
		}
	}

	var legacyID *string
	var legacyProgramID *string
	if i.LegacyID != nil {
		str := strconv.Itoa(*i.LegacyID)
		if i.SeasonID != nil {
			legacyID = &str
		} else {
			legacyProgramID = &str
		}
	}

	var duration = 0
	if i.Duration != nil {
		duration = *i.Duration
	}

	var ageRating = "A"
	if i.AgeRating != nil {
		ageRating = *i.AgeRating
	}

	return model.EpisodeSearchItem{
		ID:              strconv.Itoa(i.ID),
		LegacyID:        legacyID,
		LegacyProgramID: legacyProgramID,
		Collection:      i.Collection,
		Title:           i.Title,
		Description:     i.Description,
		Header:          i.Header,
		Image:           i.Image,
		Highlight:       i.Highlight,
		URL:             i.Url,
		Show:            show,
		ShowID:          showID,
		ShowTitle:       i.Show,
		Season:          season,
		SeasonID:        seasonID,
		SeasonTitle:     i.Season,
		Duration:        duration,
		AgeRating:       ageRating,
	}
}

func convertToGQL(items []common.SearchResultItem) []model.SearchResultItem {
	var results []model.SearchResultItem
	for _, i := range items {
		//TODO: Do we need to filter on permissions again?
		//Search is usually quicker to index, and respect roles and permissions on search.
		switch i.Collection {
		case "shows":
			item := gqlShowFromSearchResultItem(i)
			results = append(results, item)
		case "seasons":
			item := gqlSeasonFromSearchResultItem(i)
			results = append(results, item)
		case "episodes":
			item := gqlEpisodeFromSearchResultItem(i)
			results = append(results, item)
		}
	}
	return results
}

func searchResolver(r *queryRootResolver, ctx context.Context, queryString string, first *int, offset *int, typeArg *string, minScore *int) (*model.SearchResult, error) {
	ginCtx, err := utils.GinCtx(ctx)
	if err != nil {
		return nil, err
	}

	err = ratelimit.Endpoint(ctx, "search", 50, true)
	if err != nil {
		return nil, err
	}

	searchResult, err := r.SearchService.Search(ginCtx, common.SearchQuery{
		Query:    queryString,
		Limit:    first,
		Offset:   offset,
		Type:     typeArg,
		MinScore: minScore,
	}, r.AnalyticsIDFactory(ctx))
	if err != nil {
		return nil, err
	}

	return &model.SearchResult{
		Result: convertToGQL(searchResult.Result),
		Page:   searchResult.Page,
		Hits:   searchResult.HitCount,
	}, nil
}
