package model

import (
	"context"
	"strconv"

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
				ID:              id,
				Title:           title,
				CompetitionMode: task.CompetitionMode,
			}
		case common.QuestionTaskTypeText:
			return TextTask{
				ID:    id,
				Title: title,
			}
		}
	case common.TaskTypeImage:
		image := task.Images.Get(languages)
		switch task.ImageType {
		case common.ImageTaskTypeQuote:
			return QuoteTask{
				ID:    id,
				Title: title,
				Image: image,
			}
		case common.ImageTaskTypePoster:
			return PosterTask{
				ID:    id,
				Title: title,
				Image: image,
			}
		}
	case common.TaskTypeLink:
		return LinkTask{
			ID:    id,
			Title: title,
			Link: &Link{
				ID: strconv.Itoa(int(task.LinkID.Int64)),
			},
			SecondaryTitle: task.SecondaryTitle.GetValueOrNil(languages),
			Description:    task.Description.GetValueOrNil(languages),
		}
	case common.TaskTypeVideo:
		return VideoTask{
			ID:    id,
			Title: title,
			Episode: &Episode{
				ID: strconv.Itoa(int(task.EpisodeID.Int64)),
			},
			SecondaryTitle: task.SecondaryTitle.GetValueOrNil(languages),
			Description:    task.Description.GetValueOrNil(languages),
		}
	}

	return TextTask{
		ID:    id,
		Title: title,
	}
}
