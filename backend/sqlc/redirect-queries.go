package sqlc

import (
	"context"

	"github.com/bcc-code/brunstadtv/backend/batchloaders"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/google/uuid"
	"github.com/samber/lo"
)

func mapToRedirects(redirects []Redirect) []common.Redirect {
	return lo.Map(redirects, func(r Redirect, _ int) common.Redirect {
		return common.Redirect{
			Code:      r.Code,
			ID:        r.ID,
			TargetURL: r.TargetUrl,
		}
	})
}

// GetRedirects returns a list of redirects retrieved by ids
func (q *Queries) GetRedirects(ctx context.Context, ids []uuid.UUID) ([]common.Redirect, error) {
	rows, err := q.getRedirects(ctx, ids)
	if err != nil {
		return nil, err
	}
	return mapToRedirects(rows), err
}

// GetOriginal returns the requested string
func (row getRedirectIDsForCodesRow) GetOriginal() string {
	return row.Code
}

// GetResult returns the id from the query
func (row getRedirectIDsForCodesRow) GetResult() uuid.UUID {
	return row.ID
}

// GetApplicationIDsForCodes returns ids for the requested codes
func (q *Queries) GetRedirectIDsForCodes(ctx context.Context, codes []string) ([]batchloaders.Conversion[string, uuid.UUID], error) {
	rows, err := q.getRedirectIDsForCodes(ctx, codes)
	if err != nil {
		return nil, err
	}
	return lo.Map(rows, func(i getRedirectIDsForCodesRow, _ int) batchloaders.Conversion[string, uuid.UUID] {
		return i
	}), nil
}
