package model

import (
	"context"
	"time"

	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/user"
	"github.com/bcc-code/bcc-media-platform/backend/utils"
)

func PromptFrom(ctx context.Context, i *common.Prompt) Prompt {
	ginCtx, _ := utils.GinCtx(ctx)
	languages := user.GetLanguagesFromCtx(ginCtx)

	title := i.Title.Get(languages)
	//secondaryTitle := i.SecondaryTitle.GetValueOrNil(languages)
	from := i.From.Format(time.RFC3339)
	to := i.To.Format(time.RFC3339)

	switch i.Type {
	case "survey":
		return &SurveyPrompt{
			ID:             i.ID.String(),
			Title:          title,
			SecondaryTitle: i.SecondaryTitle.GetValueOrNil(languages),
			From:           from,
			To:             to,
			Survey: &Survey{
				ID: i.SurveyID.UUID.String(),
			},
		}
	}

	return &SurveyPrompt{
		ID:             i.ID.String(),
		Title:          title,
		SecondaryTitle: i.SecondaryTitle.GetValueOrNil(languages),
		From:           from,
		To:             to,
		Survey: &Survey{
			ID: i.SurveyID.UUID.String(),
		},
	}
}
