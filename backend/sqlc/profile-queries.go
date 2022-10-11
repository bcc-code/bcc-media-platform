package sqlc

import (
	"context"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/samber/lo"
)

// GetProfilesForUserIDs retrieves profiles for the specific users.
func (q *Queries) GetProfilesForUserIDs(ctx context.Context, userIDs []string) ([]common.Profile, error) {
	profiles, err := q.getProfiles(ctx, userIDs)
	if err != nil {
		return nil, err
	}
	return lo.Map(profiles, func(i UsersProfile, _ int) common.Profile {
		return common.Profile(i)
	}), nil
}

// SaveProfile creates or overwrites a profile in the database
func (q *Queries) SaveProfile(ctx context.Context, profile common.Profile) error {
	return q.saveProfile(ctx, saveProfileParams{
		Column1: profile.ID,
		Column2: profile.UserID,
		Column3: profile.Name,
	})
}
