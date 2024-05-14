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

	assetIDs, err := queries.AssetIDsByMediabankenID(ctx, params.VXID)
	if err != nil {
		return merry.Wrap(err)
	}

	if len(assetIDs) == 0 {
		return merry.New("asset not found", merry.WithUserMessage("asset not found for VXID: "+params.VXID))
	}

	tx, err := db.Begin()
	if err != nil {
		return merry.Wrap(err)
	}
	defer tx.Rollback()

	qtx := queries.WithTx(tx)

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

	tempDir, err := os.MkdirTemp(config.GetTempDir(), "timedmetadata")
	if err != nil {
		return merry.Wrap(err)
	}
	defer os.RemoveAll(tempDir)

	imagePaths := lo.FilterMap(timedMetadatas, func(t TimedMetadata, _ int) (string, bool) {
		return t.ImageFilename, t.ImageFilename != ""
	})

	var wg sync.WaitGroup
	wg.Add(len(imagePaths))
	imageIDs := make(map[string]string)
	var imageErrors []error
	for _, image := range imagePaths {
		i := image
		go func() {
			defer wg.Done()
			localPath := path.Join(tempDir, i)
			_, err := downloadFromS3(ctx, downloadFromS3Params{
				client:    s3client,
				bucket:    config.GetIngestBucket(),
				path:      i,
				localPath: localPath,
			})
			if err != nil {
				imageErrors = append(imageErrors, err)
				return
			}

			imageId, err := uploadToPlatform(ctx, services, localPath)
			if err != nil {
				imageErrors = append(imageErrors, err)
				return
			}
			imageIDs[i] = *imageId
		}()
	}
	wg.Wait()

	if len(imageErrors) > 0 {
		for _, e := range imageErrors {
			log.L.Error().Err(e).Msg("Error uploading image")
		}
		return merry.Wrap(imageErrors[0])
	}

	for _, inputTm := range timedMetadatas {
		t := common.ChapterTypes.Parse(inputTm.ChapterType)
		if t == nil {
			log.L.Warn().Msg("Skipping. Unknown chapter type: " + inputTm.ChapterType)

			continue
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
		personIDs, err = getOrInsertPersonIDs(ctx, qtx, inputTm.Persons)
		if err != nil {
			return merry.Wrap(err)
		}

		if inputTm.SongCollection != "" && inputTm.SongNumber != "" {
			songID, err := getOrInsertSongID(ctx, qtx, inputTm.SongCollection, inputTm.SongNumber)
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
			tmID, err := qtx.InsertTimedMetadata(ctx, realTm)
			if err != nil {
				return merry.Wrap(err)
			}
			for _, p := range personIDs {
				err = qtx.InsertContribution(ctx, sqlc.InsertContributionParams{
					PersonID:        p,
					Type:            mapContributionType(*t).Value,
					TimedmetadataID: uuid.NullUUID{UUID: tmID, Valid: true},
				})

				if err != nil {
					return merry.Wrap(err)
				}
			}
			imageId := imageIDs[inputTm.ImageFilename]
			styledId, err := qtx.InsertStyledImage(ctx, sqlc.InsertStyledImageParams{
				Language: (*utils.FallbackLanguages())[0],
				Style:    common.ImageStyleDefault,
				File:     uuid.MustParse(imageId),
			})
			if err != nil {
				return merry.Wrap(err)
			}

			_, err = qtx.InsertTimedMetadataStyledImage(ctx, sqlc.InsertTimedMetadataStyledImageParams{
				TimedMetadataID: uuid.NullUUID{UUID: tmID, Valid: true},
				StyledImageID:   uuid.NullUUID{UUID: styledId, Valid: true},
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
