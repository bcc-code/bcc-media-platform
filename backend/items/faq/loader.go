package faq

import (
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/graph-gophers/dataloader/v7"
)

// NewCategoryLoader creates a new dataloader for FAQ categories
func NewCategoryLoader(queries sqlc.Queries) *dataloader.Loader[int, *common.FAQCategory] {
	return common.NewBatchLoader(queries.GetFAQCategories)
}

// NewQuestionLoader creates a new dataloader for FAQ questions
func NewQuestionLoader(queries sqlc.Queries) *dataloader.Loader[int, *common.Question] {
	return common.NewBatchLoader(queries.GetQuestions)
}

// NewQuestionsLoader creates a new dataloader for questions related to faq categories
func NewQuestionsLoader(queries sqlc.Queries) *dataloader.Loader[int, []*common.Question] {
	return common.NewListBatchLoader(queries.GetQuestionsForCategories, func(i common.Question) int {
		return i.CategoryID
	})
}
