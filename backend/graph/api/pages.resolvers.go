package graph

// This file will be automatically regenerated based on the schema, any resolver implementations
// will be copied through when generating and any unknown code will be moved to the end.

import (
	"context"
	"fmt"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/graph/api/generated"
	"github.com/bcc-code/brunstadtv/backend/graph/api/model"
	"github.com/bcc-code/brunstadtv/backend/user"
	"github.com/bcc-code/brunstadtv/backend/utils"
	"strconv"
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
func (r *iconSectionResolver) Items(ctx context.Context, obj *model.IconSection, first *int, offset *int) (*model.LinkItemPagination, error) {
	pagination, err := sectionLinkItemResolver(ctx, r.Resolver, obj.ID, first, offset)

	if err != nil {
		return nil, err
	}

	return &model.LinkItemPagination{
		Total:  pagination.Total,
		First:  pagination.First,
		Offset: pagination.Offset,
		Items:  pagination.Items,
	}, nil
}

// Items is the resolver for the items field.
func (r *labelSectionResolver) Items(ctx context.Context, obj *model.LabelSection, first *int, offset *int) (*model.LinkItemPagination, error) {
	pagination, err := sectionLinkItemResolver(ctx, r.Resolver, obj.ID, first, offset)

	if err != nil {
		return nil, err
	}

	return &model.LinkItemPagination{
		Total:  pagination.Total,
		First:  pagination.First,
		Offset: pagination.Offset,
		Items:  pagination.Items,
	}, nil
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

// Page is the resolver for the page field.
func (r *pageLinkItemResolver) Page(ctx context.Context, obj *model.PageLinkItem) (*model.Page, error) {
	return r.QueryRoot().Page(ctx, &obj.Page.ID, nil)
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

// Subtitle is the resolver for the subtitle field.
func (r *sectionItemResolver) Subtitle(ctx context.Context, obj *model.SectionItem) (*string, error) {
	switch t := obj.Item.(type) {
	case *model.Episode:
		if t.Season != nil {
			s, err := r.QueryRoot().Season(ctx, t.Season.ID)
			if err != nil {
				return nil, err
			}
			sh, err := r.QueryRoot().Show(ctx, s.Show.ID)
			if err != nil {
				return nil, err
			}
			return &sh.Title, nil
		}
	case *model.Season:
		sh, err := r.QueryRoot().Show(ctx, t.Show.ID)
		if err != nil {
			return nil, err
		}
		return &sh.Title, nil
	}
	return nil, nil
}

// TertiaryTitle is the resolver for the tertiaryTitle field.
func (r *sectionItemResolver) TertiaryTitle(ctx context.Context, obj *model.SectionItem) (*string, error) {
	switch t := obj.Item.(type) {
	case *model.Episode:
		e, err := common.GetFromLoaderByID(ctx, r.Loaders.EpisodeLoader, utils.AsInt(t.ID))
		if err != nil {
			return nil, err
		}
		if e.PublishDateInTitle {
			ginCtx, _ := utils.GinCtx(ctx)
			str := utils.FormatDateInLocale(e.PublishDate, user.GetLanguagesFromCtx(ginCtx))
			return &str, nil
		}
		if t.Season != nil {
			s, err := r.QueryRoot().Season(ctx, t.Season.ID)
			if err != nil {
				return nil, err
			}
			num := 0
			if t.Number != nil {
				num = *t.Number
			}
			str := fmt.Sprintf("S%d:E%d", s.Number, num)
			return &str, nil
		}
	case *model.Season:
		str := fmt.Sprintf("S%d", t.Number)
		return &str, nil
	}
	return nil, nil
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

// IconSection returns generated.IconSectionResolver implementation.
func (r *Resolver) IconSection() generated.IconSectionResolver { return &iconSectionResolver{r} }

// LabelSection returns generated.LabelSectionResolver implementation.
func (r *Resolver) LabelSection() generated.LabelSectionResolver { return &labelSectionResolver{r} }

// Page returns generated.PageResolver implementation.
func (r *Resolver) Page() generated.PageResolver { return &pageResolver{r} }

// PageLinkItem returns generated.PageLinkItemResolver implementation.
func (r *Resolver) PageLinkItem() generated.PageLinkItemResolver { return &pageLinkItemResolver{r} }

// PosterSection returns generated.PosterSectionResolver implementation.
func (r *Resolver) PosterSection() generated.PosterSectionResolver { return &posterSectionResolver{r} }

// SectionItem returns generated.SectionItemResolver implementation.
func (r *Resolver) SectionItem() generated.SectionItemResolver { return &sectionItemResolver{r} }

type collectionResolver struct{ *Resolver }
type defaultSectionResolver struct{ *Resolver }
type featuredSectionResolver struct{ *Resolver }
type gridSectionResolver struct{ *Resolver }
type iconSectionResolver struct{ *Resolver }
type labelSectionResolver struct{ *Resolver }
type pageResolver struct{ *Resolver }
type pageLinkItemResolver struct{ *Resolver }
type posterSectionResolver struct{ *Resolver }
type sectionItemResolver struct{ *Resolver }
