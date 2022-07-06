package graph

import (
	gqlmodel "github.com/bcc-code/brunstadtv/backend/graph/model"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/graph-gophers/dataloader/v7"
)

// This file will not be regenerated automatically.
//
// It serves as dependency injection for your app, add any dependencies you require here.

// Resolver is the main struct for the GQL implementation
// It contains references to all external services and config
type Resolver struct {
	Queries *sqlc.Queries
	Loaders *BatchLoaders
}

// BatchLoaders is a collection of GQL dataloaders
type BatchLoaders struct {
	EpisodeLoader *dataloader.Loader[int, *gqlmodel.Episode]
	FilesLoader   *dataloader.Loader[int, []*gqlmodel.File]
}
