package statistics

import (
	"context"
	"embed"

	"cloud.google.com/go/bigquery"
	"github.com/ansel1/merry/v2"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/bcc-code/brunstadtv/backend/utils"
	"github.com/bcc-code/mediabank-bridge/log"
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

type DirecusHandler struct {
	bigQueryClient  *bigquery.Client
	bigQueryDataset *bigquery.Dataset
	queries         *sqlc.Queries
}

func NewDirectusHandler(ctx context.Context, bqConfig BigQueryConfig, q *sqlc.Queries) *DirecusHandler {
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

	return &DirecusHandler{
		bigQueryClient:  bqClient,
		bigQueryDataset: bqDataset,
		queries:         q,
	}
}

func (h *DirecusHandler) HandleDirectusEvent(ctx context.Context, collection string, id string) error {
	log.L.Debug().Str("collection", collection).Str("id", id).Msg("Processing directus updates")
	intID := utils.AsInt(id)

	switch collection {
	case "shows":
		return h.handleShow(ctx, intID)
	case "seasons":
		return h.handleSeason(ctx, intID)
	case "episodes":
		return h.handleEpisode(ctx, intID)
	default:
		log.L.Debug().Str("collection", collection).Msg("Cllection not suported. Skipping")
	}
	return nil
}

func (h *DirecusHandler) insert(ctx context.Context, obj interface{}, tableName string) error {
	table := h.bigQueryDataset.Table(tableName)
	inserter := table.Inserter()
	inserter.IgnoreUnknownValues = false
	inserter.SkipInvalidRows = false
	return merry.Wrap(inserter.Put(ctx, obj))
}

func (h *DirecusHandler) handleShow(ctx context.Context, id int) error {
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

	bqShows := lo.Map(shows, ShowFromCommon)
	return h.insert(ctx, bqShows, "shows")
}

func (h *DirecusHandler) handleSeason(ctx context.Context, id int) error {
	log.L.Debug().Int("season_id", id).Msg("updating season in BQ")
	seasons, err := h.queries.GetSeasons(ctx, []int{id})
	if err != nil {
		return merry.Wrap(err)
	}

	if len(seasons) == 0 {
		// Show was deleted. Not supported yet. Log warning and return nil
		log.L.Warn().Int("season id", id).Msg("Attempting to sync a deleted season. Not implemented")
		return nil
	}

	bqSeasons := lo.Map(seasons, SeasonFromCommon)
	return h.insert(ctx, bqSeasons, "seasons")
}

func (h *DirecusHandler) handleEpisode(ctx context.Context, id int) error {
	log.L.Debug().Int("episodeId", id).Msg("updating episode in BQ")
	episodes, err := h.queries.GetEpisodes(ctx, []int{id})
	if err != nil {
		return merry.Wrap(err)
	}

	if len(episodes) == 0 {
		// Show was deleted. Not supported yet. Log warning and return nil
		log.L.Warn().Int("season id", id).Msg("Attempting to sync a deleted season. Not implemented")
		return nil
	}

	bqEpisodes := lo.Map(episodes, EpisodeFromCommon)
	return h.insert(ctx, bqEpisodes, "episodes")
}
