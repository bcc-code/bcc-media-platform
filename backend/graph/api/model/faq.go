package model

import (
	"context"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/user"
	"github.com/bcc-code/brunstadtv/backend/utils"
)

// FAQCategoryFrom returns a gql category from category
func FAQCategoryFrom(ctx context.Context, i *common.FAQCategory) *FAQCategory {
	ginCtx, _ := utils.GinCtx(ctx)
	languages := user.GetLanguagesFromCtx(ginCtx)

	return &FAQCategory{
		ID:    i.ID.String(),
		Title: i.Title.Get(languages),
	}
}

// QuestionFrom returns a gql question from question
func QuestionFrom(ctx context.Context, i *common.Question) *Question {
	ginCtx, _ := utils.GinCtx(ctx)
	languages := user.GetLanguagesFromCtx(ginCtx)

	return &Question{
		ID: i.ID.String(),
		Category: &FAQCategory{
			ID: i.CategoryID.String(),
		},
		Question: i.Question.Get(languages),
		Answer:   i.Answer.Get(languages),
	}
}
