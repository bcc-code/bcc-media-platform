package crowdin

import (
	"context"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/bcc-code/brunstadtv/backend/utils"
	"github.com/google/uuid"
	"github.com/samber/lo"
)

func (c *Client) syncEpisodes(ctx context.Context, handler TranslationHandler, project Project, directoryId int, crowdinTranslations []Translation) error {
	return c.syncCollection(ctx, handler, project, directoryId, "episodes", c.episodesTranslationFactory, crowdinTranslations, nil, nil)
}

func (c *Client) episodesTranslationFactory(ctx context.Context, language string) ([]SimpleTranslation, error) {
	return dbToSimple(ctx, language, c.q.ListEpisodeTranslations)
}

func (c *Client) syncSeasons(ctx context.Context, handler TranslationHandler, project Project, directoryId int, crowdinTranslations []Translation) error {
	return c.syncCollection(ctx, handler, project, directoryId, "seasons", c.seasonsTranslationFactory, crowdinTranslations, nil, nil)
}

func (c *Client) seasonsTranslationFactory(ctx context.Context, language string) ([]SimpleTranslation, error) {
	return dbToSimple(ctx, language, c.q.ListSeasonTranslations)
}

func (c *Client) syncShows(ctx context.Context, handler TranslationHandler, project Project, directoryId int, crowdinTranslations []Translation) error {
	return c.syncCollection(ctx, handler, project, directoryId, "shows", c.showsTranslationFactory, crowdinTranslations, nil, nil)
}

func (c *Client) showsTranslationFactory(ctx context.Context, language string) ([]SimpleTranslation, error) {
	return dbToSimple(ctx, language, c.q.ListShowTranslations)
}

func (c *Client) syncSections(ctx context.Context, handler TranslationHandler, project Project, directoryId int, crowdinTranslations []Translation) error {
	return c.syncCollection(ctx, handler, project, directoryId, "sections", c.sectionsTranslationFactory, crowdinTranslations, nil, nil)
}

func (c *Client) sectionsTranslationFactory(ctx context.Context, language string) ([]SimpleTranslation, error) {
	return dbToSimple(ctx, language, c.q.ListSectionTranslations)
}

func (c *Client) syncPages(ctx context.Context, handler TranslationHandler, project Project, directoryId int, crowdinTranslations []Translation) error {
	return c.syncCollection(ctx, handler, project, directoryId, "pages", c.pagesTranslationFactory, crowdinTranslations, nil, nil)
}

func (c *Client) syncLinks(ctx context.Context, handler TranslationHandler, project Project, directoryId int, crowdinTranslations []Translation) error {
	return c.syncCollection(ctx, handler, project, directoryId, "links", c.linksTranslationFactory, crowdinTranslations, nil, nil)
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
			return lo.Map(ts, func(t sqlc.ListLessonOriginalTranslationsRow, _ int) SimpleTranslation {
				return SimpleTranslation{
					ID: t.ID.String(),
					Values: map[string]string{
						TitleField:       t.Title,
						DescriptionField: t.Description.ValueOrZero(),
					},
					Language: "no",
					ParentID: t.ID.String(),
				}
			}), nil
		}
		return dbToSimple(ctx, language, c.q.ListLessonTranslations)
	}, crowdinTranslations, nil, nil)
}

func (c *Client) syncTopics(ctx context.Context, handler TranslationHandler, project Project, directoryId int, crowdinTranslations []Translation) error {
	return c.syncCollection(ctx, handler, project, directoryId, "studytopics", func(ctx context.Context, language string) ([]SimpleTranslation, error) {
		if language == "no" {
			ts, err := c.q.ListStudyTopicOriginalTranslations(ctx)
			if err != nil {
				return nil, err
			}
			return lo.Map(ts, func(t sqlc.ListStudyTopicOriginalTranslationsRow, _ int) SimpleTranslation {
				return SimpleTranslation{
					ID: t.ID.String(),
					Values: map[string]string{
						TitleField:       t.Title,
						DescriptionField: t.Description.ValueOrZero(),
					},
					Language: "no",
					ParentID: t.ID.String(),
				}
			}), nil
		}
		return dbToSimple(ctx, language, c.q.ListStudyTopicTranslations)
	}, crowdinTranslations, nil, nil)
}

func (c *Client) syncSurveys(ctx context.Context, handler TranslationHandler, project Project, directoryId int, crowdinTranslations []Translation) error {
	return c.syncCollection(ctx, handler, project, directoryId, "surveys", func(ctx context.Context, language string) ([]SimpleTranslation, error) {
		if language == "no" {
			ts, err := c.q.ListSurveyOriginalTranslations(ctx)
			if err != nil {
				return nil, err
			}
			return lo.Map(ts, func(t sqlc.ListSurveyOriginalTranslationsRow, _ int) SimpleTranslation {
				return SimpleTranslation{
					ID: t.ID.String(),
					Values: map[string]string{
						TitleField:       t.Title,
						DescriptionField: t.Description.ValueOrZero(),
					},
					Language: "no",
					ParentID: t.ID.String(),
				}
			}), nil
		}
		return dbToSimple(ctx, language, c.q.ListSurveyTranslations)
	}, crowdinTranslations, nil, nil)
}

func (c *Client) syncSurveyQuestions(ctx context.Context, handler TranslationHandler, project Project, directoryId int, crowdinTranslations []Translation) error {
	return c.syncCollection(ctx, handler, project, directoryId, "surveyquestions", func(ctx context.Context, language string) ([]SimpleTranslation, error) {
		if language == "no" {
			ts, err := c.q.ListSurveyQuestionOriginalTranslations(ctx)
			if err != nil {
				return nil, err
			}
			return lo.Map(ts, func(t sqlc.ListSurveyQuestionOriginalTranslationsRow, _ int) SimpleTranslation {
				return SimpleTranslation{
					ID: t.ID.String(),
					Values: map[string]string{
						TitleField:       t.Title,
						DescriptionField: t.Description.ValueOrZero(),
						PlaceholderField: t.Placeholder.ValueOrZero(),
					},
					Language: "no",
					ParentID: t.ID.String(),
				}
			}), nil
		}
		return dbToSimple(ctx, language, c.q.ListSurveyQuestionTranslations)
	}, crowdinTranslations, nil, nil)
}

func (c *Client) syncTasks(ctx context.Context, handler TranslationHandler, project Project, directoryId int, crowdinTranslations []Translation) error {
	return c.syncCollection(ctx, handler, project, directoryId, "tasks", func(ctx context.Context, language string) ([]SimpleTranslation, error) {
		if language == "no" {
			ts, err := c.q.ListTaskOriginalTranslations(ctx)
			if err != nil {
				return nil, err
			}
			return lo.Map(ts, func(t sqlc.ListTaskOriginalTranslationsRow, _ int) SimpleTranslation {
				return SimpleTranslation{
					ID: t.ID.String(),
					Values: map[string]string{
						TitleField:       t.Title.ValueOrZero(),
						DescriptionField: t.Description.ValueOrZero(),
					},
					Language: "no",
					ParentID: t.ID.String(),
				}
			}), nil
		}
		return dbToSimple(ctx, language, c.q.ListTaskTranslations)
	}, crowdinTranslations, nil, nil)
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
		m[i.ID.String()] = t.Title.String
		return m
	}, map[string]string{})

	return c.syncCollection(ctx, handler, project, directoryId, "questionalternatives", func(ctx context.Context, language string) ([]SimpleTranslation, error) {
		if language == "no" {
			return lo.Map(originalTs, func(t sqlc.ListQuestionAlternativesOriginalTranslationsRow, _ int) SimpleTranslation {
				return SimpleTranslation{
					ID: t.ID.String(),
					Values: map[string]string{
						TitleField: t.Title.ValueOrZero(),
					},
					Language: "no",
					ParentID: t.ID.String(),
				}
			}), nil
		}
		return dbToSimple(ctx, language, c.q.ListAlternativeTranslations)
	}, crowdinTranslations, func(id string) string {
		if t, ok := taskTitles[id]; ok {
			return "Question: " + t
		}
		return ""
	}, nil)
}

func (c *Client) syncAchievements(ctx context.Context, handler TranslationHandler, project Project, directoryId int, crowdinTranslations []Translation) error {
	return c.syncCollection(ctx, handler, project, directoryId, "achievements", func(ctx context.Context, language string) ([]SimpleTranslation, error) {
		if language == "no" {
			ts, err := c.q.ListAchievementOriginalTranslations(ctx)
			if err != nil {
				return nil, err
			}
			return lo.Map(ts, func(t sqlc.ListAchievementOriginalTranslationsRow, _ int) SimpleTranslation {
				return SimpleTranslation{
					ID: t.ID.String(),
					Values: map[string]string{
						TitleField:       t.Title,
						DescriptionField: t.Description.ValueOrZero(),
					},
					Language: "no",
					ParentID: t.ID.String(),
				}
			}), nil
		}
		return dbToSimple(ctx, language, c.q.ListAchievementTranslations)
	}, crowdinTranslations, nil, func(ctx context.Context, keys []string) error {
		return c.q.ClearAchievementTranslations(ctx, utils.MapWith(keys, utils.AsUuid))
	})
}

func (c *Client) syncAchievementGroups(ctx context.Context, handler TranslationHandler, project Project, directoryId int, crowdinTranslations []Translation) error {
	return c.syncCollection(ctx, handler, project, directoryId, "achievementgroups", func(ctx context.Context, language string) ([]SimpleTranslation, error) {
		if language == "no" {
			ts, err := c.q.ListAchievementGroupOriginalTranslations(ctx)
			if err != nil {
				return nil, err
			}
			return lo.Map(ts, func(t sqlc.ListAchievementGroupOriginalTranslationsRow, _ int) SimpleTranslation {
				return SimpleTranslation{
					ID: t.ID.String(),
					Values: map[string]string{
						TitleField: t.Title.ValueOrZero(),
					},
					Language: "no",
					ParentID: t.ID.String(),
				}
			}), nil
		}
		return dbToSimple(ctx, language, c.q.ListAchievementGroupTranslations)
	}, crowdinTranslations, nil, func(ctx context.Context, keys []string) error {
		return c.q.ClearAchievementGroupTranslations(ctx, utils.MapWith(keys, utils.AsUuid))
	})
}

func (c *Client) syncFAQs(ctx context.Context, handler TranslationHandler, project Project, directoryId int, crowdinTranslations []Translation) error {
	return c.syncCollection(ctx, handler, project, directoryId, "faqs", func(ctx context.Context, language string) ([]SimpleTranslation, error) {
		if language == "no" {
			ts, err := c.q.ListFAQOriginalTranslations(ctx)
			if err != nil {
				return nil, err
			}
			return lo.Map(ts, func(t sqlc.ListFAQOriginalTranslationsRow, _ int) SimpleTranslation {
				return SimpleTranslation{
					ID: t.ID.String(),
					Values: map[string]string{
						"question": t.Question,
						"answer":   t.Answer,
					},
					Language: "no",
					ParentID: t.ID.String(),
				}
			}), nil
		}
		return dbToSimple(ctx, language, c.q.ListFAQTranslations)
	}, crowdinTranslations, nil, func(ctx context.Context, keys []string) error {
		return c.q.ClearFAQTranslations(ctx, utils.MapWith(keys, utils.AsUuid))
	})
}

func (c *Client) syncFAQCategories(ctx context.Context, handler TranslationHandler, project Project, directoryId int, crowdinTranslations []Translation) error {
	return c.syncCollection(ctx, handler, project, directoryId, "faqcategories", func(ctx context.Context, language string) ([]SimpleTranslation, error) {
		if language == "no" {
			ts, err := c.q.ListFAQCategoryOriginalTranslations(ctx)
			if err != nil {
				return nil, err
			}
			return lo.Map(ts, func(t sqlc.ListFAQCategoryOriginalTranslationsRow, _ int) SimpleTranslation {
				return SimpleTranslation{
					ID: t.ID.String(),
					Values: map[string]string{
						"title":       t.Title,
						"description": t.Description.String,
					},
					Language: "no",
					ParentID: t.ID.String(),
				}
			}), nil
		}
		return dbToSimple(ctx, language, c.q.ListFAQCategoryTranslations)
	}, crowdinTranslations, nil, func(ctx context.Context, keys []string) error {
		return c.q.ClearFAQCategoryTranslations(ctx, utils.MapWith(keys, utils.AsUuid))
	})
}

func (c *Client) syncGames(ctx context.Context, handler TranslationHandler, project Project, directoryId int, crowdinTranslations []Translation) error {
	return c.syncCollection(ctx, handler, project, directoryId, "games", func(ctx context.Context, language string) ([]SimpleTranslation, error) {
		if language == "no" {
			ts, err := c.q.ListGameOriginalTranslations(ctx)
			if err != nil {
				return nil, err
			}
			return lo.Map(ts, func(t sqlc.ListGameOriginalTranslationsRow, _ int) SimpleTranslation {
				return SimpleTranslation{
					ID: t.ID.String(),
					Values: map[string]string{
						"title":       t.Title,
						"description": t.Description.String,
					},
					Language: "no",
					ParentID: t.ID.String(),
				}
			}), nil
		}
		return dbToSimple(ctx, language, c.q.ListGameTranslations)
	}, crowdinTranslations, nil, func(ctx context.Context, keys []string) error {
		return c.q.ClearGameTranslations(ctx, utils.MapWith(keys, utils.AsUuid))
	})
}

type dbT interface {
	GetKey() string
	GetParentKey() string
	GetLanguage() string
	GetValues() map[string]string
}

func dbToSimple[T dbT](ctx context.Context, language string, factory func(context.Context, []string) ([]T, error)) ([]SimpleTranslation, error) {
	ts, err := factory(ctx, []string{language})
	if err != nil {
		return nil, err
	}
	return lo.Map(ts, func(t T, _ int) SimpleTranslation {
		return SimpleTranslation{
			ID:       t.GetKey(),
			Values:   t.GetValues(),
			Language: t.GetLanguage(),
			ParentID: t.GetParentKey(),
		}
	}), nil
}
