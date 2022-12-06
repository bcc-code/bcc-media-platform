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
func (r *lessonResolver) Tasks(ctx context.Context, obj *model.Lesson, first *int, offset *int) (*model.TaskPagination, error) {
	panic(fmt.Errorf("not implemented: Tasks - tasks"))
}

// Lessons is the resolver for the lessons field.
func (r *studyTopicResolver) Lessons(ctx context.Context, obj *model.StudyTopic, first *int, offset *int) (*model.LessonPagination, error) {
	panic(fmt.Errorf("not implemented: Lessons - lessons"))
}

// Lesson returns generated.LessonResolver implementation.
func (r *Resolver) Lesson() generated.LessonResolver { return &lessonResolver{r} }

// StudyTopic returns generated.StudyTopicResolver implementation.
func (r *Resolver) StudyTopic() generated.StudyTopicResolver { return &studyTopicResolver{r} }

type lessonResolver struct{ *Resolver }
type studyTopicResolver struct{ *Resolver }

// !!! WARNING !!!
// The code below was going to be deleted when updating resolvers. It has been copied here so you have
// one last chance to move it out of harms way if you want. There are two reasons this happens:
//   - When renaming or deleting a resolver the old code will be put in here. You can safely delete
//     it when you're done.
//   - You have helper methods in this file. Move them out to keep these resolver files clean.
func (r *studyResolver) Tasks(ctx context.Context, obj *model.Study) ([]model.Task, error) {
	panic(fmt.Errorf("not implemented: Tasks - tasks"))
}
func (r *Resolver) Study() generated.StudyResolver { return &studyResolver{r} }

type studyResolver struct{ *Resolver }
