package graph

import (
	"github.com/bcc-code/brunstadtv/backend/sqlc"
)

// This file will not be regenerated automatically.
//
// It serves as dependency injection for your app, add any dependencies you require here.

// Resolver is the main struct for the GQL implementation
// It contains references to all external services and config
type Resolver struct {
	Queries *sqlc.Queries
}
