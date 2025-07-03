package loaders

import (
	"context"
	"encoding/json"
	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/members"
	"github.com/bcc-code/bcc-media-platform/backend/sqlc"
	"github.com/google/uuid"
	"github.com/samber/lo"
	"gopkg.in/guregu/null.v4"
	"time"
)

func InitBatchLoaders(queries *sqlc.Queries, membersClient *members.Client) *BatchLoaders {
	ctx := context.Background()
	return &BatchLoaders{
		// App
		ApplicationLoader:           New(ctx, queries.GetApplications),
		ApplicationIDFromCodeLoader: NewConversionLoader(ctx, queries.GetApplicationIDsForCodes, WithName("application-id")),
		ApplicationGroupLoader:      New(ctx, queries.GetApplicationGroups),

		//Redirect
		RedirectLoader:           New(ctx, queries.GetRedirects),
		RedirectIDFromCodeLoader: NewConversionLoader(ctx, queries.GetRedirectIDsForCodes, WithName("redirect-id")),
		// Item
		PageLoader:                         New(ctx, queries.GetPages),
		PageIDFromCodeLoader:               NewConversionLoader(ctx, queries.GetPageIDsForCodes, WithName("page-id")),
		SectionLoader:                      New(ctx, queries.GetSections),
		ShowLoader:                         New(ctx, queries.GetShows),
		SeasonLoader:                       New(ctx, queries.GetSeasons),
		EpisodeLoader:                      New(ctx, queries.GetEpisodes),
		EpisodeIDFromLegacyProgramIDLoader: NewConversionLoader(ctx, queries.GetEpisodeIDsForLegacyProgramIDs, WithName("episode-programid")),
		EpisodeIDFromLegacyIDLoader:        NewConversionLoader(ctx, queries.GetEpisodeIDsForLegacyIDs, WithName("episode-legacyid")),
		LinkLoader:                         New(ctx, queries.GetLinks),
		EventLoader:                        New(ctx, queries.GetEvents),
		EventEntriesLoader:                 NewRelationLoader(ctx, queries.GetEntryIDsForEventIDs, WithName("event-entries")),
		PlaylistLoader: New(ctx, queries.GetPlaylists, WithName("playlist-loader"), WithKeyFunc(func(i common.Playlist) uuid.UUID {
			return i.ID
		})),

		FilesLoader: NewListLoader(ctx, queries.GetFilesForEpisodes, func(row common.File) int {
			return row.EpisodeID
		}),
		StreamsLoader: NewListLoader(ctx, queries.GetStreamsForEpisodes, func(row common.Stream) int {
			return row.EpisodeID
		}),

		AssetFilesLoader: NewListLoader(ctx, queries.GetFilesForAssets, func(row common.File) int {
			return row.AssetID
		}),
		AssetStreamsLoader: NewListLoader(ctx, queries.GetStreamsForAssets, func(row common.Stream) int {
			return row.AssetID
		}),

		CollectionLoader: New(ctx, queries.GetCollections),
		CollectionItemLoader: NewListLoader(ctx, queries.GetItemsForCollections, func(row common.CollectionItem) int {
			return row.CollectionID
		}),
		CollectionIDFromSlugLoader: NewConversionLoader(ctx, queries.GetCollectionIDsForCodes, WithName("collection-id")),
		EpisodeProgressLoader:      NewRelationLoader(ctx, queries.GetEpisodeIDsWithProgress, WithName("episode-progress")),
		EpisodeIDFromUuidLoader:    NewConversionLoader(ctx, queries.GetEpisodeIDsForUuids, WithName("episode-uuids-ids")),
		ShowIDFromUuidLoader:       NewConversionLoader(ctx, queries.GetShowIDsForUuids, WithName("show-uuids-ids")),
		// Permissions
		ShowPermissionLoader: NewCustomLoader(ctx, queries.GetPermissionsForShows, func(i common.Permissions[int]) int {
			return i.ItemID
		}, WithName("show-permission"), WithMemoryCache(time.Second*15)),
		SeasonPermissionLoader: NewCustomLoader(ctx, queries.GetPermissionsForSeasons, func(i common.Permissions[int]) int {
			return i.ItemID
		}, WithName("season-permission"), WithMemoryCache(time.Second*15)),
		EpisodePermissionLoader: NewCustomLoader(ctx, queries.GetPermissionsForEpisodes, func(i common.Permissions[int]) int {
			return i.ItemID
		}, WithName("episode-permission"), WithMemoryCache(time.Second*15)),
		PagePermissionLoader: NewCustomLoader(ctx, queries.GetPermissionsForPages, func(i common.Permissions[int]) int {
			return i.ItemID
		}, WithName("page-permission"), WithMemoryCache(time.Second*15)),
		SectionPermissionLoader: NewCustomLoader(ctx, queries.GetPermissionsForSections, func(i common.Permissions[int]) int {
			return i.ItemID
		}, WithName("section-permission"), WithMemoryCache(time.Second*15)),

		MemberLoader: New(ctx, membersClient.GetMembersByIDs, WithKeyFunc(func(i members.Member) int {
			return i.PersonID
		}), WithName("member-loader")),

		OrganizationLoader: New(ctx, membersClient.GetOrganizationsByIDs, WithKeyFunc(func(i members.Organization) uuid.UUID {
			return i.Uid
		})),

		SurveyLoader: New(ctx, queries.GetSurveys, WithName("survey-loader"), WithKeyFunc(func(i common.Survey) uuid.UUID {
			return i.ID
		})),

		SurveyQuestionLoader: New(ctx, queries.GetSurveyQuestions, WithName("survey-question-loader"), WithKeyFunc(func(i common.SurveyQuestion) uuid.UUID {
			return i.ID
		})),

		PromptLoader: New(ctx, mapDbResponseWith(queries.GetPrompts, promptRowToPrompt), WithKeyFunc(func(i common.Prompt) uuid.UUID {
			return i.ID
		})),

		PersonLoader: New(ctx, queries.GetPersons, WithName("person-loader"), WithKeyFunc(func(i common.Person) uuid.UUID {
			return i.ID
		})),
		SongLoader: New(ctx, queries.GetSongs, WithName("song-loader"), WithKeyFunc(func(i common.Song) uuid.UUID {
			return i.ID
		})),
		MediaItemPrimaryEpisodeIDLoader: NewConversionLoader(ctx, queries.GetPrimaryEpisodeIDForMediaItems, WithName("media-primary-episode")),
		TimedMetadataLoader: New(ctx, queries.GetTimedMetadata, WithName("timedmetadata-loader"), WithKeyFunc(func(i common.TimedMetadata) uuid.UUID {
			return i.ID
		})),
		ChaptersLoader: NewListLoader(ctx, queries.GetChaptersForEpisodeID, func(i common.TimedMetadata) int {
			return i.ParentEpisodeID
		}),
		PhraseLoader: New(ctx, queries.GetPhrases, WithName("phrases-loader"), WithKeyFunc(func(i common.Phrase) string {
			return i.Key
		})),

		FAQCategoryLoader:  NewLoader(ctx, queries.GetFAQCategories),
		QuestionLoader:     NewLoader(ctx, queries.GetQuestions),
		MessageGroupLoader: NewLoader(ctx, queries.GetMessageGroups),

		GameLoader: New(ctx, queries.GetGames, WithKeyFunc(func(i common.Game) uuid.UUID {
			return i.ID
		})),
		ShortLoader: New(ctx, queries.GetShorts, WithKeyFunc(func(i common.Short) uuid.UUID {
			return i.ID
		})),
		ShortsMediaIDLoader: NewConversionLoader(ctx, queries.GetMediaIDsForShortIDs, WithName("shorts-media-id")),

		// User Data
		StudyTopicLoader:  New(ctx, queries.GetTopics),
		StudyLessonLoader: New(ctx, queries.GetLessons),
		StudyTaskLoader:   New(ctx, queries.GetTasks),
		StudyQuestionAlternativesLoader: NewListLoader(ctx, queries.GetQuestionAlternatives, func(alt common.QuestionAlternative) uuid.UUID {
			return alt.TaskID
		}),
		// Achievements
		AchievementLoader:                  New(ctx, queries.GetAchievements),
		AchievementGroupLoader:             New(ctx, queries.GetAchievementGroups),
		AchievementsLoader:                 NewRelationLoader(ctx, queries.GetAchievementsForProfiles, WithMemoryCache(time.Second*30), WithName("achievements")),
		UnconfirmedAchievementsLoader:      NewRelationLoader(ctx, queries.GetUnconfirmedAchievementsForProfiles, WithMemoryCache(time.Second*30), WithName("unconfirmed-achievements")),
		AchievementGroupAchievementsLoader: NewRelationLoader(ctx, queries.GetAchievementsForGroups, WithName("group-achievements")),

		CompletedTopicsLoader:         NewRelationLoader(ctx, queries.GetCompletedTopics, WithName("completed-topics")),
		CompletedLessonsLoader:        NewRelationLoader(ctx, queries.GetCompletedLessons, WithName("completed-lessons")),
		CompletedTasksLoader:          NewRelationLoader(ctx, queries.GetCompletedTasks, WithName("completed-tasks")),
		CompletedAndLockedTasksLoader: NewRelationLoader(ctx, queries.GetCompletedAndLockedTasks, WithMemoryCache(time.Second*1), WithName("completed-locked-tasks")),

		ComputedDataLoader: NewListLoader(ctx, queries.GetComputedDataForGroups, func(i common.ComputedData) uuid.UUID {
			return i.GroupID
		}),

		UserLoader: New(ctx, queries.GetUsers, WithKeyFunc(func(i common.User) string {
			return i.PersonID
		})),

		UserCollectionLoader:           New(ctx, queries.GetUserCollections, WithKeyFunc(func(i common.UserCollection) uuid.UUID { return i.ID })),
		UserCollectionEntryLoader:      New(ctx, queries.GetUserCollectionEntries, WithKeyFunc(func(i common.UserCollectionEntry) uuid.UUID { return i.ID })),
		UserCollectionEntryIDsLoader:   NewRelationLoader(ctx, queries.GetUserCollectionEntryIDsForUserCollectionIDs, WithName("user-collection-entry-ids")),
		ProfileUserCollectionIDsLoader: NewRelationLoader(ctx, queries.GetUserCollectionIDsForProfileIDs, WithName("user-collection-ids")),
		ProfileMyListCollectionID:      NewConversionLoader(ctx, queries.GetMyListCollectionForProfileIDs, WithName("user-my-list-id")),
	}
}

func promptRowToPrompt(i sqlc.GetPromptsRow, _ int) common.Prompt {
	var t = common.LocaleString{}
	var d = common.LocaleString{}
	_ = json.Unmarshal(i.Title.RawMessage, &t)
	_ = json.Unmarshal(i.SecondaryTitle.RawMessage, &d)

	t["no"] = null.StringFrom(i.OriginalTitle)
	if i.OriginalSecondaryTitle.Valid {
		d["no"] = null.StringFrom(i.OriginalSecondaryTitle.String)
	}

	return common.Prompt{
		ID:             i.ID,
		Title:          t,
		SecondaryTitle: d,
		SurveyID:       i.SurveyID,
		From:           i.From,
		To:             i.To,
		Type:           i.Type,
	}
}

func mapDbResponseWith[K comparable, T any, R any](factory func(ctx context.Context, keys []K) ([]T, error), mapWith func(T, int) R) func(ctx context.Context, keys []K) ([]R, error) {
	return func(ctx context.Context, keys []K) ([]R, error) {
		rows, err := factory(ctx, keys)
		if err != nil {
			return nil, err
		}
		return lo.Map(rows, mapWith), nil
	}
}
