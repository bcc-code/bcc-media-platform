package section

import (
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/graph-gophers/dataloader/v7"
)

// NewBatchLoader returns a configured batch loader for GQL Section
func NewBatchLoader(queries sqlc.Queries) *dataloader.Loader[int, *sqlc.SectionExpanded] {
	return common.NewBatchLoader(queries.GetSections, func(row sqlc.SectionExpanded) int {
		return int(row.ID)
	}, func(id int) int32 {
		return int32(id)
	})
}

// NewListBatchLoader returns related data for a page
func NewListBatchLoader(queries sqlc.Queries) *dataloader.Loader[int, []*sqlc.SectionExpanded] {
	//TODO: Figure out a better way to deal with identical results from queries.
	return common.NewListBatchLoaderConvertable(queries.GetSectionsForPageIDs, func(i sqlc.GetSectionsForPageIDsRow) int {
		return int(i.PageID.ValueOrZero())
	}, func(id int) int32 {
		return int32(id)
	}, func(item sqlc.GetSectionsForPageIDsRow) sqlc.SectionExpanded {
		return sqlc.SectionExpanded{
			ID:           item.ID,
			Roles:        item.Roles,
			Title:        item.Title,
			Description:  item.Description,
			Published:    item.Published,
			Sort:         item.Sort,
			CollectionID: item.CollectionID,
			Style:        item.Style,
			PageID:       item.PageID,
			DateCreated:  item.DateCreated,
			DateUpdated:  item.DateUpdated,
		}
	})
}
