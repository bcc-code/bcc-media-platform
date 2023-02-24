package sqlc

import (
	"context"
	"encoding/json"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/google/uuid"
	"github.com/samber/lo"
	"gopkg.in/guregu/null.v4"
)

func surveyToItem(questionRows []getSurveyQuestionsForSurveyIDsRow) func(getSurveysRow, int) common.Survey {
	return func(row getSurveysRow, _ int) common.Survey {
		var title common.LocaleString
		var description common.LocaleString
		_ = json.Unmarshal(row.Title.RawMessage, &title)
		_ = json.Unmarshal(row.Description.RawMessage, &description)
		title["no"] = null.StringFrom(row.OriginalTitle)
		description["no"] = row.OriginalDescription

		questions := lo.Filter(questionRows, func(i getSurveyQuestionsForSurveyIDsRow, _ int) bool {
			return i.SurveyID == row.ID
		})

		return common.Survey{
			ID:          row.ID,
			Title:       title,
			Description: description,
			From:        row.From,
			To:          row.To,
			Questions:   lo.Map(questions, surveyQuestionToItem),
		}
	}
}

func surveyQuestionToItem(row getSurveyQuestionsForSurveyIDsRow, _ int) common.SurveyQuestion {
	var title common.LocaleString
	var d common.LocaleString
	_ = json.Unmarshal(row.Title.RawMessage, &title)
	_ = json.Unmarshal(row.Description.RawMessage, &d)
	title["no"] = null.StringFrom(row.OriginalTitle)
	d["no"] = row.OriginalDescription

	return common.SurveyQuestion{
		ID:          row.ID,
		Title:       title,
		Description: d,
		Type:        row.Type,
	}
}

// GetSurveys returns surveys
func (q *Queries) GetSurveys(ctx context.Context, ids []uuid.UUID) ([]common.Survey, error) {
	rows, err := q.getSurveys(ctx, ids)
	if err != nil {
		return nil, err
	}
	questionRows, err := q.getSurveyQuestionsForSurveyIDs(ctx, ids)
	if err != nil {
		return nil, err
	}

	return lo.Map(rows, surveyToItem(questionRows)), nil
}
