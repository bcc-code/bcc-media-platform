package sqlc

import (
	"context"
	"encoding/json"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/samber/lo"
)

func mapToCategories(items []getFAQCategoriesRow) []common.FAQCategory {
	return lo.Map(items, func(i getFAQCategoriesRow, _ int) common.FAQCategory {
		var title common.LocaleString

		_ = json.Unmarshal(i.Title.RawMessage, &title)

		return common.FAQCategory{
			ID:    int(i.ID),
			Title: title,
		}
	})
}

// GetFAQCategories retrieves specific categories
func (q *Queries) GetFAQCategories(ctx context.Context, ids []int) ([]common.FAQCategory, error) {
	items, err := q.getFAQCategories(ctx, intToInt32(ids))
	if err != nil {
		return nil, err
	}
	return mapToCategories(items), nil
}

// ListFAQCategories retrieves all categories
func (q *Queries) ListFAQCategories(ctx context.Context) ([]common.FAQCategory, error) {
	items, err := q.listFAQCategories(ctx)
	if err != nil {
		return nil, err
	}
	return mapToCategories(lo.Map(items, func(i listFAQCategoriesRow, _ int) getFAQCategoriesRow {
		return getFAQCategoriesRow(i)
	})), nil
}

func mapToQuestions(items []getQuestionsRow) []common.Question {
	return lo.Map(items, func(i getQuestionsRow, _ int) common.Question {
		var question common.LocaleString
		var answer common.LocaleString

		_ = json.Unmarshal(i.Question.RawMessage, &question)
		_ = json.Unmarshal(i.Answer.RawMessage, &answer)

		return common.Question{
			ID:         int(i.ID),
			CategoryID: int(i.Category),
			Question:   question,
			Answer:     answer,
		}
	})
}

// GetQuestions retrieves specific questions by id
func (q *Queries) GetQuestions(ctx context.Context, ids []int) ([]common.Question, error) {
	items, err := q.getQuestions(ctx, intToInt32(ids))
	if err != nil {
		return nil, err
	}
	return mapToQuestions(items), nil
}

// GetQuestionsForCategories returns all questions
func (q *Queries) GetQuestionsForCategories(ctx context.Context, ids []int) ([]common.Question, error) {
	items, err := q.getQuestionsForCategories(ctx, intToInt32(ids))
	if err != nil {
		return nil, err
	}
	return mapToQuestions(lo.Map(items, func(i getQuestionsForCategoriesRow, _ int) getQuestionsRow {
		return getQuestionsRow(i)
	})), nil
}

// ListQuestions returns all questions
func (q *Queries) ListQuestions(ctx context.Context) ([]common.Question, error) {
	items, err := q.listQuestions(ctx)
	if err != nil {
		return nil, err
	}
	return mapToQuestions(lo.Map(items, func(i listQuestionsRow, _ int) getQuestionsRow {
		return getQuestionsRow(i)
	})), nil
}
