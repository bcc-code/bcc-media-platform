package sqlc

import (
	"context"
	"database/sql"
	"encoding/json"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/mediabank-bridge/log"
)

// GetMaintenanceMessages returns maintenance messages
func (q *Queries) GetMaintenanceMessages(ctx context.Context) ([]common.MaintenanceMessage, error) {
	msg, err := q.getMaintenanceMessage(ctx)
	if err != nil {
		if err == sql.ErrNoRows {
			log.L.Error().Msg("missing maintenance message from database")
			err = nil
		}
		return nil, err
	}

	if !msg.Active.Bool {
		return nil, nil
	}

	var result []common.MaintenanceMessage

	_ = json.Unmarshal(msg.Messages, &result)

	return result, nil
}
