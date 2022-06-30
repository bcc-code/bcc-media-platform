package directus

import (
	"github.com/bcc-code/mediabank-bridge/log"
	"strconv"
)

type Translation struct {
	ID            int    `json:"id,omitempty"`
	Title         string `json:"title"`
	Description   string `json:"description,omitempty"`
	LanguagesCode string `json:"languages_code"`
}

type EpisodesTranslation struct {
	Translation
	EpisodesID       int    `json:"episodes_id"`
	ExtraDescription string `json:"extra_description,omitempty"`
}

type SeasonsTranslation struct {
	Translation
	SeasonsID int `json:"seasons_id"`
}

type ShowsTranslation struct {
	Translation
	ShowsID int `json:"shows_id"`
}

type update struct {
	Title       string `json:"title"`
	Description string `json:"description"`
}

type episodesUpdate struct {
	update
	ExtraDescription string `json:"extra_description"`
}

func (i Translation) UID() int {
	return i.ID
}

func (i Translation) ForUpdate() interface{} {
	return update{
		i.Title,
		i.Description,
	}
}

func (i EpisodesTranslation) ForUpdate() interface{} {
	return episodesUpdate{
		update{
			i.Title,
			i.Description,
		},
		i.ExtraDescription,
	}
}

func (EpisodesTranslation) TypeName() string {
	return "episodes_translations"
}

func (SeasonsTranslation) TypeName() string {
	return "seasons_translations"
}

func (ShowsTranslation) TypeName() string {
	return "shows_translations"
}

func (i Translation) GetSourceLanguage() string {
	return i.LanguagesCode
}

func (i Translation) GetValues() map[string]string {
	return map[string]string{
		"title":       i.Title,
		"description": i.Description,
	}
}

func (i EpisodesTranslation) GetCollection() string {
	return "episodes"
}

func (i EpisodesTranslation) GetValues() map[string]string {
	return map[string]string{
		"title":             i.Title,
		"description":       i.Description,
		"extra_description": i.ExtraDescription,
	}
}

func (i EpisodesTranslation) GetItemID() int {
	return i.EpisodesID
}

func (i SeasonsTranslation) GetCollection() string {
	return "seasons"
}

func (i SeasonsTranslation) GetItemID() int {
	return i.SeasonsID
}

func (i ShowsTranslation) GetCollection() string {
	return "shows"
}

func (i ShowsTranslation) GetItemID() int {
	return i.ShowsID
}

func (h *Handler) GetEpisodeTranslation(id int) (translation EpisodesTranslation) {
	translation, err := GetItem[EpisodesTranslation](h.ctx, h.c, "episodes_translations", id)
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to retrieve translation")
	}
	return
}

func (h *Handler) GetSeasonTranslation(id int) (translation SeasonsTranslation) {
	translation, err := GetItem[SeasonsTranslation](h.ctx, h.c, "seasons_translations", id)
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to retrieve translation")
	}
	return
}

func (h *Handler) GetShowTranslation(id int) (translation ShowsTranslation) {
	translation, err := GetItem[ShowsTranslation](h.ctx, h.c, "shows_translations", id)
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to retrieve translation")
	}
	return
}

func (h *Handler) ListEpisodeTranslations(language string, primary bool, episodeId int) (translations []EpisodesTranslation) {
	var queryParams = map[string]string{}
	if primary {
		queryParams["filter[is_primary][_eq]"] = "true"
	}
	if language != "" {
		queryParams["filter[languages_code][_eq]"] = language
	}
	if episodeId != 0 {
		queryParams["filter[episodes_id][_eq]"] = strconv.Itoa(episodeId)
	}
	translations, err := ListItems[EpisodesTranslation](h.ctx, h.c, "episodes_translations", queryParams)
	if err != nil {
		log.L.Error().Err(err)
	}
	return
}

func (h *Handler) ListSeasonTranslations(language string, primary bool, seasonId int) (translations []SeasonsTranslation) {
	var queryParams = map[string]string{}
	if primary {
		queryParams["filter[is_primary][_eq]"] = "true"
	}
	if language != "" {
		queryParams["filter[languages_code][_eq]"] = language
	}
	if seasonId != 0 {
		queryParams["filter[seasons_id][_eq]"] = strconv.Itoa(seasonId)
	}
	translations, err := ListItems[SeasonsTranslation](h.ctx, h.c, "seasons_translations", queryParams)
	if err != nil {
		log.L.Error().Err(err)
	}
	return
}

func (h *Handler) ListShowTranslations(language string, primary bool, showId int) (translations []ShowsTranslation) {
	var queryParams = map[string]string{}
	if primary {
		queryParams["filter[is_primary][_eq]"] = "true"
	}
	if language != "" {
		queryParams["filter[languages_code][_eq]"] = language
	}
	if showId != 0 {
		queryParams["filter[shows_id][_eq]"] = strconv.Itoa(showId)
	}
	translations, err := ListItems[ShowsTranslation](h.ctx, h.c, "shows_translations", queryParams)
	if err != nil {
		log.L.Error().Err(err)
	}
	return
}

func (h *Handler) SaveTranslations(translations []DSItem) {
	for _, item := range translations {
		_, err := SaveItem(h.ctx, h.c, item, false)
		if err != nil {
			log.L.Error().Err(err).Msg("Failed to save translations")
			return
		}
	}
}
