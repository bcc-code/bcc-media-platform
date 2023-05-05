package graph

// This file will be automatically regenerated based on the schema, any resolver implementations
// will be copied through when generating and any unknown code will be moved to the end.

import (
	"context"
	"strconv"

	"github.com/bcc-code/brunstadtv/backend/graph/api/generated"
	"github.com/bcc-code/brunstadtv/backend/graph/api/model"
	"github.com/bcc-code/brunstadtv/backend/utils"
)

// Image is the resolver for the image field.
func (r *seasonResolver) Image(ctx context.Context, obj *model.Season, style *model.ImageStyle) (*string, error) {
	e, err := r.Loaders.SeasonLoader.Get(ctx, utils.AsInt(obj.ID))
	if err != nil {
		return nil, err
	}
	sh, err := r.Loaders.ShowLoader.Get(ctx, e.ShowID)
	if err != nil {
		return nil, err
	}

	return imageOrFallback(ctx, e.Images, style, sh.Images), nil
}

// Show is the resolver for the show field.
func (r *seasonResolver) Show(ctx context.Context, obj *model.Season) (*model.Show, error) {
	return r.QueryRoot().Show(ctx, obj.Show.ID)
}

// DefaultEpisode is the resolver for the defaultEpisode field.
func (r *seasonResolver) DefaultEpisode(ctx context.Context, obj *model.Season) (*model.Episode, error) {
	s, err := r.Loaders.SeasonLoader.Get(ctx, utils.AsInt(obj.ID))
	if err != nil {
		return nil, err
	}
	ls := r.FilteredLoaders(ctx)
	var eID *int
	if p, _ := getProfile(ctx); p != nil {
		eID, err = r.GetProfileLoaders(ctx).SeasonDefaultEpisodeLoader.Get(ctx, s.ID)
		if err != nil {
			return nil, err
		}
	}
	if eID == nil {
		eIDs, err := ls.EpisodesLoader.Get(ctx, s.ID)
		if err != nil {
			return nil, err
		}
		for _, id := range eIDs {
			if id != nil {
				eID = id
				break
			}
		}
	}
	if eID == nil {
		return nil, ErrItemNotFound
	}
	return r.QueryRoot().Episode(ctx, strconv.Itoa(*eID), nil)
}

// Episodes is the resolver for the episodes field.
func (r *seasonResolver) Episodes(ctx context.Context, obj *model.Season, first *int, offset *int, dir *string) (*model.EpisodePagination, error) {
	intID, err := strconv.ParseInt(obj.ID, 10, 64)
	if err != nil {
		return nil, err
	}

	itemIDs, err := r.FilteredLoaders(ctx).EpisodesLoader.Get(ctx, int(intID))
	if err != nil {
		return nil, err
	}

	if first == nil {
		f := 100
		first = &f
	}

	page := utils.Paginate(itemIDs, first, offset, dir)

	episodes, err := r.Loaders.EpisodeLoader.GetMany(ctx, utils.PointerIntArrayToIntArray(page.Items))
	if err != nil {
		return nil, err
	}

	return &model.EpisodePagination{
		Total:  page.Total,
		First:  page.First,
		Offset: page.Offset,
		Items:  utils.MapWithCtx(ctx, episodes, model.EpisodeFrom),
	}, nil
}

// Season returns generated.SeasonResolver implementation.
func (r *Resolver) Season() generated.SeasonResolver { return &seasonResolver{r} }

type seasonResolver struct{ *Resolver }