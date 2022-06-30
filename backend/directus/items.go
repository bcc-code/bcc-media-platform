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

func (i Episode) TypeName() string {
	return "episodes"
}

func (i Season) TypeName() string {
	return "seasons"
}

func (i Show) TypeName() string {
	return "shows"
}

func (h *Handler) GetEpisode(id int) (item Episode) {
	item, err := GetItem[Episode](h.ctx, h.c, "episodes", id)
	if err != nil {
		log.L.Error().Err(err).Msg("failed to get episode")
	}
	return
}

func (h *Handler) GetSeason(id int) (item Season) {
	item, err := GetItem[Season](h.ctx, h.c, "seasons", id)
	if err != nil {
		log.L.Error().Err(err).Msg("failed to get episode")
	}
	return
}

func (h *Handler) GetShow(id int) (item Show) {
	item, err := GetItem[Show](h.ctx, h.c, "shows", id)
	if err != nil {
		log.L.Error().Err(err).Msg("failed to get episode")
	}
	return
}
