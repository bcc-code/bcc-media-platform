package loaders

import (
	"context"
	"fmt"
	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/sqlc"
	"github.com/google/uuid"
	"strings"
	"time"
)

var personalizedLoaders = NewCollection[string, *PersonalizedLoaders](time.Minute)

func GetPersonalizedLoaders(
	queries *sqlc.Queries,
	roles []string,
	languagePreferences common.LanguagePreferences,
) *PersonalizedLoaders {
	pq := queries.PersonalizedQueries(roles, languagePreferences)

	key := fmt.Sprintf(
		"%s-%s-%s-%s",
		strings.Join(roles, "-"),
		strings.Join(languagePreferences.PreferredAudioLanguages, "-"),
		strings.Join(languagePreferences.PreferredSubtitlesLanguages, "-"),
		fmt.Sprintf("%t", languagePreferences.ContentOnlyInPreferredLanguage),
	)

	if ls, ok := personalizedLoaders.Get(key); ok {
		return ls
	}

	ctx, cancel := context.WithCancel(context.Background())

	ls := &PersonalizedLoaders{
		Key: key,

		CollectionItemsLoader: NewListLoader(ctx, pq.GetEntriesForCollectionsFilteredByRolesAndLanguages, func(i common.CollectionItem) int {
			return i.CollectionID
		}),
		ContributionsForPersonLoader: NewListLoader(ctx, pq.GetContributionsForPersonsWithRoles, func(i common.Contribution) uuid.UUID {
			return i.PersonID
		}, WithName("person-contributions")),
		TagEpisodesLoader: NewRelationLoader(ctx, pq.GetEpisodeIDsWithTagIDs, WithName("tags-episodes")),
	}

	// Canceling the context on delete stops janitors nested inside the loaders as well.
	personalizedLoaders.Set(key, ls, WithOnDelete(cancel))

	return ls
}
