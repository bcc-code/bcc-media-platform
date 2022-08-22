package sqlc

import (
	"context"
	"encoding/json"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/samber/lo"
)

func mapToSections(items []getSectionsRow) []common.Section {
	return lo.Map(items, func(s getSectionsRow, _ int) common.Section {
		var title common.LocaleString
		var description common.LocaleString

		_ = json.Unmarshal(s.Title.RawMessage, &title)
		_ = json.Unmarshal(s.Description.RawMessage, &description)

		return common.Section{
			ID:           int(s.ID),
			Sort:         int(s.Sort.ValueOrZero()),
			PageID:       int(s.PageID.Int64),
			Title:        title,
			Description:  description,
			Type:         "item",
			CollectionID: s.CollectionID,
			Style:        s.Style.ValueOrZero(),
			Roles:        s.Roles,
		}
	})
}

// GetSections returns a list of sections retrieved by ids
func (q *Queries) GetSections(ctx context.Context, ids []int) ([]common.Section, error) {
	sections, err := q.getSections(ctx, intToInt32(ids))
	if err != nil {
		return nil, err
	}
	return mapToSections(sections), nil
}

// GetID returns the id for this row
func (row getSectionIDsForPagesRow) GetID() int {
	return int(row.ID)
}

// GetRelationID returns the relation id for this row
func (row getSectionIDsForPagesRow) GetRelationID() int {
	return int(row.PageID.Int64)
}

// GetSectionIDsForPages returns a list of episodes specified by seasons
func (q *Queries) GetSectionIDsForPages(ctx context.Context, ids []int) ([]common.Relation[int, int], error) {
	rows, err := q.getSectionIDsForPages(ctx, intToInt32(ids))
	if err != nil {
		return nil, err
	}
	return lo.Map(rows, func(i getSectionIDsForPagesRow, _ int) common.Relation[int, int] {
		return i
	}), nil
}
