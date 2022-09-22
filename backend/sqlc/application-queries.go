package sqlc

import (
	"context"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/samber/lo"
)

func mapToApplications(applications []getApplicationsRow) []common.Application {
	return lo.Map(applications, func(p getApplicationsRow, _ int) common.Application {
		var defaultPage *string

		if p.DefaultPage.Valid {
			defaultPage = &p.DefaultPage.String
		}

		return common.Application{
			ID:            int(p.ID),
			Default:       p.Default,
			Code:          p.Code,
			Roles:         p.Roles,
			ClientVersion: p.ClientVersion.ValueOrZero(),
			DefaultPage:   defaultPage,
		}
	})
}

// GetApplications returns a list of applications retrieved by ids
func (q *Queries) GetApplications(ctx context.Context, ids []int) ([]common.Application, error) {
	apps, err := q.getApplications(ctx, intToInt32(ids))
	if err != nil {
		return nil, err
	}
	return mapToApplications(apps), err
}

// ListApplications returns a list of applications
func (q *Queries) ListApplications(ctx context.Context) ([]common.Application, error) {
	apps, err := q.listApplications(ctx)
	if err != nil {
		return nil, err
	}
	return mapToApplications(lo.Map(apps, func(p listApplicationsRow, _ int) getApplicationsRow {
		return getApplicationsRow(p)
	})), nil
}

// GetOriginal returns the requested string
func (row getApplicationIDsForCodesRow) GetOriginal() string {
	return row.Code
}

// GetResult returns the id from the query
func (row getApplicationIDsForCodesRow) GetResult() int {
	return int(row.ID)
}

// GetApplicationIDsForCodes returns ids for the requested codes
func (q *Queries) GetApplicationIDsForCodes(ctx context.Context, codes []string) ([]common.Conversion[string, int], error) {
	rows, err := q.getApplicationIDsForCodes(ctx, codes)
	if err != nil {
		return nil, err
	}
	return lo.Map(rows, func(i getApplicationIDsForCodesRow, _ int) common.Conversion[string, int] {
		return i
	}), nil
}
