package common

import (
	"context"

	"github.com/bcc-code/bcc-media-platform/backend/loaders"
	"github.com/bcc-code/bcc-media-platform/backend/members"
	"github.com/google/uuid"
)

// BatchLoaders contains loaders for the different items
type BatchLoaders struct {
	ApplicationLoader           *loaders.Loader[int, *Application]
	ApplicationIDFromCodeLoader *loaders.Loader[string, *int]
	ApplicationGroupLoader      *loaders.Loader[uuid.UUID, *ApplicationGroup]

	RedirectLoader                     *loaders.Loader[uuid.UUID, *Redirect]
	RedirectIDFromCodeLoader           *loaders.Loader[string, *uuid.UUID]
	PageLoader                         *loaders.Loader[int, *Page]
	PageIDFromCodeLoader               *loaders.Loader[string, *int]
	CollectionIDFromSlugLoader         *loaders.Loader[string, *int]
	SectionLoader                      *loaders.Loader[int, *Section]
	CollectionLoader                   *loaders.Loader[int, *Collection]
	CollectionItemLoader               *loaders.Loader[int, []*CollectionItem]
	StudyTopicLoader                   *loaders.Loader[uuid.UUID, *StudyTopic]
	StudyLessonLoader                  *loaders.Loader[uuid.UUID, *Lesson]
	StudyTaskLoader                    *loaders.Loader[uuid.UUID, *Task]
	StudyQuestionAlternativesLoader    *loaders.Loader[uuid.UUID, []*QuestionAlternative]
	ShowLoader                         *loaders.Loader[int, *Show]
	SeasonLoader                       *loaders.Loader[int, *Season]
	EpisodeLoader                      *loaders.Loader[int, *Episode]
	EpisodeIDFromLegacyIDLoader        *loaders.Loader[int, *int]
	EpisodeIDFromLegacyProgramIDLoader *loaders.Loader[int, *int]
	LinkLoader                         *loaders.Loader[int, *Link]
	PlaylistLoader                     *loaders.Loader[uuid.UUID, *Playlist]

	FilesLoader   *loaders.Loader[int, []*File]
	StreamsLoader *loaders.Loader[int, []*Stream]

	AssetFilesLoader   *loaders.Loader[int, []*File]
	AssetStreamsLoader *loaders.Loader[int, []*Stream]

	EventLoader        *loaders.Loader[int, *Event]
	EventEntriesLoader *loaders.Loader[int, []*int]

	FAQCategoryLoader    *loaders.Loader[uuid.UUID, *FAQCategory]
	QuestionLoader       *loaders.Loader[uuid.UUID, *Question]
	MessageGroupLoader   *loaders.Loader[int, *MessageGroup]
	SurveyLoader         *loaders.Loader[uuid.UUID, *Survey]
	SurveyQuestionLoader *loaders.Loader[uuid.UUID, *SurveyQuestion]
	GameLoader           *loaders.Loader[uuid.UUID, *Game]
	ShortLoader          *loaders.Loader[uuid.UUID, *Short]
	ShortsMediaIDLoader  *loaders.Loader[uuid.UUID, *uuid.UUID]

	MemberLoader       *loaders.Loader[int, *members.Member]
	OrganizationLoader *loaders.Loader[uuid.UUID, *members.Organization]

	EpisodeProgressLoader   *loaders.Loader[uuid.UUID, []*int]
	EpisodeIDFromUuidLoader *loaders.Loader[uuid.UUID, *int]
	ShowIDFromUuidLoader    *loaders.Loader[uuid.UUID, *int]
	// Permissions
	ShowPermissionLoader    *loaders.Loader[int, *Permissions[int]]
	SeasonPermissionLoader  *loaders.Loader[int, *Permissions[int]]
	EpisodePermissionLoader *loaders.Loader[int, *Permissions[int]]
	PagePermissionLoader    *loaders.Loader[int, *Permissions[int]]
	SectionPermissionLoader *loaders.Loader[int, *Permissions[int]]

	CompletedTopicsLoader         *loaders.Loader[uuid.UUID, []*uuid.UUID]
	CompletedLessonsLoader        *loaders.Loader[uuid.UUID, []*uuid.UUID]
	CompletedTasksLoader          *loaders.Loader[uuid.UUID, []*uuid.UUID]
	CompletedAndLockedTasksLoader *loaders.Loader[uuid.UUID, []*uuid.UUID]

	// Achievements
	AchievementLoader             *loaders.Loader[uuid.UUID, *Achievement]
	AchievementGroupLoader        *loaders.Loader[uuid.UUID, *AchievementGroup]
	AchievementsLoader            *loaders.Loader[uuid.UUID, []*uuid.UUID]
	UnconfirmedAchievementsLoader *loaders.Loader[uuid.UUID, []*uuid.UUID]

	AchievementGroupAchievementsLoader *loaders.Loader[uuid.UUID, []*uuid.UUID]

	ComputedDataLoader *loaders.Loader[uuid.UUID, []*ComputedData]

	UserLoader *loaders.Loader[string, *User]

	// UserCollections
	UserCollectionLoader         *loaders.Loader[uuid.UUID, *UserCollection]
	UserCollectionEntryLoader    *loaders.Loader[uuid.UUID, *UserCollectionEntry]
	UserCollectionEntryIDsLoader *loaders.Loader[uuid.UUID, []*uuid.UUID]

	ProfileUserCollectionIDsLoader *loaders.Loader[uuid.UUID, []*uuid.UUID]
	ProfileMyListCollectionID      *loaders.Loader[uuid.UUID, *uuid.UUID]

	PromptLoader *loaders.Loader[uuid.UUID, *Prompt]

	TimedMetadataLoader *loaders.Loader[uuid.UUID, *TimedMetadata]
	PersonLoader        *loaders.Loader[uuid.UUID, *Person]
	SongLoader          *loaders.Loader[uuid.UUID, *Song]
	PhraseLoader        *loaders.Loader[string, *Phrase]
}

// FilteredLoaders contains loaders that will be filtered by permissions.
type FilteredLoaders struct {
	Key string

	EpisodeFilterLoader     *loaders.Loader[int, *int]
	EpisodeUUIDFilterLoader *loaders.Loader[uuid.UUID, *uuid.UUID]
	EpisodesLoader          *loaders.Loader[int, []*int]
	TagEpisodesLoader       *loaders.Loader[int, []*int]
	SeasonFilterLoader      *loaders.Loader[int, *int]
	SeasonsLoader           *loaders.Loader[int, []*int]
	ShowFilterLoader        *loaders.Loader[int, *int]
	ShowUUIDFilterLoader    *loaders.Loader[uuid.UUID, *uuid.UUID]
	SectionsLoader          *loaders.Loader[int, []*int]
	CollectionItemsLoader   *loaders.Loader[int, []*CollectionItem]
	CollectionItemIDsLoader *loaders.Loader[int, []Identifier]
	CalendarEntryLoader     *loaders.Loader[int, *CalendarEntry]
	StudyTopicFilterLoader  *loaders.Loader[uuid.UUID, *uuid.UUID]
	StudyLessonsLoader      *loaders.Loader[uuid.UUID, []*uuid.UUID]
	StudyLessonFilterLoader *loaders.Loader[uuid.UUID, *uuid.UUID]
	StudyTasksLoader        *loaders.Loader[uuid.UUID, []*uuid.UUID]
	StudyTaskFilterLoader   *loaders.Loader[uuid.UUID, *uuid.UUID]
	SurveyQuestionsLoader   *loaders.Loader[uuid.UUID, []*uuid.UUID]

	FAQQuestionsLoader *loaders.Loader[uuid.UUID, []*uuid.UUID]

	//Relations
	StudyLessonEpisodesLoader *loaders.Loader[uuid.UUID, []*int]
	EpisodeStudyLessonsLoader *loaders.Loader[int, []*uuid.UUID]
	StudyLessonLinksLoader    *loaders.Loader[uuid.UUID, []*int]
	LinkStudyLessonsLoader    *loaders.Loader[int, []*uuid.UUID]

	// Lists
	PromptIDsLoader      func(ctx context.Context) ([]uuid.UUID, error)
	FAQCategoryIDsLoader func(ctx context.Context) ([]uuid.UUID, error)
	ShortIDsLoader       func(ctx context.Context) ([][]uuid.UUID, error)
}

// ProfileLoaders contains loaders per profile
type ProfileLoaders struct {
	ProgressLoader                *loaders.Loader[int, *Progress]
	TaskCompletedLoader           *loaders.Loader[uuid.UUID, *uuid.UUID]
	AchievementAchievedAtLoader   *loaders.Loader[uuid.UUID, *Achieved]
	GetSelectedAlternativesLoader *loaders.Loader[uuid.UUID, *SelectedAlternatives]

	SeasonDefaultEpisodeLoader *loaders.Loader[int, *int]
	ShowDefaultEpisodeLoader   *loaders.Loader[int, *int]

	MediaProgressLoader *loaders.Loader[uuid.UUID, *MediaProgress]

	TopicDefaultLessonLoader *loaders.Loader[uuid.UUID, *uuid.UUID]
}
