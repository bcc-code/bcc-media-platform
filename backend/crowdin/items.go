package crowdin

import (
	"context"
	"encoding/json"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/google/uuid"
	"github.com/samber/lo"
)

func rawMessageToMap(msg json.RawMessage) map[string]string {
	var r map[string]string
	_ = json.Unmarshal(msg, &r)
	if r == nil {
		r = map[string]string{}
	}
	return r
}

func (c *Client) syncEpisodes(ctx context.Context, handler TranslationHandler, project Project, directoryId int, crowdinTranslations []Translation) error {
	return c.syncCollection(ctx, handler, project, directoryId, "episodes", c.episodesTranslationFactory, crowdinTranslations, nil)
}

func (c *Client) episodesTranslationFactory(ctx context.Context, language string) ([]SimpleTranslation, error) {
	return dbToSimple(ctx, language, c.q.ListEpisodeTranslations)
}

func (c *Client) syncSeasons(ctx context.Context, handler TranslationHandler, project Project, directoryId int, crowdinTranslations []Translation) error {
	return c.syncCollection(ctx, handler, project, directoryId, "seasons", c.seasonsTranslationFactory, crowdinTranslations, nil)
}

func (c *Client) seasonsTranslationFactory(ctx context.Context, language string) ([]SimpleTranslation, error) {
	return dbToSimple(ctx, language, c.q.ListSeasonTranslations)
}

func (c *Client) syncShows(ctx context.Context, handler TranslationHandler, project Project, directoryId int, crowdinTranslations []Translation) error {
	return c.syncCollection(ctx, handler, project, directoryId, "shows", c.showsTranslationFactory, crowdinTranslations, nil)
}

func (c *Client) showsTranslationFactory(ctx context.Context, language string) ([]SimpleTranslation, error) {
	return dbToSimple(ctx, language, c.q.ListShowTranslations)
}

func (c *Client) syncSections(ctx context.Context, handler TranslationHandler, project Project, directoryId int, crowdinTranslations []Translation) error {
	return c.syncCollection(ctx, handler, project, directoryId, "sections", c.sectionsTranslationFactory, crowdinTranslations, nil)
}

func (c *Client) sectionsTranslationFactory(ctx context.Context, language string) ([]SimpleTranslation, error) {
	return dbToSimple(ctx, language, c.q.ListSectionTranslations)
}

func (c *Client) syncPages(ctx context.Context, handler TranslationHandler, project Project, directoryId int, crowdinTranslations []Translation) error {
	return c.syncCollection(ctx, handler, project, directoryId, "pages", c.pagesTranslationFactory, crowdinTranslations, nil)
}

func (c *Client) syncLinks(ctx context.Context, handler TranslationHandler, project Project, directoryId int, crowdinTranslations []Translation) error {
	return c.syncCollection(ctx, handler, project, directoryId, "links", c.linksTranslationFactory, crowdinTranslations, nil)
}

func (c *Client) pagesTranslationFactory(ctx context.Context, language string) ([]SimpleTranslation, error) {
	return dbToSimple(ctx, language, c.q.ListPageTranslations)
}

func (c *Client) linksTranslationFactory(ctx context.Context, language string) ([]SimpleTranslation, error) {
	return dbToSimple(ctx, language, c.q.ListLinkTranslations)
}

func (c *Client) syncLessons(ctx context.Context, handler TranslationHandler, project Project, directoryId int, crowdinTranslations []Translation) error {
	return c.syncCollection(ctx, handler, project, directoryId, "lessons", func(ctx context.Context, language string) ([]SimpleTranslation, error) {
		if language == "no" {
			ts, err := c.q.ListLessonOriginalTranslations(ctx)
			if err != nil {
				return nil, err
			}
			return mapToSimple(ts), nil
		}
		return dbToSimple(ctx, language, c.q.ListLessonTranslations)
	}, crowdinTranslations, nil)
}

func (c *Client) syncTopics(ctx context.Context, handler TranslationHandler, project Project, directoryId int, crowdinTranslations []Translation) error {
	return c.syncCollection(ctx, handler, project, directoryId, "studytopics", func(ctx context.Context, language string) ([]SimpleTranslation, error) {
		if language == "no" {
			ts, err := c.q.ListStudyTopicOriginalTranslations(ctx)
			if err != nil {
				return nil, err
			}
			return mapToSimple(ts), nil
		}
		return dbToSimple(ctx, language, c.q.ListStudyTopicTranslations)
	}, crowdinTranslations, nil)
}

func (c *Client) syncSurveys(ctx context.Context, handler TranslationHandler, project Project, directoryId int, crowdinTranslations []Translation) error {
	return c.syncCollection(ctx, handler, project, directoryId, "surveys", func(ctx context.Context, language string) ([]SimpleTranslation, error) {
		if language == "no" {
			ts, err := c.q.ListSurveyOriginalTranslations(ctx)
			if err != nil {
				return nil, err
			}
			return mapToSimple(ts), nil
		}
		return dbToSimple(ctx, language, c.q.ListSurveyTranslations)
	}, crowdinTranslations, nil)
}

func (c *Client) syncSurveyQuestions(ctx context.Context, handler TranslationHandler, project Project, directoryId int, crowdinTranslations []Translation) error {
	return c.syncCollection(ctx, handler, project, directoryId, "surveyquestions", func(ctx context.Context, language string) ([]SimpleTranslation, error) {
		if language == "no" {
			ts, err := c.q.ListSurveyQuestionOriginalTranslations(ctx)
			if err != nil {
				return nil, err
			}
			return mapToSimple(ts), nil
		}
		return dbToSimple(ctx, language, c.q.ListSurveyQuestionTranslations)
	}, crowdinTranslations, nil)
}

func (c *Client) syncTasks(ctx context.Context, handler TranslationHandler, project Project, directoryId int, crowdinTranslations []Translation) error {
	return c.syncCollection(ctx, handler, project, directoryId, "tasks", func(ctx context.Context, language string) ([]SimpleTranslation, error) {
		if language == "no" {
			ts, err := c.q.ListTaskOriginalTranslations(ctx)
			if err != nil {
				return nil, err
			}
			return mapToSimple(ts), nil
		}
		return dbToSimple(ctx, language, c.q.ListTaskTranslations)
	}, crowdinTranslations, nil)
}

func (c *Client) syncAlternatives(ctx context.Context, handler TranslationHandler, project Project, directoryId int, crowdinTranslations []Translation) error {
	originalTs, err := c.q.ListQuestionAlternativesOriginalTranslations(ctx)
	if err != nil {
		return err
	}

	alts, err := c.q.GetQuestionAlternativesByIDs(ctx, lo.Map(originalTs, func(i sqlc.ListQuestionAlternativesOriginalTranslationsRow, _ int) uuid.UUID {
		return i.ID
	}))
	if err != nil {
		return err
	}
	taskOriginals, err := c.q.ListTaskOriginalTranslations(ctx)
	if err != nil {
		return err
	}
	taskTitles := lo.Reduce(alts, func(m map[string]string, i sqlc.GetQuestionAlternativesByIDsRow, _ int) map[string]string {
		t, f := lo.Find(taskOriginals, func(t sqlc.ListTaskOriginalTranslationsRow) bool {
			return t.ID == i.TaskID.UUID
		})
		if !f {
			return m
		}
		m[i.ID.String()] = rawMessageToMap(t.Values)["title"]
		return m
	}, map[string]string{})

	return c.syncCollection(ctx, handler, project, directoryId, "questionalternatives", func(ctx context.Context, language string) ([]SimpleTranslation, error) {
		if language == "no" {
			return mapToSimple(originalTs), nil
		}
		return dbToSimple(ctx, language, c.q.ListAlternativeTranslations)
	}, crowdinTranslations, func(id string) string {
		if t, ok := taskTitles[id]; ok {
			return "Question: " + t
		}
		return ""
	})
}

func (c *Client) syncAchievements(ctx context.Context, handler TranslationHandler, project Project, directoryId int, crowdinTranslations []Translation) error {
	return c.syncCollection(ctx, handler, project, directoryId, "achievements", func(ctx context.Context, language string) ([]SimpleTranslation, error) {
		if language == "no" {
			ts, err := c.q.ListAchievementOriginalTranslations(ctx)
			if err != nil {
				return nil, err
			}
			return mapToSimple(ts), nil
		}
		return dbToSimple(ctx, language, c.q.ListAchievementTranslations)
	}, crowdinTranslations, nil)
}

func (c *Client) syncAchievementGroups(ctx context.Context, handler TranslationHandler, project Project, directoryId int, crowdinTranslations []Translation) error {
	return c.syncCollection(ctx, handler, project, directoryId, "achievementgroups", func(ctx context.Context, language string) ([]SimpleTranslation, error) {
		if language == "no" {
			ts, err := c.q.ListAchievementGroupOriginalTranslations(ctx)
			if err != nil {
				return nil, err
			}
			return mapToSimple(ts), nil
		}
		return dbToSimple(ctx, language, c.q.ListAchievementGroupTranslations)
	}, crowdinTranslations, nil)
}

func (c *Client) syncFAQs(ctx context.Context, handler TranslationHandler, project Project, directoryId int, crowdinTranslations []Translation) error {
	return c.syncCollection(ctx, handler, project, directoryId, "faqs", func(ctx context.Context, language string) ([]SimpleTranslation, error) {
		if language == "no" {
			ts, err := c.q.ListFAQOriginalTranslations(ctx)
			if err != nil {
				return nil, err
			}
			return mapToSimple(ts), nil
		}
		return dbToSimple(ctx, language, c.q.ListFAQTranslations)
	}, crowdinTranslations, nil)
}

func (c *Client) syncFAQCategories(ctx context.Context, handler TranslationHandler, project Project, directoryId int, crowdinTranslations []Translation) error {
	return c.syncCollection(ctx, handler, project, directoryId, "faqcategories", func(ctx context.Context, language string) ([]SimpleTranslation, error) {
		if language == "no" {
			ts, err := c.q.ListFAQCategoryOriginalTranslations(ctx)
			if err != nil {
				return nil, err
			}
			return mapToSimple(ts), nil
		}
		return dbToSimple(ctx, language, c.q.ListFAQCategoryTranslations)
	}, crowdinTranslations, nil)
}

func (c *Client) syncGames(ctx context.Context, handler TranslationHandler, project Project, directoryId int, crowdinTranslations []Translation) error {
	return c.syncCollection(ctx, handler, project, directoryId, "games", func(ctx context.Context, language string) ([]SimpleTranslation, error) {
		if language == "no" {
			ts, err := c.q.ListGameOriginalTranslations(ctx)
			if err != nil {
				return nil, err
			}
			return mapToSimple(ts), nil
		}
		return dbToSimple(ctx, language, c.q.ListGameTranslations)
	}, crowdinTranslations, nil)
}

type dbT interface {
	GetKey() string
	GetParentKey() string
	GetLanguage() string
	GetValues() map[string]string
}

func mapToSimple[T any](items []T) []SimpleTranslation {
	return lo.Map(items, func(i T, _ int) SimpleTranslation {
		var v dbT
		switch t := any(i).(type) {
		case sqlc.ListEpisodeTranslationsRow:
			v = sqlc.Int32TranslationRow(t)
		case sqlc.ListSeasonTranslationsRow:
			v = sqlc.Int32TranslationRow(t)
		case sqlc.ListShowTranslationsRow:
			v = sqlc.Int32TranslationRow(t)
		case sqlc.ListSectionTranslationsRow:
			v = sqlc.Int32TranslationRow(t)
		case sqlc.ListPageTranslationsRow:
			v = sqlc.Int32TranslationRow(t)
		case sqlc.ListAchievementTranslationsRow:
			v = sqlc.UuidTranslationRow(t)
		case sqlc.ListAchievementGroupTranslationsRow:
			v = sqlc.UuidTranslationRow(t)
		case sqlc.ListSurveyTranslationsRow:
			v = sqlc.UuidTranslationRow(t)
		case sqlc.ListSurveyQuestionTranslationsRow:
			v = sqlc.UuidTranslationRow(t)
		case sqlc.ListAlternativeTranslationsRow:
			v = sqlc.UuidTranslationRow(t)
		case sqlc.ListStudyTopicTranslationsRow:
			v = sqlc.UuidTranslationRow(t)
		case sqlc.ListLessonTranslationsRow:
			v = sqlc.UuidTranslationRow(t)
		case sqlc.ListTaskTranslationsRow:
			v = sqlc.UuidTranslationRow(t)
		case sqlc.ListFAQTranslationsRow:
			v = sqlc.UuidTranslationRow(t)
		case sqlc.ListFAQCategoryTranslationsRow:
			v = sqlc.UuidTranslationRow(t)
		case sqlc.ListGameTranslationsRow:
			v = sqlc.UuidTranslationRow(t)
		case sqlc.ListLinkTranslationsRow:
			v = sqlc.Int32TranslationRow(t)
		case sqlc.ListStudyTopicOriginalTranslationsRow:
			v = sqlc.OriginalTranslationRow(t)
		case sqlc.ListLessonOriginalTranslationsRow:
			v = sqlc.OriginalTranslationRow(t)
		case sqlc.ListTaskOriginalTranslationsRow:
			v = sqlc.OriginalTranslationRow(t)
		case sqlc.ListSurveyOriginalTranslationsRow:
			v = sqlc.OriginalTranslationRow(t)
		case sqlc.ListSurveyQuestionOriginalTranslationsRow:
			v = sqlc.OriginalTranslationRow(t)
		case sqlc.ListQuestionAlternativesOriginalTranslationsRow:
			v = sqlc.OriginalTranslationRow(t)
		case sqlc.ListGameOriginalTranslationsRow:
			v = sqlc.OriginalTranslationRow(t)
		case sqlc.ListAchievementOriginalTranslationsRow:
			v = sqlc.OriginalTranslationRow(t)
		case sqlc.ListAchievementGroupOriginalTranslationsRow:
			v = sqlc.OriginalTranslationRow(t)
		case sqlc.ListFAQOriginalTranslationsRow:
			v = sqlc.OriginalTranslationRow(t)
		case sqlc.ListFAQCategoryOriginalTranslationsRow:
			v = sqlc.OriginalTranslationRow(t)
		}

		return SimpleTranslation{
			ID:       v.GetKey(),
			Values:   v.GetValues(),
			Language: v.GetLanguage(),
			ParentID: v.GetParentKey(),
		}
	})
}

func dbToSimple[T any](ctx context.Context, language string, factory func(context.Context, []string) ([]T, error)) ([]SimpleTranslation, error) {
	ts, err := factory(ctx, []string{language})
	if err != nil {
		return nil, err
	}
	return mapToSimple(ts), nil
}
