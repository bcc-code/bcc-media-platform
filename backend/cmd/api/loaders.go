package main

import (
	"context"
	"time"

	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/loaders"
	"github.com/bcc-code/bcc-media-platform/backend/log"
	"github.com/bcc-code/bcc-media-platform/backend/sqlc"
	"github.com/google/uuid"
	"github.com/samber/lo"
)

var profileLoaders = loaders.NewCollection[uuid.UUID, *loaders.ProfileLoaders](time.Minute)

func getLoadersForProfile(queries *sqlc.Queries, profile *common.Profile) *loaders.ProfileLoaders {
	if ls, ok := profileLoaders.Get(profile.ID); ok {
		return ls
	}

	ctx, cancel := context.WithCancel(context.Background())

	profileQueries := queries.ProfileQueries(profile.ID)
	ls := &loaders.ProfileLoaders{
		ProgressLoader: loaders.New(ctx, profileQueries.GetProgressForEpisodes, loaders.WithMemoryCache(time.Second*5), loaders.WithName("progress")),
		TaskCompletedLoader: loaders.NewFilterLoader(ctx, func(ctx context.Context, ids []uuid.UUID) ([]uuid.UUID, error) {
			return queries.GetAnsweredTasks(ctx, sqlc.GetAnsweredTasksParams{
				ProfileID: profile.ID,
				Column2:   ids,
			})
		}, loaders.WithMemoryCache(time.Second*5), loaders.WithName("task-completed")),
		AchievementAchievedAtLoader:        loaders.New(ctx, profileQueries.GetAchievementsAchievedAt, loaders.WithMemoryCache(time.Second*5), loaders.WithName("achieved-at")),
		GetSelectedAlternativesLoader:      loaders.New(ctx, profileQueries.GetSelectedAlternatives, loaders.WithMemoryCache(time.Second*1), loaders.WithName("selected-alternatives")),
		TaskAlternativesAnswersCountLoader: loaders.New(ctx, profileQueries.GetTaskAlternativesAnswersCount, loaders.WithMemoryCache(time.Second*15), loaders.WithName("task-alternatives-answers-count")),

		SeasonDefaultEpisodeLoader: loaders.NewConversionLoader(ctx, profileQueries.DefaultEpisodeIDForSeasonIDs, loaders.WithMemoryCache(time.Second*5), loaders.WithName("season-default-episodes")),
		ShowDefaultEpisodeLoader:   loaders.NewConversionLoader(ctx, profileQueries.DefaultEpisodeIDForShowIDs, loaders.WithMemoryCache(time.Second*5), loaders.WithName("show-default-episodes")),

		TopicDefaultLessonLoader: loaders.NewConversionLoader(ctx, profileQueries.GetDefaultLessonIDForTopicIDs, loaders.WithMemoryCache(time.Second*5), loaders.WithName("topic-default-lessons")),

		MediaProgressLoader: loaders.New(ctx, func(ctx context.Context, ids []uuid.UUID) ([]common.MediaProgress, error) {
			rows, err := queries.GetMediaProgress(ctx, sqlc.GetMediaProgressParams{
				ProfileID: profile.ID,
				ItemIds:   ids,
			})
			if err != nil {
				return nil, err
			}
			return lo.Map(rows, func(i sqlc.GetMediaProgressRow, _ int) common.MediaProgress {
				return common.MediaProgress{
					ProfileID: i.ProfileID,
					MediaID:   i.ItemID,
					Progress:  float64(i.Progress),
				}
			}), nil
		}, loaders.WithKeyFunc(func(i common.MediaProgress) uuid.UUID {
			return i.MediaID
		}), loaders.WithMemoryCache(time.Second*30)),
	}

	profileLoaders.Set(profile.ID, ls, loaders.WithOnDelete(func() {
		log.L.Debug().Msg("Clearing profile loader")

		ls.TaskCompletedLoader.ClearAll()
		ls.AchievementAchievedAtLoader.ClearAll()
		ls.ProgressLoader.ClearAll()
		ls.GetSelectedAlternativesLoader.ClearAll()
		ls.MediaProgressLoader.ClearAll()

		ls.SeasonDefaultEpisodeLoader.ClearAll()
		ls.ShowDefaultEpisodeLoader.ClearAll()

		cancel()
	}))

	return ls
}
