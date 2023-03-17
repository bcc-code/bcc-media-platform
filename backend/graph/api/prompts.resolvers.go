package graph

// This file will be automatically regenerated based on the schema, any resolver implementations
// will be copied through when generating and any unknown code will be moved to the end.

import (
	"context"

	"github.com/bcc-code/brunstadtv/backend/graph/api/generated"
	"github.com/bcc-code/brunstadtv/backend/graph/api/model"
	"github.com/bcc-code/brunstadtv/backend/utils"
)

// Survey is the resolver for the survey field.
func (r *surveyPromptResolver) Survey(ctx context.Context, obj *model.SurveyPrompt) (*model.Survey, error) {
	s, err := r.Loaders.SurveyLoader.Get(ctx, utils.AsUuid(obj.Survey.ID))
	if err != nil {
		return nil, err
	}
	return model.SurveyFrom(ctx, s), nil
}

// SurveyPrompt returns generated.SurveyPromptResolver implementation.
func (r *Resolver) SurveyPrompt() generated.SurveyPromptResolver { return &surveyPromptResolver{r} }

type surveyPromptResolver struct{ *Resolver }
