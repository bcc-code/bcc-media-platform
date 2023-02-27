package statistics

import (
	"context"
	"time"

	"cloud.google.com/go/bigquery"
	"github.com/ansel1/merry/v2"
	"google.golang.org/api/iterator"
)

var getLatestExportedAnswerDateSQL = "SELECT MAX(updated) as updated FROM `bccm-k8s-main.rudderstack_prod.answers`"

type latestExportedAnswerDateRow struct {
	Updated time.Time
}

func getLatestExportedAnswerDate(ctx context.Context, bqClient *bigquery.Client, bqDataset *bigquery.Dataset) (time.Time, error) {
	row := latestExportedAnswerDateRow{
		Updated: time.Now().AddDate(-1, 0, 0),
	}

	q := bqClient.Query(getLatestExportedAnswerDateSQL)
	result, err := q.Read(ctx)
	if err != nil {
		return row.Updated, merry.Wrap(err)
	}

	err = result.Next(&row)
	if err == iterator.Done {
		err = nil
	}

	return row.Updated, merry.Wrap(err)
}
