package graph

// This file will be automatically regenerated based on the schema, any resolver implementations
// will be copied through when generating and any unknown code will be moved to the end.

import (
	"context"
	"fmt"

	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/graph/api/generated"
	"github.com/bcc-code/brunstadtv/backend/graph/api/model"
	"github.com/bcc-code/brunstadtv/backend/user"
	"github.com/bcc-code/brunstadtv/backend/utils"
	"github.com/samber/lo"
)

// Alternatives is the resolver for the alternatives field.
func (r *alternativesTaskResolver) Alternatives(ctx context.Context, obj *model.AlternativesTask) ([]*model.Alternative, error) {
	alts, err := r.Loaders.StudyQuestionAlternativesLoader.Get(ctx, utils.AsUuid(obj.ID))
	if err != nil {
		return nil, err
	}
	ginCtx, _ := utils.GinCtx(ctx)
	languages := user.GetLanguagesFromCtx(ginCtx)

	return lo.Map(alts, func(alt *common.QuestionAlternative, _ int) *model.Alternative {
		return &model.Alternative{
			ID:    alt.ID.String(),
			Title: alt.Title.Get(languages),
		}
	}), nil
}

// Tasks is the resolver for the tasks field.
func (r *lessonResolver) Tasks(ctx context.Context, obj *model.Lesson, first *int, offset *int) (*model.TaskPagination, error) {
	ids, err := r.FilteredLoaders(ctx).StudyTasksLoader.Get(ctx, utils.AsUuid(obj.ID))
	if err != nil {
		return nil, err
	}
	page := utils.Paginate(ids, first, offset, nil)

	tasks, err := r.Loaders.StudyTaskLoader.GetMany(ctx, utils.PointerArrayToArray(page.Items))
	if err != nil {
		return nil, err
	}

	return &model.TaskPagination{
		Total:  page.Total,
		First:  page.First,
		Offset: page.Offset,
		Items:  utils.MapWithCtx(ctx, tasks, model.TaskFrom),
	}, nil
}

// Progress is the resolver for the progress field.
func (r *lessonResolver) Progress(ctx context.Context, obj *model.Lesson) (*model.LessonProgress, error) {
	panic(fmt.Errorf("not implemented: Progress - progress"))
}

// Lessons is the resolver for the lessons field.
func (r *studyTopicResolver) Lessons(ctx context.Context, obj *model.StudyTopic, first *int, offset *int) (*model.LessonPagination, error) {
	ids, err := r.FilteredLoaders(ctx).StudyLessonsLoader.Get(ctx, utils.AsUuid(obj.ID))
	if err != nil {
		return nil, err
	}
	page := utils.Paginate(ids, first, offset, nil)

	lessons, err := r.Loaders.StudyLessonLoader.GetMany(ctx, utils.PointerArrayToArray(page.Items))
	if err != nil {
		return nil, err
	}

	return &model.LessonPagination{
		Total:  page.Total,
		First:  page.First,
		Offset: page.Offset,
		Items:  utils.MapWithCtx(ctx, lessons, model.LessonFrom),
	}, nil
}

// Progress is the resolver for the progress field.
func (r *studyTopicResolver) Progress(ctx context.Context, obj *model.StudyTopic) (*model.StudyTopicProgress, error) {
	panic(fmt.Errorf("not implemented: Progress - progress"))
}

// AlternativesTask returns generated.AlternativesTaskResolver implementation.
func (r *Resolver) AlternativesTask() generated.AlternativesTaskResolver {
	return &alternativesTaskResolver{r}
}

// Lesson returns generated.LessonResolver implementation.
func (r *Resolver) Lesson() generated.LessonResolver { return &lessonResolver{r} }

// StudyTopic returns generated.StudyTopicResolver implementation.
func (r *Resolver) StudyTopic() generated.StudyTopicResolver { return &studyTopicResolver{r} }

type alternativesTaskResolver struct{ *Resolver }
type lessonResolver struct{ *Resolver }
type studyTopicResolver struct{ *Resolver }
