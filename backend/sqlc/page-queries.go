package sqlc

import (
	"context"
	"github.com/samber/lo"
)

// GetPages returns a list of pages retrieved by ids
func (q *Queries) GetPages(ctx context.Context, ids []int32) ([]PageExpanded, error) {
	return q.getPages(ctx, ids)
}

// ListPages returns a list of pages
func (q *Queries) ListPages(ctx context.Context) ([]PageExpanded, error) {
	pages, err := q.listPages(ctx)
	if err != nil {
		return nil, err
	}
	return lo.Map(pages, func(p listPagesRow, _ int) PageExpanded {
		return PageExpanded{
			ID:          p.ID,
			Code:        p.Code,
			Type:        p.Type,
			SeasonID:    p.SeasonID,
			ShowID:      p.ShowID,
			EpisodeID:   p.EpisodeID,
			Collection:  p.Collection,
			Title:       p.Title,
			Description: p.Description,
			Roles:       p.Roles,
			Published:   p.Published,
		}
	}), nil
}

// GetPagesByCode returns a list of pages retrieved by codes
func (q *Queries) GetPagesByCode(ctx context.Context, codes []string) ([]PageExpanded, error) {
	pages, err := q.getPagesByCode(ctx, codes)
	if err != nil {
		return nil, err
	}
	return lo.Map(pages, func(p getPagesByCodeRow, _ int) PageExpanded {
		return PageExpanded{
			ID:          p.ID,
			Code:        p.Code,
			Type:        p.Type,
			SeasonID:    p.SeasonID,
			ShowID:      p.ShowID,
			EpisodeID:   p.EpisodeID,
			Title:       p.Title,
			Collection:  p.Collection,
			Description: p.Description,
			Roles:       p.Roles,
			Published:   p.Published,
		}
	}), nil
}
