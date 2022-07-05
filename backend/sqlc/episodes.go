package sqlc

import (
	"encoding/json"
	"fmt"

	gqlmodel "github.com/bcc-code/brunstadtv/backend/graph/model"
	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/davecgh/go-spew/spew"
)

// AsGQL returns the Episode in GQL format
func (e GetEpisodesWithTranslationsByIDRow) AsGQL() gqlmodel.Program {
	if e.Type == "episode" {
		return e.episodeAsGQL()
	} else if e.Type == "Standalone" {
		return e.standaloneAsGQL()
	}

	log.L.Error().Str("Episode", spew.Sdump(e)).Msg("Unable to convert GetEpisodesWithTranslationsByIDRow to Program")
	return nil
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

func (e GetEpisodesWithTranslationsByIDRow) episodeAsGQL() *gqlmodel.Episode {
	t := map[string]*translation{}
	log.L.Error().Msg("episodeAsGQL")
	err := json.Unmarshal(e.Translations, &t)
	if err != nil {
		log.L.Error().Err(err).Msg("Errror unarshalling Translations")
	}

	// TODO: How is this supposed to work?
	loc := &gqlmodel.LocalizedProgram{}

	return &gqlmodel.Episode{
		Assets:        nil, // TODO
		Chapters:      []*gqlmodel.Chapter{},
		ID:            fmt.Sprintf("%d", e.ID),
		Localizations: loc,
		Title:         t["no"].Title,
		Description:   t["no"].Description,
		// TODO: Missing links to season/(series)
	}
}

func (e GetEpisodesWithTranslationsByIDRow) standaloneAsGQL() *gqlmodel.Standalone {
	t := map[string]*translation{}
	log.L.Error().Msg("episodeAsGQL")
	err := json.Unmarshal(e.Translations, &t)
	if err != nil {
		log.L.Error().Err(err).Msg("Errror unarshalling Translations")
	}

	loc := &gqlmodel.LocalizedProgram{}

	return &gqlmodel.Standalone{
		Assets:        nil, // TODO
		Chapters:      []*gqlmodel.Chapter{},
		ID:            fmt.Sprintf("%d", e.ID),
		Localizations: loc,
		Title:         t["no"].Title,
		Description:   t["no"].Description,
	}
}
