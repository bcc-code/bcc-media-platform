package graph

import (
	"context"
	"fmt"
	"strconv"

	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/graph/api/model"
	"github.com/bcc-code/bcc-media-platform/backend/utils"
)

func getSectionsForCollection(collectionID int) (*model.SectionPagination, error) {
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

	entries, err := r.GetPersonalizedCollectionItems(ctx, collectionId)
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
