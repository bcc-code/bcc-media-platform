package graph

import (
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/graph-gophers/dataloader/v7"
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
	ShowLoader    *dataloader.Loader[int, *common.Show]
	SeasonLoader  *dataloader.Loader[int, *common.Season]
	EpisodeLoader *dataloader.Loader[int, *common.Episode]
}
