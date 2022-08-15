package gqladmin

import (
	"database/sql"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
)

// Resolver contains the common properties for all endpoints
type Resolver struct {
	DB      *sql.DB
	Queries *sqlc.Queries
	Loaders *common.BatchLoaders
}
