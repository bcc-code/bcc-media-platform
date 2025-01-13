package translations

import (
	"context"
	"fmt"

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
	CollectionEpisodes        = translatableCollection{"episodes"}
	CollectionSeasons         = translatableCollection{"seasons"}
	CollectionShows           = translatableCollection{"shows"}
	CollectionEvents          = translatableCollection{"events"}
	CollectionCalendarEntries = translatableCollection{"calendarentries"}
	TranslatableCollection    = enum.New(
		CollectionEpisodes,
		CollectionShows,
	)
)

func NewService(queries *sqlc.Queries, provider TranslationsProvider) *Service {
	return &Service{
		provider: provider,
		queries:  queries,
	}
}

func (s *Service) SendCollectionToTranslation(ctx context.Context, collection translatableCollection) error {

	switch collection {
	case CollectionEpisodes:
		return s.sendEpisodes(ctx)
	case CollectionShows:
		return s.sendShows(ctx)
	case CollectionSeasons:
		return s.sendSeasons(ctx)
	case CollectionEvents:
		return s.sendEvents(ctx)
	default:
		return merry.Errorf("Unknown transalatable collection %s", collection)
	}
}

func (s *Service) sendShows(ctx context.Context) error {
	data, err := s.queries.ListShowTranslations(ctx, "no")
	if err != nil {
		return err
	}

	toSend := []common.TranslationData{}

	for _, t := range data {
		toSend = append(toSend,
			common.TranslationData{
				Language: t.Language,
				Value:    t.Values,
				ID:       fmt.Sprintf("%d", t.ID),
			},
		)
	}

	return s.provider.SendToTranslation(ctx, CollectionShows.Value, toSend)
}

func (s *Service) sendSeasons(ctx context.Context) error {
	data, err := s.queries.ListSeasonTranslations(ctx, "no")
	if err != nil {
		return err
	}

	toSend := []common.TranslationData{}

	for _, t := range data {
		toSend = append(toSend,
			common.TranslationData{
				Language: t.Language,
				Value:    t.Values,
				ID:       fmt.Sprintf("%d", t.ID),
			},
		)
	}

	return s.provider.SendToTranslation(ctx, CollectionSeasons.Value, toSend)
}

func (s *Service) sendEpisodes(ctx context.Context) error {
	data, err := s.queries.ListEpisodeTranslations(ctx, "no")
	if err != nil {
		return err
	}

	toSend := []common.TranslationData{}

	// TODO: Add context lint to episode translation
	// @context key, HTML content
	for _, t := range data {
		toSend = append(toSend,
			common.TranslationData{
				Language: t.Language,
				Value:    t.Values,
				ID:       fmt.Sprintf("%d", t.ID),
			},
		)
	}

	return s.provider.SendToTranslation(ctx, CollectionEpisodes.Value, toSend)
}

func (s *Service) sendEvents(ctx context.Context) error {
	data, err := s.queries.ListEventTranslations(ctx, "no")
	if err != nil {
		return err
	}

	toSend := []common.TranslationData{}

	for _, t := range data {
		toSend = append(toSend,
			common.TranslationData{
				Language: t.Language,
				Value:    t.Values,
				ID:       fmt.Sprintf("%d", t.ID),
			},
		)
	}

	return s.provider.SendToTranslation(ctx, CollectionEvents.Value, toSend)
}

func (s *Service) sendCalendarEntries(ctx context.Context) error {
	data, err := s.queries.ListCalendarEntryTranslations(ctx, "no")
	if err != nil {
		return err
	}

	toSend := []common.TranslationData{}

	for _, t := range data {
		toSend = append(toSend,
			common.TranslationData{
				Language: t.Language,
				Value:    t.Values,
				ID:       fmt.Sprintf("%d", t.ID),
			},
		)
	}

	return s.provider.SendToTranslation(ctx, CollectionCalendarEntries.Value, toSend)
}
