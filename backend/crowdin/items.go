package crowdin

import (
	"context"
	"github.com/bcc-code/brunstadtv/backend/directus"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/bcc-code/brunstadtv/backend/utils"
	"github.com/google/uuid"
	"github.com/samber/lo"
)

func (c *Client) syncEpisodes(ctx context.Context, d *directus.Handler, project Project, directoryId int, crowdinTranslations []Translation) error {
	return c.syncCollection(ctx, d, project, directoryId, "episodes", c.episodesTranslationFactory, crowdinTranslations, nil, episodesToDSItems, nil)
}

func (c *Client) episodesTranslationFactory(ctx context.Context, language string) ([]simpleTranslation, error) {
	return dbToSimple(ctx, language, c.q.ListEpisodeTranslations)
}

func episodesToDSItems(translations []simpleTranslation) []directus.DSItem {
	return lo.Map(translations, func(t simpleTranslation, _ int) directus.DSItem {
		ti, _ := t.Values[TitleField]
		de, _ := t.Values[DescriptionField]
		return directus.EpisodesTranslation{
			Translation: directus.Translation{
				ID:            utils.AsInt(t.ID),
				LanguagesCode: t.Language,
				Title:         ti,
				Description:   de,
			},
			EpisodesID: utils.AsInt(t.ParentID),
		}
	})
}

func (c *Client) syncSeasons(ctx context.Context, d *directus.Handler, project Project, directoryId int, crowdinTranslations []Translation) error {
	return c.syncCollection(ctx, d, project, directoryId, "seasons", c.seasonsTranslationFactory, crowdinTranslations, nil, seasonsToDSItems, nil)
}

func (c *Client) seasonsTranslationFactory(ctx context.Context, language string) ([]simpleTranslation, error) {
	return dbToSimple(ctx, language, c.q.ListSeasonTranslations)
}

func seasonsToDSItems(translations []simpleTranslation) []directus.DSItem {
	return lo.Map(translations, func(t simpleTranslation, _ int) directus.DSItem {
		ti, _ := t.Values[TitleField]
		de, _ := t.Values[DescriptionField]
		return directus.SeasonsTranslation{
			Translation: directus.Translation{
				ID:            utils.AsInt(t.ID),
				LanguagesCode: t.Language,
				Title:         ti,
				Description:   de,
			},
			SeasonsID: utils.AsInt(t.ParentID),
		}
	})
}

func (c *Client) syncShows(ctx context.Context, d *directus.Handler, project Project, directoryId int, crowdinTranslations []Translation) error {
	return c.syncCollection(ctx, d, project, directoryId, "shows", c.showsTranslationFactory, crowdinTranslations, nil, showsToDSItems, nil)
}

func (c *Client) showsTranslationFactory(ctx context.Context, language string) ([]simpleTranslation, error) {
	return dbToSimple(ctx, language, c.q.ListShowTranslations)
}

func showsToDSItems(translations []simpleTranslation) []directus.DSItem {
	return lo.Map(translations, func(t simpleTranslation, _ int) directus.DSItem {
		ti, _ := t.Values[TitleField]
		de, _ := t.Values[DescriptionField]
		return directus.ShowsTranslation{
			Translation: directus.Translation{
				ID:            utils.AsInt(t.ID),
				LanguagesCode: t.Language,
				Title:         ti,
				Description:   de,
			},
			ShowsID: utils.AsInt(t.ParentID),
		}
	})
}

func (c *Client) syncSections(ctx context.Context, d *directus.Handler, project Project, directoryId int, crowdinTranslations []Translation) error {
	return c.syncCollection(ctx, d, project, directoryId, "sections", c.sectionsTranslationFactory, crowdinTranslations, nil, sectionsToDSItems, nil)
}

func (c *Client) sectionsTranslationFactory(ctx context.Context, language string) ([]simpleTranslation, error) {
	return dbToSimple(ctx, language, c.q.ListSectionTranslations)
}

func sectionsToDSItems(translations []simpleTranslation) []directus.DSItem {
	return lo.Map(translations, func(t simpleTranslation, _ int) directus.DSItem {
		ti, _ := t.Values[TitleField]
		de, _ := t.Values[DescriptionField]
		return directus.SectionsTranslation{
			Translation: directus.Translation{
				ID:            utils.AsInt(t.ID),
				LanguagesCode: t.Language,
				Title:         ti,
				Description:   de,
			},
			SectionsID: utils.AsInt(t.ParentID),
		}
	})
}

func (c *Client) syncPages(ctx context.Context, d *directus.Handler, project Project, directoryId int, crowdinTranslations []Translation) error {
	return c.syncCollection(ctx, d, project, directoryId, "pages", c.pagesTranslationFactory, crowdinTranslations, nil, pagesToDSItems, nil)
}

func (c *Client) syncLinks(ctx context.Context, d *directus.Handler, project Project, directoryId int, crowdinTranslations []Translation) error {
	return c.syncCollection(ctx, d, project, directoryId, "links", c.linksTranslationFactory, crowdinTranslations, nil, linksToDSItems, nil)
}

func (c *Client) pagesTranslationFactory(ctx context.Context, language string) ([]simpleTranslation, error) {
	return dbToSimple(ctx, language, c.q.ListPageTranslations)
}

func pagesToDSItems(translations []simpleTranslation) []directus.DSItem {
	return lo.Map(translations, func(t simpleTranslation, _ int) directus.DSItem {
		ti, _ := t.Values[TitleField]
		de, _ := t.Values[DescriptionField]
		return directus.PagesTranslation{
			Translation: directus.Translation{
				ID:            utils.AsInt(t.ID),
				LanguagesCode: t.Language,
				Title:         ti,
				Description:   de,
			},
			PagesID: utils.AsInt(t.ParentID),
		}
	})
}

func (c *Client) linksTranslationFactory(ctx context.Context, language string) ([]simpleTranslation, error) {
	return dbToSimple(ctx, language, c.q.ListLinkTranslations)
}

func linksToDSItems(translations []simpleTranslation) []directus.DSItem {
	return lo.Map(translations, func(t simpleTranslation, _ int) directus.DSItem {
		ti, _ := t.Values[TitleField]
		de, _ := t.Values[DescriptionField]
		return directus.LinksTranslation{
			Translation: directus.Translation{
				ID:            utils.AsInt(t.ID),
				LanguagesCode: t.Language,
				Title:         ti,
				Description:   de,
			},
			LinksID: utils.AsInt(t.ParentID),
		}
	})
}

func (c *Client) syncLessons(ctx context.Context, d *directus.Handler, project Project, directoryId int, crowdinTranslations []Translation) error {
	return c.syncCollection(ctx, d, project, directoryId, "lessons", func(ctx context.Context, language string) ([]simpleTranslation, error) {
		if language == "no" {
			ts, err := c.q.ListLessonOriginalTranslations(ctx)
			if err != nil {
				return nil, err
			}
			return lo.Map(ts, func(t sqlc.ListLessonOriginalTranslationsRow, _ int) simpleTranslation {
				return simpleTranslation{
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
	}, crowdinTranslations, nil, lessonsToDSItems, nil)
}

func lessonsToDSItems(translations []simpleTranslation) []directus.DSItem {
	return lo.Map(translations, func(t simpleTranslation, _ int) directus.DSItem {
		ti, _ := t.Values[TitleField]
		de, _ := t.Values[DescriptionField]
		return directus.LessonsTranslation{
			ID:            t.ID,
			LanguagesCode: t.Language,
			Title:         ti,
			Description:   de,
			LessonsID:     t.ParentID,
		}
	})
}

func (c *Client) syncTopics(ctx context.Context, d *directus.Handler, project Project, directoryId int, crowdinTranslations []Translation) error {
	return c.syncCollection(ctx, d, project, directoryId, "studytopics", func(ctx context.Context, language string) ([]simpleTranslation, error) {
		if language == "no" {
			ts, err := c.q.ListStudyTopicOriginalTranslations(ctx)
			if err != nil {
				return nil, err
			}
			return lo.Map(ts, func(t sqlc.ListStudyTopicOriginalTranslationsRow, _ int) simpleTranslation {
				return simpleTranslation{
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
	}, crowdinTranslations, nil, topicsToDSItems, nil)
}

func topicsToDSItems(translations []simpleTranslation) []directus.DSItem {
	return lo.Map(translations, func(t simpleTranslation, _ int) directus.DSItem {
		ti, _ := t.Values[TitleField]
		de, _ := t.Values[DescriptionField]
		return directus.StudyTopicsTranslation{
			ID:            t.ID,
			LanguagesCode: t.Language,
			Title:         ti,
			Description:   de,
			StudyTopicsID: t.ParentID,
		}
	})
}

func (c *Client) syncTasks(ctx context.Context, d *directus.Handler, project Project, directoryId int, crowdinTranslations []Translation) error {
	return c.syncCollection(ctx, d, project, directoryId, "tasks", func(ctx context.Context, language string) ([]simpleTranslation, error) {
		if language == "no" {
			ts, err := c.q.ListTaskOriginalTranslations(ctx)
			if err != nil {
				return nil, err
			}
			return lo.Map(ts, func(t sqlc.ListTaskOriginalTranslationsRow, _ int) simpleTranslation {
				return simpleTranslation{
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
	}, crowdinTranslations, nil, tasksToDSItems, nil)
}

func tasksToDSItems(translations []simpleTranslation) []directus.DSItem {
	return lo.Map(translations, func(t simpleTranslation, _ int) directus.DSItem {
		ti, _ := t.Values[TitleField]
		de, _ := t.Values[DescriptionField]
		return directus.TasksTranslation{
			ID:            t.ID,
			LanguagesCode: t.Language,
			Title:         ti,
			Description:   de,
			TasksID:       t.ParentID,
		}
	})
}

func (c *Client) syncAlternatives(ctx context.Context, d *directus.Handler, project Project, directoryId int, crowdinTranslations []Translation) error {
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

	return c.syncCollection(ctx, d, project, directoryId, "questionalternatives", func(ctx context.Context, language string) ([]simpleTranslation, error) {
		if language == "no" {
			return lo.Map(originalTs, func(t sqlc.ListQuestionAlternativesOriginalTranslationsRow, _ int) simpleTranslation {
				return simpleTranslation{
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
	}, alternativesToDSItems, nil)
}

func alternativesToDSItems(translations []simpleTranslation) []directus.DSItem {
	return lo.Map(translations, func(t simpleTranslation, _ int) directus.DSItem {
		ti, _ := t.Values[TitleField]
		return directus.QuestionAlternativesTranslation{
			ID:                     t.ID,
			LanguagesCode:          t.Language,
			Title:                  ti,
			QuestionAlternativesID: t.ParentID,
		}
	})
}

func (c *Client) syncAchievements(ctx context.Context, d *directus.Handler, project Project, directoryId int, crowdinTranslations []Translation) error {
	return c.syncCollection(ctx, d, project, directoryId, "achievements", func(ctx context.Context, language string) ([]simpleTranslation, error) {
		if language == "no" {
			ts, err := c.q.ListAchievementOriginalTranslations(ctx)
			if err != nil {
				return nil, err
			}
			return lo.Map(ts, func(t sqlc.ListAchievementOriginalTranslationsRow, _ int) simpleTranslation {
				return simpleTranslation{
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
	}, crowdinTranslations, nil, achievementsToDSItems, func(ctx context.Context, keys []string) error {
		return c.q.ClearAchievementTranslations(ctx, utils.MapWith(keys, utils.AsUuid))
	})
}

func achievementsToDSItems(translations []simpleTranslation) []directus.DSItem {
	return lo.Map(translations, func(t simpleTranslation, _ int) directus.DSItem {
		ti, _ := t.Values[TitleField]
		de, _ := t.Values[DescriptionField]
		return directus.AchievementsTranslation{
			ID:             t.ID,
			LanguagesCode:  t.Language,
			Title:          ti,
			Description:    de,
			AchievementsID: t.ParentID,
		}
	})
}

func (c *Client) syncAchievementGroups(ctx context.Context, d *directus.Handler, project Project, directoryId int, crowdinTranslations []Translation) error {
	return c.syncCollection(ctx, d, project, directoryId, "achievementgroups", func(ctx context.Context, language string) ([]simpleTranslation, error) {
		if language == "no" {
			ts, err := c.q.ListAchievementGroupOriginalTranslations(ctx)
			if err != nil {
				return nil, err
			}
			return lo.Map(ts, func(t sqlc.ListAchievementGroupOriginalTranslationsRow, _ int) simpleTranslation {
				return simpleTranslation{
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
	}, crowdinTranslations, nil, achievementGroupsToDSItems, func(ctx context.Context, keys []string) error {
		return c.q.ClearAchievementGroupTranslations(ctx, utils.MapWith(keys, utils.AsUuid))
	})
}

func achievementGroupsToDSItems(translations []simpleTranslation) []directus.DSItem {
	return lo.Map(translations, func(t simpleTranslation, _ int) directus.DSItem {
		ti, _ := t.Values[TitleField]
		return directus.AchievementGroupsTranslation{
			ID:                  t.ID,
			LanguagesCode:       t.Language,
			Title:               ti,
			AchievementGroupsID: t.ParentID,
		}
	})
}

type dbT interface {
	GetKey() string
	GetParentKey() string
	GetLanguage() string
	GetValues() map[string]string
}

func dbToSimple[T dbT](ctx context.Context, language string, factory func(context.Context, []string) ([]T, error)) ([]simpleTranslation, error) {
	ts, err := factory(ctx, []string{language})
	if err != nil {
		return nil, err
	}
	return lo.Map(ts, func(t T, _ int) simpleTranslation {
		return simpleTranslation{
			ID:       t.GetKey(),
			Values:   t.GetValues(),
			Language: t.GetLanguage(),
			ParentID: t.GetParentKey(),
		}
	}), nil
}
