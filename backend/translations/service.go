package translations

import (
	"context"
	"crypto/sha1"
	"encoding/base64"
	"encoding/json"
	"github.com/ansel1/merry/v2"
	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/log"
	"github.com/bcc-code/bcc-media-platform/backend/sqlc"
	"github.com/orsinium-labs/enum"
	"net/http"
	"sort"
)

type UpdateTranslationCallback func(ctx context.Context, collection string, data []common.TranslationData) error

type TranslationsProvider interface {
	SendToTranslation(ctx context.Context, collection string, data []common.TranslationData) error
	ProcessWebhook(ctx context.Context, originalRequest *http.Request, hookData []byte) (collection *TranslatableCollection, data []common.TranslationData, err error)
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
		log.L.Debug().Str("collection", collection.Value).Msg("Checking collection for translatables translation")
		if err := s.SendCollectionToTranslation(ctx, collection); err != nil {
			errs = append(errs, err)
		}
	}
	return errs
}

func (s *Service) SendCollectionToTranslation(ctx context.Context, collection TranslatableCollection) error {
	var err error
	var data []common.TranslationData

	if !TranslatableCollections.Contains(collection) {
		return merry.Errorf("collection %s is not translatable", collection)
	}

	switch collection {
	case CollectionAchievementGroups:
		data, err = s.getDataForAchievementGroups(ctx)
	case CollectionAchievements:
		data, err = s.getDataForAchievements(ctx)
	case CollectionStudyQuestions:
		data, err = s.getDataForStudyQuestions(ctx)
	case CollectionCalendarEntries:
		data, err = s.getDataForCalendarEntries(ctx)
	case CollectionEpisodes:
		data, err = s.getDataForEpisodes(ctx)
	case CollectionEvents:
		data, err = s.getDataForEvents(ctx)
	case CollectionFAQCategories:
		data, err = s.getDataForFAQCategories(ctx)
	case CollectionFAQs:
		data, err = s.getDataForFAQs(ctx)
	case CollectionGames:
		data, err = s.getDataForGames(ctx)
	case CollectionLessons:
		data, err = s.getDataForLessons(ctx)
	case CollectionLinks:
		data, err = s.getDataForLinks(ctx)
	case CollectionMediaItems:
		data, err = s.getDataForMediaItems(ctx)
	case CollectionPages:
		data, err = s.getDataForPages(ctx)
	case CollectionPlaylists:
		data, err = s.getDataForPlaylists(ctx)
	case CollectionSeasons:
		data, err = s.getDataForSeasons(ctx)
	case CollectionSections:
		data, err = s.getDataForSections(ctx)
	case CollectionShows:
		data, err = s.getDataForShows(ctx)
	case CollectionSurveys:
		data, err = s.getDataForSurveys(ctx)
	case CollectionTopics:
		data, err = s.getDataForTopics(ctx)
	}

	if err != nil {
		return err
	}

	return s.sendToProviderIfNeeded(ctx, collection, data)
}

func (s *Service) sendToProviderIfNeeded(ctx context.Context, collection TranslatableCollection, data []common.TranslationData) error {
	if len(data) == 0 {
		return nil
	}

	sort.Slice(data, func(i, j int) bool {
		return data[i].ID < data[j].ID
	})

	marshalledData, _ := json.Marshal(data)

	h := sha1.New()
	h.Write(marshalledData)
	hash := base64.URLEncoding.EncodeToString(h.Sum(nil))

	log.L.Debug().Str("collection", collection.Value).Str("hash", hash).Send()

	// This does not work in prod (but it does locally). If you can figure out what's wrong, you get a cookie!
	res, err := s.queries.ShouldSendTranslations(ctx, sqlc.ShouldSendTranslationsParams{
		Collection: collection.Value,
		Hash:       []byte(hash),
	})
	if err != nil {
		return err
	}

	if !res {
		log.L.Debug().Str("collection", collection.Value).Msg("Skipping sending to provider")
		return nil
	}

	hashes, err := s.queries.GetTranslationsHash(ctx, []byte(hash))
	if err != nil {
		return err
	}

	if len(hashes) > 0 {
		log.L.Debug().Str("collection", collection.Value).Msg("Skipping sending to provider as it has already been sent")
		for _, hash := range hashes {
			log.L.Debug().Str("hash", string(hash.Hash)).Str("collection", hash.Collection).Msg("Skipping sending to provider as it has already been sent")
		}
		return nil
	}

	log.L.Debug().Str("collection", collection.Value).Int("count", len(data)).Msg("Sending to provider")
	err = s.provider.SendToTranslation(ctx, collection.Value, data)

	if err != nil {
		return err
	}

	log.L.Debug().Str("collection", collection.Value).Str("hash", hash).Msg("Updating hash")
	return s.queries.UpdateTranslationsHash(ctx, sqlc.UpdateTranslationsHashParams{
		Collection: collection.Value,
		Hash:       []byte(hash),
	})
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

func (s *Service) HandleWebhook(ctx context.Context, originalRequest *http.Request, hookData []byte) error {
	collection, data, err := s.provider.ProcessWebhook(ctx, originalRequest, hookData)
	if err != nil {
		return merry.Wrap(err)
	}

	if collection == nil || len(data) == 0 {
		// The provider has determined there is nothing to update
		return nil
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
