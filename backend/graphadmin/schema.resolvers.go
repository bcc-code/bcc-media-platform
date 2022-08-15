package gqladmin

// This file will be automatically regenerated based on the schema, any resolver implementations
// will be copied through when generating and any unknown code will be moved to the end.

import (
	"context"
	"encoding/json"
	"strconv"

	"github.com/bcc-code/brunstadtv/backend/common"
	gqladmingenerated "github.com/bcc-code/brunstadtv/backend/graphadmin/generated"
	gqladminmodel "github.com/bcc-code/brunstadtv/backend/graphadmin/model"
	collection2 "github.com/bcc-code/brunstadtv/backend/items/collection"
	"github.com/bcc-code/brunstadtv/backend/user"
	"github.com/bcc-code/brunstadtv/backend/utils"
	"github.com/samber/lo"
)

// Collection is the resolver for the collection field.
func (r *previewResolver) Collection(ctx context.Context, obj *gqladminmodel.Preview, collection string, filter string) (*gqladminmodel.PreviewCollection, error) {
	var f common.Filter
	_ = json.Unmarshal([]byte(filter), &f)
	ids, err := collection2.GetItemIDsForFilter(r.DB, collection, f)
	if err != nil {
		return nil, err
	}
	var items []*gqladminmodel.CollectionItem
	ginCtx, err := utils.GinCtx(ctx)
	if err != nil {
		return nil, err
	}
	languages := user.GetLanguagesFromCtx(ginCtx)
	switch collection {
	case "shows":
		shows, err := common.GetManyFromLoader(ctx, r.Loaders.ShowLoader, ids)
		items = lo.Map(shows, func(s *common.Show, _ int) *gqladminmodel.CollectionItem {
			return &gqladminmodel.CollectionItem{
				ID:    strconv.Itoa(s.ID),
				Title: s.Title.Get(languages),
			}
		})
		if err != nil {
			return nil, err
		}
	case "seasons":
		shows, err := common.GetManyFromLoader(ctx, r.Loaders.SeasonLoader, ids)
		items = lo.Map(shows, func(s *common.Season, _ int) *gqladminmodel.CollectionItem {
			return &gqladminmodel.CollectionItem{
				ID:    strconv.Itoa(s.ID),
				Title: s.Title.Get(languages),
			}
		})
		if err != nil {
			return nil, err
		}
	case "episodes":
		shows, err := common.GetManyFromLoader(ctx, r.Loaders.EpisodeLoader, ids)
		items = lo.Map(shows, func(s *common.Episode, _ int) *gqladminmodel.CollectionItem {
			return &gqladminmodel.CollectionItem{
				ID:    strconv.Itoa(s.ID),
				Title: s.Title.Get(languages),
			}
		})
		if err != nil {
			return nil, err
		}
	}
	return &gqladminmodel.PreviewCollection{
		Items: items,
	}, nil
}

// Preview is the resolver for the Preview field.
func (r *queryRootResolver) Preview(ctx context.Context) (*gqladminmodel.Preview, error) {
	return &gqladminmodel.Preview{}, nil
}

// Preview returns gqladmingenerated.PreviewResolver implementation.
func (r *Resolver) Preview() gqladmingenerated.PreviewResolver { return &previewResolver{r} }

// QueryRoot returns gqladmingenerated.QueryRootResolver implementation.
func (r *Resolver) QueryRoot() gqladmingenerated.QueryRootResolver { return &queryRootResolver{r} }

type previewResolver struct{ *Resolver }
type queryRootResolver struct{ *Resolver }
