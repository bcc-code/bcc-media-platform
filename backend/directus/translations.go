package directus

import (
	"context"
	"fmt"
	"github.com/bcc-code/mediabank-bridge/log"
	"strconv"
)

// Translation model
type Translation struct {
	ID            int    `json:"id,omitempty"`
	Title         string `json:"title"`
	Description   string `json:"description,omitempty"`
	LanguagesCode string `json:"languages_code"`
	IsPrimary     bool   `json:"is_primary"`
}

// EpisodesTranslation extends Translation
type EpisodesTranslation struct {
	Translation
	EpisodesID       int    `json:"episodes_id"`
	ExtraDescription string `json:"extra_description,omitempty"`
}

// SeasonsTranslation extends Translation
type SeasonsTranslation struct {
	Translation
	SeasonsID int `json:"seasons_id"`
}

// ShowsTranslation extends Translation
type ShowsTranslation struct {
	Translation
	ShowsID int `json:"shows_id"`
}

// SectionsTranslation extends Translation
type SectionsTranslation struct {
	Translation
	SectionsID int `json:"sections_id"`
}

// PagesTranslation extends Translation
type PagesTranslation struct {
	Translation
	PagesID int `json:"sections_id"`
}

type update struct {
	Title       string `json:"title"`
	Description string `json:"description"`
}

type episodesUpdate struct {
	update
	ExtraDescription string `json:"extra_description"`
}

// UID retrieves the not so unique ID (except internally in Collection)
func (i Translation) UID() string {
	if i.ID == 0 {
		return ""
	}
	return strconv.Itoa(i.ID)
}

// ForUpdate retrieves a struct with mutable properties
func (i Translation) ForUpdate() interface{} {
	return update{
		i.Title,
		i.Description,
	}
}

// ForUpdate retrieves a struct with mutable properties
func (i EpisodesTranslation) ForUpdate() interface{} {
	return episodesUpdate{
		update{
			i.Title,
			i.Description,
		},
		i.ExtraDescription,
	}
}

// TypeName episodes_translations
func (EpisodesTranslation) TypeName() string {
	return "episodes_translations"
}

// TypeName seasons_translations
func (SeasonsTranslation) TypeName() string {
	return "seasons_translations"
}

// TypeName shows_translations
func (ShowsTranslation) TypeName() string {
	return "shows_translations"
}

// TypeName shows_translations
func (SectionsTranslation) TypeName() string {
	return "sections_translations"
}

// TypeName shows_translations
func (PagesTranslation) TypeName() string {
	return "pages_translations"
}

// GetLanguage retrieves the configured language for this translation
func (i Translation) GetLanguage() string {
	return i.LanguagesCode
}

// GetValues retrieves a map with the values used in translations
func (i Translation) GetValues() map[string]string {
	return map[string]string{
		"title":       i.Title,
		"description": i.Description,
	}
}

func (i EpisodesTranslation) GetValues() map[string]string {
	return map[string]string{
		"title":             i.Title,
		"description":       i.Description,
		"extra_description": i.ExtraDescription,
	}
}

// GetCollection episodes
func (i EpisodesTranslation) GetCollection() string {
	return "episodes"
}

// GetItemID retrieves parentId
func (i EpisodesTranslation) GetItemID() int {
	return i.EpisodesID
}

// GetCollection seasons
func (i SeasonsTranslation) GetCollection() string {
	return "seasons"
}

// GetItemID retrieves parentId
func (i SeasonsTranslation) GetItemID() int {
	return i.SeasonsID
}

// GetCollection shows
func (i ShowsTranslation) GetCollection() string {
	return "shows"
}

// GetItemID retrieves parentId
func (i ShowsTranslation) GetItemID() int {
	return i.ShowsID
}

// GetEpisodeTranslation retrieves a translation by id
func (h *Handler) GetEpisodeTranslation(ctx context.Context, id int) (translation EpisodesTranslation) {
	translation, err := GetItem[EpisodesTranslation](ctx, h.c, "episodes_translations", id)
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to retrieve translation")
	}
	return
}

// GetSeasonTranslation retrieves a translation by id
func (h *Handler) GetSeasonTranslation(ctx context.Context, id int) (translation SeasonsTranslation) {
	translation, err := GetItem[SeasonsTranslation](ctx, h.c, "seasons_translations", id)
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to retrieve translation")
	}
	return
}

// GetShowTranslation retrieves a translation by id
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

func listTranslations[t DSItem](ctx context.Context, h *Handler, collection string, queryParams map[string]string) (translations []t, err error) {
	return ListItems[t](ctx, h.c, collection, queryParams)
}

// ListEpisodeTranslations lists translations (for language, as primary or with episodeId)
func (h *Handler) ListEpisodeTranslations(ctx context.Context, language string, primary bool, episodeId int) ([]EpisodesTranslation, error) {
	return listTranslations[EpisodesTranslation](ctx, h, "episodes_translations",
		initListQueryParams(language, primary, episodeId, "episodes_id"),
	)
}

// ListSeasonTranslations lists translations (for language, as primary or with episodeId)
func (h *Handler) ListSeasonTranslations(ctx context.Context, language string, primary bool, seasonId int) ([]SeasonsTranslation, error) {
	return listTranslations[SeasonsTranslation](ctx, h, "seasons_translations",
		initListQueryParams(language, primary, seasonId, "seasons_id"),
	)
}

// ListShowTranslations lists translations (for language, as primary or with episodeId)
func (h *Handler) ListShowTranslations(ctx context.Context, language string, primary bool, showId int) ([]ShowsTranslation, error) {
	return listTranslations[ShowsTranslation](ctx, h, "shows_translations",
		initListQueryParams(language, primary, showId, "shows_id"),
	)
}

// SaveTranslations saves translations (or other DS items)
func (h *Handler) SaveTranslations(ctx context.Context, translations []DSItem) error {
	return SaveItems(ctx, h.c, translations)
}
