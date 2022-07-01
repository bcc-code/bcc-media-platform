package directus

import (
	"context"
)

type Item struct {
	ID     int    `json:"id,omitempty"`
	Status string `json:"status"`
}

type Episode struct {
	Item
}

type Season struct {
	Item
}

type Show struct {
	Item
}

func (i Item) UID() int {
	return i.ID
}

func (i Item) ForUpdate() interface{} {
	return map[string]string{}
}

func (i Item) GetStatus() string {
	return i.Status
}

func (i Episode) TypeName() string {
	return "episodes"
}

func (i Season) TypeName() string {
	return "seasons"
}

func (i Show) TypeName() string {
	return "shows"
}

func (h *Handler) GetEpisode(ctx context.Context, id int) (Episode, error) {
	return GetItem[Episode](ctx, h.c, "episodes", id)
}

func (h *Handler) GetSeason(ctx context.Context, id int) (Season, error) {
	return GetItem[Season](ctx, h.c, "seasons", id)
}

func (h *Handler) GetShow(ctx context.Context, id int) (Show, error) {
	return GetItem[Show](ctx, h.c, "shows", id)
}

func (h *Handler) ListEpisodes(ctx context.Context) ([]Episode, error) {
	return ListItems[Episode](ctx, h.c, "episodes", nil)
}

func (h *Handler) ListSeasons(ctx context.Context) ([]Season, error) {
	return ListItems[Season](ctx, h.c, "seasons", nil)
}

func (h *Handler) ListShows(ctx context.Context) ([]Show, error) {
	return ListItems[Show](ctx, h.c, "shows", nil)
}
