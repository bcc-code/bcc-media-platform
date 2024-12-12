package notifications

import (
	"github.com/bcc-code/bcc-media-platform/backend/sqlc"
)

// Utils contains different methods for resolving notifications
type Utils struct {
	queries *sqlc.Queries
}

// NewUtils returns a new Utils struct
func NewUtils(
	queries *sqlc.Queries,
) *Utils {
	return &Utils{
		queries: queries,
	}
}
