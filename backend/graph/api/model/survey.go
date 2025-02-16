package model

import (
	"context"

	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/user"
	"github.com/bcc-code/bcc-media-platform/backend/utils"
)

// SurveyQuestionFrom returns a gql question from a question
func SurveyQuestionFrom(ctx context.Context, i *common.SurveyQuestion) SurveyQuestion {
	ginCtx, _ := utils.GinCtx(ctx)
	languages := user.GetLanguagesFromCtx(ginCtx)

	id := i.ID.String()
	title := i.Title.Get(languages)
	description := i.Description.GetValueOrNil(languages)

	switch i.Type {
	case "rating":
		return SurveyRatingQuestion{
			ID:          id,
			Title:       title,
			Description: description,
		}

	case "link":
		// This is actually enforced in the admin,
		// but just in case so we can prevent from ever serving a completely empty URL
		url := "https://app.bcc.media/"
		if i.URL.Valid {
			url = i.URL.String
		}

		return SurveyLinkQuestion{
			ID:               id,
			Title:            title,
			Description:      description,
			ActionButtonText: i.ActionButtonText.Get(languages),
			CancelButtonText: i.CancelButtonText.GetValueOrNil(languages),
			URL:              url,
		}
	default:
		return SurveyTextQuestion{
			ID:          id,
			Title:       title,
			Description: description,
		}
	}
}

// SurveyFrom returns a gql survey from a survey
func SurveyFrom(ctx context.Context, i *common.Survey) *Survey {
	ginCtx, _ := utils.GinCtx(ctx)
	languages := user.GetLanguagesFromCtx(ginCtx)
	return &Survey{
		ID:          i.ID.String(),
		Title:       i.Title.Get(languages),
		Description: i.Description.GetValueOrNil(languages),
	}
}
