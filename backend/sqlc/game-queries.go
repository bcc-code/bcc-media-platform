package sqlc

import (
	"context"
	"encoding/json"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/google/uuid"
	"github.com/samber/lo"
	"gopkg.in/guregu/null.v4"
)

// GetGames returns games from the database
func (q *Queries) GetGames(ctx context.Context, ids []uuid.UUID) ([]common.Game, error) {
	rows, err := q.getGames(ctx, ids)
	if err != nil {
		return nil, err
	}
	return lo.Map(rows, func(i getGamesRow, _ int) common.Game {
		var title = common.LocaleString{}
		var description = common.LocaleString{}
		_ = json.Unmarshal(i.Title.RawMessage, &title)
		_ = json.Unmarshal(i.Description.RawMessage, &description)

		if i.OriginalTitle != "" {
			title["no"] = null.StringFrom(i.OriginalTitle)
		}
		if i.OriginalDescription.Valid {
			description["no"] = i.OriginalDescription
		}

		return common.Game{
			ID:           i.ID,
			Url:          i.Url,
			RequiresAuth: i.RequiresAuthentication,
			Title:        title,
			Description:  description,
		}
	}), nil
}
