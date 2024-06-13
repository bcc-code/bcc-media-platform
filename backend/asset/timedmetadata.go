package asset

import (
	"cmp"
	"context"
	"sync"

	"github.com/bcc-code/bcc-media-platform/backend/sqlc"
	"github.com/bcc-code/bcc-media-platform/backend/utils"
	"github.com/bcc-code/mediabank-bridge/log"
	"go.opentelemetry.io/otel"
	"go.opentelemetry.io/otel/attribute"
	"go.opentelemetry.io/otel/trace"
	"golang.org/x/exp/slices"
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
	ctx, span := otel.Tracer("timedmetadata").Start(ctx, "ingest", trace.WithAttributes(
		attribute.String("vxid", params.VXID),
		attribute.String("json_path", params.JSONPath)),
	)
	defer span.End()

	s3client := services.GetS3Client()
	var timedMetadatas []TimedMetadata
	err := readJSONFromS3(ctx, s3client, config.GetIngestBucket(), params.JSONPath, &timedMetadatas)
	if err != nil {
		return merry.Wrap(err)
	}

	if len(timedMetadatas) == 0 {
		return merry.New("no timed metadata found", merry.WithUserMessage("no timed metadata found in JSON file"))
	}

	slices.SortStableFunc(timedMetadatas, func(i, j TimedMetadata) int {
		return cmp.Compare(i.Timestamp, j.Timestamp)
	})

	biggestTimestamp := timedMetadatas[len(timedMetadatas)-1].Timestamp

	queries := services.GetQueries()
	assetIDs, err := queries.AssetIDsByMediabankenIDAndMinimumDuration(ctx, sqlc.AssetIDsByMediabankenIDAndMinimumDurationParams{
		MediabankenID:   params.VXID,
		MinimumDuration: int32(biggestTimestamp),
	})
	if err != nil {
		return merry.Wrap(err)
	}

	if len(assetIDs) == 0 {
		span.AddEvent("no assets found for VXID")
		log.L.Trace().Msgf("Timedmetadata ingest: No assets found for VXID %s", params.VXID)
		return nil
	}

	for _, assetID := range assetIDs {
		err = queries.ClearAssetTimedMetadata(ctx, null.IntFrom(int64(assetID)))
		if err != nil {
			return merry.Wrap(err)
		}
	}

	var eg errgroup.Group
	// We lock because of https://github.com/lib/pq/issues/635
	insertLock := sync.Mutex{}
	for _, inputTm := range timedMetadatas {
		inputTm := inputTm
		eg.Go(func() error {
			ctx, span := otel.Tracer("timedmetadata").Start(ctx, "ingest loop goroutine")
			defer span.End()

			var imageFileID *string
			for _, assetID := range assetIDs {
				imageFileID, err = generateImageForAssetAtTime(ctx, services, config, assetID, inputTm.Timestamp+10)
				if err != nil {
					log.L.Warn().Err(err).Msgf("failed to generate image for timed metadata: asset %d @ %fs", assetID, inputTm.Timestamp)
					continue
				}
				break
			}
			insertLock.Lock()
			defer insertLock.Unlock()
			err = ingestOneTimedMetadata(ctx, queries, inputTm, assetIDs, imageFileID)
			if err != nil {
				return merry.Wrap(err)
			}
			return nil
		})
	}

	err = eg.Wait()
	if err != nil {
		return merry.Wrap(err)
	}
	span.AddEvent("ingested all timed metadata")

	log.L.Trace().Msgf("Ingested %d timed metadata for VXID %s into assets %v", len(timedMetadatas), params.VXID, assetIDs)

	return nil
}

// ingestOneTimedMetadata creates one timed metadata with contributions, song, etc.
func ingestOneTimedMetadata(ctx context.Context, queries *sqlc.Queries, inputTm TimedMetadata, assetIDs []int32, imageID *string) error {
	ctx, span := otel.Tracer("timedmetadata").Start(ctx, "ingestOneTimedMetadata")
	defer span.End()

	t := common.ContentTypes.Parse(inputTm.ContentType)
	if t == nil {
		log.L.Warn().Msgf("Unknown content type: %s. Falling back to '%s'.", inputTm.ContentType, common.ContentTypeOther.Value)
		t = &common.ContentTypeOther
		return nil
	}
	realTm := sqlc.InsertTimedMetadataParams{
		ContentType: null.StringFrom(t.Value),
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
		realTm.AssetID = null.IntFrom(int64(assetID))
		tmID, err := queries.InsertTimedMetadata(ctx, realTm)
		if err != nil {
			return merry.Wrap(err)
		}
		for _, p := range personIDs {
			err = queries.InsertContribution(ctx, sqlc.InsertContributionParams{
				PersonID:        p,
				Type:            MapContributionTypeFromContentType(*t).Value,
				TimedmetadataID: uuid.NullUUID{UUID: tmID, Valid: true},
			})

			if err != nil {
				return merry.Wrap(err)
			}
		}
		if imageID != nil {
			styledId, err := queries.InsertStyledImage(ctx, sqlc.InsertStyledImageParams{
				Language: (*utils.FallbackLanguages())[0],
				Style:    common.ImageStyleDefault,
				File:     uuid.MustParse(*imageID),
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

// MapContributionTypeFromContentType guesses the contribution type based on the chapter type
func MapContributionTypeFromContentType(t common.ContentType) common.ContributionType {
	switch t {
	case common.ContentTypeInterview, common.ContentTypeSpeech, common.ContentTypeTestimony, common.ContentTypeTheme:
		return common.ContributionTypeSpeaker
	case common.ContentTypeSingAlong, common.ContentTypeSong:
		return common.ContributionTypeSinger
	}

	return common.ContributionTypeUnknown
}
