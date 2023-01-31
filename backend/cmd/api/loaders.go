package main

import (
	"context"
	"database/sql"
	cache "github.com/Code-Hex/go-generics-cache"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/items/collection"
	"github.com/bcc-code/brunstadtv/backend/loaders"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/google/uuid"
	"sort"
	"strings"
	"time"
)

var rolesLoaderCache = cache.New[string, *common.FilteredLoaders]()
var profilesLoaderCache = cache.New[uuid.UUID, *common.ProfileLoaders](cache.AsLRU[uuid.UUID, *common.ProfileLoaders]())

func getLoadersForRoles(db *sql.DB, queries *sqlc.Queries, collectionLoader *loaders.Loader[int, *common.Collection], roles []string) *common.FilteredLoaders {
	sort.Strings(roles)

	key := strings.Join(roles, "-")

	if ls, ok := rolesLoaderCache.Get(key); ok {
		return ls
	}

	ctx, cancel := context.WithCancel(context.Background())

	defer cancel()

	rq := queries.RoleQueries(roles)

	ls := &common.FilteredLoaders{
		ShowFilterLoader:    loaders.NewFilterLoader(ctx, rq.GetShowIDsWithRoles),
		SeasonFilterLoader:  loaders.NewFilterLoader(ctx, rq.GetSeasonIDsWithRoles),
		EpisodeFilterLoader: loaders.NewFilterLoader(ctx, rq.GetEpisodeIDsWithRoles),
		SeasonsLoader:       loaders.NewRelationLoader(ctx, rq.GetSeasonIDsForShowsWithRoles),
		SectionsLoader:      loaders.NewRelationLoader(ctx, rq.GetSectionIDsForPagesWithRoles),
		EpisodesLoader:      loaders.NewRelationLoader(ctx, rq.GetEpisodeIDsForSeasonsWithRoles),
		CollectionItemsLoader: loaders.NewListLoader(ctx, rq.GetItemsForCollectionsWithRoles, func(i common.CollectionItem) int {
			return i.CollectionID
		}),
		CollectionItemIDsLoader: collection.NewCollectionItemLoader(ctx, db, collectionLoader, roles),
		CalendarEntryLoader:     loaders.New(ctx, rq.GetCalendarEntries),
		StudyTopicFilterLoader:  loaders.NewFilterLoader(ctx, rq.GetTopicIDsWithRoles),
		StudyLessonFilterLoader: loaders.NewFilterLoader(ctx, rq.GetLessonIDsWithRoles),
		StudyTaskFilterLoader:   loaders.NewFilterLoader(ctx, rq.GetTaskIDsWithRoles),
		StudyLessonsLoader:      loaders.NewRelationLoader(ctx, rq.GetLessonIDsForTopics),
		StudyTasksLoader:        loaders.NewRelationLoader(ctx, rq.GetTaskIDsForLessons),

		// Study Relations
		StudyLessonEpisodesLoader: loaders.NewRelationLoader(ctx, rq.GetEpisodeIDsForLessons),
		EpisodeStudyLessonsLoader: loaders.NewRelationLoader(ctx, rq.GetLessonIDsForEpisodes),
		StudyLessonLinksLoader:    loaders.NewRelationLoader(ctx, rq.GetLinkIDsForLessons),
		LinkStudyLessonsLoader:    loaders.NewRelationLoader(ctx, rq.GetLessonIDsForLinks),
	}

	rolesLoaderCache.Set(key, ls)

	return ls
}

func getLoadersForProfile(queries *sqlc.Queries, profileID uuid.UUID) *common.ProfileLoaders {
	if ls, ok := profilesLoaderCache.Get(profileID); ok {
		return ls
	}

	ctx := context.TODO()

	profileQueries := queries.ProfileQueries(profileID)
	ls := &common.ProfileLoaders{
		ProgressLoader: loaders.New(ctx, profileQueries.GetProgressForEpisodes, loaders.WithMemoryCache(time.Second*5)),
		TaskCompletedLoader: loaders.NewFilterLoader(ctx, func(ctx context.Context, ids []uuid.UUID) ([]uuid.UUID, error) {
			return queries.GetAnsweredTasks(ctx, sqlc.GetAnsweredTasksParams{
				ProfileID: profileID,
				Column2:   ids,
			})
		}, loaders.WithMemoryCache(time.Second*5)),
		AchievementAchievedAtLoader:   loaders.New(ctx, profileQueries.GetAchievementsAchievedAt, loaders.WithMemoryCache(time.Second*5)),
		GetSelectedAlternativesLoader: loaders.New(ctx, profileQueries.GetSelectedAlternatives, loaders.WithMemoryCache(time.Second*1)),
	}

	profilesLoaderCache.Set(profileID, ls, cache.WithExpiration(time.Minute*5))

	return ls
}

func initBatchLoaders(queries *sqlc.Queries) *common.BatchLoaders {
	ctx := context.Background()
	return &common.BatchLoaders{
		// App
		ApplicationLoader:           loaders.New(ctx, queries.GetApplications),
		ApplicationIDFromCodeLoader: loaders.NewConversionLoader(ctx, queries.GetApplicationIDsForCodes),
		//Redirect
		RedirectLoader:           loaders.New(ctx, queries.GetRedirects),
		RedirectIDFromCodeLoader: loaders.NewConversionLoader(ctx, queries.GetRedirectIDsForCodes),
		// Item
		PageLoader:                         loaders.New(ctx, queries.GetPages),
		PageIDFromCodeLoader:               loaders.NewConversionLoader(ctx, queries.GetPageIDsForCodes),
		SectionLoader:                      loaders.New(ctx, queries.GetSections),
		ShowLoader:                         loaders.New(ctx, queries.GetShows),
		SeasonLoader:                       loaders.New(ctx, queries.GetSeasons),
		EpisodeLoader:                      loaders.New(ctx, queries.GetEpisodes),
		EpisodeIDFromLegacyProgramIDLoader: loaders.NewConversionLoader(ctx, queries.GetEpisodeIDsForLegacyProgramIDs),
		EpisodeIDFromLegacyIDLoader:        loaders.NewConversionLoader(ctx, queries.GetEpisodeIDsForLegacyIDs),
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
		CollectionIDFromSlugLoader: loaders.NewConversionLoader(ctx, queries.GetCollectionIDsForCodes),
		EpisodeProgressLoader:      loaders.NewRelationLoader(ctx, queries.GetEpisodeIDsWithProgress),
		// Relations
		SectionsLoader: loaders.NewRelationLoader(ctx, queries.GetSectionIDsForPages),
		// Permissions
		ShowPermissionLoader: loaders.NewCustomLoader(ctx, queries.GetPermissionsForShows, func(i common.Permissions[int]) int {
			return i.ItemID
		}),
		SeasonPermissionLoader: loaders.NewCustomLoader(ctx, queries.GetPermissionsForSeasons, func(i common.Permissions[int]) int {
			return i.ItemID
		}),
		EpisodePermissionLoader: loaders.NewCustomLoader(ctx, queries.GetPermissionsForEpisodes, func(i common.Permissions[int]) int {
			return i.ItemID
		}),
		PagePermissionLoader: loaders.NewCustomLoader(ctx, queries.GetPermissionsForPages, func(i common.Permissions[int]) int {
			return i.ItemID
		}),
		SectionPermissionLoader: loaders.NewCustomLoader(ctx, queries.GetPermissionsForSections, func(i common.Permissions[int]) int {
			return i.ItemID
		}),

		FAQCategoryLoader:  loaders.NewLoader(ctx, queries.GetFAQCategories),
		QuestionLoader:     loaders.NewLoader(ctx, queries.GetQuestions),
		QuestionsLoader:    loaders.NewRelationLoader(ctx, queries.GetQuestionIDsForCategories),
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
		AchievementsLoader:                 loaders.NewRelationLoader(ctx, queries.GetAchievementsForProfiles, loaders.WithMemoryCache(time.Second*30)),
		UnconfirmedAchievementsLoader:      loaders.NewRelationLoader(ctx, queries.GetUnconfirmedAchievementsForProfiles, loaders.WithMemoryCache(time.Second*30)),
		AchievementGroupAchievementsLoader: loaders.NewRelationLoader(ctx, queries.GetAchievementsForGroups),

		CompletedTopicsLoader:         loaders.NewRelationLoader(ctx, queries.GetCompletedTopics),
		CompletedLessonsLoader:        loaders.NewRelationLoader(ctx, queries.GetCompletedLessons),
		CompletedTasksLoader:          loaders.NewRelationLoader(ctx, queries.GetCompletedTasks),
		CompletedAndLockedTasksLoader: loaders.NewRelationLoader(ctx, queries.GetCompletedAndLockedTasks, loaders.WithMemoryCache(time.Second*1)),

		ComputedDataLoader: loaders.NewListLoader(ctx, queries.GetComputedDataForGroups, func(i common.ComputedData) uuid.UUID {
			return i.GroupID
		}),
	}
}
