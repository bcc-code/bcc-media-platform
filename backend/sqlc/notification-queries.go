package sqlc

import (
	"context"
	"encoding/json"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/samber/lo"
	"gopkg.in/guregu/null.v4"
)

// GetNotifications returns notifications from the database
func (q *Queries) GetNotifications(ctx context.Context, ids []int) ([]common.Notification, error) {
	ns, err := q.getNotifications(ctx, intToInt32(ids))
	if err != nil {
		return nil, err
	}
	return lo.Map(ns, func(n getNotificationsRow, _ int) common.Notification {
		var title common.LocaleString
		var description common.LocaleString
		var images common.LocaleMap[null.String]

		_ = json.Unmarshal(n.Title, &title)
		_ = json.Unmarshal(n.Description, &description)
		_ = json.Unmarshal(n.Images, &images)

		return common.Notification{
			ID:          int(n.ID),
			Status:      common.StatusFrom(n.Status),
			Title:       title,
			Description: description,
			Images:      images,
		}
	}), nil
}
