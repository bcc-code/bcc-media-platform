package graph

import "github.com/bcc-code/brunstadtv/backend/search"

import (
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/graph-gophers/dataloader/v7"
)

// This file will not be regenerated automatically.
//
// It serves as dependency injection for your app, add any dependencies you require here.

// Resolver is the main struct for the GQL implementation
// It contains references to all external services and config
type Resolver struct {
	Queries       *sqlc.Queries
	Loaders       *BatchLoaders
	SearchService *search.Service
}

// BatchLoaders is a collection of GQL dataloaders
type BatchLoaders struct {
	ShowLoader    *dataloader.Loader[int, *sqlc.ShowExpanded]
	SeasonLoader  *dataloader.Loader[int, *sqlc.SeasonExpanded]
	EpisodeLoader *dataloader.Loader[int, *sqlc.EpisodeExpanded]
	FilesLoader   *dataloader.Loader[int, []*sqlc.GetFilesForEpisodesRow]
	StreamsLoader *dataloader.Loader[int, []*sqlc.GetStreamsForEpisodesRow]
}
