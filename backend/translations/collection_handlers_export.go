package translations

import (
	"context"
	"encoding/json"
	"fmt"
	"github.com/bcc-code/bcc-media-platform/backend/common"
	"gopkg.in/guregu/null.v4"
)

func mustToJson(v interface{}) json.RawMessage {
	b, _ := json.Marshal(v)
	return b
}

func (s *Service) sendShows(ctx context.Context) error {
	data, err := s.queries.GetShowTranslatable(ctx)
	if err != nil {
		return err
	}

	toSend := []common.TranslationData{}

	for _, t := range data {
		value := TitleDescriptionTranslation{
			Title:       t.Title.ValueOrZero(),
			Description: t.Description,
		}
		toSend = append(toSend,
			common.TranslationData{
				Language: "no",
				Value:    mustToJson(value),
				ID:       fmt.Sprintf("%d", t.ID),
			},
		)
	}

	return s.provider.SendToTranslation(ctx, CollectionShows.Value, toSend)
}

func (s *Service) sendSeasons(ctx context.Context) error {
	data, err := s.queries.GetSeasonTranslatable(ctx)
	if err != nil {
		return err
	}

	toSend := []common.TranslationData{}

	for _, t := range data {
		value := TitleDescriptionTranslation{
			Title:       t.Title.ValueOrZero(),
			Description: t.Description,
		}
		toSend = append(toSend,
			common.TranslationData{
				Language: "no",
				Value:    mustToJson(value),
				ID:       fmt.Sprintf("%d", t.ID),
			},
		)
	}

	return s.provider.SendToTranslation(ctx, CollectionSeasons.Value, toSend)
}

func (s *Service) sendEpisodes(ctx context.Context) error {
	data, err := s.queries.GetEpisodeTranslatable(ctx)
	if err != nil {
		return err
	}

	toSend := []common.TranslationData{}

	for _, t := range data {
		value := EpisodesTranslations{
			Title:       t.Title.ValueOrZero(),
			Description: t.Description,
			Context:     fmt.Sprintf("<a href=\"https://app.bcc.media/episode/%d\">Link to episode</a>", t.ID),
		}

		toSend = append(toSend,
			common.TranslationData{
				Language: "no",
				Value:    mustToJson(value),
				ID:       fmt.Sprintf("%d", t.ID),
			},
		)
	}

	return s.provider.SendToTranslation(ctx, CollectionEpisodes.Value, toSend)
}

func (s *Service) sendEvents(ctx context.Context) error {
	data, err := s.queries.GetEventTranslatable(ctx)
	if err != nil {
		return err
	}

	toSend := []common.TranslationData{}

	for _, t := range data {
		value := TitleDescriptionTranslation{
			Title:       t.Title.ValueOrZero(),
			Description: t.Description,
		}

		toSend = append(toSend,
			common.TranslationData{
				Language: "no",
				Value:    mustToJson(value),
				ID:       fmt.Sprintf("%d", t.ID),
			},
		)
	}

	return s.provider.SendToTranslation(ctx, CollectionEvents.Value, toSend)
}

func (s *Service) sendCalendarEntries(ctx context.Context) error {
	data, err := s.queries.GetCalendarEntriesTranslatable(ctx)
	if err != nil {
		return err
	}

	toSend := []common.TranslationData{}

	for _, t := range data {
		value := TitleDescriptionTranslation{
			Title:       t.Title.ValueOrZero(),
			Description: t.Description,
		}

		toSend = append(toSend,
			common.TranslationData{
				Language: "no",
				Value:    mustToJson(value),
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
	data, err := s.queries.GetSectionTranslatable(ctx)
	if err != nil {
		return err
	}

	toSend := []common.TranslationData{}

	for _, t := range data {
		value := TitleDescriptionTranslation{
			Title:       t.Title.ValueOrZero(),
			Description: t.Description,
		}
		toSend = append(toSend,
			common.TranslationData{
				Language: "no",
				Value:    mustToJson(value),
				ID:       fmt.Sprintf("%d", t.ID),
			},
		)
	}

	return s.provider.SendToTranslation(ctx, CollectionSections.Value, toSend)
}

func (s *Service) sendPages(ctx context.Context) error {
	data, err := s.queries.GetPageTranslatable(ctx)
	if err != nil {
		return err
	}

	toSend := []common.TranslationData{}

	for _, t := range data {
		value := TitleDescriptionTranslation{
			Title:       t.Title.ValueOrZero(),
			Description: t.Description,
		}
		toSend = append(toSend,
			common.TranslationData{
				Language: "no",
				Value:    mustToJson(value),
				ID:       fmt.Sprintf("%d", t.ID),
			},
		)
	}

	return s.provider.SendToTranslation(ctx, CollectionPages.Value, toSend)
}

func (s *Service) sendLinks(ctx context.Context) error {
	data, err := s.queries.GetLinkTranslatable(ctx)
	if err != nil {
		return err
	}

	toSend := []common.TranslationData{}

	for _, t := range data {
		value := TitleDescriptionTranslation{
			Title:       t.Title,
			Description: null.StringFrom(t.Description),
		}
		toSend = append(toSend,
			common.TranslationData{
				Language: "no",
				Value:    mustToJson(value),
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
		value := TitleDescriptionTranslation{
			Title:       t.Title,
			Description: t.Description,
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
		value := TitleDescriptionTranslation{
			Title:       t.Title,
			Description: t.Description,
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
		value := SurveyTranslations{
			Title:        t.Title,
			Description:  t.Description,
			RawQuestions: t.Questions,
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
		value := StudyQuestions{
			Question:    t.Question.ValueOrZero(),
			Description: t.Description,
			RawAnswers:  t.Answers,
		}

		toSend = append(toSend,
			common.TranslationData{
				Language: "no",
				ID:       t.ID.String(),
				Value:    mustToJson(value),
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
		value := TitleDescriptionTranslation{
			Title:       t.Title,
			Description: t.Description,
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
		toSend = append(toSend,
			common.TranslationData{
				Language: "no",
				Value:    mustToJson(TitleTranslation{Title: t.Title}),
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
		value := FAQTranslations{
			Question: t.Question,
			Answer:   t.Answer,
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
		toSend = append(toSend,
			common.TranslationData{
				Language: "no",
				Value:    mustToJson(TitleTranslation{Title: null.StringFrom(t.Title)}),
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
		value := TitleDescriptionTranslation{
			Title:       t.Title,
			Description: t.Description,
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
	data, err := s.queries.GetPlaylistTranslatable(ctx)
	if err != nil {
		return err
	}

	toSend := []common.TranslationData{}

	for _, t := range data {
		value := TitleDescriptionTranslation{
			Title:       t.Title,
			Description: t.Description,
		}

		toSend = append(toSend,
			common.TranslationData{
				Language: "no",
				Value:    mustToJson(value),
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
		value := MediaItemTranslation{
			Title:       t.Title,
			Description: t.Description,
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
