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
		// Achievement groups are exported as TitleTranslation (title only),
		// so decode the same shape here to avoid losing the title to a
		// type mismatch.
		value := &TitleTranslation{}
		err := json.Unmarshal(d.Value, value)
		if err != nil {
			errs = append(errs, err)
			continue
		}
		if err := s.queries.UpdateAchievementGroupTranslation(ctx, sqlc.UpdateAchievementGroupTranslationParams{
			Language: d.Language,
			ItemID:   utils.AsUuid(d.ID),
			Title:    value.Title,
		}); err != nil {
			errs = append(errs, err)
		}
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
		if err := s.queries.UpdateAchievementTranslation(ctx, sqlc.UpdateAchievementTranslationParams{
			Language:    d.Language,
			ItemID:      utils.AsUuid(d.ID),
			Description: value.Description,
			Title:       null.StringFrom(value.Title),
		}); err != nil {
			errs = append(errs, err)
		}
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

		if err := s.queries.UpdateTaskTranslation(ctx, sqlc.UpdateTaskTranslationParams{
			Language:    d.Language,
			ItemID:      utils.AsUuid(d.ID),
			Title:       null.StringFrom(value.Question),
			Description: value.Description,
		}); err != nil {
			errs = append(errs, err)
		}

		for _, answer := range value.Answers {
			if err := s.queries.UpdateAlternativeTranslation(ctx, sqlc.UpdateAlternativeTranslationParams{
				Language: d.Language,
				ItemID:   utils.AsUuid(answer.ID),
				Title:    null.StringFrom(answer.Title),
			}); err != nil {
				errs = append(errs, err)
			}
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

		if err := s.queries.UpdateCalendarEntryTranslation(ctx, sqlc.UpdateCalendarEntryTranslationParams{
			Language:    d.Language,
			ItemID:      int32(utils.AsInt(d.ID)),
			Description: value.Description,
			Title:       null.StringFrom(value.Title),
		}); err != nil {
			errs = append(errs, err)
		}
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
		if err := s.queries.UpdateEpisodeTranslation(ctx, sqlc.UpdateEpisodeTranslationParams{
			Language:    d.Language,
			ItemID:      int32(utils.AsInt(d.ID)),
			Description: value.Description,
			Title:       null.StringFrom(value.Title),
		}); err != nil {
			errs = append(errs, err)
		}
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
		if err := s.queries.UpdateEventTranslation(ctx, sqlc.UpdateEventTranslationParams{
			Language:    d.Language,
			ItemID:      int32(utils.AsInt(d.ID)),
			Description: value.Description,
			Title:       null.StringFrom(value.Title),
		}); err != nil {
			errs = append(errs, err)
		}
	}

	if len(errs) > 0 {
		return errs
	}

	return nil
}

func (s *Service) updateFAQCategories(ctx context.Context, data []common.TranslationData) []error {
	errs := make([]error, 0)
	for _, d := range data {
		// FAQ categories are exported as TitleTranslation (title only).
		value := &TitleTranslation{}
		err := json.Unmarshal(d.Value, value)
		if err != nil {
			errs = append(errs, err)
			continue
		}
		if err := s.queries.UpdateFAQCategoryTranslation(ctx, sqlc.UpdateFAQCategoryTranslationParams{
			Language: d.Language,
			ItemID:   utils.AsUuid(d.ID),
			Title:    value.Title,
		}); err != nil {
			errs = append(errs, err)
		}
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
		if err := s.queries.UpdateFAQTranslation(ctx, sqlc.UpdateFAQTranslationParams{
			Language: d.Language,
			ItemID:   utils.AsUuid(d.ID),
			Question: value.Question,
			Answer:   value.Answer,
		}); err != nil {
			errs = append(errs, err)
		}
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
		if err := s.queries.UpdateGameTranslation(ctx, sqlc.UpdateGameTranslationParams{
			Language:    d.Language,
			ItemID:      utils.AsUuid(d.ID),
			Description: value.Description,
			Title:       null.StringFrom(value.Title),
		}); err != nil {
			errs = append(errs, err)
		}
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
		if err := s.queries.UpdateLessonTranslation(ctx, sqlc.UpdateLessonTranslationParams{
			Language:    d.Language,
			ItemID:      utils.AsUuid(d.ID),
			Description: value.Description,
			Title:       null.StringFrom(value.Title),
		}); err != nil {
			errs = append(errs, err)
		}
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
		if err := s.queries.UpdateLinkTranslation(ctx, sqlc.UpdateLinkTranslationParams{
			Language:    d.Language,
			ItemID:      int32(utils.AsInt(d.ID)),
			Description: value.Description.ValueOrZero(),
			Title:       value.Title,
		}); err != nil {
			errs = append(errs, err)
		}
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
		if err := s.queries.UpdateMediaItemTranslation(ctx, sqlc.UpdateMediaItemTranslationParams{
			Language:    d.Language,
			ItemID:      utils.AsUuid(d.ID),
			Description: value.Description,
			Title:       value.Title,
		}); err != nil {
			errs = append(errs, err)
		}
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
		if err := s.queries.UpdatePageTranslation(ctx, sqlc.UpdatePageTranslationParams{
			Language:    d.Language,
			ItemID:      int32(utils.AsInt(d.ID)),
			Description: value.Description,
			Title:       null.StringFrom(value.Title),
		}); err != nil {
			errs = append(errs, err)
		}
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
		if err := s.queries.UpdatePlaylistTranslation(ctx, sqlc.UpdatePlaylistTranslationParams{
			Language:    d.Language,
			ItemID:      utils.AsUuid(d.ID),
			Description: value.Description,
			Title:       null.StringFrom(value.Title),
		}); err != nil {
			errs = append(errs, err)
		}
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
		if err := s.queries.UpdateSeasonTranslation(ctx, sqlc.UpdateSeasonTranslationParams{
			Language:    d.Language,
			ItemID:      int32(utils.AsInt(d.ID)),
			Description: value.Description,
			Title:       null.StringFrom(value.Title),
		}); err != nil {
			errs = append(errs, err)
		}
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
		if err := s.queries.UpdateSectionTranslation(ctx, sqlc.UpdateSectionTranslationParams{
			Language:    d.Language,
			ItemID:      int32(utils.AsInt(d.ID)),
			Description: value.Description,
			Title:       null.StringFrom(value.Title),
		}); err != nil {
			errs = append(errs, err)
		}
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
		if err := s.queries.UpdateShowTranslation(ctx, sqlc.UpdateShowTranslationParams{
			Language:    d.Language,
			ItemID:      int32(utils.AsInt(d.ID)),
			Description: value.Description,
			Title:       null.StringFrom(value.Title),
		}); err != nil {
			errs = append(errs, err)
		}
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
				Language:    d.Language,
				ItemID:      utils.AsUuid(q.ID),
				Title:       null.StringFrom(q.Title),
				Description: q.Description,
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
