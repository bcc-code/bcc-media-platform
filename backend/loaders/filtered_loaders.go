package loaders

import (
	"context"
	"fmt"
	cache "github.com/Code-Hex/go-generics-cache"
	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/memorycache"
	"github.com/bcc-code/bcc-media-platform/backend/sqlc"
	"github.com/google/uuid"
	"github.com/samber/lo"
	"sort"
	"strings"
	"time"
)

func GetLoadersForRoles(queries *sqlc.Queries, roles []string) *LoadersWithPermissions {
	sort.Strings(roles)

	key := strings.Join(roles, "-")

	if ls, ok := roleLoaders.Get(key); ok {
		return ls
	}

	ctx, cancel := context.WithCancel(context.Background())

	rq := queries.RoleQueries(roles)

	ls := &LoadersWithPermissions{
		Key: key,

		ShowFilterLoader:        NewFilterLoader(ctx, rq.GetShowIDsWithRoles, WithName("show-filter")),
		ShowUUIDFilterLoader:    NewFilterLoader(ctx, rq.GetShowUUIDsWithRoles, WithName("show-uuid-filter")),
		SeasonFilterLoader:      NewFilterLoader(ctx, rq.GetSeasonIDsWithRoles, WithName("season-filter")),
		EpisodeFilterLoader:     NewFilterLoader(ctx, rq.GetEpisodeIDsWithRoles, WithName("episode-filter")),
		EpisodeUUIDFilterLoader: NewFilterLoader(ctx, rq.GetEpisodeUUIDsWithRoles, WithName("episode-uuid-filter")),
		SeasonsLoader:           NewRelationLoader(ctx, rq.GetSeasonIDsForShowsWithRoles, WithName("seasons")),
		SectionsLoader:          NewRelationLoader(ctx, rq.GetSectionIDsForPagesWithRoles, WithName("sections")),
		EpisodesLoader:          NewRelationLoader(ctx, rq.GetEpisodeIDsForSeasonsWithRoles, WithName("episodes")),
		CalendarEntryLoader:     New(ctx, rq.GetCalendarEntries, WithMemoryCache(time.Minute*5)),
		StudyTopicFilterLoader:  NewFilterLoader(ctx, rq.GetTopicIDsWithRoles, WithName("study-topic-filter")),
		StudyLessonFilterLoader: NewFilterLoader(ctx, rq.GetLessonIDsWithRoles, WithName("study-lesson-filter")),
		StudyTaskFilterLoader:   NewFilterLoader(ctx, rq.GetTaskIDsWithRoles, WithName("study-task-filter")),
		StudyLessonsLoader:      NewRelationLoader(ctx, rq.GetLessonIDsForTopics, WithName("study-lessons")),
		StudyTasksLoader:        NewRelationLoader(ctx, rq.GetTaskIDsForLessons, WithName("study-tasks")),

		// Study Relations
		StudyLessonEpisodesLoader: NewRelationLoader(ctx, rq.GetEpisodeIDsForLessons, WithName("study-lesson-episodes")),
		EpisodeStudyLessonsLoader: NewRelationLoader(ctx, rq.GetLessonIDsForEpisodes, WithName("episode-study-lessons")),
		StudyLessonLinksLoader:    NewRelationLoader(ctx, rq.GetLinkIDsForLessons, WithName("study-lesson-links")),
		LinkStudyLessonsLoader:    NewRelationLoader(ctx, rq.GetLessonIDsForLinks, WithName("link-study-lessons")),
		FAQQuestionsLoader:        NewRelationLoader(ctx, rq.GetQuestionIDsForCategories, WithName("questions")),

		PromptIDsLoader: func(ctx context.Context) ([]uuid.UUID, error) {
			return memorycache.GetOrSet(ctx, fmt.Sprintf("promptIDs:roles:%s", key), func(ctx context.Context) ([]uuid.UUID, error) {
				return queries.GetPromptIDsForRoles(ctx, roles)
			}, cache.WithExpiration(time.Minute*5))
		},
		FAQCategoryIDsLoader: func(ctx context.Context) ([]uuid.UUID, error) {
			return memorycache.GetOrSet(ctx, fmt.Sprintf("categoryIDs:roles:%s", key), func(ctx context.Context) ([]uuid.UUID, error) {
				return queries.ListFAQCategoryIDsForRoles(ctx, roles)
			}, cache.WithExpiration(time.Minute*5))
		},
		SurveyQuestionsLoader: NewRelationLoader(ctx, rq.GetSurveyQuestionIDsForSurveyIDs, WithName("survey-questions-loader")),

		ShortIDsLoader: func(ctx context.Context) ([][]uuid.UUID, error) {
			return memorycache.GetOrSet(ctx, fmt.Sprintf("shortIDs:roles:%s", key), func(ctx context.Context) ([][]uuid.UUID, error) {
				rows, err := queries.ListSegmentedShortIDsForRoles(ctx, roles)
				if err != nil {
					return nil, err
				}
				return lo.Map(rows, func(i sqlc.ListSegmentedShortIDsForRolesRow, _ int) []uuid.UUID {
					return i.Ids
				}), nil
			}, cache.WithExpiration(time.Minute*5))
		},

		ShortWithScoresLoader: func(ctx context.Context) ([]common.ShortIDWithMeta, error) {
			return memorycache.GetOrSet(ctx, fmt.Sprintf("shortIDs-scores:roles:%s", key), func(ctx context.Context) ([]common.ShortIDWithMeta, error) {
				rows, err := queries.ListSegmentedShortIDsForRolesWithScores(ctx, roles)
				if err != nil {
					return nil, err
				}
				return lo.Map(rows, func(i sqlc.ListSegmentedShortIDsForRolesWithScoresRow, _ int) common.ShortIDWithMeta {
					return common.ShortIDWithMeta{
						ID:              i.ID,
						AgeInDays:       int(i.AgeInDays),
						ParentEpisodeID: i.ParentEpisodeID,
						FinalScore:      i.FinalScore,
					}
				}), nil
			}, cache.WithExpiration(time.Minute*5))
		},
	}

	// Canceling the context on delete stops janitors nested inside the loaders as well.
	roleLoaders.Set(key, ls, WithOnDelete(cancel))

	return ls
}

var roleLoaders = NewCollection[string, *LoadersWithPermissions](time.Minute)
