package sqlc

import (
	"context"
	"encoding/json"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/samber/lo"
)

func mapToPages(pages []PageExpanded) []common.Page {
	return lo.Map(pages, func(p PageExpanded, _ int) common.Page {
		var title common.LocaleString
		var description common.LocaleString

		_ = json.Unmarshal(p.Title.RawMessage, &title)
		_ = json.Unmarshal(p.Title.RawMessage, &description)

		return common.Page{
			ID:          int(p.ID),
			Published:   p.Published,
			Title:       title,
			Description: description,
		}
	})
}

// GetPages returns a list of pages retrieved by ids
func (q *Queries) GetPages(ctx context.Context, ids []int) ([]common.Page, error) {
	pages, err := q.getPages(ctx, intToInt32(ids))
	if err != nil {
		return nil, err
	}
	return mapToPages(pages), err
}

// ListPages returns a list of pages
func (q *Queries) ListPages(ctx context.Context) ([]common.Page, error) {
	pages, err := q.listPages(ctx)
	if err != nil {
		return nil, err
	}
	return mapToPages(lo.Map(pages, func(p listPagesRow, _ int) PageExpanded {
		return PageExpanded(p)
	})), nil
}

// GetPagesByCode returns a list of pages retrieved by codes
func (q *Queries) GetPagesByCode(ctx context.Context, codes []string) ([]common.Page, error) {
	pages, err := q.getPagesByCode(ctx, codes)
	if err != nil {
		return nil, err
	}
	return mapToPages(lo.Map(pages, func(p getPagesByCodeRow, _ int) PageExpanded {
		return PageExpanded(p)
	})), nil
}
