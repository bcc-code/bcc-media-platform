package graph

import (
	"context"
	"github.com/bcc-code/brunstadtv/backend/common"
	gqlmodel "github.com/bcc-code/brunstadtv/backend/graph/model"
	"github.com/bcc-code/brunstadtv/backend/utils"
	"strconv"
)

func searchResolver(r *queryRootResolver, ctx context.Context, queryString string, first *int, offset *int) (*gqlmodel.SearchResult, error) {
	ginCtx, err := utils.GinCtx(ctx)
	if err != nil {
		return nil, err
	}
	searchResult, err := r.SearchService.Search(ginCtx, common.SearchQuery{
		Query:  queryString,
		Limit:  first,
		Offset: offset,
	})
	if err != nil {
		return nil, err
	}

	var keysByCollection = map[string][]int{}

	for _, i := range searchResult.Result {
		keysByCollection[i.Collection] = append(keysByCollection[i.Collection], i.ID)
	}

	if keys, ok := keysByCollection["shows"]; ok {
		r.Loaders.ShowLoader.LoadMany(ctx, keys)
	}
	if keys, ok := keysByCollection["seasons"]; ok {
		r.Loaders.SeasonLoader.LoadMany(ctx, keys)
	}
	if keys, ok := keysByCollection["episodes"]; ok {
		r.Loaders.EpisodeLoader.LoadMany(ctx, keys)
	}

	var results []gqlmodel.SearchResultItem

	for _, i := range searchResult.Result {
		switch i.Collection {
		case "shows":
			show, err := r.Show(ctx, strconv.Itoa(i.ID))
			if err != nil {
				continue
			}
			results = append(results, show)
		case "seasons":
			season, err := r.Season(ctx, strconv.Itoa(i.ID))
			if err != nil {
				continue
			}
			results = append(results, season)
		case "episodes":
			episode, err := r.Episode(ctx, strconv.Itoa(i.ID))
			if err != nil {
				continue
			}
			results = append(results, episode)
		}
	}

	return &gqlmodel.SearchResult{
		Result: results,
		Page:   searchResult.Page,
		Hits:   searchResult.HitCount,
	}, nil
}
