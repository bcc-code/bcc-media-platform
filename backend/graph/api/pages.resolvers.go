package graph

// This file will be automatically regenerated based on the schema, any resolver implementations
// will be copied through when generating and any unknown code will be moved to the end.

import (
	"context"
	"strconv"

	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/graph/api/generated"
	"github.com/bcc-code/brunstadtv/backend/graph/api/model"
	"github.com/bcc-code/brunstadtv/backend/utils"
	null "gopkg.in/guregu/null.v4"
)

// Items is the resolver for the items field.
func (r *collectionResolver) Items(ctx context.Context, obj *model.Collection, first *int, offset *int) (*model.CollectionItemPagination, error) {
	pagination, err := collectionItemResolverFromCollection(ctx, r.Resolver, obj.ID, first, offset)
	if err != nil {
		return nil, err
	}

	return &model.CollectionItemPagination{
		Total:  pagination.Total,
		First:  pagination.First,
		Offset: pagination.Offset,
		Items:  pagination.Items,
	}, nil
}

// Items is the resolver for the items field.
func (r *defaultGridSectionResolver) Items(ctx context.Context, obj *model.DefaultGridSection, first *int, offset *int) (*model.SectionItemPagination, error) {
	return sectionCollectionItemResolver(ctx, r.Resolver, obj.ID, first, offset)
}

// Items is the resolver for the items field.
func (r *defaultSectionResolver) Items(ctx context.Context, obj *model.DefaultSection, first *int, offset *int) (*model.SectionItemPagination, error) {
	return sectionCollectionItemResolver(ctx, r.Resolver, obj.ID, first, offset)
}

// Items is the resolver for the items field.
func (r *featuredSectionResolver) Items(ctx context.Context, obj *model.FeaturedSection, first *int, offset *int) (*model.SectionItemPagination, error) {
	return sectionCollectionItemResolver(ctx, r.Resolver, obj.ID, first, offset)
}

// Items is the resolver for the items field.
func (r *iconSectionResolver) Items(ctx context.Context, obj *model.IconSection, first *int, offset *int) (*model.SectionItemPagination, error) {
	return sectionCollectionItemResolver(ctx, r.Resolver, obj.ID, first, offset)
}

// Items is the resolver for the items field.
func (r *labelSectionResolver) Items(ctx context.Context, obj *model.LabelSection, first *int, offset *int) (*model.SectionItemPagination, error) {
	return sectionCollectionItemResolver(ctx, r.Resolver, obj.ID, first, offset)
}

// Messages is the resolver for the messages field.
func (r *messageSectionResolver) Messages(ctx context.Context, obj *model.MessageSection) ([]*model.Message, error) {
	s, err := common.GetFromLoaderByID(ctx, r.Loaders.SectionLoader, utils.AsInt(obj.ID))
	if err != nil {
		return nil, err
	}
	return resolveMessageSection(ctx, r, s)
}

// Image is the resolver for the image field.
func (r *pageResolver) Image(ctx context.Context, obj *model.Page, style *model.ImageStyle) (*string, error) {
	e, err := common.GetFromLoaderByID(ctx, r.Loaders.PageLoader, utils.AsInt(obj.ID))
	if err != nil {
		return nil, err
	}
	return imageOrFallback(ctx, e.Images, null.String{}, style), nil
}

// Sections is the resolver for the sections field.
func (r *pageResolver) Sections(ctx context.Context, obj *model.Page, first *int, offset *int) (*model.SectionPagination, error) {
	intID, err := strconv.ParseInt(obj.ID, 10, 64)
	if err != nil {
		return nil, err
	}

	itemIDs, err := common.GetFromLoaderForKey(ctx, r.FilteredLoaders(ctx).SectionsLoader, int(intID))
	if err != nil {
		return nil, err
	}

	page := utils.Paginate(itemIDs, first, offset, nil)

	sections, err := common.GetManyFromLoader(ctx, r.Loaders.SectionLoader, utils.PointerIntArrayToIntArray(page.Items))
	if err != nil {
		return nil, err
	}
	return &model.SectionPagination{
		Total:  page.Total,
		First:  page.First,
		Offset: page.Offset,
		Items:  utils.MapWithCtx(ctx, sections, model.SectionFrom),
	}, nil
}

// Items is the resolver for the items field.
func (r *posterGridSectionResolver) Items(ctx context.Context, obj *model.PosterGridSection, first *int, offset *int) (*model.SectionItemPagination, error) {
	return sectionCollectionItemResolver(ctx, r.Resolver, obj.ID, first, offset)
}

// Items is the resolver for the items field.
func (r *posterSectionResolver) Items(ctx context.Context, obj *model.PosterSection, first *int, offset *int) (*model.SectionItemPagination, error) {
	return sectionCollectionItemResolver(ctx, r.Resolver, obj.ID, first, offset)
}

// Collection returns generated.CollectionResolver implementation.
func (r *Resolver) Collection() generated.CollectionResolver { return &collectionResolver{r} }

// DefaultGridSection returns generated.DefaultGridSectionResolver implementation.
func (r *Resolver) DefaultGridSection() generated.DefaultGridSectionResolver {
	return &defaultGridSectionResolver{r}
}

// DefaultSection returns generated.DefaultSectionResolver implementation.
func (r *Resolver) DefaultSection() generated.DefaultSectionResolver {
	return &defaultSectionResolver{r}
}

// FeaturedSection returns generated.FeaturedSectionResolver implementation.
func (r *Resolver) FeaturedSection() generated.FeaturedSectionResolver {
	return &featuredSectionResolver{r}
}

// IconSection returns generated.IconSectionResolver implementation.
func (r *Resolver) IconSection() generated.IconSectionResolver { return &iconSectionResolver{r} }

// LabelSection returns generated.LabelSectionResolver implementation.
func (r *Resolver) LabelSection() generated.LabelSectionResolver { return &labelSectionResolver{r} }

// MessageSection returns generated.MessageSectionResolver implementation.
func (r *Resolver) MessageSection() generated.MessageSectionResolver {
	return &messageSectionResolver{r}
}

// Page returns generated.PageResolver implementation.
func (r *Resolver) Page() generated.PageResolver { return &pageResolver{r} }

// PosterGridSection returns generated.PosterGridSectionResolver implementation.
func (r *Resolver) PosterGridSection() generated.PosterGridSectionResolver {
	return &posterGridSectionResolver{r}
}

// PosterSection returns generated.PosterSectionResolver implementation.
func (r *Resolver) PosterSection() generated.PosterSectionResolver { return &posterSectionResolver{r} }

type collectionResolver struct{ *Resolver }
type defaultGridSectionResolver struct{ *Resolver }
type defaultSectionResolver struct{ *Resolver }
type featuredSectionResolver struct{ *Resolver }
type iconSectionResolver struct{ *Resolver }
type labelSectionResolver struct{ *Resolver }
type messageSectionResolver struct{ *Resolver }
type pageResolver struct{ *Resolver }
type posterGridSectionResolver struct{ *Resolver }
type posterSectionResolver struct{ *Resolver }
