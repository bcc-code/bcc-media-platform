package graph

// This file will be automatically regenerated based on the schema, any resolver implementations
// will be copied through when generating and any unknown code will be moved to the end.

import (
	"context"
	"fmt"

	"github.com/bcc-code/brunstadtv/backend/graph/api/generated"
	"github.com/bcc-code/brunstadtv/backend/graph/api/model"
)

// Tasks is the resolver for the tasks field.
func (r *studyResolver) Tasks(ctx context.Context, obj *model.Study) ([]model.Task, error) {
	panic(fmt.Errorf("not implemented: Tasks - tasks"))
}

// Study returns generated.StudyResolver implementation.
func (r *Resolver) Study() generated.StudyResolver { return &studyResolver{r} }

type studyResolver struct{ *Resolver }
