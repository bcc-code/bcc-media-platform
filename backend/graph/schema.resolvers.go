package graph

// This file will be automatically regenerated based on the schema, any resolver implementations
// will be copied through when generating and any unknown code will be moved to the end.

import (
	"context"
	"fmt"

	"github.com/bcc-code/brunstadtv/backend/asset"
	"github.com/bcc-code/brunstadtv/backend/auth0"
	"github.com/bcc-code/brunstadtv/backend/graph/generated"
	gqlmodel "github.com/bcc-code/brunstadtv/backend/graph/model"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/bcc-code/brunstadtv/backend/user"
	"github.com/bcc-code/brunstadtv/backend/utils"
	"github.com/samber/lo"
)

// Sections is the resolver for the sections field.
func (r *customPageResolver) Sections(ctx context.Context, obj *gqlmodel.CustomPage, first *int, after *string) (*gqlmodel.SectionConnection, error) {
	return sectionResolver(ctx, obj.ID, r.Loaders, first, after)
}

// Sections is the resolver for the sections field.
func (r *defaultPageResolver) Sections(ctx context.Context, obj *gqlmodel.DefaultPage, first *int, after *string) (*gqlmodel.SectionConnection, error) {
	return sectionResolver(ctx, obj.ID, r.Loaders, first, after)
}

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

// Items is the resolver for the items field.
func (r *episodeCollectionResolver) Items(ctx context.Context, obj *gqlmodel.EpisodeCollection) ([]*gqlmodel.EpisodeItem, error) {
	return collectionResolverFor(ctx, r.Loaders, r.Loaders.EpisodeLoader, obj.ID, gqlmodel.EpisodeItemFromSQL)
}

// Episode is the resolver for the episode field.
func (r *episodePageResolver) Episode(ctx context.Context, obj *gqlmodel.EpisodePage) (*gqlmodel.Episode, error) {
	return r.QueryRoot().Episode(ctx, obj.Episode.ID)
}

// Show is the resolver for the show field.
func (r *episodeSearchItemResolver) Show(ctx context.Context, obj *gqlmodel.EpisodeSearchItem) (*gqlmodel.Show, error) {
	return r.QueryRoot().Show(ctx, obj.Show.ID)
}

// Season is the resolver for the season field.
func (r *episodeSearchItemResolver) Season(ctx context.Context, obj *gqlmodel.EpisodeSearchItem) (*gqlmodel.Season, error) {
	return r.QueryRoot().Season(ctx, obj.Season.ID)
}

// Page is the resolver for the page field.
func (r *itemSectionResolver) Page(ctx context.Context, obj *gqlmodel.ItemSection) (gqlmodel.Page, error) {
	return r.QueryRoot().Page(ctx, obj.PageID)
}

// Collection is the resolver for the collection field.
func (r *itemSectionResolver) Collection(ctx context.Context, obj *gqlmodel.ItemSection) (gqlmodel.Collection, error) {
	if obj.CollectionID != nil {
		return resolverWithoutAccessValidationForIntID(ctx, *obj.CollectionID, r.Loaders.CollectionLoader, gqlmodel.CollectionFromSQL)
	}
	return nil, nil
}

// Items is the resolver for the items field.
func (r *pageCollectionResolver) Items(ctx context.Context, obj *gqlmodel.PageCollection) ([]*gqlmodel.PageItem, error) {
	return collectionResolverFor(ctx, r.Loaders, r.Loaders.PageLoader, obj.ID, gqlmodel.PageItemFromSQL)
}

// Page is the resolver for the page field.
func (r *queryRootResolver) Page(ctx context.Context, id string) (gqlmodel.Page, error) {
	return resolverWithoutAccessValidationForIntID(ctx, id, r.Loaders.PageLoader, gqlmodel.PageFromSQL)
}

// Pages is the resolver for the pages field.
func (r *queryRootResolver) Pages(ctx context.Context, first *int, offset *int) ([]gqlmodel.Page, error) {
	//TODO: implement paging
	pages, err := r.Queries.ListPages(ctx)
	if err != nil {
		return nil, err
	}
	pagePointers := lo.Map(pages, func(p sqlc.PageExpanded, _ int) *sqlc.PageExpanded {
		return &p
	})
	return utils.MapWithCtx(ctx, pagePointers, gqlmodel.PageFromSQL), nil
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
	return resolverWithoutAccessValidationForIntID(ctx, id, r.Loaders.SectionLoader, gqlmodel.SectionFromSQL)
}

// Search is the resolver for the search field.
func (r *queryRootResolver) Search(ctx context.Context, queryString string, first *int, offset *int) (*gqlmodel.SearchResult, error) {
	return searchResolver(r, ctx, queryString, first, offset)
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
	return itemsResolverForIntID(ctx, obj.ID, r.Resolver.Loaders.EpisodesLoader, gqlmodel.EpisodeFromSQL)
}

// Items is the resolver for the items field.
func (r *seasonCollectionResolver) Items(ctx context.Context, obj *gqlmodel.SeasonCollection) ([]*gqlmodel.SeasonItem, error) {
	return collectionResolverFor(ctx, r.Loaders, r.Loaders.SeasonLoader, obj.ID, gqlmodel.SeasonItemFromSQL)
}

// Season is the resolver for the season field.
func (r *seasonPageResolver) Season(ctx context.Context, obj *gqlmodel.SeasonPage) (*gqlmodel.Season, error) {
	return r.QueryRoot().Season(ctx, obj.Season.ID)
}

// Show is the resolver for the show field.
func (r *seasonSearchItemResolver) Show(ctx context.Context, obj *gqlmodel.SeasonSearchItem) (*gqlmodel.Show, error) {
	return r.QueryRoot().Show(ctx, obj.Show.ID)
}

// Seasons is the resolver for the seasons field.
func (r *showResolver) Seasons(ctx context.Context, obj *gqlmodel.Show) ([]*gqlmodel.Season, error) {
	return itemsResolverForIntID(ctx, obj.ID, r.Resolver.Loaders.SeasonsLoader, gqlmodel.SeasonFromSQL)
}

// Items is the resolver for the items field.
func (r *showCollectionResolver) Items(ctx context.Context, obj *gqlmodel.ShowCollection) ([]*gqlmodel.ShowItem, error) {
	return collectionResolverFor(ctx, r.Loaders, r.Loaders.ShowLoader, obj.ID, gqlmodel.ShowItemFromSQL)
}

// Show is the resolver for the show field.
func (r *showPageResolver) Show(ctx context.Context, obj *gqlmodel.ShowPage) (*gqlmodel.Show, error) {
	return r.QueryRoot().Show(ctx, obj.Show.ID)
}

// CustomPage returns generated.CustomPageResolver implementation.
func (r *Resolver) CustomPage() generated.CustomPageResolver { return &customPageResolver{r} }

// DefaultPage returns generated.DefaultPageResolver implementation.
func (r *Resolver) DefaultPage() generated.DefaultPageResolver { return &defaultPageResolver{r} }

// Episode returns generated.EpisodeResolver implementation.
func (r *Resolver) Episode() generated.EpisodeResolver { return &episodeResolver{r} }

// EpisodeCollection returns generated.EpisodeCollectionResolver implementation.
func (r *Resolver) EpisodeCollection() generated.EpisodeCollectionResolver {
	return &episodeCollectionResolver{r}
}

// EpisodePage returns generated.EpisodePageResolver implementation.
func (r *Resolver) EpisodePage() generated.EpisodePageResolver { return &episodePageResolver{r} }

// EpisodeSearchItem returns generated.EpisodeSearchItemResolver implementation.
func (r *Resolver) EpisodeSearchItem() generated.EpisodeSearchItemResolver {
	return &episodeSearchItemResolver{r}
}

// ItemSection returns generated.ItemSectionResolver implementation.
func (r *Resolver) ItemSection() generated.ItemSectionResolver { return &itemSectionResolver{r} }

// PageCollection returns generated.PageCollectionResolver implementation.
func (r *Resolver) PageCollection() generated.PageCollectionResolver {
	return &pageCollectionResolver{r}
}

// QueryRoot returns generated.QueryRootResolver implementation.
func (r *Resolver) QueryRoot() generated.QueryRootResolver { return &queryRootResolver{r} }

// Season returns generated.SeasonResolver implementation.
func (r *Resolver) Season() generated.SeasonResolver { return &seasonResolver{r} }

// SeasonCollection returns generated.SeasonCollectionResolver implementation.
func (r *Resolver) SeasonCollection() generated.SeasonCollectionResolver {
	return &seasonCollectionResolver{r}
}

// SeasonPage returns generated.SeasonPageResolver implementation.
func (r *Resolver) SeasonPage() generated.SeasonPageResolver { return &seasonPageResolver{r} }

// SeasonSearchItem returns generated.SeasonSearchItemResolver implementation.
func (r *Resolver) SeasonSearchItem() generated.SeasonSearchItemResolver {
	return &seasonSearchItemResolver{r}
}

// Show returns generated.ShowResolver implementation.
func (r *Resolver) Show() generated.ShowResolver { return &showResolver{r} }

// ShowCollection returns generated.ShowCollectionResolver implementation.
func (r *Resolver) ShowCollection() generated.ShowCollectionResolver {
	return &showCollectionResolver{r}
}

// ShowPage returns generated.ShowPageResolver implementation.
func (r *Resolver) ShowPage() generated.ShowPageResolver { return &showPageResolver{r} }

type customPageResolver struct{ *Resolver }
type defaultPageResolver struct{ *Resolver }
type episodeResolver struct{ *Resolver }
type episodeCollectionResolver struct{ *Resolver }
type episodePageResolver struct{ *Resolver }
type episodeSearchItemResolver struct{ *Resolver }
type itemSectionResolver struct{ *Resolver }
type pageCollectionResolver struct{ *Resolver }
type queryRootResolver struct{ *Resolver }
type seasonResolver struct{ *Resolver }
type seasonCollectionResolver struct{ *Resolver }
type seasonPageResolver struct{ *Resolver }
type seasonSearchItemResolver struct{ *Resolver }
type showResolver struct{ *Resolver }
type showCollectionResolver struct{ *Resolver }
type showPageResolver struct{ *Resolver }
