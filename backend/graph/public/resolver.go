package graph

import (
	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/loaders"
)

// This file will not be regenerated automatically.
//
// It serves as dependency injection for your app, add any dependencies you require here.

// Resolver contains necessary properties to serve the endpoints
type Resolver struct {
	Loaders *Loaders
}

// Loaders required for operation
type Loaders struct {
	ShowLoader    *loaders.Loader[int, *common.Show]
	SeasonLoader  *loaders.Loader[int, *common.Season]
	EpisodeLoader *loaders.Loader[int, *common.Episode]
}
