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

	rq := queries.RoleQueries(roles)

	ls := &common.FilteredLoaders{
		ShowFilterLoader:    loaders.NewFilterLoader(rq.GetShowIDsWithRoles),
		SeasonFilterLoader:  loaders.NewFilterLoader(rq.GetSeasonIDsWithRoles),
		EpisodeFilterLoader: loaders.NewFilterLoader(rq.GetEpisodeIDsWithRoles),
		SeasonsLoader:       loaders.NewRelationLoader(rq.GetSeasonIDsForShowsWithRoles),
		SectionsLoader:      loaders.NewRelationLoader(rq.GetSectionIDsForPagesWithRoles),
		EpisodesLoader:      loaders.NewRelationLoader(rq.GetEpisodeIDsForSeasonsWithRoles),
		CollectionItemsLoader: loaders.NewListLoader(rq.GetItemsForCollectionsWithRoles, func(i common.CollectionItem) int {
			return i.CollectionID
		}),
		CollectionItemIDsLoader: collection.NewCollectionItemLoader(db, collectionLoader, roles),
		CalendarEntryLoader:     loaders.New(rq.GetCalendarEntries),
		StudyTopicFilterLoader:  loaders.NewFilterLoader(rq.GetTopicIDsWithRoles),
		StudyLessonFilterLoader: loaders.NewFilterLoader(rq.GetLessonIDsWithRoles),
		StudyTaskFilterLoader:   loaders.NewFilterLoader(rq.GetTaskIDsWithRoles),
		StudyLessonsLoader:      loaders.NewRelationLoader(rq.GetLessonIDsForTopics),
		StudyTasksLoader:        loaders.NewRelationLoader(rq.GetTaskIDsForLessons),

		// Study Relations
		StudyLessonEpisodesLoader: loaders.NewRelationLoader(rq.GetEpisodeIDsForLessons),
		EpisodeStudyLessonsLoader: loaders.NewRelationLoader(rq.GetLessonIDsForEpisodes),
		StudyLessonLinksLoader:    loaders.NewRelationLoader(rq.GetLinkIDsForLessons),
		LinkStudyLessonsLoader:    loaders.NewRelationLoader(rq.GetLessonIDsForLinks),
	}

	rolesLoaderCache.Set(key, ls)

	return ls
}

func getLoadersForProfile(queries *sqlc.Queries, profileID uuid.UUID) *common.ProfileLoaders {
	if ls, ok := profilesLoaderCache.Get(profileID); ok {
		return ls
	}

	profileQueries := queries.ProfileQueries(profileID)
	ls := &common.ProfileLoaders{
		ProgressLoader: loaders.New(profileQueries.GetProgressForEpisodes, loaders.WithMemoryCache(time.Second*5)),
		TaskCompletedLoader: loaders.NewFilterLoader(func(ctx context.Context, ids []uuid.UUID) ([]uuid.UUID, error) {
			return queries.GetAnsweredTasks(ctx, sqlc.GetAnsweredTasksParams{
				ProfileID: profileID,
				Column2:   ids,
			})
		}, loaders.WithMemoryCache(time.Second*5)),
		AchievementAchievedAtLoader:   loaders.New(profileQueries.GetAchievementsAchievedAt, loaders.WithMemoryCache(time.Second*5)),
		GetSelectedAlternativesLoader: loaders.New(profileQueries.GetSelectedAlternatives, loaders.WithMemoryCache(time.Second*1)),
	}

	profilesLoaderCache.Set(profileID, ls, cache.WithExpiration(time.Minute*5))

	return ls
}

func initBatchLoaders(queries *sqlc.Queries) *common.BatchLoaders {
	return &common.BatchLoaders{
		// App
		ApplicationLoader:           loaders.New(queries.GetApplications),
		ApplicationIDFromCodeLoader: loaders.NewConversionLoader(queries.GetApplicationIDsForCodes),
		//Redirect
		RedirectLoader:           loaders.New(queries.GetRedirects),
		RedirectIDFromCodeLoader: loaders.NewConversionLoader(queries.GetRedirectIDsForCodes),
		// Item
		PageLoader:                         loaders.New(queries.GetPages),
		PageIDFromCodeLoader:               loaders.NewConversionLoader(queries.GetPageIDsForCodes),
		SectionLoader:                      loaders.New(queries.GetSections),
		ShowLoader:                         loaders.New(queries.GetShows),
		SeasonLoader:                       loaders.New(queries.GetSeasons),
		EpisodeLoader:                      loaders.New(queries.GetEpisodes),
		EpisodeIDFromLegacyProgramIDLoader: loaders.NewConversionLoader(queries.GetEpisodeIDsForLegacyProgramIDs),
		EpisodeIDFromLegacyIDLoader:        loaders.NewConversionLoader(queries.GetEpisodeIDsForLegacyIDs),
		LinkLoader:                         loaders.New(queries.GetLinks),
		EventLoader:                        loaders.New(queries.GetEvents),
		FilesLoader: loaders.NewListLoader(queries.GetFilesForEpisodes, func(row common.File) int {
			return row.EpisodeID
		}),
		StreamsLoader: loaders.NewListLoader(queries.GetStreamsForEpisodes, func(row common.Stream) int {
			return row.EpisodeID
		}),
		CollectionLoader: loaders.New(queries.GetCollections),
		CollectionItemLoader: loaders.NewListLoader(queries.GetItemsForCollections, func(row common.CollectionItem) int {
			return row.CollectionID
		}),
		CollectionIDFromSlugLoader: loaders.NewConversionLoader(queries.GetCollectionIDsForCodes),
		EpisodeProgressLoader:      loaders.NewRelationLoader(queries.GetEpisodeIDsWithProgress),
		// Relations
		SectionsLoader: loaders.NewRelationLoader(queries.GetSectionIDsForPages),
		// Permissions
		ShowPermissionLoader: loaders.NewCustomLoader(queries.GetPermissionsForShows, func(i common.Permissions[int]) int {
			return i.ItemID
		}),
		SeasonPermissionLoader: loaders.NewCustomLoader(queries.GetPermissionsForSeasons, func(i common.Permissions[int]) int {
			return i.ItemID
		}),
		EpisodePermissionLoader: loaders.NewCustomLoader(queries.GetPermissionsForEpisodes, func(i common.Permissions[int]) int {
			return i.ItemID
		}),
		PagePermissionLoader: loaders.NewCustomLoader(queries.GetPermissionsForPages, func(i common.Permissions[int]) int {
			return i.ItemID
		}),
		SectionPermissionLoader: loaders.NewCustomLoader(queries.GetPermissionsForSections, func(i common.Permissions[int]) int {
			return i.ItemID
		}),

		FAQCategoryLoader:  loaders.NewLoader(queries.GetFAQCategories),
		QuestionLoader:     loaders.NewLoader(queries.GetQuestions),
		QuestionsLoader:    loaders.NewRelationLoader(queries.GetQuestionIDsForCategories),
		MessageGroupLoader: loaders.NewLoader(queries.GetMessageGroups),
		// User Data
		ProfilesLoader: loaders.NewListLoader(queries.GetProfilesForUserIDs, func(i common.Profile) string {
			return i.UserID
		}),
		StudyTopicLoader:  loaders.New(queries.GetTopics),
		StudyLessonLoader: loaders.New(queries.GetLessons),
		StudyTaskLoader:   loaders.New(queries.GetTasks),
		StudyQuestionAlternativesLoader: loaders.NewListLoader(queries.GetQuestionAlternatives, func(alt common.QuestionAlternative) uuid.UUID {
			return alt.TaskID
		}),
		// Achievements
		AchievementLoader:                  loaders.New(queries.GetAchievements),
		AchievementGroupLoader:             loaders.New(queries.GetAchievementGroups),
		AchievementsLoader:                 loaders.NewRelationLoader(queries.GetAchievementsForProfiles, loaders.WithMemoryCache(time.Second*30)),
		UnconfirmedAchievementsLoader:      loaders.NewRelationLoader(queries.GetUnconfirmedAchievementsForProfiles, loaders.WithMemoryCache(time.Second*30)),
		AchievementGroupAchievementsLoader: loaders.NewRelationLoader(queries.GetAchievementsForGroups),

		CompletedTopicsLoader:         loaders.NewRelationLoader(queries.GetCompletedTopics),
		CompletedLessonsLoader:        loaders.NewRelationLoader(queries.GetCompletedLessons),
		CompletedTasksLoader:          loaders.NewRelationLoader(queries.GetCompletedTasks),
		CompletedAndLockedTasksLoader: loaders.NewRelationLoader(queries.GetCompletedAndLockedTasks, loaders.WithMemoryCache(time.Second*1)),

		ComputedDataLoader: loaders.NewListLoader(queries.GetComputedDataForGroups, func(i common.ComputedData) uuid.UUID {
			return i.GroupID
		}),
	}
}
