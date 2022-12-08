package model

import (
	"context"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/user"
	"github.com/bcc-code/brunstadtv/backend/utils"
)

// LessonFrom returns a lesson from studies.Lesson
func LessonFrom(ctx context.Context, lesson *common.Lesson) *Lesson {
	ginCtx, _ := utils.GinCtx(ctx)
	languages := user.GetLanguagesFromCtx(ginCtx)

	id := lesson.ID.String()
	title := lesson.Title.Get(languages)

	return &Lesson{
		ID:    id,
		Title: title,
		Topic: &StudyTopic{
			ID: lesson.TopicID.String(),
		},
	}
}
