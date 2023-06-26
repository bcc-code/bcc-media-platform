package graph

import (
	"context"
	"database/sql"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/graph/admin/model"
	"github.com/bcc-code/brunstadtv/backend/items/collection"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/bcc-code/brunstadtv/backend/user"
	"github.com/bcc-code/brunstadtv/backend/utils"
	"github.com/google/uuid"
	"github.com/samber/lo"
)

// Resolver contains the common properties for all endpoints
type Resolver struct {
	DB      *sql.DB
	Queries *sqlc.Queries
	Loaders *common.BatchLoaders
}

func (r *previewResolver) getItemsForFilter(ctx context.Context, filter common.Filter) ([]*model.CollectionItem, error) {
	identifiers, err := collection.GetItemIDsForFilter(ctx, r.DB, nil, filter, false)
	if err != nil {
		return nil, err
	}

	ginCtx, err := utils.GinCtx(ctx)
	if err != nil {
		return nil, err
	}

	var items []*model.CollectionItem
	languages := user.GetLanguagesFromCtx(ginCtx)

	getIDs := func(col string, ids []common.Identifier) []string {
		return lo.Map(lo.Filter(ids, func(i common.Identifier, _ int) bool {
			return i.Collection == col
		}), func(i common.Identifier, _ int) string {
			return i.ID
		})
	}

	if ids := getIDs("shows", identifiers); len(ids) > 0 {
		r.Loaders.ShowLoader.LoadMany(ctx, utils.MapAsIntegers(ids))
	}

	if ids := getIDs("seasons", identifiers); len(ids) > 0 {
		r.Loaders.SeasonLoader.LoadMany(ctx, utils.MapAsIntegers(ids))
	}

	if ids := getIDs("episodes", identifiers); len(ids) > 0 {
		r.Loaders.EpisodeLoader.LoadMany(ctx, utils.MapAsIntegers(ids))
	}

	if ids := getIDs("games", identifiers); len(ids) > 0 {
		r.Loaders.GameLoader.LoadMany(ctx, lo.Map(ids, func(i string, _ int) uuid.UUID {
			return utils.AsUuid(i)
		}))
	}

	for _, e := range identifiers {
		switch e.Collection {
		case "shows":
			i, err := r.Loaders.ShowLoader.Get(ctx, utils.AsInt(e.ID))
			if err != nil {
				return nil, err
			}
			items = append(items, &model.CollectionItem{
				Collection: model.CollectionShows,
				ID:         e.ID,
				Title:      i.Title.Get(languages),
			})
		case "seasons":
			i, err := r.Loaders.SeasonLoader.Get(ctx, utils.AsInt(e.ID))
			if err != nil {
				return nil, err
			}
			items = append(items, &model.CollectionItem{
				Collection: model.CollectionSeasons,
				ID:         e.ID,
				Title:      i.Title.Get(languages),
			})
		case "episodes":
			i, err := r.Loaders.EpisodeLoader.Get(ctx, utils.AsInt(e.ID))
			if err != nil {
				return nil, err
			}
			items = append(items, &model.CollectionItem{
				Collection: model.CollectionEpisodes,
				ID:         e.ID,
				Title:      i.Title.Get(languages),
			})
		case "games":
			i, err := r.Loaders.GameLoader.Get(ctx, utils.AsUuid(e.ID))
			if err != nil {
				return nil, err
			}
			items = append(items, &model.CollectionItem{
				Collection: model.CollectionGames,
				ID:         e.ID,
				Title:      i.Title.Get(languages),
			})
		}
	}

	return items, nil
}
