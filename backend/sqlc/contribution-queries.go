package sqlc

import (
	"context"

	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/google/uuid"
	"github.com/samber/lo"
)

func (pq *PersonalizedQueries) GetContributionsForPersonsWithRoles(ctx context.Context, ids []uuid.UUID) ([]common.Contribution, error) {
	rows, err := pq.queries.getContributionIDsForPersonsWithRoles(ctx, getContributionIDsForPersonsWithRolesParams{
		PersonIds:                  ids,
		Roles:                      pq.roles,
		PreferredLanguagesOnly:     pq.languagePreferences.ContentOnlyInPreferredLanguage,
		PreferredAudioLanguages:    pq.languagePreferences.PreferredAudioLanguages,
		PreferredSubtitleLanguages: pq.languagePreferences.PreferredSubtitlesLanguages,
	})

	if err != nil {
		return nil, err
	}
	return lo.Map(rows, func(i getContributionIDsForPersonsWithRolesRow, _ int) common.Contribution {
		return common.Contribution{
			PersonID:    i.PersonID,
			Type:        i.Type,
			ItemID:      i.ItemID,
			ItemType:    i.ItemType,
			ContentType: i.ContentType,
			MediaItemID: i.MediaitemID,
		}
	}), nil
}
