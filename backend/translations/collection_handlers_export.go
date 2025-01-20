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

func (s *Service) getDataForShows(ctx context.Context) ([]common.TranslationData, error) {
	data, err := s.queries.GetShowTranslatable(ctx)
	if err != nil {
		return nil, err
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

	return toSend, err
}

func (s *Service) getDataForSeasons(ctx context.Context) ([]common.TranslationData, error) {
	data, err := s.queries.GetSeasonTranslatable(ctx)
	if err != nil {
		return nil, err
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

	return toSend, err
}

func (s *Service) getDataForEpisodes(ctx context.Context) ([]common.TranslationData, error) {
	data, err := s.queries.GetEpisodeTranslatable(ctx)
	if err != nil {
		return nil, err
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

	return toSend, err
}

func (s *Service) getDataForEvents(ctx context.Context) ([]common.TranslationData, error) {
	data, err := s.queries.GetEventTranslatable(ctx)
	if err != nil {
		return nil, err
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

	return toSend, err
}

func (s *Service) getDataForCalendarEntries(ctx context.Context) ([]common.TranslationData, error) {
	data, err := s.queries.GetCalendarEntriesTranslatable(ctx)
	if err != nil {
		return nil, err
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

	return toSend, err
}

func (s *Service) getDataForClanedarEntries(ctx context.Context) ([]common.TranslationData, error) {
	data, err := s.queries.ListCalendarEntryTranslations(ctx, "no")
	if err != nil {
		return nil, err
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

	return toSend, err
}

func (s *Service) getDataForSections(ctx context.Context) ([]common.TranslationData, error) {
	data, err := s.queries.GetSectionTranslatable(ctx)
	if err != nil {
		return nil, err
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

	return toSend, err
}

func (s *Service) getDataForPages(ctx context.Context) ([]common.TranslationData, error) {
	data, err := s.queries.GetPageTranslatable(ctx)
	if err != nil {
		return nil, err
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

	return toSend, err
}

func (s *Service) getDataForLinks(ctx context.Context) ([]common.TranslationData, error) {
	data, err := s.queries.GetLinkTranslatable(ctx)
	if err != nil {
		return nil, err
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

	return toSend, err
}

func (s *Service) getDataForLessons(ctx context.Context) ([]common.TranslationData, error) {
	data, err := s.queries.GetLessonsTranslatableText(ctx)
	if err != nil {
		return nil, err
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

	return toSend, err
}

func (s *Service) getDataForTopics(ctx context.Context) ([]common.TranslationData, error) {
	data, err := s.queries.GetStudyTopicsTranslatableText(ctx)
	if err != nil {
		return nil, err
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

	return toSend, err
}

func (s *Service) getDataForSurveys(ctx context.Context) ([]common.TranslationData, error) {
	data, err := s.queries.GetSurveyTranslatableText(ctx)
	if err != nil {
		return nil, err
	}

	toSend := []common.TranslationData{}

	for _, t := range data {
		questions := []TitleWithId{}
		_ = json.Unmarshal(t.Questions, &questions)

		value := SurveyTranslations{
			Title:       t.Title,
			Description: t.Description,
			Questions:   questions,
		}

		toSend = append(toSend,
			common.TranslationData{
				Language: "no",
				Value:    mustToJson(value),
				ID:       t.ID.String(),
			},
		)
	}

	return toSend, err
}

func (s *Service) getDataForStudyQuestions(ctx context.Context) ([]common.TranslationData, error) {
	data, err := s.queries.GetQuestionsTranslations(ctx)
	if err != nil {
		return nil, err
	}

	toSend := []common.TranslationData{}

	for _, t := range data {
		answers := []TitleWithId{}
		_ = json.Unmarshal(t.Answers, &answers)

		value := StudyQuestions{
			Question:    t.Question.ValueOrZero(),
			Description: t.Description,
			Answers:     answers,
		}

		toSend = append(toSend,
			common.TranslationData{
				Language: "no",
				ID:       t.ID.String(),
				Value:    mustToJson(value),
			},
		)
	}

	return toSend, err
}

func (s *Service) getDataForAchievements(ctx context.Context) ([]common.TranslationData, error) {
	data, err := s.queries.GetAchieventsTranslatableTexts(ctx)
	if err != nil {
		return nil, err
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

	return toSend, err
}

func (s *Service) getDataForAchievementGroups(ctx context.Context) ([]common.TranslationData, error) {
	data, err := s.queries.GetAchieventGroupsTranslatableTexts(ctx)
	if err != nil {
		return nil, err
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

	return toSend, err
}

func (s *Service) getDataForFAQs(ctx context.Context) ([]common.TranslationData, error) {
	data, err := s.queries.GetFaqTranslatableText(ctx)
	if err != nil {
		return nil, err
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

	return toSend, err
}

func (s *Service) getDataForFAQCategories(ctx context.Context) ([]common.TranslationData, error) {
	data, err := s.queries.GetFaqCategoryTranslatableText(ctx)
	if err != nil {
		return nil, err
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

	return toSend, err
}

func (s *Service) getDataForGames(ctx context.Context) ([]common.TranslationData, error) {
	data, err := s.queries.GetGameTranslatableTexts(ctx)
	if err != nil {
		return nil, err
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

	return toSend, err
}

func (s *Service) getDataForPlaylists(ctx context.Context) ([]common.TranslationData, error) {
	data, err := s.queries.GetPlaylistTranslatable(ctx)
	if err != nil {
		return nil, err
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

	return toSend, err
}

func (s *Service) getDataForMediaItems(ctx context.Context) ([]common.TranslationData, error) {
	data, err := s.queries.GetMediaItemsTranslatableText(ctx)
	if err != nil {
		return nil, err
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

	return toSend, err
}
