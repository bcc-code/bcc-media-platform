package sqlc

import (
	"context"

	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/google/uuid"
	"github.com/samber/lo"
	"gopkg.in/guregu/null.v4"
)

func surveyToItem(row getSurveysRow, _ int) common.Survey {
	title := localeString(row.Title.RawMessage)
	description := localeString(row.Description.RawMessage)
	title["no"] = null.StringFrom(row.OriginalTitle)
	description["no"] = row.OriginalDescription

	return common.Survey{
		ID:          row.ID,
		Title:       title,
		Description: description,
	}
}

func surveyQuestionToItem(row getSurveyQuestionsRow, _ int) common.SurveyQuestion {
	title := localeString(row.Title.RawMessage)
	d := localeString(row.Description.RawMessage)
	actionButton := localeString(row.ActionButtonText.RawMessage)
	cancelButton := localeString(row.CancelButtonText.RawMessage)

	title["no"] = null.StringFrom(row.OriginalTitle)
	d["no"] = row.OriginalDescription
	actionButton["no"] = row.OriginalActionButtonText
	cancelButton["no"] = row.OriginalCancelButtonText

	return common.SurveyQuestion{
		ID:               row.ID,
		Title:            title,
		Description:      d,
		Type:             row.Type,
		ActionButtonText: actionButton,
		CancelButtonText: cancelButton,
		URL:              row.Url,
	}
}

// GetSurveys returns surveys
func (q *Queries) GetSurveys(ctx context.Context, ids []uuid.UUID) ([]common.Survey, error) {
	rows, err := q.getSurveys(ctx, ids)
	if err != nil {
		return nil, err
	}
	return lo.Map(rows, surveyToItem), nil
}

// GetSurveyQuestions returns survey questions
func (q *Queries) GetSurveyQuestions(ctx context.Context, ids []uuid.UUID) ([]common.SurveyQuestion, error) {
	rows, err := q.getSurveyQuestions(ctx, ids)
	if err != nil {
		return nil, err
	}
	return lo.Map(rows, surveyQuestionToItem), nil
}

// GetSurveyQuestionIDsForSurveyIDs returns relation structs for the questions
func (rq *RoleQueries) GetSurveyQuestionIDsForSurveyIDs(ctx context.Context, ids []uuid.UUID) ([]common.Mapping[uuid.UUID, uuid.UUID], error) {
	rows, err := rq.queries.getQuestionIDsForSurveyIDs(ctx, ids)
	if err != nil {
		return nil, err
	}
	return lo.Map(rows, func(i getQuestionIDsForSurveyIDsRow, _ int) common.Mapping[uuid.UUID, uuid.UUID] {
		return common.Mapping[uuid.UUID, uuid.UUID]{Key: i.ParentID, Value: i.ID}
	}), nil
}
