package graph

import (
	"context"
	"github.com/bcc-code/brunstadtv/backend/common"
	gqlmodel "github.com/bcc-code/brunstadtv/backend/graph/model"
	"github.com/bcc-code/brunstadtv/backend/utils"
	"strconv"
)

//func preloadItems(ctx context.Context, r *queryRootResolver, items []common.SearchResultItem) {
//	var keysByCollection = map[string][]int{}
//
//	for _, i := range items {
//		keysByCollection[i.Collection] = append(keysByCollection[i.Collection], i.ID)
//	}
//
//	if keys, ok := keysByCollection["shows"]; ok {
//		r.Loaders.ShowLoader.LoadMany(ctx, keys)
//	}
//	if keys, ok := keysByCollection["seasons"]; ok {
//		r.Loaders.SeasonLoader.LoadMany(ctx, keys)
//	}
//	if keys, ok := keysByCollection["episodes"]; ok {
//		r.Loaders.EpisodeLoader.LoadMany(ctx, keys)
//	}
//}
//
//func filterOrAppend[t gqlmodel.SearchResultItem](ctx context.Context, results []gqlmodel.SearchResultItem, id int, factory func(context.Context, string) (*t, error)) []gqlmodel.SearchResultItem {
//	item, err := factory(ctx, strconv.Itoa(id))
//	if err != nil {
//		return results
//	}
//	return append(results, *item)
//}

func gqlShowFromSearchResultItem(i common.SearchResultItem) gqlmodel.ShowSearchItem {
	var legacyID *string
	if i.LegacyID != nil {
		str := strconv.Itoa(*i.LegacyID)
		legacyID = &str
	}

	return gqlmodel.ShowSearchItem{
		ID:          strconv.Itoa(i.ID),
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

func gqlSeasonFromSearchResultItem(i common.SearchResultItem) gqlmodel.SeasonSearchItem {
	showID := strconv.Itoa(*i.ShowID)
	show := &gqlmodel.Show{
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

	return gqlmodel.SeasonSearchItem{
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

func gqlEpisodeFromSearchResultItem(i common.SearchResultItem) gqlmodel.EpisodeSearchItem {
	var showID *string
	var show *gqlmodel.Show
	if i.ShowID != nil {
		strID := strconv.Itoa(*i.ShowID)
		showID = &strID
		show = &gqlmodel.Show{
			ID: strID,
		}
	}
	var seasonID *string
	var season *gqlmodel.Season
	if i.ShowID != nil {
		strID := strconv.Itoa(*i.SeasonID)
		seasonID = &strID
		season = &gqlmodel.Season{
			ID: strID,
		}
	}

	var legacyID *string
	if i.LegacyID != nil {
		str := strconv.Itoa(*i.LegacyID)
		legacyID = &str
	}

	var duration = 0
	if i.Duration != nil {
		duration = *i.Duration
	}

	var ageRating = "A"
	if i.AgeRating != nil {
		ageRating = *i.AgeRating
	}

	return gqlmodel.EpisodeSearchItem{
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
		ShowTitle:   i.Show,
		Season:      season,
		SeasonID:    seasonID,
		SeasonTitle: i.Season,
		Duration:    duration,
		AgeRating:   ageRating,
	}
}

func convertToGQL(items []common.SearchResultItem) []gqlmodel.SearchResultItem {
	var results []gqlmodel.SearchResultItem
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

func searchResolver(r *queryRootResolver, ctx context.Context, queryString string, first *int, offset *int, typeArg *string, minScore *int) (*gqlmodel.SearchResult, error) {
	ginCtx, err := utils.GinCtx(ctx)
	if err != nil {
		return nil, err
	}
	searchResult, err := r.SearchService.Search(ginCtx, common.SearchQuery{
		Query:    queryString,
		Limit:    first,
		Offset:   offset,
		Type:     typeArg,
		MinScore: minScore,
	})
	if err != nil {
		return nil, err
	}

	return &gqlmodel.SearchResult{
		Result: convertToGQL(searchResult.Result),
		Page:   searchResult.Page,
		Hits:   searchResult.HitCount,
	}, nil
}
