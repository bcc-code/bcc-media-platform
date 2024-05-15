package asset

import (
	"context"
	"os"
	"path"
	"sync"

	"github.com/bcc-code/bcc-media-platform/backend/files"
	"github.com/bcc-code/bcc-media-platform/backend/sqlc"
	"github.com/bcc-code/bcc-media-platform/backend/utils"
	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/samber/lo"
	"golang.org/x/sync/errgroup"
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
	tx, err := db.Begin()
	if err != nil {
		return merry.Wrap(err)
	}
	defer tx.Rollback()
	qtx := queries.WithTx(tx)

	assetIDs, err := qtx.AssetIDsByMediabankenID(ctx, params.VXID)
	if err != nil {
		return merry.Wrap(err)
	}

	if len(assetIDs) == 0 {
		return merry.New("asset not found", merry.WithUserMessage("asset not found for VXID: "+params.VXID))
	}

	for _, assetID := range assetIDs {
		err = qtx.ClearAssetTimedMetadata(ctx, null.IntFrom(int64(assetID)))
		if err != nil {
			return merry.Wrap(err)
		}
	}

	var timedMetadatas []TimedMetadata
	err = readJSONFromS3(ctx, s3client, config.GetIngestBucket(), params.JSONPath, &timedMetadatas)
	if err != nil {
		return merry.Wrap(err)
	}
	imagePaths := lo.FilterMap(timedMetadatas, func(t TimedMetadata, _ int) (string, bool) {
		return t.ImageFilename, t.ImageFilename != ""
	})

	tempDir, err := os.MkdirTemp(config.GetTempDir(), "timedmetadata")
	if err != nil {
		return merry.Wrap(err)
	}
	defer os.RemoveAll(tempDir)

	var eg errgroup.Group
	imageIDs := make(map[string]string)
	var mu sync.Mutex
	for _, image := range imagePaths {
		i := image
		eg.Go(func() error {
			localPath := path.Join(tempDir, i)
			_, err := downloadFromS3(ctx, downloadFromS3Params{
				client:    s3client,
				bucket:    config.GetIngestBucket(),
				path:      i,
				localPath: localPath,
			})
			if err != nil {
				return merry.Wrap(err)
			}

			imageId, err := uploadToPlatform(ctx, services, localPath)
			if err != nil {
				return merry.Wrap(err)
			}
			mu.Lock()
			imageIDs[i] = *imageId
			mu.Unlock()
			return nil
		})
	}
	if err := eg.Wait(); err != nil {
		log.L.Error().Err(err).Msg("Error uploading image")
		return merry.Wrap(err)
	}

	for _, inputTm := range timedMetadatas {
		err = insertTimedMetadata(ctx, inputTm, qtx, assetIDs, imageIDs)
		if err != nil {
			return merry.Wrap(err)
		}
	}

	err = tx.Commit()
	if err != nil {
		return merry.Wrap(err)
	}

	return nil
}

func insertTimedMetadata(ctx context.Context, inputTm TimedMetadata, queries *sqlc.Queries, assetIDs []int32, imageIDs map[string]string) error {
	t := common.ChapterTypes.Parse(inputTm.ChapterType)
	if t == nil {
		log.L.Warn().Msg("Skipping. Unknown chapter type: " + inputTm.ChapterType)
		return nil
	}
	realTm := sqlc.InsertTimedMetadataParams{
		ChapterType: null.StringFrom(t.Value),
		Title:       inputTm.Title,
		Highlight:   inputTm.Highlight,
		Description: inputTm.Description,
		Status:      string(common.StatusPublished),
		Label:       inputTm.Label,
		Type:        "chapter",
		Seconds:     float32(inputTm.Timestamp),
	}

	var personIDs []uuid.UUID
	personIDs, err := getOrInsertPersonIDs(ctx, queries, inputTm.Persons)
	if err != nil {
		return merry.Wrap(err)
	}

	if inputTm.SongCollection != "" && inputTm.SongNumber != "" {
		songID, err := getOrInsertSongID(ctx, queries, inputTm.SongCollection, inputTm.SongNumber)
		if err != nil {
			return merry.Wrap(err)
		}
		realTm.SongID = uuid.NullUUID{
			Valid: true,
			UUID:  songID,
		}
	}

	for _, assetID := range assetIDs {
		realTm.ID = uuid.New()
		realTm.AssetID = null.IntFrom(int64(assetID))
		tmID, err := queries.InsertTimedMetadata(ctx, realTm)
		if err != nil {
			return merry.Wrap(err)
		}
		for _, p := range personIDs {
			err = queries.InsertContribution(ctx, sqlc.InsertContributionParams{
				PersonID:        p,
				Type:            mapContributionType(*t).Value,
				TimedmetadataID: uuid.NullUUID{UUID: tmID, Valid: true},
			})

			if err != nil {
				return merry.Wrap(err)
			}
		}
		if imageId, exists := imageIDs[inputTm.ImageFilename]; exists {
			styledId, err := queries.InsertStyledImage(ctx, sqlc.InsertStyledImageParams{
				Language: (*utils.FallbackLanguages())[0],
				Style:    common.ImageStyleDefault,
				File:     uuid.MustParse(imageId),
			})
			if err != nil {
				return merry.Wrap(err)
			}

			_, err = queries.InsertTimedMetadataStyledImage(ctx, sqlc.InsertTimedMetadataStyledImageParams{
				TimedMetadataID: uuid.NullUUID{UUID: tmID, Valid: true},
				StyledImageID:   uuid.NullUUID{UUID: styledId, Valid: true},
			})
			if err != nil {
				return merry.Wrap(err)
			}
		}
	}
	return nil
}

// mapContributionType guesses the contribution type based on the chapter type
func mapContributionType(t common.ChapterType) common.ContributionType {
	switch t {
	case common.ChapterTypeInterview:
	case common.ChapterTypeSpeech:
	case common.ChapterTypeTestimony:
	case common.ChapterTypeTheme:
		return common.ContributionTypeSpeaker
	case common.ChapterTypeSingAlong:
	case common.ChapterTypeSong:
		return common.ContributionTypeSinger
	}

	return common.ContributionTypeUnknown
}

func uploadToPlatform(ctx context.Context, services externalServices, localPath string) (*string, error) {
	fs := services.GetFileService()
	file, err := os.Open(localPath)
	if err != nil {
		return nil, merry.Wrap(err)
	}
	defer file.Close()

	f, err := fs.UploadFile(ctx, files.UploadFileParams{
		File:     file,
		FileName: path.Base(localPath),
	})
	if err != nil {
		return nil, merry.Wrap(err)
	}

	return &f.ID, nil
}
