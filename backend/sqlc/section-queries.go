package sqlc

import (
	"context"
	"encoding/json"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/samber/lo"
)

func mapToSections(items []SectionExpanded) []common.Section {
	return lo.Map(items, func(s SectionExpanded, _ int) common.Section {
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
			CollectionID: int(s.CollectionID.Int64),
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

// ListSections returns a list of sections
func (q *Queries) ListSections(ctx context.Context) ([]common.Section, error) {
	sections, err := q.listSections(ctx)
	if err != nil {
		return nil, err
	}
	return mapToSections(lo.Map(sections, func(s listSectionsRow, _ int) SectionExpanded {
		return SectionExpanded(s)
	})), nil
}

// GetSectionsForPageIDs returns a list of sections retrieved by page_id
func (q *Queries) GetSectionsForPageIDs(ctx context.Context, pageIds []int) ([]common.Section, error) {
	sections, err := q.getSectionsForPageIDs(ctx, intToInt32(pageIds))
	if err != nil {
		return nil, err
	}
	return mapToSections(lo.Map(sections, func(s getSectionsForPageIDsRow, _ int) SectionExpanded {
		return SectionExpanded(s)
	})), nil
}
