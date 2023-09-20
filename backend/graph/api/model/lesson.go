package model

import (
	"context"
	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/user"
	"github.com/bcc-code/bcc-media-platform/backend/utils"
)

// LessonFrom returns a lesson from studies.Lesson
func LessonFrom(ctx context.Context, lesson *common.Lesson) *Lesson {
	ginCtx, _ := utils.GinCtx(ctx)
	languages := user.GetLanguagesFromCtx(ginCtx)

	id := lesson.ID.String()
	title := lesson.Title.Get(languages)

	return &Lesson{
		ID:          id,
		Title:       title,
		Description: lesson.Description.Get(languages),
		Topic: &StudyTopic{
			ID: lesson.TopicID.String(),
		},
	}
}
