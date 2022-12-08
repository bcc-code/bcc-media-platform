package model

import (
	"context"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/user"
	"github.com/bcc-code/brunstadtv/backend/utils"
)

// TaskFrom returns a task from studies.Task
func TaskFrom(ctx context.Context, task *common.Task) Task {
	ginCtx, _ := utils.GinCtx(ctx)
	languages := user.GetLanguagesFromCtx(ginCtx)

	id := task.ID.String()
	title := task.Title.Get(languages)

	switch task.Type {
	case common.TaskTypeQuestion:
		switch task.QuestionType {
		case common.QuestionTaskTypeAlternatives:
			return AlternativesTask{
				ID:    id,
				Title: title,
			}
		case common.QuestionTaskTypeText:
			return TextTask{
				ID:    id,
				Title: title,
			}
		}
	}

	return TextTask{
		ID:    id,
		Title: title,
	}
}
