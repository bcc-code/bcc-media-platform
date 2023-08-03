package server

import (
	"context"
	"database/sql"
	"github.com/bcc-code/brunstadtv/backend/utils"
	"gopkg.in/guregu/null.v4"

	"github.com/aws/aws-sdk-go-v2/service/mediapackagevod"
	"github.com/aws/aws-sdk-go-v2/service/s3"
	"github.com/bcc-code/brunstadtv/backend/crowdin"
	"github.com/bcc-code/brunstadtv/backend/directus"
	"github.com/bcc-code/brunstadtv/backend/remotecache"
	"github.com/bcc-code/brunstadtv/backend/scheduler"
	"github.com/bcc-code/brunstadtv/backend/search"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/bcc-code/brunstadtv/backend/statistics"
	"github.com/go-resty/resty/v2"
)

// ExternalServices used by the Server
type ExternalServices struct {
	S3Client             *s3.Client
	MediaPackageVOD      *mediapackagevod.Client
	DirectusClient       *resty.Client
	SearchService        *search.Service
	DirectusEventHandler *directus.EventHandler
	Database             *sql.DB
	RemoteCache          *remotecache.Client
	Queries              *sqlc.Queries
	CrowdinClient        *crowdin.Client
	Scheduler            *scheduler.Service
	StatisticsHandler    *statistics.Handler
}

// GetTranslationHandler returns the translation handler
func (e ExternalServices) GetTranslationHandler() crowdin.TranslationHandler {
	return &translationHandler{
		e.GetQueries(),
	}
}

type translationHandler struct {
	db *sqlc.Queries
}

// SaveTranslations saves translations
func (h *translationHandler) SaveTranslations(ctx context.Context, collection string, translations []crowdin.SimpleTranslation) error {
	for _, t := range translations {
		title, _ := t.Values["title"]
		description, _ := t.Values["description"]
		var err error
		switch collection {
		case "episodes":
			err = h.db.UpdateEpisodeTranslation(ctx, sqlc.UpdateEpisodeTranslationParams{
				ItemID:      int32(utils.AsInt(t.ParentID)),
				Language:    t.Language,
				Title:       null.StringFrom(title),
				Description: null.StringFrom(description),
			})
		case "seasons":
			err = h.db.UpdateSeasonTranslation(ctx, sqlc.UpdateSeasonTranslationParams{
				ItemID:      int32(utils.AsInt(t.ParentID)),
				Language:    t.Language,
				Title:       null.StringFrom(title),
				Description: null.StringFrom(description),
			})
		case "shows":
			err = h.db.UpdateShowTranslation(ctx, sqlc.UpdateShowTranslationParams{
				ItemID:      int32(utils.AsInt(t.ParentID)),
				Language:    t.Language,
				Title:       null.StringFrom(title),
				Description: null.StringFrom(description),
			})
		case "sections":
			err = h.db.UpdateSectionTranslation(ctx, sqlc.UpdateSectionTranslationParams{
				ItemID:      int32(utils.AsInt(t.ParentID)),
				Language:    t.Language,
				Title:       null.StringFrom(title),
				Description: null.StringFrom(description),
			})
		case "pages":
			err = h.db.UpdatePageTranslation(ctx, sqlc.UpdatePageTranslationParams{
				ItemID:      int32(utils.AsInt(t.ParentID)),
				Language:    t.Language,
				Title:       null.StringFrom(title),
				Description: null.StringFrom(description),
			})
		case "links":
			err = h.db.UpdateLinkTranslation(ctx, sqlc.UpdateLinkTranslationParams{
				ItemID:      int32(utils.AsInt(t.ParentID)),
				Language:    t.Language,
				Title:       title,
				Description: description,
			})
		case "studytopics":
			err = h.db.UpdateStudyTopicTranslation(ctx, sqlc.UpdateStudyTopicTranslationParams{
				ItemID:      utils.AsUuid(t.ParentID),
				Language:    t.Language,
				Title:       null.StringFrom(title),
				Description: null.StringFrom(description),
			})
		case "lessons":
			err = h.db.UpdateLessonTranslation(ctx, sqlc.UpdateLessonTranslationParams{
				ItemID:      utils.AsUuid(t.ParentID),
				Language:    t.Language,
				Title:       null.StringFrom(title),
				Description: null.StringFrom(description),
			})
		case "tasks":
			err = h.db.UpdateTaskTranslation(ctx, sqlc.UpdateTaskTranslationParams{
				ItemID:      utils.AsUuid(t.ParentID),
				Language:    t.Language,
				Title:       null.StringFrom(title),
				Description: null.StringFrom(description),
			})
		case "questionalternatives":
			err = h.db.UpdateAlternativeTranslation(ctx, sqlc.UpdateAlternativeTranslationParams{
				ItemID:   utils.AsUuid(t.ParentID),
				Language: t.Language,
				Title:    null.StringFrom(title),
			})
		case "achievements":
			err = h.db.UpdateAchievementTranslation(ctx, sqlc.UpdateAchievementTranslationParams{
				ItemID:      utils.AsUuid(t.ParentID),
				Language:    t.Language,
				Title:       null.StringFrom(title),
				Description: null.StringFrom(description),
			})
		case "achievementgroups":
			err = h.db.UpdateAchievementGroupTranslation(ctx, sqlc.UpdateAchievementGroupTranslationParams{
				ItemID:      utils.AsUuid(t.ParentID),
				Language:    t.Language,
				Title:       null.StringFrom(title),
				Description: null.StringFrom(description),
			})
		case "surveys":
			err = h.db.UpdateSurveyTranslation(ctx, sqlc.UpdateSurveyTranslationParams{
				ItemID:      utils.AsUuid(t.ParentID),
				Language:    t.Language,
				Title:       null.StringFrom(title),
				Description: null.StringFrom(description),
			})
		case "surveyquestions":
			err = h.db.UpdateSurveyQuestionTranslation(ctx, sqlc.UpdateSurveyQuestionTranslationParams{
				ItemID:      utils.AsUuid(t.ParentID),
				Language:    t.Language,
				Title:       null.StringFrom(title),
				Description: null.StringFrom(description),
			})
		case "faqs":
			err = h.db.UpdateFAQTranslation(ctx, sqlc.UpdateFAQTranslationParams{
				ItemID:   utils.AsUuid(t.ParentID),
				Language: t.Language,
				Question: null.StringFrom(t.Values["question"]),
				Answer:   null.StringFrom(t.Values["answer"]),
			})
		case "faqcategories":
			err = h.db.UpdateFAQCategoryTranslation(ctx, sqlc.UpdateFAQCategoryTranslationParams{
				ItemID:      utils.AsUuid(t.ParentID),
				Language:    t.Language,
				Title:       null.StringFrom(title),
				Description: null.StringFrom(description),
			})
		case "games":
			err = h.db.UpdateGameTranslation(ctx, sqlc.UpdateGameTranslationParams{
				ItemID:      utils.AsUuid(t.ParentID),
				Language:    t.Language,
				Title:       null.StringFrom(title),
				Description: null.StringFrom(description),
			})
		}
		if err != nil {
			return err
		}
	}
	return nil
}

// DeleteTranslations deletes translations
func (h *translationHandler) DeleteTranslations(ctx context.Context, collection string, keys []string) error {
	return nil
}

// GetS3Client as stored in the struct
func (e ExternalServices) GetS3Client() *s3.Client {
	return e.S3Client
}

// GetMediaPackageVOD as stored in the struct
func (e ExternalServices) GetMediaPackageVOD() *mediapackagevod.Client {
	return e.MediaPackageVOD
}

// GetDirectusClient as stored in the struct
func (e ExternalServices) GetDirectusClient() *resty.Client {
	return e.DirectusClient
}

// GetSearchService as stored in the struct
func (e ExternalServices) GetSearchService() *search.Service {
	return e.SearchService
}

// GetDirectusEventHandler as stored in the struct
func (e ExternalServices) GetDirectusEventHandler() *directus.EventHandler {
	return e.DirectusEventHandler
}

// GetCrowdinClient as stored in the struct
func (e ExternalServices) GetCrowdinClient() *crowdin.Client {
	return e.CrowdinClient
}

// GetQueries as stored in the struct
func (e ExternalServices) GetQueries() *sqlc.Queries {
	return e.Queries
}

// GetScheduler as stored in the struct
func (e ExternalServices) GetScheduler() *scheduler.Service {
	return e.Scheduler
}

func (e ExternalServices) GetStatisticHandler() *statistics.Handler {
	return e.StatisticsHandler
}
