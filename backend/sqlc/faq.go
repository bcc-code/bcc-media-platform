package sqlc

import (
	"context"
	"encoding/json"
	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/loaders"
	"github.com/google/uuid"
	"github.com/samber/lo"
	"gopkg.in/guregu/null.v4"
)

func mapToCategories(items []getFAQCategoriesRow) []common.FAQCategory {
	return lo.Map(items, func(i getFAQCategoriesRow, _ int) common.FAQCategory {
		var title = common.LocaleString{}
		var description = common.LocaleString{}

		_ = json.Unmarshal(i.Title.RawMessage, &title)
		_ = json.Unmarshal(i.Description.RawMessage, &description)
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
		var question = common.LocaleString{}
		var answer = common.LocaleString{}

		_ = json.Unmarshal(i.Question.RawMessage, &question)
		_ = json.Unmarshal(i.Answer.RawMessage, &answer)
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

// GetKey returns the id for this row
func (row getQuestionIDsForCategoriesWithRolesRow) GetKey() uuid.UUID {
	return row.ID
}

// GetRelationID returns the relation id for this row
func (row getQuestionIDsForCategoriesWithRolesRow) GetRelationID() uuid.UUID {
	return row.CategoryID
}

// GetQuestionIDsForCategories returns a list of episodes specified by seasons
func (rq *RoleQueries) GetQuestionIDsForCategories(ctx context.Context, ids []uuid.UUID) ([]loaders.Relation[uuid.UUID, uuid.UUID], error) {
	rows, err := rq.queries.getQuestionIDsForCategoriesWithRoles(ctx, getQuestionIDsForCategoriesWithRolesParams{
		Roles:       rq.roles,
		CategoryIds: ids,
	})
	if err != nil {
		return nil, err
	}
	return lo.Map(rows, func(i getQuestionIDsForCategoriesWithRolesRow, _ int) loaders.Relation[uuid.UUID, uuid.UUID] {
		return i
	}), nil
}
