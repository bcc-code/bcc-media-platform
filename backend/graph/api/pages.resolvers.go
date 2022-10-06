package graph

// This file will be automatically regenerated based on the schema, any resolver implementations
// will be copied through when generating and any unknown code will be moved to the end.

import (
	"context"
	"fmt"

	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/graph/api/generated"
	"github.com/bcc-code/brunstadtv/backend/graph/api/model"
	"github.com/bcc-code/brunstadtv/backend/utils"
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
func (r *defaultSectionResolver) Items(ctx context.Context, obj *model.DefaultSection, first *int, offset *int) (*model.SectionItemPagination, error) {
	pagination, err := sectionCollectionItemResolver(ctx, r.Resolver, obj.ID, first, offset)

	if err != nil {
		return nil, err
	}

	return &model.SectionItemPagination{
		Total:  pagination.Total,
		First:  pagination.First,
		Offset: pagination.Offset,
		Items:  pagination.Items,
	}, nil
}

// Items is the resolver for the items field.
func (r *featuredSectionResolver) Items(ctx context.Context, obj *model.FeaturedSection, first *int, offset *int) (*model.SectionItemPagination, error) {
	pagination, err := sectionCollectionItemResolver(ctx, r.Resolver, obj.ID, first, offset)

	if err != nil {
		return nil, err
	}

	return &model.SectionItemPagination{
		Total:  pagination.Total,
		First:  pagination.First,
		Offset: pagination.Offset,
		Items:  pagination.Items,
	}, nil
}

// Items is the resolver for the items field.
func (r *gridSectionResolver) Items(ctx context.Context, obj *model.GridSection, first *int, offset *int) (*model.SectionItemPagination, error) {
	pagination, err := sectionCollectionItemResolver(ctx, r.Resolver, obj.ID, first, offset)

	if err != nil {
		return nil, err
	}

	return &model.SectionItemPagination{
		Total:  pagination.Total,
		First:  pagination.First,
		Offset: pagination.Offset,
		Items:  pagination.Items,
	}, nil
}

// Items is the resolver for the items field.
func (r *labelSectionResolver) Items(ctx context.Context, obj *model.LabelSection) (*model.LabelItemPagination, error) {
	panic(fmt.Errorf("not implemented"))
}

// Sections is the resolver for the sections field.
func (r *pageResolver) Sections(ctx context.Context, obj *model.Page, first *int, offset *int) (*model.SectionPagination, error) {
	sections, err := itemsResolverForIntID(ctx, &itemLoaders[int, common.Section]{
		Item:        r.Loaders.SectionLoader,
		Permissions: r.Loaders.SectionPermissionLoader,
	}, r.Loaders.SectionsLoader, obj.ID, model.SectionFrom)
	if err != nil {
		return nil, err
	}
	pagination := utils.Paginate(sections, first, offset, nil)
	return &model.SectionPagination{
		Total:  pagination.Total,
		First:  pagination.First,
		Offset: pagination.Offset,
		Items:  pagination.Items,
	}, nil
}

// Page is the resolver for the page field.
func (r *pageLabelItemResolver) Page(ctx context.Context, obj *model.PageLabelItem) (*model.Page, error) {
	return r.QueryRoot().Page(ctx, &obj.ID, nil)
}

// Items is the resolver for the items field.
func (r *posterSectionResolver) Items(ctx context.Context, obj *model.PosterSection, first *int, offset *int) (*model.SectionItemPagination, error) {
	pagination, err := sectionCollectionItemResolver(ctx, r.Resolver, obj.ID, first, offset)

	if err != nil {
		return nil, err
	}

	return &model.SectionItemPagination{
		Total:  pagination.Total,
		First:  pagination.First,
		Offset: pagination.Offset,
		Items:  pagination.Items,
	}, nil
}

// Collection returns generated.CollectionResolver implementation.
func (r *Resolver) Collection() generated.CollectionResolver { return &collectionResolver{r} }

// DefaultSection returns generated.DefaultSectionResolver implementation.
func (r *Resolver) DefaultSection() generated.DefaultSectionResolver {
	return &defaultSectionResolver{r}
}

// FeaturedSection returns generated.FeaturedSectionResolver implementation.
func (r *Resolver) FeaturedSection() generated.FeaturedSectionResolver {
	return &featuredSectionResolver{r}
}

// GridSection returns generated.GridSectionResolver implementation.
func (r *Resolver) GridSection() generated.GridSectionResolver { return &gridSectionResolver{r} }

// LabelSection returns generated.LabelSectionResolver implementation.
func (r *Resolver) LabelSection() generated.LabelSectionResolver { return &labelSectionResolver{r} }

// Page returns generated.PageResolver implementation.
func (r *Resolver) Page() generated.PageResolver { return &pageResolver{r} }

// PageLabelItem returns generated.PageLabelItemResolver implementation.
func (r *Resolver) PageLabelItem() generated.PageLabelItemResolver { return &pageLabelItemResolver{r} }

// PosterSection returns generated.PosterSectionResolver implementation.
func (r *Resolver) PosterSection() generated.PosterSectionResolver { return &posterSectionResolver{r} }

type collectionResolver struct{ *Resolver }
type defaultSectionResolver struct{ *Resolver }
type featuredSectionResolver struct{ *Resolver }
type gridSectionResolver struct{ *Resolver }
type labelSectionResolver struct{ *Resolver }
type pageResolver struct{ *Resolver }
type pageLabelItemResolver struct{ *Resolver }
type posterSectionResolver struct{ *Resolver }
