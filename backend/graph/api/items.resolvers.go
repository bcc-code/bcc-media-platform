package graph

// This file will be automatically regenerated based on the schema, any resolver implementations
// will be copied through when generating and any unknown code will be moved to the end.

import (
	"context"
	"github.com/bcc-code/brunstadtv/backend/user"
	"strconv"

	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/graph/api/generated"
	"github.com/bcc-code/brunstadtv/backend/graph/api/model"
	"github.com/bcc-code/brunstadtv/backend/utils"
)

// Streams is the resolver for the streams field.
func (r *episodeResolver) Streams(ctx context.Context, obj *model.Episode) ([]*model.Stream, error) {
	intID, _ := strconv.ParseInt(obj.ID, 10, 32)
	streams, err := common.GetFromLoaderForKey(ctx, r.Resolver.Loaders.StreamsLoader, int(intID))
	if err != nil {
		return nil, err
	}

	out := []*model.Stream{}
	for _, s := range streams {
		stream, err := model.StreamFrom(ctx, r.URLSigner, r.Resolver.APIConfig, s)
		if err != nil {
			return nil, err
		}

		out = append(out, stream)
	}

	return out, nil
}

// Files is the resolver for the files field.
func (r *episodeResolver) Files(ctx context.Context, obj *model.Episode) ([]*model.File, error) {
	intID, err := strconv.ParseInt(obj.ID, 10, 32)
	if err != nil {
		return nil, err
	}

	files, err := common.GetFromLoaderForKey(ctx, r.Resolver.Loaders.FilesLoader, int(intID))
	if err != nil {
		return nil, err
	}

	out := []*model.File{}
	for _, f := range files {
		out = append(out, model.FileFrom(ctx, r.URLSigner, r.Resolver.APIConfig.GetFilesCDNDomain(), f))
	}
	return out, nil
}

// Season is the resolver for the season field.
func (r *episodeResolver) Season(ctx context.Context, obj *model.Episode) (*model.Season, error) {
	if obj.Season != nil {
		return r.QueryRoot().Season(ctx, obj.Season.ID)
	}
	return nil, nil
}

// Show is the resolver for the show field.
func (r *seasonResolver) Show(ctx context.Context, obj *model.Season) (*model.Show, error) {
	return r.QueryRoot().Show(ctx, obj.Show.ID)
}

// Episodes is the resolver for the episodes field.
func (r *seasonResolver) Episodes(ctx context.Context, obj *model.Season, first *int, offset *int) (*model.EpisodePagination, error) {
	items, err := itemsResolverForIntID(ctx, toItemLoaders(r.Loaders.EpisodeLoader, r.Loaders.EpisodePermissionLoader), r.Resolver.Loaders.EpisodesLoader, obj.ID, model.EpisodeFrom)
	if err != nil {
		return nil, err
	}

	page := utils.Paginate(items, first, offset)

	return &model.EpisodePagination{
		Total:  page.Total,
		First:  page.First,
		Offset: page.Offset,
		Items:  page.Items,
	}, nil
}

// FirstEpisode is the resolver for the firstEpisode field.
func (r *seasonResolver) FirstEpisode(ctx context.Context, obj *model.Season) (*model.Episode, error) {
	intID, err := strconv.ParseInt(obj.ID, 10, 64)
	if err != nil {
		return nil, err
	}
	itemIds, err := common.GetFromLoaderForKey(ctx, r.Resolver.Loaders.EpisodesLoader, int(intID))

	for i := 0; i < len(itemIds); i++ {
		if i > 10 {
			break
		}
		id := itemIds[i]
		if id == nil {
			continue
		}
		err = user.ValidateAccess(ctx, r.Loaders.EpisodePermissionLoader, *id)
		if err == nil {
			return r.QueryRoot().Episode(ctx, strconv.Itoa(*id))
		}
	}

	return nil, nil
}

// LastEpisode is the resolver for the lastEpisode field.
func (r *seasonResolver) LastEpisode(ctx context.Context, obj *model.Season) (*model.Episode, error) {
	intID, err := strconv.ParseInt(obj.ID, 10, 64)
	if err != nil {
		return nil, err
	}
	itemIds, err := common.GetFromLoaderForKey(ctx, r.Resolver.Loaders.EpisodesLoader, int(intID))
	length := len(itemIds)

	for i := length - 1; i >= 0; i-- {
		if i < length-10 {
			break
		}
		id := itemIds[i]
		if id == nil {
			continue
		}
		err = user.ValidateAccess(ctx, r.Loaders.EpisodePermissionLoader, *id)
		if err == nil {
			return r.QueryRoot().Episode(ctx, strconv.Itoa(*id))
		}
	}

	return nil, nil
}

// Seasons is the resolver for the seasons field.
func (r *showResolver) Seasons(ctx context.Context, obj *model.Show, first *int, offset *int) (*model.SeasonPagination, error) {
	seasons, err := itemsResolverForIntID(ctx, toItemLoaders(r.Loaders.SeasonLoader, r.Loaders.SeasonPermissionLoader), r.Resolver.Loaders.SeasonsLoader, obj.ID, model.SeasonFrom)
	if err != nil {
		return nil, err
	}
	pagination := utils.Paginate(seasons, first, offset)
	return &model.SeasonPagination{
		Total:  pagination.Total,
		First:  pagination.First,
		Offset: pagination.Offset,
		Items:  pagination.Items,
	}, nil
}

// FirstSeason is the resolver for the firstSeason field.
func (r *showResolver) FirstSeason(ctx context.Context, obj *model.Show) (*model.Season, error) {
	intID, err := strconv.ParseInt(obj.ID, 10, 64)
	if err != nil {
		return nil, err
	}
	itemIds, err := common.GetFromLoaderForKey(ctx, r.Resolver.Loaders.SeasonsLoader, int(intID))

	for i := 0; i < len(itemIds); i++ {
		if i > 10 {
			break
		}
		id := itemIds[i]
		if id == nil {
			continue
		}
		err = user.ValidateAccess(ctx, r.Loaders.SeasonPermissionLoader, *id)
		if err == nil {
			return r.QueryRoot().Season(ctx, strconv.Itoa(*id))
		}
	}

	return nil, nil
}

// LastSeason is the resolver for the lastSeason field.
func (r *showResolver) LastSeason(ctx context.Context, obj *model.Show) (*model.Season, error) {
	intID, err := strconv.ParseInt(obj.ID, 10, 64)
	if err != nil {
		return nil, err
	}
	itemIds, err := common.GetFromLoaderForKey(ctx, r.Resolver.Loaders.SeasonsLoader, int(intID))
	length := len(itemIds)

	for i := length - 1; i >= 0; i-- {
		if i < length-10 {
			break
		}
		id := itemIds[i]
		if id == nil {
			continue
		}
		err = user.ValidateAccess(ctx, r.Loaders.SeasonPermissionLoader, *id)
		if err == nil {
			return r.QueryRoot().Season(ctx, strconv.Itoa(*id))
		}
	}

	return nil, nil
}

// Episode returns generated.EpisodeResolver implementation.
func (r *Resolver) Episode() generated.EpisodeResolver { return &episodeResolver{r} }

// Season returns generated.SeasonResolver implementation.
func (r *Resolver) Season() generated.SeasonResolver { return &seasonResolver{r} }

// Show returns generated.ShowResolver implementation.
func (r *Resolver) Show() generated.ShowResolver { return &showResolver{r} }

type episodeResolver struct{ *Resolver }
type seasonResolver struct{ *Resolver }
type showResolver struct{ *Resolver }
