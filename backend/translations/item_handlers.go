package translations

import (
	"context"
	"encoding/json"
	"fmt"
	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/gin-gonic/gin"
)

func mustToJson(v interface{}) json.RawMessage {
	b, _ := json.Marshal(v)
	return b
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

	// TODO: Add context link to episode translation
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

func (s *Service) sendClanedarEntries(ctx context.Context) error {
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

func (s *Service) sendSections(ctx context.Context) error {
	data, err := s.queries.ListSectionTranslations(ctx, "no")
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

	return s.provider.SendToTranslation(ctx, CollectionSections.Value, toSend)
}

func (s *Service) sendPages(ctx context.Context) error {
	data, err := s.queries.ListPageTranslations(ctx, "no")
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

	return s.provider.SendToTranslation(ctx, CollectionPages.Value, toSend)
}

func (s *Service) sendLinks(ctx context.Context) error {
	data, err := s.queries.ListLinkTranslations(ctx, "no")
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

	return s.provider.SendToTranslation(ctx, CollectionLinks.Value, toSend)
}

func (s *Service) sendLessons(ctx context.Context) error {
	data, err := s.queries.GetLessonsTranslatableText(ctx)
	if err != nil {
		return err
	}

	toSend := []common.TranslationData{}

	for _, t := range data {
		value := gin.H{
			"title":       t.Title,
			"description": t.Description,
		}
		toSend = append(toSend,
			common.TranslationData{
				Language: "no",
				Value:    mustToJson(value),
				ID:       t.ID.String(),
			},
		)
	}

	return s.provider.SendToTranslation(ctx, CollectionLessons.Value, toSend)
}

func (s *Service) sendTopics(ctx context.Context) error {
	data, err := s.queries.GetStudyTopicsTranslatableText(ctx)
	if err != nil {
		return err
	}

	toSend := []common.TranslationData{}

	for _, t := range data {
		value := gin.H{
			"title":       t.Title,
			"description": t.Description,
		}
		toSend = append(toSend,
			common.TranslationData{
				Language: "no",
				Value:    mustToJson(value),
				ID:       t.ID.String(),
			},
		)
	}

	return s.provider.SendToTranslation(ctx, CollectionTopics.Value, toSend)
}

func (s *Service) sendSurveys(ctx context.Context) error {
	data, err := s.queries.GetSurveyTranslatableText(ctx)
	if err != nil {
		return err
	}

	toSend := []common.TranslationData{}

	for _, t := range data {
		value := gin.H{
			"title":       t.Title,
			"description": t.Description,
			"questions":   t.Questions,
		}
		toSend = append(toSend,
			common.TranslationData{
				Language: "no",
				Value:    mustToJson(value),
				ID:       t.ID.String(),
			},
		)
	}

	return s.provider.SendToTranslation(ctx, CollectionSurveys.Value, toSend)
}

func (s *Service) sendStudyQuestions(ctx context.Context) error {
	data, err := s.queries.GetQuestionsTranslations(ctx)
	if err != nil {
		return err
	}

	toSend := []common.TranslationData{}

	for _, t := range data {
		value := gin.H{
			"question": t.Question,
			"answers":  t.Answers,
		}

		j, _ := json.Marshal(value)

		toSend = append(toSend,
			common.TranslationData{
				Language: "no",
				ID:       t.TaskID.UUID.String(),
				Value:    j,
			},
		)
	}

	return s.provider.SendToTranslation(ctx, CollectionStudyQuestions.Value, toSend)
}

func (s *Service) sendAchievements(ctx context.Context) error {
	data, err := s.queries.GetAchieventsTranslatableTexts(ctx)
	if err != nil {
		return err
	}

	toSend := []common.TranslationData{}

	for _, t := range data {
		value := gin.H{
			"title":       t.Title,
			"description": t.Description,
		}

		toSend = append(toSend,
			common.TranslationData{
				Language: "no",
				Value:    mustToJson(value),
				ID:       t.ID.String(),
			},
		)
	}

	return s.provider.SendToTranslation(ctx, CollectionAchievements.Value, toSend)
}

func (s *Service) sendAchievementGroups(ctx context.Context) error {
	data, err := s.queries.GetAchieventGroupsTranslatableTexts(ctx)
	if err != nil {
		return err
	}

	toSend := []common.TranslationData{}

	for _, t := range data {
		value := gin.H{
			"title": t.Title,
		}

		toSend = append(toSend,
			common.TranslationData{
				Language: "no",
				Value:    mustToJson(value),
				ID:       t.ID.String(),
			},
		)
	}

	return s.provider.SendToTranslation(ctx, CollectionAchievementGroups.Value, toSend)
}

func (s *Service) sendFAQs(ctx context.Context) error {
	data, err := s.queries.GetFaqTranslatableText(ctx)
	if err != nil {
		return err
	}

	toSend := []common.TranslationData{}

	for _, t := range data {
		value := gin.H{
			"question": t.Question,
			"answer":   t.Answer,
		}
		toSend = append(toSend,
			common.TranslationData{
				Language: "no",
				Value:    mustToJson(value),
				ID:       t.ID.String(),
			},
		)
	}

	return s.provider.SendToTranslation(ctx, CollectionFAQs.Value, toSend)
}

func (s *Service) sendFAQCategories(ctx context.Context) error {
	data, err := s.queries.GetFaqCategoryTranslatableText(ctx)
	if err != nil {
		return err
	}

	toSend := []common.TranslationData{}

	for _, t := range data {
		value := gin.H{
			"title": t.Title,
		}

		toSend = append(toSend,
			common.TranslationData{
				Language: "no",
				Value:    mustToJson(value),
				ID:       t.ID.String(),
			},
		)
	}

	return s.provider.SendToTranslation(ctx, CollectionFAQCategories.Value, toSend)
}

func (s *Service) sendGames(ctx context.Context) error {
	data, err := s.queries.GetGameTranslatableTexts(ctx)
	if err != nil {
		return err
	}

	toSend := []common.TranslationData{}

	for _, t := range data {
		value := gin.H{
			"title":       t.Title,
			"description": t.Description,
		}

		toSend = append(toSend,
			common.TranslationData{
				Language: "no",
				Value:    mustToJson(value),
				ID:       t.ID.String(),
			},
		)
	}

	return s.provider.SendToTranslation(ctx, CollectionGames.Value, toSend)
}

func (s *Service) sendPlaylists(ctx context.Context) error {
	data, err := s.queries.ListPlaylistTranslations(ctx, "no")
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

	return s.provider.SendToTranslation(ctx, CollectionPlaylists.Value, toSend)
}

func (s *Service) sendMediaItems(ctx context.Context) error {
	data, err := s.queries.GetMediaItemsTranslatableText(ctx)
	if err != nil {
		return err
	}

	toSend := []common.TranslationData{}

	for _, t := range data {
		value := gin.H{
			"title":       t.Title,
			"description": t.Description,
		}
		toSend = append(toSend,
			common.TranslationData{
				Language: "no",
				Value:    mustToJson(value),
				ID:       t.ID.String(),
			},
		)
	}

	return s.provider.SendToTranslation(ctx, CollectionMediaItems.Value, toSend)
}
