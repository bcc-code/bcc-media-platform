package sqlc

import (
	"context"
	"github.com/bcc-code/bcc-media-platform/backend/common"
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
		ApplicationgroupID: aq.GroupID,
	})
	if err != nil {
		return nil, err
	}
	return lo.Map(profiles, func(i getProfilesRow, _ int) common.Profile {
		return common.Profile{
			ID:     i.ID,
			UserID: i.UserID,
			Name:   i.Name,
		}
	}), nil
}

// SaveProfile creates or overwrites a profile in the database
func (aq *ApplicationQueries) SaveProfile(ctx context.Context, profile common.Profile) error {
	return aq.saveProfile(ctx, saveProfileParams{
		ID:                 profile.ID,
		UserID:             profile.UserID,
		Name:               profile.Name,
		ApplicationgroupID: aq.GroupID,
	})
}
