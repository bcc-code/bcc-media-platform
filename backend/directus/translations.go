package directus

import (
	"context"
	"fmt"
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

func (h *Handler) GetEpisodeTranslation(ctx context.Context, id int) (translation EpisodesTranslation) {
	translation, err := GetItem[EpisodesTranslation](ctx, h.c, "episodes_translations", id)
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to retrieve translation")
	}
	return
}

func (h *Handler) GetSeasonTranslation(ctx context.Context, id int) (translation SeasonsTranslation) {
	translation, err := GetItem[SeasonsTranslation](ctx, h.c, "seasons_translations", id)
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to retrieve translation")
	}
	return
}

func (h *Handler) GetShowTranslation(ctx context.Context, id int) (translation ShowsTranslation) {
	translation, err := GetItem[ShowsTranslation](ctx, h.c, "shows_translations", id)
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to retrieve translation")
	}
	return
}

func initListQueryParams(language string, primary bool, parentId int, parentProperty string) map[string]string {
	params := map[string]string{}
	if language != "" {
		params["filter[languages_code][_eq]"] = language
	}
	if primary {
		params["filter[is_primary][_eq]"] = "true"
	}
	if parentId != 0 {
		params[fmt.Sprintf("filter[%s][_eq]", parentProperty)] = strconv.Itoa(parentId)
	}
	return params
}

func listTranslations[t DSItem](ctx context.Context, h *Handler, collection string, queryParams map[string]string) (translations []t) {
	translations, err := ListItems[t](ctx, h.c, collection, queryParams)
	if err != nil {
		log.L.Error().Err(err)
	}
	return
}

func (h *Handler) ListEpisodeTranslations(ctx context.Context, language string, primary bool, episodeId int) []EpisodesTranslation {
	return listTranslations[EpisodesTranslation](ctx, h, "episodes_translations",
		initListQueryParams(language, primary, episodeId, "episodes_id"),
	)
}

func (h *Handler) ListSeasonTranslations(ctx context.Context, language string, primary bool, seasonId int) []SeasonsTranslation {
	return listTranslations[SeasonsTranslation](ctx, h, "seasons_translations",
		initListQueryParams(language, primary, seasonId, "seasons_id"),
	)
}

func (h *Handler) ListShowTranslations(ctx context.Context, language string, primary bool, showId int) (translations []ShowsTranslation) {
	return listTranslations[ShowsTranslation](ctx, h, "shows_translations",
		initListQueryParams(language, primary, showId, "shows_id"),
	)
}

func (h *Handler) SaveTranslations(ctx context.Context, translations []DSItem) {
	for _, item := range translations {
		_, err := SaveItem(ctx, h.c, item, false)
		if err != nil {
			log.L.Error().Err(err).Msg("Failed to save translations")
			return
		}
	}
}
