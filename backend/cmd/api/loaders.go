package main

import (
	"context"
	"database/sql"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/items/collection"
	"github.com/bcc-code/brunstadtv/backend/loaders"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/google/uuid"
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
		ShowFilterLoader:    loaders.NewFilterLoader(ctx, rq.GetShowIDsWithRoles, loaders.WithTraceName("show-filter")),
		SeasonFilterLoader:  loaders.NewFilterLoader(ctx, rq.GetSeasonIDsWithRoles, loaders.WithTraceName("season-filter")),
		EpisodeFilterLoader: loaders.NewFilterLoader(ctx, rq.GetEpisodeIDsWithRoles, loaders.WithTraceName("episode-filter")),
		SeasonsLoader:       loaders.NewRelationLoader(ctx, rq.GetSeasonIDsForShowsWithRoles, loaders.WithTraceName("seasons")),
		SectionsLoader:      loaders.NewRelationLoader(ctx, rq.GetSectionIDsForPagesWithRoles, loaders.WithTraceName("sections")),
		EpisodesLoader:      loaders.NewRelationLoader(ctx, rq.GetEpisodeIDsForSeasonsWithRoles, loaders.WithTraceName("episodes")),
		CollectionItemsLoader: loaders.NewListLoader(ctx, rq.GetItemsForCollectionsWithRoles, func(i common.CollectionItem) int {
			return i.CollectionID
		}, loaders.WithTraceName("collection-items")),
		CollectionItemIDsLoader: collection.NewCollectionItemLoader(ctx, db, collectionLoader, roles),
		CalendarEntryLoader:     loaders.New(ctx, rq.GetCalendarEntries),
		StudyTopicFilterLoader:  loaders.NewFilterLoader(ctx, rq.GetTopicIDsWithRoles, loaders.WithTraceName("study-topic-filter")),
		StudyLessonFilterLoader: loaders.NewFilterLoader(ctx, rq.GetLessonIDsWithRoles, loaders.WithTraceName("study-lesson-filter")),
		StudyTaskFilterLoader:   loaders.NewFilterLoader(ctx, rq.GetTaskIDsWithRoles, loaders.WithTraceName("study-task-filter")),
		StudyLessonsLoader:      loaders.NewRelationLoader(ctx, rq.GetLessonIDsForTopics, loaders.WithTraceName("study-lessons")),
		StudyTasksLoader:        loaders.NewRelationLoader(ctx, rq.GetTaskIDsForLessons, loaders.WithTraceName("study-tasks")),

		// Study Relations
		StudyLessonEpisodesLoader: loaders.NewRelationLoader(ctx, rq.GetEpisodeIDsForLessons, loaders.WithTraceName("study-lesson-episodes")),
		EpisodeStudyLessonsLoader: loaders.NewRelationLoader(ctx, rq.GetLessonIDsForEpisodes, loaders.WithTraceName("episode-study-lessons")),
		StudyLessonLinksLoader:    loaders.NewRelationLoader(ctx, rq.GetLinkIDsForLessons, loaders.WithTraceName("study-lesson-links")),
		LinkStudyLessonsLoader:    loaders.NewRelationLoader(ctx, rq.GetLessonIDsForLinks, loaders.WithTraceName("link-study-lessons")),
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
		ProgressLoader: loaders.New(ctx, profileQueries.GetProgressForEpisodes, loaders.WithMemoryCache(time.Second*5), loaders.WithTraceName("progress")),
		TaskCompletedLoader: loaders.NewFilterLoader(ctx, func(ctx context.Context, ids []uuid.UUID) ([]uuid.UUID, error) {
			return queries.GetAnsweredTasks(ctx, sqlc.GetAnsweredTasksParams{
				ProfileID: profileID,
				Column2:   ids,
			})
		}, loaders.WithMemoryCache(time.Second*5), loaders.WithTraceName("task-completed")),
		AchievementAchievedAtLoader:   loaders.New(ctx, profileQueries.GetAchievementsAchievedAt, loaders.WithMemoryCache(time.Second*5), loaders.WithTraceName("achieved-at")),
		GetSelectedAlternativesLoader: loaders.New(ctx, profileQueries.GetSelectedAlternatives, loaders.WithMemoryCache(time.Second*1), loaders.WithTraceName("selected-alternatives")),
	}

	profileLoaders.Set(profileID, ls, loaders.WithOnDelete(cancel))

	return ls
}

func initBatchLoaders(queries *sqlc.Queries) *common.BatchLoaders {
	ctx := context.Background()
	return &common.BatchLoaders{
		// App
		ApplicationLoader:           loaders.New(ctx, queries.GetApplications),
		ApplicationIDFromCodeLoader: loaders.NewConversionLoader(ctx, queries.GetApplicationIDsForCodes, loaders.WithTraceName("application-id")),
		//Redirect
		RedirectLoader:           loaders.New(ctx, queries.GetRedirects),
		RedirectIDFromCodeLoader: loaders.NewConversionLoader(ctx, queries.GetRedirectIDsForCodes, loaders.WithTraceName("redirect-id")),
		// Item
		PageLoader:                         loaders.New(ctx, queries.GetPages),
		PageIDFromCodeLoader:               loaders.NewConversionLoader(ctx, queries.GetPageIDsForCodes, loaders.WithTraceName("page-id")),
		SectionLoader:                      loaders.New(ctx, queries.GetSections),
		ShowLoader:                         loaders.New(ctx, queries.GetShows),
		SeasonLoader:                       loaders.New(ctx, queries.GetSeasons),
		EpisodeLoader:                      loaders.New(ctx, queries.GetEpisodes),
		EpisodeIDFromLegacyProgramIDLoader: loaders.NewConversionLoader(ctx, queries.GetEpisodeIDsForLegacyProgramIDs, loaders.WithTraceName("episode-programid")),
		EpisodeIDFromLegacyIDLoader:        loaders.NewConversionLoader(ctx, queries.GetEpisodeIDsForLegacyIDs, loaders.WithTraceName("episode-legacyid")),
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
		CollectionIDFromSlugLoader: loaders.NewConversionLoader(ctx, queries.GetCollectionIDsForCodes, loaders.WithTraceName("collection-id")),
		EpisodeProgressLoader:      loaders.NewRelationLoader(ctx, queries.GetEpisodeIDsWithProgress, loaders.WithTraceName("episode-progress")),
		// Relations
		SectionsLoader: loaders.NewRelationLoader(ctx, queries.GetSectionIDsForPages, loaders.WithTraceName("sections")),
		// Permissions
		ShowPermissionLoader: loaders.NewCustomLoader(ctx, queries.GetPermissionsForShows, func(i common.Permissions[int]) int {
			return i.ItemID
		}, loaders.WithTraceName("show-permission")),
		SeasonPermissionLoader: loaders.NewCustomLoader(ctx, queries.GetPermissionsForSeasons, func(i common.Permissions[int]) int {
			return i.ItemID
		}, loaders.WithTraceName("season-permission")),
		EpisodePermissionLoader: loaders.NewCustomLoader(ctx, queries.GetPermissionsForEpisodes, func(i common.Permissions[int]) int {
			return i.ItemID
		}, loaders.WithTraceName("episode-permission")),
		PagePermissionLoader: loaders.NewCustomLoader(ctx, queries.GetPermissionsForPages, func(i common.Permissions[int]) int {
			return i.ItemID
		}, loaders.WithTraceName("page-permission")),
		SectionPermissionLoader: loaders.NewCustomLoader(ctx, queries.GetPermissionsForSections, func(i common.Permissions[int]) int {
			return i.ItemID
		}, loaders.WithTraceName("section-permission")),

		FAQCategoryLoader:  loaders.NewLoader(ctx, queries.GetFAQCategories),
		QuestionLoader:     loaders.NewLoader(ctx, queries.GetQuestions),
		QuestionsLoader:    loaders.NewRelationLoader(ctx, queries.GetQuestionIDsForCategories, loaders.WithTraceName("questions")),
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
		AchievementsLoader:                 loaders.NewRelationLoader(ctx, queries.GetAchievementsForProfiles, loaders.WithMemoryCache(time.Second*30), loaders.WithTraceName("achievements")),
		UnconfirmedAchievementsLoader:      loaders.NewRelationLoader(ctx, queries.GetUnconfirmedAchievementsForProfiles, loaders.WithMemoryCache(time.Second*30), loaders.WithTraceName("unconfirmed-achievements")),
		AchievementGroupAchievementsLoader: loaders.NewRelationLoader(ctx, queries.GetAchievementsForGroups, loaders.WithTraceName("group-achievements")),

		CompletedTopicsLoader:         loaders.NewRelationLoader(ctx, queries.GetCompletedTopics, loaders.WithTraceName("completed-topics")),
		CompletedLessonsLoader:        loaders.NewRelationLoader(ctx, queries.GetCompletedLessons, loaders.WithTraceName("completed-lessons")),
		CompletedTasksLoader:          loaders.NewRelationLoader(ctx, queries.GetCompletedTasks, loaders.WithTraceName("completed-tasks")),
		CompletedAndLockedTasksLoader: loaders.NewRelationLoader(ctx, queries.GetCompletedAndLockedTasks, loaders.WithMemoryCache(time.Second*1), loaders.WithTraceName("completed-locked-tasks")),

		ComputedDataLoader: loaders.NewListLoader(ctx, queries.GetComputedDataForGroups, func(i common.ComputedData) uuid.UUID {
			return i.GroupID
		}),
	}
}
