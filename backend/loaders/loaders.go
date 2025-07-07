package loaders

import (
	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/members"
	"github.com/google/uuid"
)

// BatchLoaders contains loaders for the different items
type BatchLoaders struct {
	ApplicationLoader           *Loader[int, *common.Application]
	ApplicationIDFromCodeLoader *Loader[string, *int]
	ApplicationGroupLoader      *Loader[uuid.UUID, *common.ApplicationGroup]

	RedirectLoader                     *Loader[uuid.UUID, *common.Redirect]
	RedirectIDFromCodeLoader           *Loader[string, *uuid.UUID]
	PageLoader                         *Loader[int, *common.Page]
	PageIDFromCodeLoader               *Loader[string, *int]
	CollectionIDFromSlugLoader         *Loader[string, *int]
	SectionLoader                      *Loader[int, *common.Section]
	CollectionLoader                   *Loader[int, *common.Collection]
	CollectionItemLoader               *Loader[int, []*common.CollectionItem]
	StudyTopicLoader                   *Loader[uuid.UUID, *common.StudyTopic]
	StudyLessonLoader                  *Loader[uuid.UUID, *common.Lesson]
	StudyTaskLoader                    *Loader[uuid.UUID, *common.Task]
	StudyQuestionAlternativesLoader    *Loader[uuid.UUID, []*common.QuestionAlternative]
	ShowLoader                         *Loader[int, *common.Show]
	SeasonLoader                       *Loader[int, *common.Season]
	EpisodeLoader                      *Loader[int, *common.Episode]
	EpisodeIDFromLegacyIDLoader        *Loader[int, *int]
	EpisodeIDFromLegacyProgramIDLoader *Loader[int, *int]
	LinkLoader                         *Loader[int, *common.Link]
	PlaylistLoader                     *Loader[uuid.UUID, *common.Playlist]

	FilesLoader   *Loader[int, []*common.File]
	StreamsLoader *Loader[int, []*common.Stream]

	AssetFilesLoader   *Loader[int, []*common.File]
	AssetStreamsLoader *Loader[int, []*common.Stream]

	EventLoader        *Loader[int, *common.Event]
	EventEntriesLoader *Loader[int, []*int]

	FAQCategoryLoader    *Loader[uuid.UUID, *common.FAQCategory]
	QuestionLoader       *Loader[uuid.UUID, *common.Question]
	MessageGroupLoader   *Loader[int, *common.MessageGroup]
	SurveyLoader         *Loader[uuid.UUID, *common.Survey]
	SurveyQuestionLoader *Loader[uuid.UUID, *common.SurveyQuestion]
	GameLoader           *Loader[uuid.UUID, *common.Game]
	ShortLoader          *Loader[uuid.UUID, *common.Short]
	ShortsMediaIDLoader  *Loader[uuid.UUID, *uuid.UUID]

	MemberLoader       *Loader[int, *members.Member]
	OrganizationLoader *Loader[uuid.UUID, *members.Organization]

	EpisodeProgressLoader   *Loader[uuid.UUID, []*int]
	EpisodeIDFromUuidLoader *Loader[uuid.UUID, *int]
	ShowIDFromUuidLoader    *Loader[uuid.UUID, *int]
	// Permissions
	ShowPermissionLoader    *Loader[int, *common.Permissions[int]]
	SeasonPermissionLoader  *Loader[int, *common.Permissions[int]]
	EpisodePermissionLoader *Loader[int, *common.Permissions[int]]
	PagePermissionLoader    *Loader[int, *common.Permissions[int]]
	SectionPermissionLoader *Loader[int, *common.Permissions[int]]

	CompletedTopicsLoader         *Loader[uuid.UUID, []*uuid.UUID]
	CompletedLessonsLoader        *Loader[uuid.UUID, []*uuid.UUID]
	CompletedTasksLoader          *Loader[uuid.UUID, []*uuid.UUID]
	CompletedAndLockedTasksLoader *Loader[uuid.UUID, []*uuid.UUID]

	// Achievements
	AchievementLoader             *Loader[uuid.UUID, *common.Achievement]
	AchievementGroupLoader        *Loader[uuid.UUID, *common.AchievementGroup]
	AchievementsLoader            *Loader[uuid.UUID, []*uuid.UUID]
	UnconfirmedAchievementsLoader *Loader[uuid.UUID, []*uuid.UUID]

	AchievementGroupAchievementsLoader *Loader[uuid.UUID, []*uuid.UUID]

	ComputedDataLoader *Loader[uuid.UUID, []*common.ComputedData]

	UserLoader *Loader[string, *common.User]

	// UserCollections
	UserCollectionLoader         *Loader[uuid.UUID, *common.UserCollection]
	UserCollectionEntryLoader    *Loader[uuid.UUID, *common.UserCollectionEntry]
	UserCollectionEntryIDsLoader *Loader[uuid.UUID, []*uuid.UUID]

	ProfileUserCollectionIDsLoader *Loader[uuid.UUID, []*uuid.UUID]
	ProfileMyListCollectionID      *Loader[uuid.UUID, *uuid.UUID]

	PromptLoader *Loader[uuid.UUID, *common.Prompt]

	MediaItemPrimaryEpisodeIDLoader *Loader[uuid.UUID, *int]
	TimedMetadataLoader             *Loader[uuid.UUID, *common.TimedMetadata]
	ChaptersLoader                  *Loader[int, []*common.TimedMetadata]
	PersonLoader                    *Loader[uuid.UUID, *common.Person]
	SongLoader                      *Loader[uuid.UUID, *common.Song]
	PhraseLoader                    *Loader[string, *common.Phrase]
	ContributionsLoader             *Loader[int32, *common.Contribution]
}

// PersonalizedLoaders contains loaders that are personalized to the user
//
// This includes things like permissions, settings, langauges, etc
type PersonalizedLoaders struct {
	Key string

	CollectionItemsLoader        *Loader[int, []*common.CollectionItem]
	ContributionsForPersonLoader *Loader[uuid.UUID, []*common.Contribution]
	TagEpisodesLoader            *Loader[int, []*int]
}

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
