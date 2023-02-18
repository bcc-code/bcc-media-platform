package statistics

import (
	"context"
	"embed"
	"fmt"
	"net/http"
	"time"

	"cloud.google.com/go/bigquery"
	"github.com/ansel1/merry/v2"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/bcc-code/brunstadtv/backend/utils"
	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/samber/lo"
	"go.opentelemetry.io/otel"
	"google.golang.org/api/googleapi"
	"gopkg.in/guregu/null.v4"
)

// Embed the migrations into the binary
//
//go:embed bq-schema/*.json
var bqMigrationsJson embed.FS

type BigQueryConfig struct {
	ProjectID string
	DatasetID string
}

func bqTableExistsOrCreate(ctx context.Context, dataset *bigquery.Dataset, tableName string) error {
	t := dataset.Table(tableName)
	_, err := t.Metadata(ctx)
	if err == nil {
		// Table Exists
		return nil
	}

	if e, ok := err.(*googleapi.Error); !ok || e.Code != http.StatusNotFound {
		// Unknown error
		return merry.Wrap(err)
	}

	// Table does not exist

	schemaBytes, err := bqMigrationsJson.ReadFile(fmt.Sprintf("bq-schema/%s.json", tableName))
	if err != nil {
		return merry.Wrap(err)
	}

	schema, err := bigquery.SchemaFromJSON(schemaBytes)
	if err != nil {
		return merry.Wrap(err)
	}

	tm := &bigquery.TableMetadata{}
	tm.Name = tableName
	tm.Clustering = &bigquery.Clustering{Fields: []string{"Updated"}}
	tm.TimePartitioning = &bigquery.TimePartitioning{Field: "Updated", Type: bigquery.YearPartitioningType, RequirePartitionFilter: false}
	tm.Schema = schema.Relax() // Make sure everyting is nullable. This is ok for stats

	err = t.Create(ctx, tm)
	return merry.Wrap(err)
}

var bqTables = []string{
	"shows",
	"seasons",
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

type DirecusHandler struct {
	bigQueryClient  *bigquery.Client
	bigQueryDataset *bigquery.Dataset
	queries         *sqlc.Queries
}

func (h *DirecusHandler) HandleDirectusEvent(ctx context.Context, collection string, id string) error {
	log.L.Debug().Str("collection", collection).Str("id", id).Msg("Processing directus updates")
	intID := utils.AsInt(id)

	switch collection {
	case "shows":
		return h.handleShow(ctx, intID)
	case "seasons":
		return h.handleSeason(ctx, intID)
	default:
		log.L.Debug().Str("collection", collection).Msg("Cllection not suported. Skipping")
	}
	return nil
}

type bqShow struct {
	common.Show
	Updated time.Time
	Deleted null.Time
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
