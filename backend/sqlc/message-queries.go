package sqlc

import (
	"context"
	"encoding/json"
	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/samber/lo"
)

// GetMessageGroups returns messages
func (q *Queries) GetMessageGroups(ctx context.Context, ids []int) ([]common.MessageGroup, error) {
	groups, err := q.getMessageGroups(ctx, intToInt32(ids))
	if err != nil {
		return nil, err
	}
	return lo.Map(groups, func(i getMessageGroupsRow, _ int) common.MessageGroup {
		var messages []common.Message
		_ = json.Unmarshal(i.Messages, &messages)
		return common.MessageGroup{
			ID:       int(i.ID),
			Enabled:  i.Enabled.Bool,
			Messages: messages,
		}
	}), nil
}
