package sqlc

import (
	"context"
	"encoding/json"
	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/log"
	"github.com/google/uuid"
)

func targetRowToModel(row getTargetsRow) common.Target {
	t := common.Target{}

	t.ID = row.ID
	t.Type = row.Type
	t.GroupCodes = row.GroupCodes
	t.ApplicationBuildMin = row.ApplicationMinimumBuildNumber
	t.ApplicationBuildMax = row.ApplicationMaximumBuildNumber
	t.InactiveDaysMin = row.InactiveDaysMin
	t.InactiveDaysMax = row.InactiveDaysMax

	var deviceOs []string
	var languages []string

	if row.DeviceOs.Valid {
		err := json.Unmarshal(row.DeviceOs.RawMessage, &deviceOs)
		if err != nil {
			log.L.Warn().Err(err).Msg("Failed to unmarshal deviceOs")
		}
	}

	if row.Languages.Valid {
		err := json.Unmarshal(row.Languages.RawMessage, &languages)
		if err != nil {
			log.L.Warn().Err(err).Msg("Failed to unmarshal languages")
		}
	}

	t.DeviceOs = deviceOs
	t.Languages = languages

	return t
}

func (q *Queries) GetTargets(ctx context.Context, dollar_1 []uuid.UUID) ([]common.Target, error) {
	rows, err := q.getTargets(ctx, dollar_1)
	if err != nil {
		return nil, err
	}

	var out []common.Target
	for _, row := range rows {
		out = append(out, targetRowToModel(row))
	}
	return out, err
}
