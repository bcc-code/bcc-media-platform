package translations

import (
	"context"
	"encoding/json"
	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/sqlc"
	"github.com/bcc-code/bcc-media-platform/backend/utils"
	"gopkg.in/guregu/null.v4"
)

func (s *Service) updateAchievementGroups(ctx context.Context, data []common.TranslationData) []error {
	errs := make([]error, 0)
	for _, d := range data {
		value := &TitleDescriptionTranslation{}
		err := json.Unmarshal(d.Value, value)
		if err != nil {
			errs = append(errs, err)
			continue
		}
		s.queries.UpdateAchievementGroupTranslation(ctx, sqlc.UpdateAchievementGroupTranslationParams{
			Language:    d.Language,
			ItemID:      utils.AsUuid(d.ID),
			Description: value.Description,
			Title:       null.StringFrom(value.Title),
		})
	}

	if len(errs) > 0 {
		return errs
	}

	return nil
}

func (s *Service) updateAchievements(ctx context.Context, data []common.TranslationData) []error {
	errs := make([]error, 0)
	for _, d := range data {
		value := &TitleDescriptionTranslation{}
		err := json.Unmarshal(d.Value, value)
		if err != nil {
			errs = append(errs, err)
			continue
		}
		s.queries.UpdateAchievementTranslation(ctx, sqlc.UpdateAchievementTranslationParams{
			Language:    d.Language,
			ItemID:      utils.AsUuid(d.ID),
			Description: value.Description,
			Title:       null.StringFrom(value.Title),
		})
	}

	if len(errs) > 0 {
		return errs
	}

	return nil
}

func (s *Service) updateStudyQuestions(ctx context.Context, data []common.TranslationData) []error {
	errs := make([]error, 0)
	for _, d := range data {
		value := &StudyQuestions{}
		err := json.Unmarshal(d.Value, value)
		if err != nil {
			errs = append(errs, err)
			continue
		}

		s.queries.UpdateTaskTranslation(ctx, sqlc.UpdateTaskTranslationParams{
			Language:    d.Language,
			ItemID:      utils.AsUuid(d.ID),
			Title:       null.StringFrom(value.Question),
			Description: value.Description,
		})

		for _, answer := range value.Answers {
			s.queries.UpdateAlternativeTranslation(ctx, sqlc.UpdateAlternativeTranslationParams{
				Language: d.Language,
				ItemID:   utils.AsUuid(answer.ID),
				Title:    null.StringFrom(answer.Title),
			})
		}
	}

	if len(errs) > 0 {
		return errs
	}

	return nil
}

func (s *Service) updateCalendarEntries(ctx context.Context, data []common.TranslationData) []error {
	errs := make([]error, 0)
	for _, d := range data {
		value := &TitleDescriptionTranslation{}
		err := json.Unmarshal(d.Value, value)
		if err != nil {
			errs = append(errs, err)
			continue
		}

		s.queries.UpdateCalendarEntryTranslation(ctx, sqlc.UpdateCalendarEntryTranslationParams{
			Language:    d.Language,
			ItemID:      int32(utils.AsInt(d.ID)),
			Description: value.Description,
			Title:       null.StringFrom(value.Title),
		})
	}

	if len(errs) > 0 {
		return errs
	}

	return nil
}

func (s *Service) updateEpisodes(ctx context.Context, data []common.TranslationData) []error {
	errs := make([]error, 0)
	for _, d := range data {
		value := &EpisodesTranslations{}
		err := json.Unmarshal(d.Value, value)
		if err != nil {
			errs = append(errs, err)
			continue
		}
		s.queries.UpdateEpisodeTranslation(ctx, sqlc.UpdateEpisodeTranslationParams{
			Language:    d.Language,
			ItemID:      int32(utils.AsInt(d.ID)),
			Description: value.Description,
			Title:       null.StringFrom(value.Title),
		})
	}

	if len(errs) > 0 {
		return errs
	}

	return nil
}

func (s *Service) updateEvents(ctx context.Context, data []common.TranslationData) []error {
	errs := make([]error, 0)
	for _, d := range data {
		value := &TitleDescriptionTranslation{}
		err := json.Unmarshal(d.Value, value)
		if err != nil {
			errs = append(errs, err)
			continue
		}
		s.queries.UpdateEventTranslation(ctx, sqlc.UpdateEventTranslationParams{
			Language:    d.Language,
			ItemID:      int32(utils.AsInt(d.ID)),
			Description: value.Description,
			Title:       null.StringFrom(value.Title),
		})
	}

	if len(errs) > 0 {
		return errs
	}

	return nil
}

func (s *Service) updateFAQCategories(ctx context.Context, data []common.TranslationData) []error {
	errs := make([]error, 0)
	for _, d := range data {
		value := &TitleDescriptionTranslation{}
		err := json.Unmarshal(d.Value, value)
		if err != nil {
			errs = append(errs, err)
			continue
		}
		s.queries.UpdateFAQCategoryTranslation(ctx, sqlc.UpdateFAQCategoryTranslationParams{
			Language:    d.Language,
			ItemID:      utils.AsUuid(d.ID),
			Description: value.Description,
			Title:       null.StringFrom(value.Title),
		})
	}

	if len(errs) > 0 {
		return errs
	}

	return nil
}

func (s *Service) updateFAQs(ctx context.Context, data []common.TranslationData) []error {
	errs := make([]error, 0)
	for _, d := range data {
		value := &FAQTranslations{}
		err := json.Unmarshal(d.Value, value)
		if err != nil {
			errs = append(errs, err)
			continue
		}
		s.queries.UpdateFAQTranslation(ctx, sqlc.UpdateFAQTranslationParams{
			Language: d.Language,
			ItemID:   utils.AsUuid(d.ID),
			Question: value.Question,
			Answer:   value.Answer,
		})
	}

	if len(errs) > 0 {
		return errs
	}

	return nil
}

func (s *Service) updateGames(ctx context.Context, data []common.TranslationData) []error {
	errs := make([]error, 0)
	for _, d := range data {
		value := &TitleDescriptionTranslation{}
		err := json.Unmarshal(d.Value, value)
		if err != nil {
			errs = append(errs, err)
			continue
		}
		s.queries.UpdateGameTranslation(ctx, sqlc.UpdateGameTranslationParams{
			Language:    d.Language,
			ItemID:      utils.AsUuid(d.ID),
			Description: value.Description,
			Title:       null.StringFrom(value.Title),
		})
	}

	if len(errs) > 0 {
		return errs
	}

	return nil
}

func (s *Service) updateLessons(ctx context.Context, data []common.TranslationData) []error {
	errs := make([]error, 0)
	for _, d := range data {
		value := &TitleDescriptionTranslation{}
		err := json.Unmarshal(d.Value, value)
		if err != nil {
			errs = append(errs, err)
			continue
		}
		s.queries.UpdateLessonTranslation(ctx, sqlc.UpdateLessonTranslationParams{
			Language:    d.Language,
			ItemID:      utils.AsUuid(d.ID),
			Description: value.Description,
			Title:       null.StringFrom(value.Title),
		})
	}

	if len(errs) > 0 {
		return errs
	}

	return nil
}

func (s *Service) updateLinks(ctx context.Context, data []common.TranslationData) []error {
	errs := make([]error, 0)
	for _, d := range data {
		value := &TitleDescriptionTranslation{}
		err := json.Unmarshal(d.Value, value)
		if err != nil {
			errs = append(errs, err)
			continue
		}
		s.queries.UpdateLinkTranslation(ctx, sqlc.UpdateLinkTranslationParams{
			Language:    d.Language,
			ItemID:      int32(utils.AsInt(d.ID)),
			Description: value.Description.ValueOrZero(),
			Title:       value.Title,
		})
	}

	if len(errs) > 0 {
		return errs
	}

	return nil
}

func (s *Service) updateMediaItems(ctx context.Context, data []common.TranslationData) []error {
	errs := make([]error, 0)
	for _, d := range data {
		value := &MediaItemTranslation{}
		err := json.Unmarshal(d.Value, value)
		if err != nil {
			errs = append(errs, err)
			continue
		}
		s.queries.UpdateMediaItemTranslation(ctx, sqlc.UpdateMediaItemTranslationParams{
			Language:    d.Language,
			ItemID:      utils.AsUuid(d.ID),
			Description: value.Description,
			Title:       value.Title,
		})
	}

	if len(errs) > 0 {
		return errs
	}

	return nil

}

func (s *Service) updatePages(ctx context.Context, data []common.TranslationData) []error {
	errs := make([]error, 0)
	for _, d := range data {
		value := &TitleDescriptionTranslation{}
		err := json.Unmarshal(d.Value, value)
		if err != nil {
			errs = append(errs, err)
			continue
		}
		s.queries.UpdatePageTranslation(ctx, sqlc.UpdatePageTranslationParams{
			Language:    d.Language,
			ItemID:      int32(utils.AsInt(d.ID)),
			Description: value.Description,
			Title:       null.StringFrom(value.Title),
		})
	}

	if len(errs) > 0 {
		return errs
	}

	return nil
}

func (s *Service) updatePlaylists(ctx context.Context, data []common.TranslationData) []error {
	errs := make([]error, 0)
	for _, d := range data {
		value := &TitleDescriptionTranslation{}
		err := json.Unmarshal(d.Value, value)
		if err != nil {
			errs = append(errs, err)
			continue
		}
		s.queries.UpdatePlaylistTranslation(ctx, sqlc.UpdatePlaylistTranslationParams{
			Language:    d.Language,
			ItemID:      utils.AsUuid(d.ID),
			Description: value.Description,
			Title:       null.StringFrom(value.Title),
		})
	}

	if len(errs) > 0 {
		return errs
	}

	return nil
}

func (s *Service) updateSeasons(ctx context.Context, data []common.TranslationData) []error {
	errs := make([]error, 0)
	for _, d := range data {
		value := &TitleDescriptionTranslation{}
		err := json.Unmarshal(d.Value, value)
		if err != nil {
			errs = append(errs, err)
			continue
		}
		s.queries.UpdateSeasonTranslation(ctx, sqlc.UpdateSeasonTranslationParams{
			Language:    d.Language,
			ItemID:      int32(utils.AsInt(d.ID)),
			Description: value.Description,
			Title:       null.StringFrom(value.Title),
		})
	}

	if len(errs) > 0 {
		return errs
	}

	return nil
}

func (s *Service) updateSections(ctx context.Context, data []common.TranslationData) []error {
	errs := make([]error, 0)
	for _, d := range data {
		value := &TitleDescriptionTranslation{}
		err := json.Unmarshal(d.Value, value)
		if err != nil {
			errs = append(errs, err)
			continue
		}
		s.queries.UpdateSectionTranslation(ctx, sqlc.UpdateSectionTranslationParams{
			Language:    d.Language,
			ItemID:      int32(utils.AsInt(d.ID)),
			Description: value.Description,
			Title:       null.StringFrom(value.Title),
		})
	}

	if len(errs) > 0 {
		return errs
	}

	return nil
}

func (s *Service) updateShows(ctx context.Context, data []common.TranslationData) []error {
	errs := make([]error, 0)
	for _, d := range data {
		value := &TitleDescriptionTranslation{}
		err := json.Unmarshal(d.Value, value)
		if err != nil {
			errs = append(errs, err)
			continue
		}
		s.queries.UpdateShowTranslation(ctx, sqlc.UpdateShowTranslationParams{
			Language:    d.Language,
			ItemID:      int32(utils.AsInt(d.ID)),
			Description: value.Description,
			Title:       null.StringFrom(value.Title),
		})
	}

	if len(errs) > 0 {
		return errs
	}

	return nil
}

func (s *Service) updateSurveys(ctx context.Context, data []common.TranslationData) []error {
	errs := make([]error, 0)
	for _, d := range data {
		value := &SurveyTranslations{}
		err := json.Unmarshal(d.Value, value)
		if err != nil {
			errs = append(errs, err)
			continue
		}
		err = s.queries.UpdateSurveyTranslation(ctx, sqlc.UpdateSurveyTranslationParams{
			Language:    d.Language,
			ItemID:      utils.AsUuid(d.ID),
			Description: value.Description,
			Title:       null.StringFrom(value.Title),
		})
		if err != nil {
			errs = append(errs, err)
		}

		for _, q := range value.Questions {
			err = s.queries.UpdateSurveyQuestionTranslation(ctx, sqlc.UpdateSurveyQuestionTranslationParams{
				Language: d.Language,
				ItemID:   utils.AsUuid(q.ID),
				Title:    null.StringFrom(q.Title),
			})
			if err != nil {
				errs = append(errs, err)
			}
		}

	}

	if len(errs) > 0 {
		return errs
	}

	return nil
}

func (s *Service) updateTopics(ctx context.Context, data []common.TranslationData) []error {
	errs := make([]error, 0)
	for _, d := range data {
		value := &TitleDescriptionTranslation{}
		err := json.Unmarshal(d.Value, value)
		if err != nil {
			errs = append(errs, err)
			continue
		}
		err = s.queries.UpdateStudyTopicTranslation(ctx, sqlc.UpdateStudyTopicTranslationParams{
			Language:    d.Language,
			ItemID:      utils.AsUuid(d.ID),
			Description: value.Description,
			Title:       null.StringFrom(value.Title),
		})
		if err != nil {
			errs = append(errs, err)
		}
	}

	if len(errs) > 0 {
		return errs
	}

	return nil
}
