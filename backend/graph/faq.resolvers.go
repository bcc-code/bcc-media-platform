package graph

// This file will be automatically regenerated based on the schema, any resolver implementations
// will be copied through when generating and any unknown code will be moved to the end.

import (
	"context"
	"time"

	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/graph/generated"
	gqlmodel "github.com/bcc-code/brunstadtv/backend/graph/model"
	"github.com/bcc-code/brunstadtv/backend/utils"
	"github.com/samber/lo"
)

// Categories is the resolver for the categories field.
func (r *fAQResolver) Categories(ctx context.Context, obj *gqlmodel.Faq, first *int, offset *int) (*gqlmodel.FAQCategoryPagination, error) {
	items, err := withCache(ctx, "categories", r.Queries.ListFAQCategories, time.Minute*5)
	if err != nil {
		return nil, err
	}

	cats := utils.MapWithCtx(ctx, lo.Map(items, func(i common.FAQCategory, _ int) *common.FAQCategory {
		return &i
	}), gqlmodel.FAQCategoryFrom)

	page := utils.Paginate(cats, first, offset)

	return &gqlmodel.FAQCategoryPagination{
		Total:  page.Total,
		First:  page.First,
		Offset: page.Offset,
		Items:  page.Items,
	}, nil
}

// Category is the resolver for the category field.
func (r *fAQResolver) Category(ctx context.Context, obj *gqlmodel.Faq, id string) (*gqlmodel.FAQCategory, error) {
	return resolverForIntID(ctx, &itemLoaders[int, common.FAQCategory]{
		Item: r.Loaders.FAQCategoryLoader,
	}, id, gqlmodel.FAQCategoryFrom)
}

// Question is the resolver for the question field.
func (r *fAQResolver) Question(ctx context.Context, obj *gqlmodel.Faq, id string) (*gqlmodel.Question, error) {
	return resolverForIntID(ctx, &itemLoaders[int, common.Question]{
		Item: r.Loaders.QuestionLoader,
	}, id, gqlmodel.QuestionFrom)
}

// Questions is the resolver for the questions field.
func (r *fAQCategoryResolver) Questions(ctx context.Context, obj *gqlmodel.FAQCategory, first *int, offset *int) (*gqlmodel.QuestionPagination, error) {
	items, err := itemsResolverForIntID(ctx, &itemLoaders[int, common.Question]{
		Item: r.Loaders.QuestionLoader,
	}, r.Loaders.QuestionsLoader, obj.ID, gqlmodel.QuestionFrom)
	if err != nil {
		return nil, err
	}

	page := utils.Paginate(items, first, offset)

	return &gqlmodel.QuestionPagination{
		Total:  page.Total,
		First:  page.First,
		Offset: page.Offset,
		Items:  page.Items,
	}, nil
}

// Category is the resolver for the category field.
func (r *questionResolver) Category(ctx context.Context, obj *gqlmodel.Question) (*gqlmodel.FAQCategory, error) {
	return r.FAQ().Category(ctx, nil, obj.Category.ID)
}

// FAQ returns generated.FAQResolver implementation.
func (r *Resolver) FAQ() generated.FAQResolver { return &fAQResolver{r} }

// FAQCategory returns generated.FAQCategoryResolver implementation.
func (r *Resolver) FAQCategory() generated.FAQCategoryResolver { return &fAQCategoryResolver{r} }

// Question returns generated.QuestionResolver implementation.
func (r *Resolver) Question() generated.QuestionResolver { return &questionResolver{r} }

type fAQResolver struct{ *Resolver }
type fAQCategoryResolver struct{ *Resolver }
type questionResolver struct{ *Resolver }
