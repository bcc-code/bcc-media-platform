package sqlc

import (
	"encoding/json"
	"fmt"

	gqlmodel "github.com/bcc-code/brunstadtv/backend/graph/model"
	"github.com/bcc-code/mediabank-bridge/log"
)

// AsGQL returns the Episode in GQL format
func (e GetEpisodesWithTranslationsByIDRow) AsGQL() *gqlmodel.Episode {
	t := map[string]*translation{}
	log.L.Error().Msg("episodeAsGQL")
	err := json.Unmarshal(e.Translations, &t)
	if err != nil {
		log.L.Error().Err(err).Msg("Errror unarshalling Translations")
	}

	return &gqlmodel.Episode{
		Assets:      []*gqlmodel.Asset{},   // TODO
		Chapters:    []*gqlmodel.Chapter{}, // Currently not supported
		ID:          fmt.Sprintf("%d", e.ID),
		Title:       t["no"].Title, // selectLang(t.Title)
		Description: t["no"].Description,
	}
}

type translation struct {
	ID               int    `json:"id"`
	Title            string `json:"title"`
	IsPrimary        bool   `json:"is_primary"`
	Description      string `json:"description"`
	EpisodeID        int    `json:"episodes_id"`
	LanguageCode     string `json:"languages_code"`
	ExtraDescription string `json:"extra_description"`
}
