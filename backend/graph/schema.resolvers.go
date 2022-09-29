package graph

// This file will be automatically regenerated based on the schema, any resolver implementations
// will be copied through when generating and any unknown code will be moved to the end.

import (
	"context"
	"strconv"

	merry "github.com/ansel1/merry/v2"
	"github.com/bcc-code/brunstadtv/backend/applications"
	"github.com/bcc-code/brunstadtv/backend/auth0"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/graph/generated"
	gqlmodel "github.com/bcc-code/brunstadtv/backend/graph/model"
	"github.com/bcc-code/brunstadtv/backend/user"
	"github.com/bcc-code/brunstadtv/backend/utils"
)

// ImageURL is the resolver for the imageUrl field.
func (r *episodeResolver) ImageURL(ctx context.Context, obj *gqlmodel.Episode) (*string, error) {
	itemId, _ := strconv.ParseInt(obj.ID, 10, 32)
	item, err := common.GetFromLoaderByID(ctx, r.Loaders.EpisodeLoader, int(itemId))
	if err != nil {
		return nil, err
	}
	if !item.ImageID.Valid {
		return nil, nil
	}
	image, err := common.GetFromLoaderByID(ctx, r.Loaders.ImageFileLoader, item.ImageID.UUID)
	if err != nil {
		return nil, err
	}
	imageUrl := image.GetImageUrl()
	return &imageUrl, nil
}

// Streams is the resolver for the streams field.
func (r *episodeResolver) Streams(ctx context.Context, obj *gqlmodel.Episode) ([]*gqlmodel.Stream, error) {
	intID, _ := strconv.ParseInt(obj.ID, 10, 32)
	streams, err := common.GetFromLoaderForKey(ctx, r.Resolver.Loaders.StreamsLoader, int(intID))
	if err != nil {
		return nil, err
	}

	out := []*gqlmodel.Stream{}
	for _, s := range streams {
		stream, err := gqlmodel.StreamFrom(ctx, r.URLSigner, r.Resolver.APIConfig.GetVOD2Domain(), s)
		if err != nil {
			return nil, err
		}

		out = append(out, stream)
	}

	return out, nil
}

// Files is the resolver for the files field.
func (r *episodeResolver) Files(ctx context.Context, obj *gqlmodel.Episode) ([]*gqlmodel.File, error) {
	intID, err := strconv.ParseInt(obj.ID, 10, 32)
	if err != nil {
		return nil, err
	}

	files, err := common.GetFromLoaderForKey(ctx, r.Resolver.Loaders.FilesLoader, int(intID))
	if err != nil {
		return nil, err
	}

	out := []*gqlmodel.File{}
	for _, f := range files {
		out = append(out, gqlmodel.FileFrom(ctx, r.URLSigner, r.Resolver.APIConfig.GetFilesCDNDomain(), f))
	}
	return out, nil
}

// Season is the resolver for the season field.
func (r *episodeResolver) Season(ctx context.Context, obj *gqlmodel.Episode) (*gqlmodel.Season, error) {
	if obj.Season != nil {
		return r.QueryRoot().Season(ctx, obj.Season.ID)
	}
	return nil, nil
}

// ImageURL is the resolver for the imageUrl field.
func (r *episodeItemResolver) ImageURL(ctx context.Context, obj *gqlmodel.EpisodeItem) (*string, error) {
	itemId, _ := strconv.ParseInt(obj.ID, 10, 32)
	item, err := common.GetFromLoaderByID(ctx, r.Loaders.EpisodeLoader, int(itemId))
	if err != nil {
		return nil, err
	}
	if !item.ImageID.Valid {
		return nil, nil
	}
	image, err := common.GetFromLoaderByID(ctx, r.Loaders.ImageFileLoader, item.ImageID.UUID)
	if err != nil {
		return nil, err
	}
	imageUrl := image.GetImageUrl()
	return &imageUrl, nil
}

// Application is the resolver for the application field.
func (r *queryRootResolver) Application(ctx context.Context) (*gqlmodel.Application, error) {
	ginCtx, err := utils.GinCtx(ctx)
	if err != nil {
		return nil, err
	}
	app, err := applications.GetFromCtx(ginCtx)
	if err != nil {
		return nil, err
	}

	var page *gqlmodel.Page
	if app.DefaultPageID.Valid {
		page = &gqlmodel.Page{
			ID: strconv.Itoa(int(app.DefaultPageID.Int64)),
		}
	}

	return &gqlmodel.Application{
		ID:            strconv.Itoa(app.ID),
		Code:          app.Code,
		Page:          page,
		ClientVersion: app.ClientVersion,
	}, nil
}

// Page is the resolver for the page field.
func (r *queryRootResolver) Page(ctx context.Context, id *string, code *string) (*gqlmodel.Page, error) {
	if id != nil {
		return resolverForIntID(ctx, &itemLoaders[int, common.Page]{
			Item:        r.Loaders.PageLoader,
			Permissions: r.Loaders.PagePermissionLoader,
		}, *id, gqlmodel.PageFrom)
	}
	if code != nil {
		intID, err := common.GetFromLoaderByID(ctx, r.Loaders.PageIDFromCodeLoader, *code)
		if err != nil {
			return nil, err
		}
		if intID == nil {
			return nil, merry.Sentinel("No page found with that code")
		}
		return resolverFor(ctx, &itemLoaders[int, common.Page]{
			Item:        r.Loaders.PageLoader,
			Permissions: r.Loaders.PagePermissionLoader,
		}, *intID, gqlmodel.PageFrom)
	}
	return nil, merry.Sentinel("Must specify either ID or code", merry.WithHTTPCode(400))
}

// Section is the resolver for the section field.
func (r *queryRootResolver) Section(ctx context.Context, id string) (gqlmodel.Section, error) {
	return resolverForIntID(ctx, &itemLoaders[int, common.Section]{
		Item:        r.Loaders.SectionLoader,
		Permissions: r.Loaders.SectionPermissionLoader,
	}, id, gqlmodel.SectionFrom)
}

// Show is the resolver for the show field.
func (r *queryRootResolver) Show(ctx context.Context, id string) (*gqlmodel.Show, error) {
	return resolverForIntID(ctx, &itemLoaders[int, common.Show]{
		Item:        r.Loaders.ShowLoader,
		Permissions: r.Loaders.ShowPermissionLoader,
	}, id, gqlmodel.ShowFrom)
}

// Season is the resolver for the season field.
func (r *queryRootResolver) Season(ctx context.Context, id string) (*gqlmodel.Season, error) {
	return resolverForIntID(ctx, &itemLoaders[int, common.Season]{
		Item:        r.Loaders.SeasonLoader,
		Permissions: r.Loaders.SeasonPermissionLoader,
	}, id, gqlmodel.SeasonFrom)
}

// Episode is the resolver for the episode field.
func (r *queryRootResolver) Episode(ctx context.Context, id string) (*gqlmodel.Episode, error) {
	return resolverForIntID(ctx, &itemLoaders[int, common.Episode]{
		Item:        r.Loaders.EpisodeLoader,
		Permissions: r.Loaders.EpisodePermissionLoader,
	}, id, gqlmodel.EpisodeFrom)
}

// Collection is the resolver for the collection field.
func (r *queryRootResolver) Collection(ctx context.Context, id string) (*gqlmodel.Collection, error) {
	return resolverForIntID(ctx, &itemLoaders[int, common.Collection]{
		Item: r.Loaders.CollectionLoader,
	}, id, gqlmodel.CollectionFrom)
}

// Search is the resolver for the search field.
func (r *queryRootResolver) Search(ctx context.Context, queryString string, first *int, offset *int, typeArg *string, minScore *int) (*gqlmodel.SearchResult, error) {
	return searchResolver(r, ctx, queryString, first, offset, typeArg, minScore)
}

// Messages is the resolver for the messages field.
func (r *queryRootResolver) Messages(ctx context.Context) (*gqlmodel.Messages, error) {
	return &gqlmodel.Messages{}, nil
}

// Calendar is the resolver for the calendar field.
func (r *queryRootResolver) Calendar(ctx context.Context) (*gqlmodel.Calendar, error) {
	return &gqlmodel.Calendar{}, nil
}

// Event is the resolver for the event field.
func (r *queryRootResolver) Event(ctx context.Context, id string) (*gqlmodel.Event, error) {
	return resolverForIntID(ctx, &itemLoaders[int, common.Event]{
		Item: r.Loaders.EventLoader,
	}, id, gqlmodel.EventFrom)
}

// Faq is the resolver for the faq field.
func (r *queryRootResolver) Faq(ctx context.Context) (*gqlmodel.Faq, error) {
	return &gqlmodel.Faq{}, nil
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

	if pid := gc.GetString(auth0.CtxUserID); pid != "" {
		u.ID = &pid
	}

	//if aud := gc.GetString(auth0.CtxAudience); aud != "" {
	//	u.Audience = &aud
	//}

	if usr.Email != "" {
		u.Email = &usr.Email
	}

	return u, nil
}

// Config is the resolver for the config field.
func (r *queryRootResolver) Config(ctx context.Context) (*gqlmodel.Config, error) {
	return &gqlmodel.Config{}, nil
}

// ImageURL is the resolver for the imageUrl field.
func (r *seasonResolver) ImageURL(ctx context.Context, obj *gqlmodel.Season) (*string, error) {
	itemId, _ := strconv.ParseInt(obj.ID, 10, 32)
	item, err := common.GetFromLoaderByID(ctx, r.Loaders.SeasonLoader, int(itemId))
	if err != nil {
		return nil, err
	}
	if !item.ImageID.Valid {
		return nil, nil
	}
	image, err := common.GetFromLoaderByID(ctx, r.Loaders.ImageFileLoader, item.ImageID.UUID)
	if err != nil {
		return nil, err
	}
	imageUrl := image.GetImageUrl()
	return &imageUrl, nil
}

// Show is the resolver for the show field.
func (r *seasonResolver) Show(ctx context.Context, obj *gqlmodel.Season) (*gqlmodel.Show, error) {
	return r.QueryRoot().Show(ctx, obj.Show.ID)
}

// Episodes is the resolver for the episodes field.
func (r *seasonResolver) Episodes(ctx context.Context, obj *gqlmodel.Season, first *int, offset *int) (*gqlmodel.EpisodePagination, error) {
	items, err := itemsResolverForIntID(ctx, toItemLoaders(r.Loaders.EpisodeLoader, r.Loaders.EpisodePermissionLoader), r.Resolver.Loaders.EpisodesLoader, obj.ID, gqlmodel.EpisodeFrom)
	if err != nil {
		return nil, err
	}

	page := utils.Paginate(items, first, offset)

	return &gqlmodel.EpisodePagination{
		Total:  page.Total,
		First:  page.First,
		Offset: page.Offset,
		Items:  page.Items,
	}, nil
}

// ImageURL is the resolver for the imageUrl field.
func (r *seasonItemResolver) ImageURL(ctx context.Context, obj *gqlmodel.SeasonItem) (*string, error) {
	return r.Season().ImageURL(ctx, &gqlmodel.Season{ID: obj.ID})
}

// ImageURL is the resolver for the imageUrl field.
func (r *showResolver) ImageURL(ctx context.Context, obj *gqlmodel.Show) (*string, error) {
	itemId, _ := strconv.ParseInt(obj.ID, 10, 32)
	item, err := common.GetFromLoaderByID(ctx, r.Loaders.ShowLoader, int(itemId))
	if err != nil {
		return nil, err
	}
	if !item.ImageID.Valid {
		return nil, nil
	}
	image, err := common.GetFromLoaderByID(ctx, r.Loaders.ImageFileLoader, item.ImageID.UUID)
	if err != nil {
		return nil, err
	}
	imageUrl := image.GetImageUrl()
	return &imageUrl, nil
}

// Seasons is the resolver for the seasons field.
func (r *showResolver) Seasons(ctx context.Context, obj *gqlmodel.Show, first *int, offset *int) (*gqlmodel.SeasonPagination, error) {
	seasons, err := itemsResolverForIntID(ctx, toItemLoaders(r.Loaders.SeasonLoader, r.Loaders.SeasonPermissionLoader), r.Resolver.Loaders.SeasonsLoader, obj.ID, gqlmodel.SeasonFrom)
	if err != nil {
		return nil, err
	}
	pagination := utils.Paginate(seasons, first, offset)
	return &gqlmodel.SeasonPagination{
		Total:  pagination.Total,
		First:  pagination.First,
		Offset: pagination.Offset,
		Items:  pagination.Items,
	}, nil
}

// ImageURL is the resolver for the imageUrl field.
func (r *showItemResolver) ImageURL(ctx context.Context, obj *gqlmodel.ShowItem) (*string, error) {
	return r.Show().ImageURL(ctx, &gqlmodel.Show{ID: obj.ID})
}

// Episode returns generated.EpisodeResolver implementation.
func (r *Resolver) Episode() generated.EpisodeResolver { return &episodeResolver{r} }

// EpisodeItem returns generated.EpisodeItemResolver implementation.
func (r *Resolver) EpisodeItem() generated.EpisodeItemResolver { return &episodeItemResolver{r} }

// QueryRoot returns generated.QueryRootResolver implementation.
func (r *Resolver) QueryRoot() generated.QueryRootResolver { return &queryRootResolver{r} }

// Season returns generated.SeasonResolver implementation.
func (r *Resolver) Season() generated.SeasonResolver { return &seasonResolver{r} }

// SeasonItem returns generated.SeasonItemResolver implementation.
func (r *Resolver) SeasonItem() generated.SeasonItemResolver { return &seasonItemResolver{r} }

// Show returns generated.ShowResolver implementation.
func (r *Resolver) Show() generated.ShowResolver { return &showResolver{r} }

// ShowItem returns generated.ShowItemResolver implementation.
func (r *Resolver) ShowItem() generated.ShowItemResolver { return &showItemResolver{r} }

type episodeResolver struct{ *Resolver }
type episodeItemResolver struct{ *Resolver }
type queryRootResolver struct{ *Resolver }
type seasonResolver struct{ *Resolver }
type seasonItemResolver struct{ *Resolver }
type showResolver struct{ *Resolver }
type showItemResolver struct{ *Resolver }
