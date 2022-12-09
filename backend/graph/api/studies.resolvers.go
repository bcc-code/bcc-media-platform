package graph

// This file will be automatically regenerated based on the schema, any resolver implementations
// will be copied through when generating and any unknown code will be moved to the end.

import (
	"context"

	"github.com/bcc-code/brunstadtv/backend/batchloaders"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/graph/api/generated"
	"github.com/bcc-code/brunstadtv/backend/graph/api/model"
	"github.com/bcc-code/brunstadtv/backend/user"
	"github.com/bcc-code/brunstadtv/backend/utils"
	"github.com/google/uuid"
	"github.com/samber/lo"
)

// Completed is the resolver for the completed field.
func (r *alternativesTaskResolver) Completed(ctx context.Context, obj *model.AlternativesTask) (bool, error) {
	id, err := r.GetProfileLoaders(ctx).TaskCompletedLoader.Get(ctx, utils.AsUuid(obj.ID))
	if err != nil {
		return false, err
	}
	return id != nil, nil
}

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
			ID:        alt.ID.String(),
			Title:     alt.Title.Get(languages),
			IsCorrect: alt.IsCorrect,
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

// Topic is the resolver for the topic field.
func (r *lessonResolver) Topic(ctx context.Context, obj *model.Lesson) (*model.StudyTopic, error) {
	return r.QueryRoot().StudyTopic(ctx, obj.Topic.ID)
}

// Progress is the resolver for the progress field.
func (r *lessonResolver) Progress(ctx context.Context, obj *model.Lesson) (*model.TasksProgress, error) {
	ids, err := r.GetFilteredLoaders(ctx).StudyTasksLoader.Get(ctx, utils.AsUuid(obj.ID))
	if err != nil {
		return nil, err
	}
	completed, err := r.GetProfileLoaders(ctx).TaskCompletedLoader.GetMany(ctx, utils.PointerArrayToArray(ids))
	if err != nil {
		return nil, err
	}
	return &model.TasksProgress{
		Total: len(ids),
		Completed: len(lo.Filter(completed, func(i *uuid.UUID, _ int) bool {
			return i != nil
		})),
	}, nil
}

// Episodes is the resolver for the episodes field.
func (r *lessonResolver) Episodes(ctx context.Context, obj *model.Lesson, first *int, offset *int) (*model.EpisodePagination, error) {
	ids, err := r.GetFilteredLoaders(ctx).StudyLessonEpisodesLoader.Get(ctx, utils.AsUuid(obj.ID))
	if err != nil {
		return nil, err
	}
	page := utils.Paginate(ids, first, offset, nil)

	episodes, err := batchloaders.GetMany(ctx, r.Loaders.EpisodeLoader, utils.PointerArrayToArray(page.Items))
	if err != nil {
		return nil, err
	}

	return &model.EpisodePagination{
		Items:  utils.MapWithCtx(ctx, episodes, model.EpisodeFrom),
		Total:  page.Total,
		First:  page.First,
		Offset: page.Offset,
	}, nil
}

// Completed is the resolver for the completed field.
func (r *linkTaskResolver) Completed(ctx context.Context, obj *model.LinkTask) (bool, error) {
	id, err := r.GetProfileLoaders(ctx).TaskCompletedLoader.Get(ctx, utils.AsUuid(obj.ID))
	if err != nil {
		return false, err
	}
	return id != nil, nil
}

// Completed is the resolver for the completed field.
func (r *posterTaskResolver) Completed(ctx context.Context, obj *model.PosterTask) (bool, error) {
	id, err := r.GetProfileLoaders(ctx).TaskCompletedLoader.Get(ctx, utils.AsUuid(obj.ID))
	if err != nil {
		return false, err
	}
	return id != nil, nil
}

// Completed is the resolver for the completed field.
func (r *quoteTaskResolver) Completed(ctx context.Context, obj *model.QuoteTask) (bool, error) {
	id, err := r.GetProfileLoaders(ctx).TaskCompletedLoader.Get(ctx, utils.AsUuid(obj.ID))
	if err != nil {
		return false, err
	}
	return id != nil, nil
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
func (r *studyTopicResolver) Progress(ctx context.Context, obj *model.StudyTopic) (*model.TasksProgress, error) {
	ids, err := r.GetFilteredLoaders(ctx).StudyLessonsLoader.Get(ctx, utils.AsUuid(obj.ID))
	if err != nil {
		return nil, err
	}
	taskIDGroups, err := r.GetFilteredLoaders(ctx).StudyTasksLoader.GetMany(ctx, utils.PointerArrayToArray(ids))
	if err != nil {
		return nil, err
	}
	taskIDs := lo.Uniq(
		utils.PointerArrayToArray(
			lo.Reduce(taskIDGroups, func(r []*uuid.UUID, v []*uuid.UUID, _ int) []*uuid.UUID {
				return append(r, v...)
			}, []*uuid.UUID{}),
		),
	)
	completedTaskIDs, err := r.GetProfileLoaders(ctx).TaskCompletedLoader.GetMany(ctx, taskIDs)
	if err != nil {
		return nil, err
	}
	return &model.TasksProgress{
		Total: len(taskIDs),
		Completed: len(lo.Filter(completedTaskIDs, func(i *uuid.UUID, _ int) bool {
			return i != nil
		})),
	}, nil
}

// Completed is the resolver for the completed field.
func (r *textTaskResolver) Completed(ctx context.Context, obj *model.TextTask) (bool, error) {
	id, err := r.GetProfileLoaders(ctx).TaskCompletedLoader.Get(ctx, utils.AsUuid(obj.ID))
	if err != nil {
		return false, err
	}
	return id != nil, nil
}

// Completed is the resolver for the completed field.
func (r *videoTaskResolver) Completed(ctx context.Context, obj *model.VideoTask) (bool, error) {
	id, err := r.GetProfileLoaders(ctx).TaskCompletedLoader.Get(ctx, utils.AsUuid(obj.ID))
	if err != nil {
		return false, err
	}
	return id != nil, nil
}

// Episode is the resolver for the episode field.
func (r *videoTaskResolver) Episode(ctx context.Context, obj *model.VideoTask) (*model.Episode, error) {
	return r.QueryRoot().Episode(ctx, obj.Episode.ID, nil)
}

// AlternativesTask returns generated.AlternativesTaskResolver implementation.
func (r *Resolver) AlternativesTask() generated.AlternativesTaskResolver {
	return &alternativesTaskResolver{r}
}

// Lesson returns generated.LessonResolver implementation.
func (r *Resolver) Lesson() generated.LessonResolver { return &lessonResolver{r} }

// LinkTask returns generated.LinkTaskResolver implementation.
func (r *Resolver) LinkTask() generated.LinkTaskResolver { return &linkTaskResolver{r} }

// PosterTask returns generated.PosterTaskResolver implementation.
func (r *Resolver) PosterTask() generated.PosterTaskResolver { return &posterTaskResolver{r} }

// QuoteTask returns generated.QuoteTaskResolver implementation.
func (r *Resolver) QuoteTask() generated.QuoteTaskResolver { return &quoteTaskResolver{r} }

// StudyTopic returns generated.StudyTopicResolver implementation.
func (r *Resolver) StudyTopic() generated.StudyTopicResolver { return &studyTopicResolver{r} }

// TextTask returns generated.TextTaskResolver implementation.
func (r *Resolver) TextTask() generated.TextTaskResolver { return &textTaskResolver{r} }

// VideoTask returns generated.VideoTaskResolver implementation.
func (r *Resolver) VideoTask() generated.VideoTaskResolver { return &videoTaskResolver{r} }

type alternativesTaskResolver struct{ *Resolver }
type lessonResolver struct{ *Resolver }
type linkTaskResolver struct{ *Resolver }
type posterTaskResolver struct{ *Resolver }
type quoteTaskResolver struct{ *Resolver }
type studyTopicResolver struct{ *Resolver }
type textTaskResolver struct{ *Resolver }
type videoTaskResolver struct{ *Resolver }
