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
			Title: title,
		}
	}), nil
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
