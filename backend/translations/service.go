package translations

import (
	"context"
	"github.com/ansel1/merry/v2"
	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/sqlc"
	"github.com/orsinium-labs/enum"
)

type UpdateTranslationCallback func(ctx context.Context, collection string, data []common.TranslationData) error

type TranslationsProvider interface {
	SendToTranslation(ctx context.Context, collection string, data []common.TranslationData) error
	ProcessWebhook(ctx context.Context, url string, hookData []byte) (collection string, data []common.TranslationData, err error)
}

type Service struct {
	provider TranslationsProvider
	queries  *sqlc.Queries
}

type translatableCollection enum.Member[string]

var (
	CollectionAchievementGroups = translatableCollection{"achievementgroups"}
	CollectionAchievements      = translatableCollection{"achievements"}
	CollectionStudyQuestions    = translatableCollection{"studyquestions"}
	CollectionCalendarEntries   = translatableCollection{"calendarentries"}
	CollectionEpisodes          = translatableCollection{"episodes"}
	CollectionEvents            = translatableCollection{"events"}
	CollectionFAQCategories     = translatableCollection{"faqcategories"}
	CollectionFAQs              = translatableCollection{"faqs"}
	CollectionGames             = translatableCollection{"games"}
	CollectionLessons           = translatableCollection{"lessons"}
	CollectionLinks             = translatableCollection{"links"}
	CollectionMediaItems        = translatableCollection{"mediaitems"}
	CollectionPages             = translatableCollection{"pages"}
	CollectionPlaylists         = translatableCollection{"playlists"}
	CollectionSeasons           = translatableCollection{"seasons"}
	CollectionSections          = translatableCollection{"sections"}
	CollectionShows             = translatableCollection{"shows"}
	CollectionSurveys           = translatableCollection{"surveys"}
	CollectionTopics            = translatableCollection{"topics"}

	TranslatableCollection = enum.New(
		CollectionAchievementGroups,
		CollectionAchievements,
		CollectionCalendarEntries,
		CollectionEpisodes,
		CollectionEvents,
		CollectionFAQCategories,
		CollectionFAQs,
		CollectionGames,
		CollectionLessons,
		CollectionLinks,
		CollectionMediaItems,
		CollectionPages,
		CollectionPlaylists,
		CollectionSeasons,
		CollectionSections,
		CollectionShows,
		CollectionSurveys,
		CollectionTopics,
		CollectionStudyQuestions,
	)
)

func NewService(queries *sqlc.Queries, provider TranslationsProvider) *Service {
	return &Service{
		provider: provider,
		queries:  queries,
	}
}

func (s *Service) SendAllToTranslation(ctx context.Context) []error {
	err := s.sendSurveys(ctx)
	if err != nil {
		return []error{merry.Wrap(err)}
	}
	return []error{}

	errs := make([]error, 0)
	for _, collection := range TranslatableCollection.Members() {
		if err := s.SendCollectionToTranslation(ctx, collection); err != nil {
			errs = append(errs, err)
		}
	}
	return errs
}

func (s *Service) SendCollectionToTranslation(ctx context.Context, collection translatableCollection) error {
	switch collection {
	case CollectionAchievementGroups:
		return s.sendAchievementGroups(ctx)
	case CollectionAchievements:
		return s.sendAchievements(ctx)
	case CollectionStudyQuestions:
		return s.sendStudyQuestions(ctx)
	case CollectionCalendarEntries:
		return s.sendCalendarEntries(ctx)
	case CollectionEpisodes:
		return s.sendEpisodes(ctx)
	case CollectionEvents:
		return s.sendEvents(ctx)
	case CollectionFAQCategories:
		return s.sendFAQCategories(ctx)
	case CollectionFAQs:
		return s.sendFAQs(ctx)
	case CollectionGames:
		return s.sendGames(ctx)
	case CollectionLessons:
		return s.sendLessons(ctx)
	case CollectionLinks:
		return s.sendLinks(ctx)
	case CollectionMediaItems:
		return s.sendMediaItems(ctx)
	case CollectionPages:
		return s.sendPages(ctx)
	case CollectionPlaylists:
		return s.sendPlaylists(ctx)
	case CollectionSeasons:
		return s.sendSeasons(ctx)
	case CollectionSections:
		return s.sendSections(ctx)
	case CollectionShows:
		return s.sendShows(ctx)
	case CollectionSurveys:
		return s.sendSurveys(ctx)
	case CollectionTopics:
		return s.sendTopics(ctx)
	}
	return merry.Errorf("Unknown transalatable collection %s", collection)
}
