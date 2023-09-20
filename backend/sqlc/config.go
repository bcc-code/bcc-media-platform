package sqlc

import (
	"context"
	"database/sql"
	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/mediabank-bridge/log"
)

// GetGlobalConfig returns configuration options for app
func (q *Queries) GetGlobalConfig(ctx context.Context) (common.GlobalConfig, error) {
	conf, err := q.getGlobalConfig(ctx)
	if err != nil {
		if err == sql.ErrNoRows {
			log.L.Error().Msg("Missing app config in database")
			err = nil
		}
		return common.GlobalConfig{}, err
	}

	return common.GlobalConfig{
		LiveOnline:  conf.LiveOnline.Bool,
		NPAWEnabled: conf.NpawEnabled.Bool,
	}, nil
}
