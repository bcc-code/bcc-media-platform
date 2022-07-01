package directus

import "github.com/bcc-code/mediabank-bridge/log"

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

func getAndHandleError[t DSItem](h *Handler, collection string, id int) (item t) {
	item, err := GetItem[t](h.ctx, h.c, collection, id)
	if err != nil {
		log.L.Error().Err(err).Str("collection", collection).Msg("failed to get item")
	}
	return
}

func (h *Handler) GetEpisode(id int) Episode {
	return getAndHandleError[Episode](h, "episodes", id)
}

func (h *Handler) GetSeason(id int) Season {
	return getAndHandleError[Season](h, "seasons", id)
}

func (h *Handler) GetShow(id int) Show {
	return getAndHandleError[Show](h, "shows", id)
}

func listAndHandleError[t DSItem](h *Handler, collection string) (items []t) {
	items, err := ListItems[t](h.ctx, h.c, collection, nil)
	if err != nil {
		log.L.Error().Err(err).Str("collection", collection).Msg("failed to list")
	}
	return
}

func (h *Handler) ListEpisodes() (items []Episode) {
	return listAndHandleError[Episode](h, "episodes")
}

func (h *Handler) ListSeasons() []Season {
	return listAndHandleError[Season](h, "seasons")
}

func (h *Handler) ListShows() []Show {
	return listAndHandleError[Show](h, "shows")
}
