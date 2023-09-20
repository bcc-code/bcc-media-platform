package sqlc

import (
	"context"
	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/loaders"
	"github.com/google/uuid"
	"github.com/samber/lo"
)

// ApplicationQueries contains queries specific to application
type ApplicationQueries struct {
	*Queries
	GroupID uuid.UUID
}

// ApplicationQueries returns application-queries
func (q *Queries) ApplicationQueries(groupID uuid.UUID) *ApplicationQueries {
	return &ApplicationQueries{
		GroupID: groupID,
		Queries: q,
	}
}

func mapToApplications(applications []getApplicationsRow) []common.Application {
	return lo.Map(applications, func(p getApplicationsRow, _ int) common.Application {

		return common.Application{
			ID:                  int(p.ID),
			UUID:                p.Uuid,
			GroupID:             p.GroupID,
			Default:             p.Default,
			Code:                p.Code,
			ClientVersion:       p.ClientVersion.ValueOrZero(),
			DefaultPageID:       p.DefaultPageID,
			SearchPageID:        p.SearchPageID,
			GamesPageID:         p.GamesPageID,
			RelatedCollectionID: p.StandaloneRelatedCollectionID,
			SupportEmail:        p.SupportEmail,
			Roles:               p.Roles,
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

// GetApplicationGroups returns application groups
func (q *Queries) GetApplicationGroups(ctx context.Context, ids []uuid.UUID) ([]common.ApplicationGroup, error) {
	rows, err := q.getApplicationGroups(ctx, ids)
	if err != nil {
		return nil, err
	}
	return lo.Map(rows, func(i getApplicationGroupsRow, _ int) common.ApplicationGroup {
		return common.ApplicationGroup{
			ID:    i.ID,
			Roles: i.Roles,
		}
	}), nil
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
func (q *Queries) GetApplicationIDsForCodes(ctx context.Context, codes []string) ([]loaders.Conversion[string, int], error) {
	rows, err := q.getApplicationIDsForCodes(ctx, codes)
	if err != nil {
		return nil, err
	}
	return lo.Map(rows, func(i getApplicationIDsForCodesRow, _ int) loaders.Conversion[string, int] {
		return i
	}), nil
}
