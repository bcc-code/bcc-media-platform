package sqlc

import (
	"context"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/google/uuid"
	"github.com/samber/lo"
)

// ProfileQueries contains methods for retrieving profile specific queries
type ProfileQueries struct {
	queries   *Queries
	profileID uuid.UUID
}

// ProfileQueries returns queries for profile
func (q *Queries) ProfileQueries(profileID uuid.UUID) *ProfileQueries {
	return &ProfileQueries{
		queries:   q,
		profileID: profileID,
	}
}

// GetProfilesForUserIDs retrieves profiles for the specific users.
func (aq *ApplicationQueries) GetProfilesForUserIDs(ctx context.Context, userIDs []string) ([]common.Profile, error) {
	profiles, err := aq.getProfiles(ctx, getProfilesParams{
		UserID:             userIDs,
		ApplicationgroupID: aq.groupID,
	})
	if err != nil {
		return nil, err
	}
	return lo.Map(profiles, func(i getProfilesRow, _ int) common.Profile {
		return common.Profile(i)
	}), nil
}

// SaveProfile creates or overwrites a profile in the database
func (q *Queries) SaveProfile(ctx context.Context, profile common.Profile) error {
	return q.saveProfile(ctx, saveProfileParams{
		ID:                 profile.ID,
		UserID:             profile.UserID,
		Name:               profile.Name,
		ApplicationgroupID: profile.ApplicationGroupID,
	})
}
