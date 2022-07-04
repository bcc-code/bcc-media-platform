package directus

import (
	"context"
)

// Item model
type Item struct {
	ID     int    `json:"id,omitempty"`
	Status string `json:"status"`
}

// Episode model
type Episode struct {
	Item
}

// Season model
type Season struct {
	Item
}

// Show model
type Show struct {
	Item
}

// UID retrieves the not so unique ID (but unique in collection)
func (i Item) UID() int {
	return i.ID
}

// ForUpdate retrieves a model with only mutable properties
func (i Item) ForUpdate() interface{} {
	return map[string]string{}
}

// GetStatus for this item
func (i Item) GetStatus() string {
	return i.Status
}

// TypeName episodes
func (i Episode) TypeName() string {
	return "episodes"
}

// TypeName seasons
func (i Season) TypeName() string {
	return "seasons"
}

// TypeName shows
func (i Show) TypeName() string {
	return "shows"
}

// GetEpisode get an episode by id
func (h *Handler) GetEpisode(ctx context.Context, id int) (Episode, error) {
	return GetItem[Episode](ctx, h.c, "episodes", id)
}

// GetSeason get a season by id
func (h *Handler) GetSeason(ctx context.Context, id int) (Season, error) {
	return GetItem[Season](ctx, h.c, "seasons", id)
}

// GetShow get a show by id
func (h *Handler) GetShow(ctx context.Context, id int) (Show, error) {
	return GetItem[Show](ctx, h.c, "shows", id)
}

// ListEpisodes lists all episodes
func (h *Handler) ListEpisodes(ctx context.Context) ([]Episode, error) {
	return ListItems[Episode](ctx, h.c, "episodes", nil)
}

// ListSeasons lists all seasons
func (h *Handler) ListSeasons(ctx context.Context) ([]Season, error) {
	return ListItems[Season](ctx, h.c, "seasons", nil)
}

// ListShows lists all shows
func (h *Handler) ListShows(ctx context.Context) ([]Show, error) {
	return ListItems[Show](ctx, h.c, "shows", nil)
}
