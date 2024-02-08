package statistics

import (
	"context"
	"fmt"
	"net/http"

	"cloud.google.com/go/bigquery"
	"github.com/ansel1/merry/v2"
	"google.golang.org/api/googleapi"
	"gopkg.in/guregu/null.v4"
)

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

	tm := &bigquery.TableMetadata{
		RequirePartitionFilter: false,
	}
	tm.Name = tableName
	tm.Clustering = &bigquery.Clustering{Fields: []string{"Updated"}}
	tm.TimePartitioning = &bigquery.TimePartitioning{Field: "Updated", Type: bigquery.YearPartitioningType}
	tm.Schema = schema.Relax() // Make sure everyting is nullable. This is ok for stats

	err = t.Create(ctx, tm)
	return merry.Wrap(err)
}

func nullIntToBQNullString(i null.Int) bigquery.NullString {
	var s *string
	if i.Valid {
		v := fmt.Sprintf("%d", i.Int64)
		s = &v
	}
	return nullStr(s)
}
