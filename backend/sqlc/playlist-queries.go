package sqlc

import (
	"context"
	"encoding/json"
	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/google/uuid"
	"github.com/samber/lo"
	"gopkg.in/guregu/null.v4"
)

// GetPlaylists returns playlists from the database
func (q *Queries) GetPlaylists(ctx context.Context, ids []uuid.UUID) ([]common.Playlist, error) {
	rows, err := q.getPlaylists(ctx, ids)
	if err != nil {
		return nil, err
	}
	return lo.Map(rows, func(i getPlaylistsRow, _ int) common.Playlist {
		var title = common.LocaleString{}
		var description = common.LocaleString{}
		_ = json.Unmarshal(i.Title, &title)
		_ = json.Unmarshal(i.Description, &description)

		if i.OriginalTitle != "" {
			title["no"] = null.StringFrom(i.OriginalTitle)
		}
		if i.OriginalDescription.Valid {
			description["no"] = i.OriginalDescription
		}

		return common.Playlist{
			ID:           i.ID,
			CollectionID: i.CollectionID,
			Title:        title,
			Description:  description,
			Images:       q.getImages(i.Images),
		}
	}), nil
}

// ListPlaylists returns playlists from the database
func (q *Queries) ListPlaylists(ctx context.Context) ([]common.Playlist, error) {
	rows, err := q.listPlaylists(ctx)
	if err != nil {
		return nil, err
	}
	return lo.Map(rows, func(i listPlaylistsRow, _ int) common.Playlist {
		var title = common.LocaleString{}
		var description = common.LocaleString{}
		_ = json.Unmarshal(i.Title, &title)
		_ = json.Unmarshal(i.Description, &description)

		if i.OriginalTitle != "" {
			title["no"] = null.StringFrom(i.OriginalTitle)
		}
		if i.OriginalDescription.Valid {
			description["no"] = i.OriginalDescription
		}

		return common.Playlist{
			ID:           i.ID,
			CollectionID: i.CollectionID,
			Title:        title,
			Description:  description,
			Images:       q.getImages(i.Images),
		}
	}), nil
}
