package graph

import (
	"context"
	"fmt"
	"strconv"

	merry "github.com/ansel1/merry/v2"
	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/graph/api/model"
	"github.com/bcc-code/bcc-media-platform/backend/user"
	"github.com/bcc-code/bcc-media-platform/backend/utils"
)

func getPageForCollection(ctx context.Context, r *queryRootResolver, collectionId string) (*model.Page, error) {
	collection, err := r.Loaders.CollectionLoader.Get(ctx, utils.AsInt(collectionId))
	if err != nil {
		return nil, err
	}
	if collection == nil {
		return nil, merry.New("collection not found")
	}

	ginCtx, _ := utils.GinCtx(ctx)
	languages := user.GetLanguagesFromCtx(ginCtx)

	return &model.Page{
		Code:        fmt.Sprintf("c-%d", collection.ID),
		Title:       collection.Title.Get(languages),
		Description: nil,
	}, nil
}

func getSectionsForCollectionPage(collectionID int) (*model.SectionPagination, error) {
	return &model.SectionPagination{
		Total:  1,
		First:  1,
		Offset: 0,
		Items: []model.Section{
			&model.ListSection{
				ID: fmt.Sprintf("c-%s", strconv.Itoa(collectionID)),
			},
		},
	}, nil
}

func getSectionItemsForCollectionPage(ctx context.Context, r *Resolver, collectionId int, first, offset *int) (*model.SectionItemPagination, error) {
	ls := r.GetLoaders()

	col, err := ls.CollectionLoader.Get(ctx, collectionId)
	if err != nil {
		return nil, err
	}

	entries, err := r.GetCollectionEntries(ctx, collectionId)
	if err != nil {
		return nil, err
	}

	pagination := utils.Paginate(entries, first, offset, nil)

	preloadEntryLoaders(ctx, ls, pagination.Items)

	items, err := mapCollectionEntriesToSectionItems(ctx, ls, pagination.Items, common.ImageStyleDefault, col.NumberInTitles)
	if err != nil {
		return nil, err
	}

	return &model.SectionItemPagination{
		Total:  pagination.Total,
		First:  pagination.First,
		Offset: pagination.Offset,
		Items:  items,
	}, nil
}
