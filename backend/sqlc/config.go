package sqlc

import (
	"context"
	"database/sql"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/mediabank-bridge/log"
)

// GetAppConfig returns configuration options for app
func (q *Queries) GetAppConfig(ctx context.Context) (common.AppConfig, error) {
	conf, err := q.getAppConfig(ctx)
	if err != nil {
		if err == sql.ErrNoRows {
			log.L.Error().Msg("Missing app config in database")
			err = nil
		}
		return common.AppConfig{}, err
	}

	return common.AppConfig{
		MinVersion: conf.AppVersion,
	}, nil
}

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
