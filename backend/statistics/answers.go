package statistics

import (
	"context"
	"time"

	"cloud.google.com/go/bigquery"
	"github.com/ansel1/merry/v2"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/google/uuid"
	"google.golang.org/api/iterator"
	null "gopkg.in/guregu/null.v4"
)

var getLatestExportedAnswerDateSQL = "SELECT MAX(updated) as updated FROM `bccm-k8s-main.rudderstack_prod.answers`"

type latestExportedAnswerDateRow struct {
	Updated time.Time
}

type GetAnswersSinceBQRow struct {
	Message  string      `bigquery:"message"`
	ItemID   uuid.UUID   `bigquery:"item_id"`
	Rating   int32       `bigquery:"rating"`
	AgeGroup null.String `bigquery:"age_group"`
	OrgID    null.Int    `bigquery:"org_id"`
	Updated  null.Time   `bigquery:"updated"`
}

func answerRowToBQRow(r sqlc.GetAnswersSinceRow, _ int) GetAnswersSinceBQRow {
	return GetAnswersSinceBQRow{
		Message:  r.Message,
		ItemID:   r.ItemID,
		Rating:   r.Rating,
		AgeGroup: r.AgeGroup,
		OrgID:    r.OrgID,
		Updated:  r.Updated,
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
