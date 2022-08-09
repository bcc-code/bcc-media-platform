package sqlc

import (
	"context"
	"encoding/json"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/samber/lo"
	"time"
)

func mapToPages(pages []getPagesRow) []common.Page {
	return lo.Map(pages, func(p getPagesRow, _ int) common.Page {
		var title common.LocaleString
		var description common.LocaleString

		_ = json.Unmarshal(p.Title.RawMessage, &title)
		_ = json.Unmarshal(p.Title.RawMessage, &description)

		return common.Page{
			ID: int(p.ID),
			Availability: common.Availability{
				Published: p.Published,
				From:      time.Date(2000, time.January, 1, 0, 0, 0, 0, nil),
				To:        time.Date(2100, time.January, 1, 0, 0, 0, 0, nil),
			},
			Roles: common.Roles{
				Access: p.Roles,
			},
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
	return mapToPages(lo.Map(pages, func(p listPagesRow, _ int) getPagesRow {
		return getPagesRow(p)
	})), nil
}

// GetPagesByCode returns a list of pages retrieved by codes
func (q *Queries) GetPagesByCode(ctx context.Context, codes []string) ([]common.Page, error) {
	pages, err := q.getPagesByCode(ctx, codes)
	if err != nil {
		return nil, err
	}
	return mapToPages(lo.Map(pages, func(p getPagesByCodeRow, _ int) getPagesRow {
		return getPagesRow(p)
	})), nil
}
