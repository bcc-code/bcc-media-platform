package graph

import (
	"context"
	"fmt"
	"strconv"

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
		return nil, nil
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

func getSectionItemsForCollectionPage(ctx context.Context, r *Resolver, collectionId int, first, offset *int, cursor *string) (*model.SectionItemPagination, error) {
	ls := r.GetLoaders()

	col, err := ls.CollectionLoader.Get(ctx, collectionId)
	if err != nil {
		return nil, err
	}

	entries, err := r.GetCollectionEntries(ctx, collectionId)
	if err != nil {
		return nil, err
	}

	var parsedCursor *utils.OffsetCursor
	if cursor != nil && *cursor != "" {
		var err error
		parsedCursor, err = utils.ParseOffsetCursor(*cursor)
		if err != nil {
			return nil, err
		}
	}

	pagination := utils.Paginate(entries, first, offset, nil, parsedCursor)

	preloadEntryLoaders(ctx, ls, pagination.Items)

	items, err := mapCollectionEntriesToSectionItems(ctx, ls, pagination.Items, common.ImageStyleDefault, col.NumberInTitles)
	if err != nil {
		return nil, err
	}

	return &model.SectionItemPagination{
		Total:       pagination.Total,
		First:       pagination.First,
		Offset:      pagination.Offset,
		Items:       items,
		Cursor:      pagination.Cursor.Encode(),
		NextCursor:  pagination.NextCursor.Encode(),
		HasNext:     pagination.HasNext,
		HasPrevious: pagination.HasPrevious,
	}, nil
}
