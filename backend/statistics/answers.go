package statistics

import (
	"context"
	"time"

	"cloud.google.com/go/bigquery"
	"github.com/ansel1/merry/v2"
	"github.com/bcc-code/bcc-media-platform/backend/sqlc"
	"github.com/google/uuid"
	"google.golang.org/api/iterator"
)

var getLatestExportedAnswerDateSQL = "SELECT MAX(updated) as updated FROM `bccm-k8s-main.rudderstack_prod.answers`"

type latestExportedAnswerDateRow struct {
	Updated time.Time
}

// GetAnswersSinceBQRow is a row
type GetAnswersSinceBQRow struct {
	Message  string    `bigquery:"message"`
	ItemID   uuid.UUID `bigquery:"item_id"`
	Rating   int32     `bigquery:"rating"`
	AgeGroup string    `bigquery:"age_group"`
	OrgID    int       `bigquery:"org_id"`
	Updated  time.Time `bigquery:"updated"`
}

func answerRowToBQRow(r sqlc.GetAnswersSinceRow, _ int) GetAnswersSinceBQRow {
	return GetAnswersSinceBQRow{
		Message:  r.Message,
		ItemID:   r.ItemID,
		Rating:   r.Rating,
		AgeGroup: r.AgeGroup.String,
		OrgID:    int(r.OrgID.Int64),
		Updated:  r.Updated.Time,
	}
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
