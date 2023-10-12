package sqlc

import (
	"context"
	"encoding/json"
	"github.com/bcc-code/bcc-media-platform/backend/loaders"
	"time"

	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/samber/lo"
)

func (q *Queries) mapToPages(pages []getPagesRow) []common.Page {
	return lo.Map(pages, func(p getPagesRow, _ int) common.Page {
		var title common.LocaleString
		var description common.LocaleString

		_ = json.Unmarshal(p.Title.RawMessage, &title)
		_ = json.Unmarshal(p.Title.RawMessage, &description)

		return common.Page{
			ID:          int(p.ID),
			Code:        p.Code,
			Title:       title,
			Description: description,
			Images:      q.getImages(p.Images),
		}
	})
}

// GetPages returns a list of pages retrieved by ids
func (q *Queries) GetPages(ctx context.Context, ids []int) ([]common.Page, error) {
	pages, err := q.getPages(ctx, intToInt32(ids))
	if err != nil {
		return nil, err
	}
	return q.mapToPages(pages), err
}

// ListPages returns a list of pages
func (q *Queries) ListPages(ctx context.Context) ([]common.Page, error) {
	pages, err := q.listPages(ctx)
	if err != nil {
		return nil, err
	}

	return q.mapToPages(lo.Map(pages, func(p listPagesRow, _ int) getPagesRow {
		return getPagesRow(p)
	})), nil
}

// GetPermissionsForPages returns permissions for pages
func (q *Queries) GetPermissionsForPages(ctx context.Context, ids []int) ([]common.Permissions[int], error) {
	items, err := q.getPermissionsForPages(ctx, intToInt32(ids))
	if err != nil {
		return nil, err
	}

	from, _ := time.Parse("2006-01-02", "1900-01-01")
	to, _ := time.Parse("2006-01-02", "2100-01-01")

	return lo.Map(items, func(row getPermissionsForPagesRow, _ int) common.Permissions[int] {
		return common.Permissions[int]{
			ItemID: int(row.ID),
			Availability: common.Availability{
				Published: row.Published,
				From:      from,
				To:        to,
			},
			Roles: common.Roles{
				Access: row.Roles,
			},
		}
	}), nil
}

// GetOriginal returns the requested string
func (row getPageIDsForCodesRow) GetOriginal() string {
	return row.Code.String
}

// GetResult returns the id from the query
func (row getPageIDsForCodesRow) GetResult() int {
	return int(row.ID)
}

// GetPageIDsForCodes returns ids for the requested codes
func (q *Queries) GetPageIDsForCodes(ctx context.Context, codes []string) ([]loaders.Conversion[string, int], error) {
	rows, err := q.getPageIDsForCodes(ctx, codes)
	if err != nil {
		return nil, err
	}
	return lo.Map(rows, func(i getPageIDsForCodesRow, _ int) loaders.Conversion[string, int] {
		return i
	}), nil
}
