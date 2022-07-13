package graph

// This file will be automatically regenerated based on the schema, any resolver implementations
// will be copied through when generating and any unknown code will be moved to the end.

import (
	"context"
	"fmt"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/samber/lo"
	"strconv"

	"github.com/bcc-code/brunstadtv/backend/asset"
	"github.com/bcc-code/brunstadtv/backend/auth0"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/graph/generated"
	gqlmodel "github.com/bcc-code/brunstadtv/backend/graph/model"
	"github.com/bcc-code/brunstadtv/backend/user"
	"github.com/bcc-code/brunstadtv/backend/utils"
)

// Streams is the resolver for the streams field.
func (r *episodeResolver) Streams(ctx context.Context, obj *gqlmodel.Episode) ([]*gqlmodel.Stream, error) {
	streams, err := asset.GetStreamsForEpisode(ctx, r.Resolver.Loaders.StreamsLoader, obj.ID)
	if err != nil {
		return nil, err
	}
	return utils.MapWithCtx(ctx, streams, gqlmodel.StreamFromSQL), nil
}

// Files is the resolver for the files field.
func (r *episodeResolver) Files(ctx context.Context, obj *gqlmodel.Episode) ([]*gqlmodel.File, error) {
	files, err := asset.GetFilesForEpisode(ctx, r.Resolver.Loaders.FilesLoader, obj.ID)
	if err != nil {
		return nil, err
	}

	return utils.MapWithCtx(ctx, files, gqlmodel.FileFromSQL), nil
}

// Season is the resolver for the season field.
func (r *episodeResolver) Season(ctx context.Context, obj *gqlmodel.Episode) (*gqlmodel.Season, error) {
	if obj.Season != nil {
		return r.QueryRoot().Season(ctx, obj.Season.ID)
	}
	return nil, nil
}

// Page is the resolver for the page field.
func (r *queryRootResolver) Page(ctx context.Context, id string) (gqlmodel.Page, error) {
	panic(fmt.Errorf("not implemented"))
}

// Episode is the resolver for the episode field.
func (r *queryRootResolver) Episode(ctx context.Context, id string) (*gqlmodel.Episode, error) {
	return resolverForIntID(ctx, id, r.Loaders.EpisodeLoader, gqlmodel.EpisodeFromSQL)
}

// Season is the resolver for the season field.
func (r *queryRootResolver) Season(ctx context.Context, id string) (*gqlmodel.Season, error) {
	return resolverForIntID(ctx, id, r.Loaders.SeasonLoader, gqlmodel.SeasonFromSQL)
}

// Show is the resolver for the show field.
func (r *queryRootResolver) Show(ctx context.Context, id string) (*gqlmodel.Show, error) {
	return resolverForIntID(ctx, id, r.Loaders.ShowLoader, gqlmodel.ShowFromSQL)
}

// Section is the resolver for the section field.
func (r *queryRootResolver) Section(ctx context.Context, id string) (gqlmodel.Section, error) {
	panic(fmt.Errorf("not implemented"))
}

// Search is the resolver for the search field.
func (r *queryRootResolver) Search(ctx context.Context, queryString string, first *int, offset *int) (*gqlmodel.SearchResult, error) {
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
	var results []gqlmodel.SearchResultItem
	for _, i := range searchResult.Result {
		switch i.Collection {
		case "shows":
			s, err := r.Show(ctx, strconv.Itoa(i.ID))
			if err != nil {
				continue
			}
			results = append(results, s)
		case "seasons":
			se, err := r.Season(ctx, strconv.Itoa(i.ID))
			if err != nil {
				continue
			}
			results = append(results, se)
		case "episodes":
			e, err := r.Episode(ctx, strconv.Itoa(i.ID))
			if err != nil {
				// Ignore if errors occur - lack of access, etc.
				continue
			}
			results = append(results, e)
		}
	}
	return &gqlmodel.SearchResult{
		Result: results,
		Page:   searchResult.Page,
		Hits:   searchResult.HitCount,
	}, nil
}

// Calendar is the resolver for the calendar field.
func (r *queryRootResolver) Calendar(ctx context.Context) (*gqlmodel.Calendar, error) {
	panic(fmt.Errorf("not implemented"))
}

// Event is the resolver for the event field.
func (r *queryRootResolver) Event(ctx context.Context, id string) (*gqlmodel.Event, error) {
	panic(fmt.Errorf("not implemented"))
}

// AllFAQs is the resolver for the allFAQs field.
func (r *queryRootResolver) AllFAQs(ctx context.Context) ([]*gqlmodel.FAQCategory, error) {
	panic(fmt.Errorf("not implemented"))
}

// Me is the resolver for the me field.
func (r *queryRootResolver) Me(ctx context.Context) (*gqlmodel.User, error) {
	gc, err := utils.GinCtx(ctx)
	if err != nil {
		return nil, err
	}

	usr := user.GetFromCtx(gc)

	u := &gqlmodel.User{
		Anonymous: usr.IsAnonymous(),
		BccMember: usr.IsActiveBCC(),
		Roles:     usr.Roles,
	}

	if pid := gc.GetString(auth0.CtxPersonID); pid != "" {
		u.ID = &pid
	}

	if aud := gc.GetString(auth0.CtxJWTAudience); aud != "" {
		u.Audience = &aud
	}

	if usr.Email != "" {
		u.Email = &usr.Email
	}

	return u, nil
}

// Show is the resolver for the show field.
func (r *seasonResolver) Show(ctx context.Context, obj *gqlmodel.Season) (*gqlmodel.Show, error) {
	return r.QueryRoot().Show(ctx, obj.Show.ID)
}

// Episodes is the resolver for the episodes field.
func (r *seasonResolver) Episodes(ctx context.Context, obj *gqlmodel.Season) ([]*gqlmodel.Episode, error) {
	items, err := episode.GetEpisodesForSeason(ctx, r.Resolver.Loaders.EpisodesLoader, obj.ID)
	if err != nil {
		return nil, err
	}

	return utils.MapWithCtx(ctx, lo.Filter(items, func(i *sqlc.EpisodeExpanded, _ int) bool {
		// Validate that user has access
		return user.ValidateAccess(ctx, i) == nil
	}), gqlmodel.EpisodeFromSQL), nil
}

// Seasons is the resolver for the seasons field.
func (r *showResolver) Seasons(ctx context.Context, obj *gqlmodel.Show) ([]*gqlmodel.Season, error) {
	items, err := season.GetSeasonsForShow(ctx, r.Resolver.Loaders.SeasonsLoader, obj.ID)
	if err != nil {
		return nil, err
	}

	return utils.MapWithCtx(ctx, lo.Filter(items, func(i *sqlc.SeasonExpanded, _ int) bool {
		// Validate that user has access
		return user.ValidateAccess(ctx, i) == nil
	}), gqlmodel.SeasonFromSQL), nil
}

// Episode returns generated.EpisodeResolver implementation.
func (r *Resolver) Episode() generated.EpisodeResolver { return &episodeResolver{r} }

// QueryRoot returns generated.QueryRootResolver implementation.
func (r *Resolver) QueryRoot() generated.QueryRootResolver { return &queryRootResolver{r} }

// Season returns generated.SeasonResolver implementation.
func (r *Resolver) Season() generated.SeasonResolver { return &seasonResolver{r} }

// Show returns generated.ShowResolver implementation.
func (r *Resolver) Show() generated.ShowResolver { return &showResolver{r} }

type episodeResolver struct{ *Resolver }
type queryRootResolver struct{ *Resolver }
type seasonResolver struct{ *Resolver }
type showResolver struct{ *Resolver }
