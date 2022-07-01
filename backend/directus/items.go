package directus

import (
	"context"
	"github.com/bcc-code/mediabank-bridge/log"
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

func getAndHandleError[t DSItem](ctx context.Context, h *Handler, collection string, id int) (item t) {
	item, err := GetItem[t](ctx, h.c, collection, id)
	if err != nil {
		log.L.Error().Err(err).Str("collection", collection).Msg("failed to get item")
	}
	return
}

func (h *Handler) GetEpisode(ctx context.Context, id int) Episode {
	return getAndHandleError[Episode](ctx, h, "episodes", id)
}

func (h *Handler) GetSeason(ctx context.Context, id int) Season {
	return getAndHandleError[Season](ctx, h, "seasons", id)
}

func (h *Handler) GetShow(ctx context.Context, id int) Show {
	return getAndHandleError[Show](ctx, h, "shows", id)
}

func listAndHandleError[t DSItem](ctx context.Context, h *Handler, collection string) (items []t) {
	items, err := ListItems[t](ctx, h.c, collection, nil)
	if err != nil {
		log.L.Error().Err(err).Str("collection", collection).Msg("failed to list")
	}
	return
}

func (h *Handler) ListEpisodes(ctx context.Context) (items []Episode) {
	return listAndHandleError[Episode](ctx, h, "episodes")
}

func (h *Handler) ListSeasons(ctx context.Context) []Season {
	return listAndHandleError[Season](ctx, h, "seasons")
}

func (h *Handler) ListShows(ctx context.Context) []Show {
	return listAndHandleError[Show](ctx, h, "shows")
}
