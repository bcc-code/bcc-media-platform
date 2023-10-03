package asset

import (
	"context"
	"database/sql"
	"errors"
	"github.com/bcc-code/bcc-media-platform/backend/sqlc"
	"github.com/google/uuid"
	"github.com/samber/lo"
)

func getOrInsertSongID(ctx context.Context, queries *sqlc.Queries, collectionKey, songKey string) (uuid.UUID, error) {
	songID, err := queries.GetCollectionSongID(ctx, sqlc.GetCollectionSongIDParams{
		CollectionKey: collectionKey,
		SongKey:       songKey,
	})
	noRows := errors.Is(err, sql.ErrNoRows)
	if err != nil && !noRows {
		return songID, err
	}
	if songID == uuid.Nil || noRows {
		songID = uuid.New()

		collectionID, err := getOrInsertSongCollectionID(ctx, queries, collectionKey)
		if err != nil {
			return songID, err
		}
		err = queries.InsertSong(ctx, sqlc.InsertSongParams{
			ID:           songID,
			Key:          songKey,
			Title:        collectionKey + " " + songKey,
			CollectionID: collectionID,
		})
		if err != nil {
			return songID, err
		}
	}
	return songID, nil
}

func getOrInsertSongCollectionID(ctx context.Context, queries *sqlc.Queries, key string) (uuid.UUID, error) {
	collectionID, err := queries.GetCollectionIDFromKey(ctx, key)
	noRows := errors.Is(err, sql.ErrNoRows)
	if err != nil && !noRows {
		return collectionID, err
	}
	if collectionID == uuid.Nil || noRows {
		collectionID = uuid.New()
		err = queries.InsertSongCollection(ctx, sqlc.InsertSongCollectionParams{
			ID:  collectionID,
			Key: key,
		})
		if err != nil {
			return collectionID, err
		}
	}
	return collectionID, nil
}

func getOrInsertPersonIDs(ctx context.Context, queries *sqlc.Queries, names []string) ([]uuid.UUID, error) {
	persons, err := queries.GetPersonIDsByNames(ctx, names)
	if err != nil {
		return nil, err
	}
	for _, name := range names {
		hasPerson := lo.SomeBy(persons, func(person sqlc.Person) bool {
			return person.Name == name
		})
		if !hasPerson {
			newPerson := sqlc.Person{
				ID:   uuid.New(),
				Name: name,
			}
			err = queries.InsertPerson(ctx, sqlc.InsertPersonParams{
				ID:   newPerson.ID,
				Name: name,
			})
			if err != nil {
				return nil, err
			}
			persons = append(persons, newPerson)
		}
	}
	return lo.Map(persons, func(i sqlc.Person, _ int) uuid.UUID {
		return i.ID
	}), nil
}
