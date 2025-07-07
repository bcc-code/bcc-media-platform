package loaders

import (
	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/google/uuid"
)

// ProfileLoaders contains loaders per profile
type ProfileLoaders struct {
	ProgressLoader                     *Loader[int, *common.Progress]
	TaskCompletedLoader                *Loader[uuid.UUID, *uuid.UUID]
	TaskAlternativesAnswersCountLoader *Loader[uuid.UUID, *common.AlternativesTasksProgress]
	AchievementAchievedAtLoader        *Loader[uuid.UUID, *common.Achieved]
	GetSelectedAlternativesLoader      *Loader[uuid.UUID, *common.SelectedAlternatives]

	SeasonDefaultEpisodeLoader *Loader[int, *int]
	ShowDefaultEpisodeLoader   *Loader[int, *int]

	MediaProgressLoader *Loader[uuid.UUID, *common.MediaProgress]

	TopicDefaultLessonLoader *Loader[uuid.UUID, *uuid.UUID]
}
