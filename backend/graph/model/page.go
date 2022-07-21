package gqlmodel

import (
	"context"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"strconv"
)

func PageFromSQL(ctx context.Context, item *sqlc.Page) Page {
	if item.Type.Valid {
		switch item.Type.String {
		case "show":
			return &ShowPage{
				ID: item.Code.ValueOrZero(),
				Show: &Show{
					ID: strconv.Itoa(int(item.ShowID.ValueOrZero())),
				},
			}
		case "episode":
			return &EpisodePage{
				ID: item.Code.ValueOrZero(),
				Episode: &Episode{
					ID: strconv.Itoa(int(item.EpisodeID.ValueOrZero())),
				},
			}
		}
	}
	return nil
}
