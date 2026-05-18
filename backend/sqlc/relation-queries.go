package sqlc

import (
	"context"

	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/google/uuid"
	"github.com/samber/lo"
)

// GetSongs returns songs for the specified ids
func (q *Queries) GetSongs(ctx context.Context, ids []uuid.UUID) ([]common.Song, error) {
	rows, err := q.getSongs(ctx, ids)
	if err != nil {
		return nil, err
	}
	return lo.Map(rows, func(i Song, _ int) common.Song {
		title := toLocaleString(nil, i.Title)
		return common.Song{
			ID:    i.ID,
			Key:   i.Key,
			Title: title,
			URLs:  i.Urls,
		}
	}), nil
}

// GetSongIDsForMediaItems returns song ids related to mediaitem ids via mediaitems_songs.
func (q *Queries) GetSongIDsForMediaItems(ctx context.Context, ids []uuid.UUID) ([]common.Mapping[uuid.UUID, uuid.UUID], error) {
	rows, err := q.getSongIDsForMediaItems(ctx, ids)
	if err != nil {
		return nil, err
	}
	return lo.Map(rows, func(r getSongIDsForMediaItemsRow, _ int) common.Mapping[uuid.UUID, uuid.UUID] {
		return common.Mapping[uuid.UUID, uuid.UUID]{Key: r.ParentID, Value: r.ID}
	}), nil
}

// GetContributionsForSongs returns contribution rows (person + type) for each of the supplied song ids.
// Rows are tagged with their song id so the list loader can bucket them.
func (q *Queries) GetContributionsForSongs(ctx context.Context, songIDs []uuid.UUID) ([]common.SongContribution, error) {
	rows, err := q.getContributionsForSongs(ctx, songIDs)
	if err != nil {
		return nil, err
	}
	out := make([]common.SongContribution, 0, len(rows))
	for _, r := range rows {
		if !r.SongID.Valid {
			continue
		}
		out = append(out, common.SongContribution{
			SongID:   r.SongID.UUID,
			PersonID: r.PersonID,
			Type:     r.Type,
		})
	}
	return out, nil
}

// GetContributionsForEpisodes returns contribution rows (person + type) for each
// supplied primary_episode_id, aggregated across the episode's mediaitem and
// any timedmetadata chapters. Rows are tagged with the episode id so the list
// loader can bucket them.
func (q *Queries) GetContributionsForEpisodes(ctx context.Context, episodeIDs []int) ([]common.EpisodeContribution, error) {
	ids32 := make([]int32, len(episodeIDs))
	for i, id := range episodeIDs {
		ids32[i] = int32(id)
	}
	rows, err := q.getContributionsForEpisodes(ctx, ids32)
	if err != nil {
		return nil, err
	}
	out := make([]common.EpisodeContribution, 0, len(rows))
	for _, r := range rows {
		if !r.EpisodeID.Valid {
			continue
		}
		out = append(out, common.EpisodeContribution{
			EpisodeID: int(r.EpisodeID.Int64),
			PersonID:  r.PersonID,
			Type:      r.Type,
		})
	}
	return out, nil
}

// GetPersons returns persons for the specified ids
func (q *Queries) GetPersons(ctx context.Context, ids []uuid.UUID) ([]common.Person, error) {
	rows, err := q.getPersons(ctx, ids)
	if err != nil {
		return nil, err
	}
	return lo.Map(rows, func(i getPersonsRow, _ int) common.Person {
		return common.Person{
			ID:     i.ID,
			Name:   i.Name,
			Type:   common.PersonType(i.Type),
			Images: q.getImages(i.Images),
		}
	}), nil
}

// GetPhrases returns phrases for the specified keys
func (q *Queries) GetPhrases(ctx context.Context, keys []string) ([]common.Phrase, error) {
	rows, err := q.getPhrases(ctx, keys)
	if err != nil {
		return nil, err
	}
	return lo.Map(rows, func(i getPhrasesRow, _ int) common.Phrase {
		value := toLocaleString(i.Value, i.OriginalValue)
		return common.Phrase{
			Key:   i.Key,
			Value: value,
		}
	}), nil
}
