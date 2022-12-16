package model

import (
	"context"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/user"
	"github.com/bcc-code/brunstadtv/backend/utils"
)

// AchievementFrom returns an Achievement from common.Achievement
func AchievementFrom(ctx context.Context, i *common.Achievement) *Achievement {
	ginCtx, _ := utils.GinCtx(ctx)
	languages := user.GetLanguagesFromCtx(ginCtx)

	var group *AchievementGroup
	if i.GroupID.Valid {
		group = &AchievementGroup{
			ID: i.GroupID.UUID.String(),
		}
	}

	return &Achievement{
		ID:    i.ID.String(),
		Title: i.Title.Get(languages),
		Image: i.Images.Get(languages).Ptr(),
		Group: group,
	}
}
