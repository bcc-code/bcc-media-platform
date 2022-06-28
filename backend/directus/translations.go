package directus

import "github.com/bcc-code/mediabank-bridge/log"

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

func (i EpisodesTranslation) UID() int {
	return i.ID
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

func (i SeasonsTranslation) UID() int {
	return i.ID
}

func (i SeasonsTranslation) ForUpdate() interface{} {
	return update{
		i.Title,
		i.Description,
	}
}

func (SeasonsTranslation) TypeName() string {
	return "seasons_translations"
}

func (i ShowsTranslation) UID() int {
	return i.ID
}

func (i ShowsTranslation) ForUpdate() interface{} {
	return update{
		i.Title,
		i.Description,
	}
}

func (ShowsTranslation) TypeName() string {
	return "shows_translations"
}

func (h *Handler) ListEpisodeTranslations(language string, primary bool) (translations []EpisodesTranslation) {
	var queryParams = map[string]string{}
	if primary {
		//queryParams["filter[is_primary][_eq]"] = "true"
	}
	if language != "" {
		queryParams["filter[languages_code][_eq]"] = language
	}
	translations, err := ListItems[EpisodesTranslation](h.ctx, h.c, "episodes_translations", queryParams)
	if err != nil {
		log.L.Error().Err(err)
	}
	return
}

func (h *Handler) ListSeasonTranslations(language string, primary bool) (translations []SeasonsTranslation) {
	var queryParams = map[string]string{}
	if primary {
		queryParams["filter[is_primary][_eq]"] = "true"
	}
	if language != "" {
		queryParams["filter[languages_code][_eq]"] = language
	}
	translations, err := ListItems[SeasonsTranslation](h.ctx, h.c, "seasons_translations", queryParams)
	if err != nil {
		log.L.Error().Err(err)
	}
	return
}

func (h *Handler) ListShowTranslations(language string, primary bool) (translations []ShowsTranslation) {
	var queryParams = map[string]string{}
	if primary {
		queryParams["filter[is_primary][_eq]"] = "true"
	}
	if language != "" {
		queryParams["filter[languages_code][_eq]"] = language
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
