package sqlc

import (
	"context"
	"database/sql"
	"encoding/json"
	"github.com/bcc-code/brunstadtv/backend/common"
)

// GetMaintenanceMessages returns maintenance messages
func (q *Queries) GetMaintenanceMessages(ctx context.Context) ([]common.MaintenanceMessage, error) {
	msg, err := q.getMaintenanceMessage(ctx)
	if err != nil && err != sql.ErrNoRows {
		return nil, err
	}
	var result []common.MaintenanceMessage

	_ = json.Unmarshal(msg.Messages, &result)

	return result, nil
}
