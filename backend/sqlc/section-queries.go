package sqlc

import (
	"context"
	"github.com/samber/lo"
)

// GetSections returns a list of sections retrieved by ids
func (q *Queries) GetSections(ctx context.Context, ids []int32) ([]SectionExpanded, error) {
	return q.getSections(ctx, ids)
}

// ListSections returns a list of sections
func (q *Queries) ListSections(ctx context.Context) ([]SectionExpanded, error) {
	sections, err := q.listSections(ctx)
	if err != nil {
		return nil, err
	}
	return lo.Map(sections, func(s listSectionsRow, _ int) SectionExpanded {
		return SectionExpanded(s)
	}), nil
}

// GetSectionsForPageIDs returns a list of sections retrieved by page_id
func (q *Queries) GetSectionsForPageIDs(ctx context.Context, pageIds []int32) ([]SectionExpanded, error) {
	sections, err := q.getSectionsForPageIDs(ctx, pageIds)
	if err != nil {
		return nil, err
	}
	return lo.Map(sections, func(s getSectionsForPageIDsRow, _ int) SectionExpanded {
		return SectionExpanded(s)
	}), nil
}
