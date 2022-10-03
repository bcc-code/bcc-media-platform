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
	"github.com/samber/lo"
	"strconv"
)

// Resolver contains the common properties for all endpoints
type Resolver struct {
	DB      *sql.DB
	Queries *sqlc.Queries
	Loaders *common.BatchLoaders
}

func (r *previewResolver) getItemsForFilter(ctx context.Context, col string, filter common.Filter) ([]*model.CollectionItem, error) {
	ids, err := collection.GetItemIDsForFilter(ctx, r.DB, col, filter)
	if err != nil {
		return nil, err
	}

	ginCtx, err := utils.GinCtx(ctx)
	if err != nil {
		return nil, err
	}

	var items []*model.CollectionItem
	languages := user.GetLanguagesFromCtx(ginCtx)

	switch col {
	case "shows":
		shows, err := common.GetManyFromLoader(ctx, r.Loaders.ShowLoader, ids)
		items = lo.Map(shows, func(s *common.Show, _ int) *model.CollectionItem {
			return &model.CollectionItem{
				ID:    strconv.Itoa(s.ID),
				Title: s.Title.Get(languages),
			}
		})
		if err != nil {
			return nil, err
		}
	case "seasons":
		shows, err := common.GetManyFromLoader(ctx, r.Loaders.SeasonLoader, ids)
		items = lo.Map(shows, func(s *common.Season, _ int) *model.CollectionItem {
			return &model.CollectionItem{
				ID:    strconv.Itoa(s.ID),
				Title: s.Title.Get(languages),
			}
		})
		if err != nil {
			return nil, err
		}
	case "episodes":
		shows, err := common.GetManyFromLoader(ctx, r.Loaders.EpisodeLoader, ids)
		items = lo.Map(shows, func(s *common.Episode, _ int) *model.CollectionItem {
			return &model.CollectionItem{
				ID:    strconv.Itoa(s.ID),
				Title: s.Title.Get(languages),
			}
		})
		if err != nil {
			return nil, err
		}
	}

	return items, nil
}
