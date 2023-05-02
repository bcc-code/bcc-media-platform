package main

import (
	"context"
	"database/sql"
	"encoding/json"
	"fmt"
	cache "github.com/Code-Hex/go-generics-cache"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/items/collection"
	"github.com/bcc-code/brunstadtv/backend/loaders"
	"github.com/bcc-code/brunstadtv/backend/members"
	"github.com/bcc-code/brunstadtv/backend/memorycache"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/google/uuid"
	"github.com/samber/lo"
	"gopkg.in/guregu/null.v4"
	"sort"
	"strings"
	"time"
)

var roleLoaders = loaders.NewCollection[string, *common.FilteredLoaders](time.Minute)

func getLoadersForRoles(db *sql.DB, queries *sqlc.Queries, collectionLoader *loaders.Loader[int, *common.Collection], roles []string) *common.FilteredLoaders {
	sort.Strings(roles)

	key := strings.Join(roles, "-")

	if ls, ok := roleLoaders.Get(key); ok {
		return ls
	}

	ctx, cancel := context.WithCancel(context.Background())

	rq := queries.RoleQueries(roles)

	ls := &common.FilteredLoaders{
		Key: key,

		ShowFilterLoader:        loaders.NewFilterLoader(ctx, rq.GetShowIDsWithRoles, loaders.WithName("show-filter")),
		ShowUUIDFilterLoader:    loaders.NewFilterLoader(ctx, rq.GetShowUUIDsWithRoles, loaders.WithName("show-uuid-filter")),
		SeasonFilterLoader:      loaders.NewFilterLoader(ctx, rq.GetSeasonIDsWithRoles, loaders.WithName("season-filter")),
		EpisodeFilterLoader:     loaders.NewFilterLoader(ctx, rq.GetEpisodeIDsWithRoles, loaders.WithName("episode-filter")),
		EpisodeUUIDFilterLoader: loaders.NewFilterLoader(ctx, rq.GetEpisodeUUIDsWithRoles, loaders.WithName("episode-uuid-filter")),
		SeasonsLoader:           loaders.NewRelationLoader(ctx, rq.GetSeasonIDsForShowsWithRoles, loaders.WithName("seasons")),
		SectionsLoader:          loaders.NewRelationLoader(ctx, rq.GetSectionIDsForPagesWithRoles, loaders.WithName("sections")),
		EpisodesLoader:          loaders.NewRelationLoader(ctx, rq.GetEpisodeIDsForSeasonsWithRoles, loaders.WithName("episodes")),
		CollectionItemsLoader: loaders.NewListLoader(ctx, rq.GetItemsForCollectionsWithRoles, func(i common.CollectionItem) int {
			return i.CollectionID
		}, loaders.WithName("collection-items")),
		CollectionItemIDsLoader: collection.NewCollectionItemLoader(ctx, db, collectionLoader, roles),
		CalendarEntryLoader:     loaders.New(ctx, rq.GetCalendarEntries),
		StudyTopicFilterLoader:  loaders.NewFilterLoader(ctx, rq.GetTopicIDsWithRoles, loaders.WithName("study-topic-filter")),
		StudyLessonFilterLoader: loaders.NewFilterLoader(ctx, rq.GetLessonIDsWithRoles, loaders.WithName("study-lesson-filter")),
		StudyTaskFilterLoader:   loaders.NewFilterLoader(ctx, rq.GetTaskIDsWithRoles, loaders.WithName("study-task-filter")),
		StudyLessonsLoader:      loaders.NewRelationLoader(ctx, rq.GetLessonIDsForTopics, loaders.WithName("study-lessons")),
		StudyTasksLoader:        loaders.NewRelationLoader(ctx, rq.GetTaskIDsForLessons, loaders.WithName("study-tasks")),

		// Study Relations
		StudyLessonEpisodesLoader: loaders.NewRelationLoader(ctx, rq.GetEpisodeIDsForLessons, loaders.WithName("study-lesson-episodes")),
		EpisodeStudyLessonsLoader: loaders.NewRelationLoader(ctx, rq.GetLessonIDsForEpisodes, loaders.WithName("episode-study-lessons")),
		StudyLessonLinksLoader:    loaders.NewRelationLoader(ctx, rq.GetLinkIDsForLessons, loaders.WithName("study-lesson-links")),
		LinkStudyLessonsLoader:    loaders.NewRelationLoader(ctx, rq.GetLessonIDsForLinks, loaders.WithName("link-study-lessons")),

		PromptIDsLoader: func(ctx context.Context) ([]uuid.UUID, error) {
			return memorycache.GetOrSet(ctx, fmt.Sprintf("promptIDs:roles:%s", key), func(ctx context.Context) ([]uuid.UUID, error) {
				return queries.GetPromptIDsForRoles(ctx, roles)
			}, cache.WithExpiration(time.Minute*5))
		},
		SurveyQuestionsLoader: loaders.NewRelationLoader(ctx, rq.GetSurveyQuestionIDsForSurveyIDs, loaders.WithName("survey-questions-loader")),
	}

	// Canceling the context on delete stops janitors nested inside the loaders as well.
	roleLoaders.Set(key, ls, loaders.WithOnDelete(cancel))

	return ls
}

var profileLoaders = loaders.NewCollection[uuid.UUID, *common.ProfileLoaders](time.Minute)

func getLoadersForProfile(queries *sqlc.Queries, profileID uuid.UUID) *common.ProfileLoaders {
	if ls, ok := profileLoaders.Get(profileID); ok {
		return ls
	}

	ctx, cancel := context.WithCancel(context.Background())

	profileQueries := queries.ProfileQueries(profileID)
	ls := &common.ProfileLoaders{
		ProgressLoader: loaders.New(ctx, profileQueries.GetProgressForEpisodes, loaders.WithMemoryCache(time.Second*5), loaders.WithName("progress")),
		TaskCompletedLoader: loaders.NewFilterLoader(ctx, func(ctx context.Context, ids []uuid.UUID) ([]uuid.UUID, error) {
			return queries.GetAnsweredTasks(ctx, sqlc.GetAnsweredTasksParams{
				ProfileID: profileID,
				Column2:   ids,
			})
		}, loaders.WithMemoryCache(time.Second*5), loaders.WithName("task-completed")),
		AchievementAchievedAtLoader:   loaders.New(ctx, profileQueries.GetAchievementsAchievedAt, loaders.WithMemoryCache(time.Second*5), loaders.WithName("achieved-at")),
		GetSelectedAlternativesLoader: loaders.New(ctx, profileQueries.GetSelectedAlternatives, loaders.WithMemoryCache(time.Second*1), loaders.WithName("selected-alternatives")),

		SeasonDefaultEpisodeLoader: loaders.NewConversionLoader(ctx, profileQueries.DefaultEpisodeIDForSeasonIDs, loaders.WithMemoryCache(time.Second*5), loaders.WithName("season-default-episodes")),
		ShowDefaultEpisodeLoader:   loaders.NewConversionLoader(ctx, profileQueries.DefaultEpisodeIDForShowIDs, loaders.WithMemoryCache(time.Second*5), loaders.WithName("show-default-episodes")),

		TopicDefaultLessonLoader: loaders.NewConversionLoader(ctx, profileQueries.GetDefaultLessonIDForTopicIDs, loaders.WithMemoryCache(time.Second*5), loaders.WithName("topic-default-lessons")),
	}

	profileLoaders.Set(profileID, ls, loaders.WithOnDelete(func() {
		log.L.Debug().Msg("Clearing profile loader")

		ls.TaskCompletedLoader.ClearAll()
		ls.AchievementAchievedAtLoader.ClearAll()
		ls.ProgressLoader.ClearAll()
		ls.GetSelectedAlternativesLoader.ClearAll()

		ls.SeasonDefaultEpisodeLoader.ClearAll()
		ls.ShowDefaultEpisodeLoader.ClearAll()

		cancel()
	}))

	return ls
}

var applicationLoaders = loaders.NewCollection[uuid.UUID, *common.ApplicationLoaders](time.Minute)

func getApplicationLoaders(queries *sqlc.Queries, applicationID uuid.UUID) *common.ApplicationLoaders {
	if ls, ok := applicationLoaders.Get(applicationID); ok {
		return ls
	}

	appQueries := queries.ApplicationQueries(applicationID)

	ctx, cancel := context.WithCancel(context.Background())

	ls := &common.ApplicationLoaders{
		UserCollectionIDsLoader: loaders.NewRelationLoader(ctx, appQueries.GetUserCollectionIDsForProfileIDs, loaders.WithName("user-collection-ids")),
		UserMyListCollectionID:  loaders.NewConversionLoader(ctx, appQueries.GetMyListCollectionForProfileIDs, loaders.WithName("user-my-list-id")),
	}

	applicationLoaders.Set(applicationID, ls, loaders.WithOnDelete(cancel))

	return ls
}

func initBatchLoaders(queries *sqlc.Queries, membersClient *members.Client) *common.BatchLoaders {
	ctx := context.Background()
	return &common.BatchLoaders{
		// App
		ApplicationLoader:           loaders.New(ctx, queries.GetApplications),
		ApplicationIDFromCodeLoader: loaders.NewConversionLoader(ctx, queries.GetApplicationIDsForCodes, loaders.WithName("application-id")),
		//Redirect
		RedirectLoader:           loaders.New(ctx, queries.GetRedirects),
		RedirectIDFromCodeLoader: loaders.NewConversionLoader(ctx, queries.GetRedirectIDsForCodes, loaders.WithName("redirect-id")),
		// Item
		PageLoader:                         loaders.New(ctx, queries.GetPages),
		PageIDFromCodeLoader:               loaders.NewConversionLoader(ctx, queries.GetPageIDsForCodes, loaders.WithName("page-id")),
		SectionLoader:                      loaders.New(ctx, queries.GetSections),
		ShowLoader:                         loaders.New(ctx, queries.GetShows),
		SeasonLoader:                       loaders.New(ctx, queries.GetSeasons),
		EpisodeLoader:                      loaders.New(ctx, queries.GetEpisodes),
		EpisodeIDFromLegacyProgramIDLoader: loaders.NewConversionLoader(ctx, queries.GetEpisodeIDsForLegacyProgramIDs, loaders.WithName("episode-programid")),
		EpisodeIDFromLegacyIDLoader:        loaders.NewConversionLoader(ctx, queries.GetEpisodeIDsForLegacyIDs, loaders.WithName("episode-legacyid")),
		LinkLoader:                         loaders.New(ctx, queries.GetLinks),
		EventLoader:                        loaders.New(ctx, queries.GetEvents),
		FilesLoader: loaders.NewListLoader(ctx, queries.GetFilesForEpisodes, func(row common.File) int {
			return row.EpisodeID
		}),
		StreamsLoader: loaders.NewListLoader(ctx, queries.GetStreamsForEpisodes, func(row common.Stream) int {
			return row.EpisodeID
		}),
		CollectionLoader: loaders.New(ctx, queries.GetCollections),
		CollectionItemLoader: loaders.NewListLoader(ctx, queries.GetItemsForCollections, func(row common.CollectionItem) int {
			return row.CollectionID
		}),
		CollectionIDFromSlugLoader: loaders.NewConversionLoader(ctx, queries.GetCollectionIDsForCodes, loaders.WithName("collection-id")),
		EpisodeProgressLoader:      loaders.NewRelationLoader(ctx, queries.GetEpisodeIDsWithProgress, loaders.WithName("episode-progress")),
		EpisodeIDFromUuidLoader:    loaders.NewConversionLoader(ctx, queries.GetEpisodeIDsForUuids, loaders.WithName("episode-uuids-ids")),
		ShowIDFromUuidLoader:       loaders.NewConversionLoader(ctx, queries.GetShowIDsForUuids, loaders.WithName("show-uuids-ids")),
		// Permissions
		ShowPermissionLoader: loaders.NewCustomLoader(ctx, queries.GetPermissionsForShows, func(i common.Permissions[int]) int {
			return i.ItemID
		}, loaders.WithName("show-permission")),
		SeasonPermissionLoader: loaders.NewCustomLoader(ctx, queries.GetPermissionsForSeasons, func(i common.Permissions[int]) int {
			return i.ItemID
		}, loaders.WithName("season-permission")),
		EpisodePermissionLoader: loaders.NewCustomLoader(ctx, queries.GetPermissionsForEpisodes, func(i common.Permissions[int]) int {
			return i.ItemID
		}, loaders.WithName("episode-permission")),
		PagePermissionLoader: loaders.NewCustomLoader(ctx, queries.GetPermissionsForPages, func(i common.Permissions[int]) int {
			return i.ItemID
		}, loaders.WithName("page-permission")),
		SectionPermissionLoader: loaders.NewCustomLoader(ctx, queries.GetPermissionsForSections, func(i common.Permissions[int]) int {
			return i.ItemID
		}, loaders.WithName("section-permission")),

		MemberLoader: loaders.New(ctx, membersClient.RetrieveByIDs, loaders.WithKeyFunc(func(i members.Member) int {
			return i.PersonID
		}), loaders.WithName("member-loader")),

		SurveyLoader: loaders.New(ctx, queries.GetSurveys, loaders.WithName("survey-loader"), loaders.WithKeyFunc(func(i common.Survey) uuid.UUID {
			return i.ID
		})),

		SurveyQuestionLoader: loaders.New(ctx, queries.GetSurveyQuestions, loaders.WithName("survey-question-loader"), loaders.WithKeyFunc(func(i common.SurveyQuestion) uuid.UUID {
			return i.ID
		})),

		PromptLoader: loaders.New(ctx, mapDbResponseWith(queries.GetPrompts, promptRowToPrompt), loaders.WithKeyFunc(func(i common.Prompt) uuid.UUID {
			return i.ID
		})),

		FAQCategoryLoader:  loaders.NewLoader(ctx, queries.GetFAQCategories),
		QuestionLoader:     loaders.NewLoader(ctx, queries.GetQuestions),
		QuestionsLoader:    loaders.NewRelationLoader(ctx, queries.GetQuestionIDsForCategories, loaders.WithName("questions")),
		MessageGroupLoader: loaders.NewLoader(ctx, queries.GetMessageGroups),
		// User Data
		ProfilesLoader: loaders.NewListLoader(ctx, queries.GetProfilesForUserIDs, func(i common.Profile) string {
			return i.UserID
		}),
		StudyTopicLoader:  loaders.New(ctx, queries.GetTopics),
		StudyLessonLoader: loaders.New(ctx, queries.GetLessons),
		StudyTaskLoader:   loaders.New(ctx, queries.GetTasks),
		StudyQuestionAlternativesLoader: loaders.NewListLoader(ctx, queries.GetQuestionAlternatives, func(alt common.QuestionAlternative) uuid.UUID {
			return alt.TaskID
		}),
		// Achievements
		AchievementLoader:                  loaders.New(ctx, queries.GetAchievements),
		AchievementGroupLoader:             loaders.New(ctx, queries.GetAchievementGroups),
		AchievementsLoader:                 loaders.NewRelationLoader(ctx, queries.GetAchievementsForProfiles, loaders.WithMemoryCache(time.Second*30), loaders.WithName("achievements")),
		UnconfirmedAchievementsLoader:      loaders.NewRelationLoader(ctx, queries.GetUnconfirmedAchievementsForProfiles, loaders.WithMemoryCache(time.Second*30), loaders.WithName("unconfirmed-achievements")),
		AchievementGroupAchievementsLoader: loaders.NewRelationLoader(ctx, queries.GetAchievementsForGroups, loaders.WithName("group-achievements")),

		CompletedTopicsLoader:         loaders.NewRelationLoader(ctx, queries.GetCompletedTopics, loaders.WithName("completed-topics")),
		CompletedLessonsLoader:        loaders.NewRelationLoader(ctx, queries.GetCompletedLessons, loaders.WithName("completed-lessons")),
		CompletedTasksLoader:          loaders.NewRelationLoader(ctx, queries.GetCompletedTasks, loaders.WithName("completed-tasks")),
		CompletedAndLockedTasksLoader: loaders.NewRelationLoader(ctx, queries.GetCompletedAndLockedTasks, loaders.WithMemoryCache(time.Second*1), loaders.WithName("completed-locked-tasks")),

		ComputedDataLoader: loaders.NewListLoader(ctx, queries.GetComputedDataForGroups, func(i common.ComputedData) uuid.UUID {
			return i.GroupID
		}),

		UserLoader: loaders.New(ctx, queries.GetUsers, loaders.WithKeyFunc(func(i common.User) string {
			return i.PersonID
		})),

		UserCollectionLoader:         loaders.New(ctx, queries.GetUserCollections, loaders.WithKeyFunc(func(i common.UserCollection) uuid.UUID { return i.ID })),
		UserCollectionEntryLoader:    loaders.New(ctx, queries.GetUserCollectionEntries, loaders.WithKeyFunc(func(i common.UserCollectionEntry) uuid.UUID { return i.ID })),
		UserCollectionEntryIDsLoader: loaders.NewRelationLoader(ctx, queries.GetUserCollectionEntryIDsForUserCollectionIDs, loaders.WithName("user-collection-entry-ids")),
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
