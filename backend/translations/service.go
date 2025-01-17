package translations

import (
	"context"
	"github.com/ansel1/merry/v2"
	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/log"
	"github.com/bcc-code/bcc-media-platform/backend/sqlc"
	"github.com/orsinium-labs/enum"
)

type UpdateTranslationCallback func(ctx context.Context, collection string, data []common.TranslationData) error

type TranslationsProvider interface {
	SendToTranslation(ctx context.Context, collection string, data []common.TranslationData) error
	ProcessWebhook(ctx context.Context, url string, hookData []byte) (collection *TranslatableCollection, data []common.TranslationData, err error)
}

type Service struct {
	provider TranslationsProvider
	queries  *sqlc.Queries
}

type TranslatableCollection enum.Member[string]

var (
	CollectionAchievementGroups = TranslatableCollection{"achievementgroups"}
	CollectionAchievements      = TranslatableCollection{"achievements"}
	CollectionStudyQuestions    = TranslatableCollection{"studyquestions"}
	CollectionCalendarEntries   = TranslatableCollection{"calendarentries"}
	CollectionEpisodes          = TranslatableCollection{"episodes"}
	CollectionEvents            = TranslatableCollection{"events"}
	CollectionFAQCategories     = TranslatableCollection{"faqcategories"}
	CollectionFAQs              = TranslatableCollection{"faqs"}
	CollectionGames             = TranslatableCollection{"games"}
	CollectionLessons           = TranslatableCollection{"lessons"}
	CollectionLinks             = TranslatableCollection{"links"}
	CollectionMediaItems        = TranslatableCollection{"mediaitems"}
	CollectionPages             = TranslatableCollection{"pages"}
	CollectionPlaylists         = TranslatableCollection{"playlists"}
	CollectionSeasons           = TranslatableCollection{"seasons"}
	CollectionSections          = TranslatableCollection{"sections"}
	CollectionShows             = TranslatableCollection{"shows"}
	CollectionSurveys           = TranslatableCollection{"surveys"}
	CollectionTopics            = TranslatableCollection{"topics"}

	TranslatableCollections = enum.New(
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
	errs := make([]error, 0)
	for _, collection := range TranslatableCollections.Members() {
		if err := s.SendCollectionToTranslation(ctx, collection); err != nil {
			errs = append(errs, err)
		}
	}
	return errs
}

func (s *Service) SendCollectionToTranslation(ctx context.Context, collection TranslatableCollection) error {
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

func (s *Service) UpdateTranslations(ctx context.Context, collection *TranslatableCollection, data []common.TranslationData) []error {
	switch *collection {
	case CollectionAchievementGroups:
		return s.updateAchievementGroups(ctx, data)
	case CollectionAchievements:
		return s.updateAchievements(ctx, data)
	case CollectionStudyQuestions:
		return s.updateStudyQuestions(ctx, data)
	case CollectionCalendarEntries:
		return s.updateCalendarEntries(ctx, data)
	case CollectionEpisodes:
		return s.updateEpisodes(ctx, data)
	case CollectionEvents:
		return s.updateEvents(ctx, data)
	case CollectionFAQCategories:
		return s.updateFAQCategories(ctx, data)
	case CollectionFAQs:
		return s.updateFAQs(ctx, data)
	case CollectionGames:
		return s.updateGames(ctx, data)
	case CollectionLessons:
		return s.updateLessons(ctx, data)
	case CollectionLinks:
		return s.updateLinks(ctx, data)
	case CollectionMediaItems:
		return s.updateMediaItems(ctx, data)
	case CollectionPages:
		return s.updatePages(ctx, data)
	case CollectionPlaylists:
		return s.updatePlaylists(ctx, data)
	case CollectionSeasons:
		return s.updateSeasons(ctx, data)
	case CollectionSections:
		return s.updateSections(ctx, data)
	case CollectionShows:
		return s.updateShows(ctx, data)
	case CollectionSurveys:
		return s.updateSurveys(ctx, data)
	case CollectionTopics:
		return s.updateTopics(ctx, data)
	}
	return []error{merry.Errorf("Unknown transalatable collection %s", collection)}
}

func (s *Service) HandleWebhook(ctx context.Context, url string, hookData []byte) error {
	collection, data, err := s.provider.ProcessWebhook(ctx, url, hookData)
	if err != nil {
		return merry.Wrap(err)
	}

	errors := s.UpdateTranslations(ctx, collection, data)
	if len(errors) > 0 {
		for _, err := range errors {
			log.L.Err(err).Msg("Error occurred while updating translations")
		}
	}

	// Return nil as any error here is likley nor recoverable and makes no sense to repeat the request
	return nil
}
