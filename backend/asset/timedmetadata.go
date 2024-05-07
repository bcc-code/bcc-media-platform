package asset

import (
	"context"

	"github.com/bcc-code/bcc-media-platform/backend/sqlc"
	"gopkg.in/guregu/null.v4"

	"github.com/bcc-code/bcc-media-platform/backend/common"

	"github.com/ansel1/merry/v2"
	"github.com/google/uuid"
)

type IngestTimedMetadataParams struct {
	VXID     string
	JSONPath string
}

// Ingest timedmetadata from a JSON file based on the vxID
func IngestTimedMetadata(ctx context.Context, services externalServices, config config, params IngestTimedMetadataParams) error {
	queries := services.GetQueries()
	s3client := services.GetS3Client()
	db := services.GetDatabase()

	assetID, err := queries.AssetIDsByMediabankenID(ctx, params.VXID)
	if err != nil {
		return merry.Wrap(err)
	}

	if assetID == 0 {
		return merry.New("asset not found", merry.WithUserMessage("asset not found for VXID: "+params.VXID))
	}

	tx, err := db.Begin()
	if err != nil {
		return merry.Wrap(err)
	}
	defer tx.Rollback()

	qtx := queries.WithTx(tx)

	err = qtx.ClearAssetTimedMetadata(ctx, null.IntFrom(int64(assetID)))
	if err != nil {
		return merry.Wrap(err)
	}

	var chapters []TimedMetadata
	err = readJSONFromS3(ctx, s3client, config.GetIngestBucket(), params.JSONPath, &chapters)
	if err != nil {
		return merry.Wrap(err)
	}

	for _, chapter := range chapters {
		t := common.ChapterTypes.Parse(chapter.ChapterType)
		if t == nil {
			continue
		}
		timedMetadata := sqlc.InsertTimedMetadataParams{
			ID:          uuid.New(),
			ChapterType: null.StringFrom(t.Value),
			Title:       chapter.Title,
			AssetID:     null.IntFrom(int64(assetID)),
			Highlight:   chapter.Highlight,
			Description: chapter.Description,
			Status:      string(common.StatusPublished),
			Label:       chapter.Label,
			Type:        "chapter",
			Seconds:     float32(chapter.Timestamp),
		}

		var personIDs []uuid.UUID
		switch *t {
		case common.ChapterTypeSong:
			// We only want to insert the song number if it is present
			songID, err := getOrInsertSongID(ctx, qtx, chapter.SongCollection, chapter.SongNumber)
			if err != nil {
				return merry.Wrap(err)
			}
			timedMetadata.SongID = uuid.NullUUID{
				Valid: true,
				UUID:  songID,
			}
		case common.ChapterTypeTestimony, common.ChapterTypeAppeal, common.ChapterTypeSpeech:
			// We only want to insert the persons if they are present
			personIDs, err = getOrInsertPersonIDs(ctx, qtx, chapter.Persons)
			if err != nil {
				return merry.Wrap(err)
			}
		}
		err = qtx.InsertTimedMetadata(ctx, timedMetadata)
		if err != nil {
			return merry.Wrap(err)
		}
		for _, p := range personIDs {
			err = qtx.InsertTimedMetadataPerson(ctx, sqlc.InsertTimedMetadataPersonParams{
				PersonsID:       p,
				TimedmetadataID: timedMetadata.ID,
			})
			if err != nil {
				return merry.Wrap(err)
			}
		}
	}
	err = tx.Commit()
	if err != nil {
		return merry.Wrap(err)
	}

	return nil
}
