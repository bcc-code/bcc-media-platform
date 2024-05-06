package statistics

import (
	"context"
	"embed"

	"cloud.google.com/go/bigquery"
	"github.com/ansel1/merry/v2"
	"github.com/bcc-code/bcc-media-platform/backend/sqlc"
	"github.com/bcc-code/bcc-media-platform/backend/utils"
	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/google/uuid"
	"github.com/samber/lo"
	"go.opentelemetry.io/otel"
)

var bqTables = []string{
	"shows",
	"seasons",
	"episodes",
}

// Embed the migrations into the binary
//
//go:embed bq-schema/*.json
var bqMigrationsJson embed.FS

type BigQueryConfig struct {
	ProjectID string
	DatasetID string
}

type Handler struct {
	bigQueryClient  *bigquery.Client
	bigQueryDataset *bigquery.Dataset
	queries         *sqlc.Queries
}

func NewHandler(ctx context.Context, bqConfig BigQueryConfig, q *sqlc.Queries) *Handler {
	ctx, span := otel.Tracer("statistics").Start(ctx, "NewDirectusHandler")
	defer span.End()

	bqClient, err := bigquery.NewClient(ctx, bqConfig.ProjectID)
	if err != nil || bqConfig.ProjectID == "" || bqConfig.DatasetID == "" {
		log.L.Warn().
			Err(err).
			Str("ProjectID", bqConfig.ProjectID).
			Str("DatasetID", bqConfig.DatasetID).
			Msg("Failed to set up BQ client. Data will not be exported to BQ")
		return nil
	}

	bqDataset := bqClient.Dataset(bqConfig.DatasetID)

	for _, tableName := range bqTables {
		err := bqTableExistsOrCreate(ctx, bqDataset, tableName)
		if err != nil {
			log.L.Error().
				Err(err).
				Str("ProjectID", bqConfig.ProjectID).
				Str("DatasetID", bqConfig.DatasetID).
				Str("TableName", tableName).
				Msg("Failed to load or create table in BQ")
		}
	}

	return &Handler{
		bigQueryClient:  bqClient,
		bigQueryDataset: bqDataset,
		queries:         q,
	}
}

func (h *Handler) HandleDirectusEvent(ctx context.Context, collection string, id string) error {
	log.L.Debug().Str("collection", collection).Str("id", id).Msg("Processing directus updates")
	intID := utils.AsInt(id)

	switch collection {
	case "shows":
		return h.handleShow(ctx, intID)
	case "seasons":
		return h.handleSeason(ctx, intID)
	case "episodes":
		return h.handleEpisode(ctx, intID)
	case "timedmetadata":
		return h.handleTimedMetadata(ctx, id)
	case "mediaitems":
		return h.handleMediaitem(ctx, id)
	case "shorts":
		return h.handleShort(ctx, id)
	case "calendarentries":
		return h.handleCalendarEntry(ctx, id)
	default:
		log.L.Debug().Str("collection", collection).Msg("Cllection not suported. Skipping")
	}
	return nil
}

func (h *Handler) insert(ctx context.Context, obj interface{}, tableName string) error {
	table := h.bigQueryDataset.Table(tableName)
	inserter := table.Inserter()
	inserter.IgnoreUnknownValues = false
	inserter.SkipInvalidRows = false
	return merry.Wrap(inserter.Put(ctx, obj))
}

func (h *Handler) handleShow(ctx context.Context, id int) error {
	log.L.Debug().Int("show_id", id).Msg("updating show in BQ")
	shows, err := h.queries.GetShows(ctx, []int{id})
	if err != nil {
		return merry.Wrap(err)
	}

	if len(shows) == 0 {
		// Show was deleted. Not supported yet. Log warning and return nil
		log.L.Warn().Int("show id", id).Msg("Attempting to sync a deleted show. Not implemented")
		return nil
	}

	bqShows, err := h.resolveShows(ctx, shows)
	if err != nil {
		return merry.Wrap(err)
	}
	return h.insert(ctx, bqShows, "shows")
}

func (h *Handler) handleSeason(ctx context.Context, id int) error {
	log.L.Debug().Int("season_id", id).Msg("updating season in BQ")
	seasons, err := h.queries.GetSeasons(ctx, []int{id})
	if err != nil {
		return merry.Wrap(err)
	}

	if len(seasons) == 0 {
		// Season was deleted. Not supported yet. Log warning and return nil
		log.L.Warn().Int("season id", id).Msg("Attempting to sync a deleted season. Not implemented")
		return nil
	}

	bqSeasons, err := h.resolveSeasons(ctx, seasons)
	if err != nil {
		return merry.Wrap(err)
	}
	return h.insert(ctx, bqSeasons, "seasons")
}

func (h *Handler) handleEpisode(ctx context.Context, id int) error {
	log.L.Debug().Int("episodeId", id).Msg("updating episode in BQ")
	episodes, err := h.queries.GetEpisodes(ctx, []int{id})
	if err != nil {
		return merry.Wrap(err)
	}

	if len(episodes) == 0 {
		// Show was deleted. Not supported yet. Log warning and return nil
		log.L.Warn().Int("episode id", id).Msg("Attempting to sync a deleted episode. Not implemented")
		return nil
	}

	bqEpisodes, err := h.resolveEpisodes(ctx, episodes)
	if err != nil {
		return merry.Wrap(err)
	}
	return h.insert(ctx, bqEpisodes, "episodes")
}

func (h *Handler) handleTimedMetadata(ctx context.Context, id string) error {
	log.L.Debug().Str("timedMetadata", id).Msg("updating timedMetadata in BQ")
	tmUuid := utils.AsUuid(id)
	timedMetadatas, err := h.queries.GetTimedMetadata(ctx, []uuid.UUID{tmUuid})
	if err != nil {
		return merry.Wrap(err)
	}

	if len(timedMetadatas) == 0 {
		// Was deleted. Not supported yet. Log warning and return nil
		log.L.Warn().Str("timed metadata id", id).Msg("Attempting to sync a deleted timed metadata. Not implemented")
		return nil
	}

	bqTimedMetadatas := lo.Map(timedMetadatas, TimedMetadataFromCommon)
	return h.insert(ctx, bqTimedMetadatas, "timedmetadata")
}

// handleMediaitem updated the related shorts in BQ
//
// This is intentinall as most of the data about the short is stored in the mediaitem
func (h *Handler) handleMediaitem(ctx context.Context, id string) error {
	log.L.Debug().Str("mediaitem", id).Msg("updating mediaitem in BQ")
	miUuid := utils.AsUuid(id)
	shorts, err := h.queries.GetShortsByMediaItemIDs(ctx, miUuid)
	if err != nil {
		return merry.Wrap(err)
	}

	bqShorts, err := h.resolveShorts(ctx, shorts)
	if err != nil {
		return merry.Wrap(err)
	}

	err = h.insert(ctx, bqShorts, "shorts")
	if err != nil {
		return merry.Wrap(err)
	}

	episodeIDs, err := h.queries.GetEpisodeIDsByMediaItemID(ctx, miUuid)
	if err != nil {
		return merry.Wrap(err)
	}

	episodes, err := h.queries.GetEpisodes(ctx, episodeIDs)
	if err != nil {
		return merry.Wrap(err)
	}

	bqEpisodes, err := h.resolveEpisodes(ctx, episodes)
	if err != nil {
		return merry.Wrap(err)
	}

	return h.insert(ctx, bqEpisodes, "episodes")
}

func (h *Handler) handleShort(ctx context.Context, id string) error {
	log.L.Debug().Str("shorts", id).Msg("updating shorts in BQ")
	shortUuid := utils.AsUuid(id)
	shorts, err := h.queries.GetShorts(ctx, []uuid.UUID{shortUuid})
	if err != nil {
		return merry.Wrap(err)
	}

	bqShorts, err := h.resolveShorts(ctx, shorts)
	if err != nil {
		return merry.Wrap(err)
	}
	return h.insert(ctx, bqShorts, "shorts")
}

func (h *Handler) handleCalendarEntry(ctx context.Context, id string) error {
	log.L.Debug().Str("calendarEntry", id).Msg("updating calendarEntry in BQ")
	event, err := h.queries.GetCalendarEntriesByID(ctx, []int{utils.AsInt(id)})
	if err != nil {
		return merry.Wrap(err)
	}

	bqEvents := lo.Map(event, CalendarEntryFromCommon)
	return h.insert(ctx, bqEvents, "calendar_entries")
}

func (h *Handler) HandleAnswerExportToBQ(ctx context.Context) error {
	lastExported, err := getLatestExportedAnswerDate(ctx, h.bigQueryClient, h.bigQueryDataset)
	if err != nil {
		return err
	}

	log.L.Debug().Time("last exported answer", lastExported).Msg("Starting export of answers to BQ")

	res, err := h.queries.GetAnswersSince(ctx, lastExported)
	if err != nil {
		return err
	}

	bqAnswers := lo.Map(res, answerRowToBQRow)
	log.L.Debug().Int("new answer count", len(bqAnswers)).Msg("Fetched answers to export")
	return h.insert(ctx, bqAnswers, "answers")
}
