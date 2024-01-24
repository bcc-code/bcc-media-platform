package crowdin

import (
	"context"
	"encoding/json"

	"github.com/bcc-code/bcc-media-platform/backend/sqlc"
	"github.com/bcc-code/bcc-media-platform/backend/utils"
	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/google/uuid"
	"github.com/samber/lo"
	"gopkg.in/guregu/null.v4"
)

func rawMessageToMap(msg json.RawMessage) map[string]string {
	var r map[string]string
	_ = json.Unmarshal(msg, &r)
	if r == nil {
		r = map[string]string{}
	}
	return r
}

func (c *Client) syncEpisodes(ctx context.Context, options Options) error {
	return syncCollection(ctx, c, options, NewTranslationHandler(
		"episodes",
		c.q.ListEpisodeTranslations,
		func(t SimpleTranslation) sqlc.UpdateEpisodeTranslationParams {
			return sqlc.UpdateEpisodeTranslationParams{
				ItemID:      int32(utils.AsInt(t.ParentID)),
				Language:    t.Language,
				Title:       null.StringFrom(t.Values["title"]),
				Description: null.StringFrom(t.Values["description"]),
			}
		},
		c.q.UpdateEpisodeTranslation,
		nil,
	))
}

func (c *Client) syncSeasons(ctx context.Context, options Options) error {
	return syncCollection(ctx, c, options, NewTranslationHandler(
		"seasons",
		c.q.ListSeasonTranslations,
		func(t SimpleTranslation) sqlc.UpdateSeasonTranslationParams {
			return sqlc.UpdateSeasonTranslationParams{
				ItemID:      int32(utils.AsInt(t.ParentID)),
				Language:    t.Language,
				Title:       null.StringFrom(t.Values["title"]),
				Description: null.StringFrom(t.Values["description"]),
			}
		},
		c.q.UpdateSeasonTranslation,
		nil,
	))
}

func (c *Client) syncShows(ctx context.Context, options Options) error {
	return syncCollection(ctx, c, options, NewTranslationHandler(
		"shows",
		c.q.ListShowTranslations,
		func(t SimpleTranslation) sqlc.UpdateShowTranslationParams {
			return sqlc.UpdateShowTranslationParams{
				ItemID:      int32(utils.AsInt(t.ParentID)),
				Language:    t.Language,
				Title:       null.StringFrom(t.Values["title"]),
				Description: null.StringFrom(t.Values["description"]),
			}
		},
		c.q.UpdateShowTranslation,
		nil,
	))
}

func (c *Client) syncEvents(ctx context.Context, options Options) error {
	return syncCollection(ctx, c, options, NewTranslationHandler(
		"events",
		c.q.ListEventTranslations,
		func(t SimpleTranslation) sqlc.UpdateEventTranslationParams {
			return sqlc.UpdateEventTranslationParams{
				ItemID:      int32(utils.AsInt(t.ParentID)),
				Language:    t.Language,
				Title:       null.StringFrom(t.Values["title"]),
				Description: null.StringFrom(t.Values["description"]),
			}
		},
		c.q.UpdateEventTranslation,
		nil,
	))
}

func (c *Client) syncCalendarEntries(ctx context.Context, options Options) error {
	return syncCollection(ctx, c, options, NewTranslationHandler(
		"calendarentries",
		c.q.ListCalendarEntryTranslations,
		func(t SimpleTranslation) sqlc.UpdateCalendarEntryTranslationParams {
			return sqlc.UpdateCalendarEntryTranslationParams{
				ItemID:      int32(utils.AsInt(t.ParentID)),
				Language:    t.Language,
				Title:       null.StringFrom(t.Values["title"]),
				Description: null.StringFrom(t.Values["description"]),
			}
		},
		c.q.UpdateCalendarEntryTranslation,
		nil,
	))
}

func (c *Client) syncSections(ctx context.Context, options Options) error {
	return syncCollection(ctx, c, options, NewTranslationHandler(
		"sections",
		c.q.ListSectionTranslations,
		func(t SimpleTranslation) sqlc.UpdateSectionTranslationParams {
			return sqlc.UpdateSectionTranslationParams{
				ItemID:      int32(utils.AsInt(t.ParentID)),
				Language:    t.Language,
				Title:       null.StringFrom(t.Values["title"]),
				Description: null.StringFrom(t.Values["description"]),
			}
		},
		c.q.UpdateSectionTranslation,
		nil,
	))
}

func (c *Client) syncPages(ctx context.Context, options Options) error {
	return syncCollection(ctx, c, options, NewTranslationHandler(
		"pages",
		c.q.ListPageTranslations,
		func(t SimpleTranslation) sqlc.UpdatePageTranslationParams {
			return sqlc.UpdatePageTranslationParams{
				ItemID:      int32(utils.AsInt(t.ParentID)),
				Language:    t.Language,
				Title:       null.StringFrom(t.Values["title"]),
				Description: null.StringFrom(t.Values["description"]),
			}
		},
		c.q.UpdatePageTranslation,
		nil,
	))
}

func (c *Client) syncLinks(ctx context.Context, options Options) error {
	return syncCollection(ctx, c, options, NewTranslationHandler(
		"links",
		c.q.ListLinkTranslations,
		func(t SimpleTranslation) sqlc.UpdateLinkTranslationParams {
			return sqlc.UpdateLinkTranslationParams{
				ItemID:      int32(utils.AsInt(t.ParentID)),
				Language:    t.Language,
				Title:       t.Values["title"],
				Description: t.Values["description"],
			}
		},
		c.q.UpdateLinkTranslation,
		nil,
	))
}

func (c *Client) syncLessons(ctx context.Context, options Options) error {
	return syncCollection(ctx, c, options, NewTranslationHandler(
		"lessons",
		func(ctx context.Context, language string) ([]SimpleTranslation, error) {
			if language == "no" {
				ts, err := c.q.ListLessonOriginalTranslations(ctx)
				if err != nil {
					return nil, err
				}
				return mapToSimpleTranslations(ts), nil
			}
			return dbToSimple(ctx, language, c.q.ListLessonTranslations)
		},
		func(t SimpleTranslation) sqlc.UpdateLessonTranslationParams {
			return sqlc.UpdateLessonTranslationParams{
				ItemID:      utils.AsUuid(t.ParentID),
				Language:    t.Language,
				Title:       null.StringFrom(t.Values["title"]),
				Description: null.StringFrom(t.Values["description"]),
			}
		},
		c.q.UpdateLessonTranslation,
		nil,
	))
}

func (c *Client) syncTopics(ctx context.Context, options Options) error {
	return syncCollection(ctx, c, options, NewTranslationHandler(
		"topics",
		func(ctx context.Context, language string) ([]SimpleTranslation, error) {
			if language == "no" {
				ts, err := c.q.ListStudyTopicOriginalTranslations(ctx)
				if err != nil {
					return nil, err
				}
				return mapToSimpleTranslations(ts), nil
			}
			return dbToSimple(ctx, language, c.q.ListStudyTopicTranslations)
		},
		func(t SimpleTranslation) sqlc.UpdateStudyTopicTranslationParams {
			return sqlc.UpdateStudyTopicTranslationParams{
				ItemID:      utils.AsUuid(t.ParentID),
				Language:    t.Language,
				Title:       null.StringFrom(t.Values["title"]),
				Description: null.StringFrom(t.Values["description"]),
			}
		},
		c.q.UpdateStudyTopicTranslation,
		nil,
	))
}

func (c *Client) syncSurveys(ctx context.Context, options Options) error {
	return syncCollection(ctx, c, options, NewTranslationHandler(
		"surveys",
		func(ctx context.Context, language string) ([]SimpleTranslation, error) {
			if language == "no" {
				ts, err := c.q.ListSurveyOriginalTranslations(ctx)
				if err != nil {
					return nil, err
				}
				return mapToSimpleTranslations(ts), nil
			}
			return dbToSimple(ctx, language, c.q.ListSurveyTranslations)
		},
		func(t SimpleTranslation) sqlc.UpdateSurveyTranslationParams {
			return sqlc.UpdateSurveyTranslationParams{
				ItemID:      utils.AsUuid(t.ParentID),
				Language:    t.Language,
				Title:       null.StringFrom(t.Values["title"]),
				Description: null.StringFrom(t.Values["description"]),
			}
		},
		c.q.UpdateSurveyTranslation,
		nil,
	))
}

func (c *Client) syncSurveyQuestions(ctx context.Context, options Options) error {
	return syncCollection(ctx, c, options, NewTranslationHandler(
		"surveyquestions",
		func(ctx context.Context, language string) ([]SimpleTranslation, error) {
			if language == "no" {
				ts, err := c.q.ListSurveyQuestionOriginalTranslations(ctx)
				if err != nil {
					return nil, err
				}
				return mapToSimpleTranslations(ts), nil
			}
			return dbToSimple(ctx, language, c.q.ListSurveyQuestionTranslations)
		},
		func(t SimpleTranslation) sqlc.UpdateSurveyQuestionTranslationParams {
			return sqlc.UpdateSurveyQuestionTranslationParams{
				ItemID:      utils.AsUuid(t.ParentID),
				Language:    t.Language,
				Title:       null.StringFrom(t.Values["title"]),
				Description: null.StringFrom(t.Values["description"]),
			}
		},
		c.q.UpdateSurveyQuestionTranslation,
		nil,
	))
}

func (c *Client) syncTasks(ctx context.Context, options Options) error {
	return syncCollection(ctx, c, options, NewTranslationHandler(
		"tasks",
		func(ctx context.Context, language string) ([]SimpleTranslation, error) {
			if language == "no" {
				ts, err := c.q.ListTaskOriginalTranslations(ctx)
				if err != nil {
					return nil, err
				}
				return mapToSimpleTranslations(ts), nil
			}
			return dbToSimple(ctx, language, c.q.ListTaskTranslations)
		},
		func(t SimpleTranslation) sqlc.UpdateTaskTranslationParams {
			return sqlc.UpdateTaskTranslationParams{
				ItemID:      utils.AsUuid(t.ParentID),
				Language:    t.Language,
				Title:       null.StringFrom(t.Values["title"]),
				Description: null.StringFrom(t.Values["description"]),
			}
		},
		c.q.UpdateTaskTranslation,
		nil,
	))
}

func (c *Client) syncAlternatives(ctx context.Context, options Options) error {
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

	return syncCollection(ctx, c, options, NewTranslationHandler(
		"questionalternatives",
		func(ctx context.Context, language string) ([]SimpleTranslation, error) {
			if language == "no" {
				return mapToSimpleTranslations(originalTs), nil
			}
			return dbToSimple(ctx, language, c.q.ListAlternativeTranslations)
		},
		func(t SimpleTranslation) sqlc.UpdateAlternativeTranslationParams {
			return sqlc.UpdateAlternativeTranslationParams{
				ItemID:   utils.AsUuid(t.ParentID),
				Language: t.Language,
				Title:    null.StringFrom(t.Values["title"]),
			}
		},
		c.q.UpdateAlternativeTranslation,
		func(id string) string {
			if t, ok := taskTitles[id]; ok {
				return "Question: " + t
			}
			return ""
		},
	))
}

func (c *Client) syncAchievements(ctx context.Context, options Options) error {
	return syncCollection(ctx, c, options, NewTranslationHandler(
		"achievements",
		func(ctx context.Context, language string) ([]SimpleTranslation, error) {
			if language == "no" {
				ts, err := c.q.ListAchievementOriginalTranslations(ctx)
				if err != nil {
					return nil, err
				}
				return mapToSimpleTranslations(ts), nil
			}
			return dbToSimple(ctx, language, c.q.ListAchievementTranslations)
		},
		func(t SimpleTranslation) sqlc.UpdateAchievementTranslationParams {
			return sqlc.UpdateAchievementTranslationParams{
				ItemID:      utils.AsUuid(t.ParentID),
				Language:    t.Language,
				Title:       null.StringFrom(t.Values["title"]),
				Description: null.StringFrom(t.Values["description"]),
			}
		},
		c.q.UpdateAchievementTranslation,
		nil,
	))
}

func (c *Client) syncAchievementGroups(ctx context.Context, options Options) error {
	return syncCollection(ctx, c, options, NewTranslationHandler(
		"achievementgroups",
		func(ctx context.Context, language string) ([]SimpleTranslation, error) {
			if language == "no" {
				ts, err := c.q.ListAchievementGroupOriginalTranslations(ctx)
				if err != nil {
					return nil, err
				}
				return mapToSimpleTranslations(ts), nil
			}
			return dbToSimple(ctx, language, c.q.ListAchievementGroupTranslations)
		},
		func(t SimpleTranslation) sqlc.UpdateAchievementGroupTranslationParams {
			return sqlc.UpdateAchievementGroupTranslationParams{
				ItemID:      utils.AsUuid(t.ParentID),
				Language:    t.Language,
				Title:       null.StringFrom(t.Values["title"]),
				Description: null.StringFrom(t.Values["description"]),
			}
		},
		c.q.UpdateAchievementGroupTranslation,
		nil,
	))
}

func (c *Client) syncFAQs(ctx context.Context, options Options) error {
	return syncCollection(ctx, c, options, NewTranslationHandler(
		"faqs",
		func(ctx context.Context, language string) ([]SimpleTranslation, error) {
			if language == "no" {
				ts, err := c.q.ListFAQOriginalTranslations(ctx)
				if err != nil {
					return nil, err
				}
				return mapToSimpleTranslations(ts), nil
			}
			return dbToSimple(ctx, language, c.q.ListFAQTranslations)
		},
		func(t SimpleTranslation) sqlc.UpdateFAQTranslationParams {
			return sqlc.UpdateFAQTranslationParams{
				ItemID:   utils.AsUuid(t.ParentID),
				Language: t.Language,
				Question: null.StringFrom(t.Values["question"]),
				Answer:   null.StringFrom(t.Values["answer"]),
			}
		},
		c.q.UpdateFAQTranslation,
		nil,
	))
}

func (c *Client) syncFAQCategories(ctx context.Context, options Options) error {
	return syncCollection(ctx, c, options, NewTranslationHandler(
		"faqcategories",
		func(ctx context.Context, language string) ([]SimpleTranslation, error) {
			if language == "no" {
				ts, err := c.q.ListFAQCategoryOriginalTranslations(ctx)
				if err != nil {
					return nil, err
				}
				return mapToSimpleTranslations(ts), nil
			}
			return dbToSimple(ctx, language, c.q.ListFAQCategoryTranslations)
		},
		func(t SimpleTranslation) sqlc.UpdateFAQCategoryTranslationParams {
			return sqlc.UpdateFAQCategoryTranslationParams{
				ItemID:      utils.AsUuid(t.ParentID),
				Language:    t.Language,
				Title:       null.StringFrom(t.Values["title"]),
				Description: null.StringFrom(t.Values["description"]),
			}
		},
		c.q.UpdateFAQCategoryTranslation,
		nil,
	))
}

func (c *Client) syncGames(ctx context.Context, options Options) error {
	return syncCollection(ctx, c, options, NewTranslationHandler(
		"games",
		func(ctx context.Context, language string) ([]SimpleTranslation, error) {
			if language == "no" {
				ts, err := c.q.ListGameOriginalTranslations(ctx)
				if err != nil {
					return nil, err
				}
				return mapToSimpleTranslations(ts), nil
			}
			return dbToSimple(ctx, language, c.q.ListGameTranslations)
		},
		func(t SimpleTranslation) sqlc.UpdateGameTranslationParams {
			return sqlc.UpdateGameTranslationParams{
				ItemID:      utils.AsUuid(t.ParentID),
				Language:    t.Language,
				Title:       null.StringFrom(t.Values["title"]),
				Description: null.StringFrom(t.Values["description"]),
			}
		},
		c.q.UpdateGameTranslation,
		nil,
	))
}

func (c *Client) syncPlaylists(ctx context.Context, options Options) error {
	return syncCollection(ctx, c, options, NewTranslationHandler(
		"playlists",
		func(ctx context.Context, language string) ([]SimpleTranslation, error) {
			if language == "no" {
				ts, err := c.q.ListPlaylistOriginalTranslations(ctx)
				if err != nil {
					return nil, err
				}
				return mapToSimpleTranslations(ts), nil
			}
			return dbToSimple(ctx, language, c.q.ListPlaylistTranslations)
		},
		func(t SimpleTranslation) sqlc.UpdatePlaylistTranslationParams {
			return sqlc.UpdatePlaylistTranslationParams{
				ItemID:      utils.AsUuid(t.ParentID),
				Language:    t.Language,
				Title:       null.StringFrom(t.Values["title"]),
				Description: null.StringFrom(t.Values["description"]),
			}
		},
		c.q.UpdatePlaylistTranslation,
		nil,
	))
}

type dbT interface {
	GetKey() string
	GetParentKey() string
	GetLanguage() string
	GetValues() map[string]string
}

func toSimple[T any](i T) SimpleTranslation {
	var v dbT
	switch t := any(i).(type) {
	case sqlc.ListEpisodeTranslationsRow:
		v = sqlc.Int32TranslationRow(t)
	case sqlc.ListSeasonTranslationsRow:
		v = sqlc.Int32TranslationRow(t)
	case sqlc.ListShowTranslationsRow:
		v = sqlc.Int32TranslationRow(t)
	case sqlc.ListEventTranslationsRow:
		v = sqlc.Int32TranslationRow(t)
	case sqlc.ListCalendarEntryTranslationsRow:
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
	case sqlc.ListPlaylistTranslationsRow:
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
	case sqlc.ListPlaylistOriginalTranslationsRow:
		v = sqlc.OriginalTranslationRow(t)
	case SimpleTranslation:
		return t
	}

	if v == nil {
		log.L.Error().Type("type", i).Msg("Could not convert to simple translation")
	}

	return SimpleTranslation{
		ID:       v.GetKey(),
		Values:   v.GetValues(),
		Language: v.GetLanguage(),
		ParentID: v.GetParentKey(),
	}
}

func mapToSimpleTranslations[T any](items []T) []SimpleTranslation {
	return lo.Map(items, func(i T, _ int) SimpleTranslation {
		return toSimple(i)
	})
}

func dbToSimple[T any](ctx context.Context, language string, factory func(context.Context, string) ([]T, error)) ([]SimpleTranslation, error) {
	ts, err := factory(ctx, language)
	if err != nil {
		return nil, err
	}
	return mapToSimpleTranslations(ts), nil
}
