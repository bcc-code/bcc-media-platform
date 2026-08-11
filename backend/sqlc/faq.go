package sqlc

import (
	"context"
	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/google/uuid"
	"github.com/samber/lo"
	"gopkg.in/guregu/null.v4"
)

func mapToCategories(items []getFAQCategoriesRow) []common.FAQCategory {
	return lo.Map(items, func(i getFAQCategoriesRow, _ int) common.FAQCategory {
		title := localeString(i.Title.RawMessage)
		description := localeString(i.Description.RawMessage)
		title["no"] = null.StringFrom(i.OriginalTitle)
		description["no"] = i.OriginalDescription

		return common.FAQCategory{
			ID:    i.ID,
			Title: title,
		}
	})
}

// GetFAQCategories retrieves specific categories
func (q *Queries) GetFAQCategories(ctx context.Context, ids []uuid.UUID) ([]common.FAQCategory, error) {
	items, err := q.getFAQCategories(ctx, ids)
	if err != nil {
		return nil, err
	}
	return mapToCategories(items), nil
}

func mapToQuestions(items []getQuestionsRow) []common.Question {
	return lo.Map(items, func(i getQuestionsRow, _ int) common.Question {
		question := localeString(i.Question.RawMessage)
		answer := localeString(i.Answer.RawMessage)
		question["no"] = null.StringFrom(i.OriginalQuestion)
		answer["no"] = null.StringFrom(i.OriginalAnswer)

		return common.Question{
			ID:         i.ID,
			CategoryID: i.CategoryID,
			Question:   question,
			Answer:     answer,
		}
	})
}

// GetQuestions retrieves specific questions by id
func (q *Queries) GetQuestions(ctx context.Context, ids []uuid.UUID) ([]common.Question, error) {
	items, err := q.getQuestions(ctx, ids)
	if err != nil {
		return nil, err
	}
	return mapToQuestions(items), nil
}

// GetQuestionIDsForCategories returns a list of episodes specified by seasons
func (rq *RoleQueries) GetQuestionIDsForCategories(ctx context.Context, ids []uuid.UUID) ([]common.Mapping[uuid.UUID, uuid.UUID], error) {
	rows, err := rq.queries.getQuestionIDsForCategoriesWithRoles(ctx, getQuestionIDsForCategoriesWithRolesParams{
		Roles:       rq.roles,
		CategoryIds: ids,
	})
	if err != nil {
		return nil, err
	}
	return lo.Map(rows, func(i getQuestionIDsForCategoriesWithRolesRow, _ int) common.Mapping[uuid.UUID, uuid.UUID] {
		return common.Mapping[uuid.UUID, uuid.UUID]{Key: i.CategoryID, Value: i.ID}
	}), nil
}
