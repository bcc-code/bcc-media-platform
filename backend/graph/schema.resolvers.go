package graph

// This file will be automatically regenerated based on the schema, any resolver implementations
// will be copied through when generating and any unknown code will be moved to the end.

import (
	"context"
	"fmt"
	"strconv"

	"github.com/bcc-code/brunstadtv/backend/asset"
	"github.com/bcc-code/brunstadtv/backend/auth0"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/episode"
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
	panic(fmt.Errorf("not implemented"))
}

// Page is the resolver for the page field.
func (r *queryRootResolver) Page(ctx context.Context, id string) (gqlmodel.Page, error) {
	panic(fmt.Errorf("not implemented"))
}

// Episode is the resolver for the episode field.
func (r *queryRootResolver) Episode(ctx context.Context, id string) (*gqlmodel.Episode, error) {
	intID, err := strconv.ParseInt(id, 10, 32)
	if err != nil {
		return nil, err
	}

	episodeObj, err := episode.GetByID(ctx, r.Resolver.Loaders.EpisodeLoader, int(intID))
	if err != nil {
		return nil, err
	}

	err = episode.ValidateAccess(ctx, *episodeObj)
	if err != nil {
		return nil, err
	}

	return gqlmodel.EpisodeFromSQL(ctx, episodeObj), nil
}

// Section is the resolver for the section field.
func (r *queryRootResolver) Section(ctx context.Context, id string) (gqlmodel.Section, error) {
	panic(fmt.Errorf("not implemented"))
}

// Search is the resolver for the search field.
func (r *queryRootResolver) Search(ctx context.Context, queryString string, page int) (*gqlmodel.SearchResult, error) {
	ginCtx, err := utils.GinCtx(ctx)
	if err != nil {
		return nil, err
	}
	searchResult, err := r.SearchService.Search(ginCtx, common.SearchQuery{
		Query: queryString,
		Page:  page,
	})
	if err != nil {
		return nil, err
	}
	var results []gqlmodel.SearchResultItem
	for _, i := range searchResult.Result {
		switch i.Collection {
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

// Episode returns generated.EpisodeResolver implementation.
func (r *Resolver) Episode() generated.EpisodeResolver { return &episodeResolver{r} }

// QueryRoot returns generated.QueryRootResolver implementation.
func (r *Resolver) QueryRoot() generated.QueryRootResolver { return &queryRootResolver{r} }

type episodeResolver struct{ *Resolver }
type queryRootResolver struct{ *Resolver }
