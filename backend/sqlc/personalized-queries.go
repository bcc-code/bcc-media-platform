package sqlc

import (
	"context"
	"github.com/bcc-code/bcc-media-platform/backend/common"
)

// PersonalizedQueries contains queries that are personalized to the user and request
type PersonalizedQueries struct {
	queries             *Queries
	roles               []string
	languagePreferences common.LanguagePreferences
}

// PersonalizedQueries creates a new PersonalizedQueries instance.
// The PersonalizedQueries instance adds user specific filtering to the queries.
//
// Note that this should be extended if we need more personalized queries, or queries that
// need more data that is specific to the user or request
func (q *Queries) PersonalizedQueries(
	roles []string,
	languagePreferences common.LanguagePreferences,
) *PersonalizedQueries {
	return &PersonalizedQueries{
		queries: q,

		roles:               roles,
		languagePreferences: languagePreferences,
	}
}

func (q *PersonalizedQueries) GetEntriesForCollectionsFilteredByRolesAndLanguages(ctx context.Context, collectionIDs []int) ([]common.CollectionItem, error) {
	params := getCollectionEntriesForCollectionsFilteredByRolesAndLanguagesParams{
		Ids:                        intToInt32(collectionIDs),
		Roles:                      q.roles,
		OnlyPreferedLanguages:      q.languagePreferences.ContentOnlyInPreferredLanguage,
		PreferredAudioLanguages:    q.languagePreferences.PreferredAudioLanguages,
		PreferredSubtitleLanguages: q.languagePreferences.PreferredSubtitlesLanguages,
	}
	res, err := q.queries.getCollectionEntriesForCollectionsFilteredByRolesAndLanguages(ctx, params)

	if err != nil {
		return nil, err
	}

	colEnts := []CollectionsEntry{}
	for _, i := range res {
		colEnts = append(colEnts, CollectionsEntry{
			ID:            i.ID,
			Sort:          i.Sort,
			CollectionsID: i.CollectionsID,
			Item:          i.Item,
			Collection:    i.Collection,
		})
	}

	x := mapToCollectionItems(colEnts)
	return x, err
}
