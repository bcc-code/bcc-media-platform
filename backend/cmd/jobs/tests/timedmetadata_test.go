package tests

import (
	"bytes"
	"context"
	"database/sql"
	"encoding/base64"
	"encoding/json"
	"io"
	"log"
	"net/http"
	"os"
	"testing"
	"time"

	"github.com/aws/aws-sdk-go-v2/service/s3"
	"github.com/bcc-code/bcc-media-platform/backend/events"
	"github.com/bcc-code/bcc-media-platform/backend/pubsub"
	"github.com/bcc-code/bcc-media-platform/backend/sqlc"
	cloudevents "github.com/cloudevents/sdk-go/v2"
	"github.com/google/uuid"
	"github.com/samber/lo"
	"gopkg.in/guregu/null.v4"

	awsSDKConfig "github.com/aws/aws-sdk-go-v2/config"
	_ "github.com/lib/pq"
	"github.com/stretchr/testify/assert"
)

const dbConnectionString = "postgres://bccm@localhost:5432/bccm?sslmode=disable"

func TestIngestMetadata(t *testing.T) {
	ctx := context.Background()

	db, err := sql.Open("postgres", dbConnectionString)
	if err != nil {
		panic(err)
	}
	defer db.Close()
	queries := sqlc.New(db)

	// Add test data
	vxID, err := uuid.NewRandom()
	if err != nil {
		panic(err)
	}
	assetID, err := queries.InsertAsset(ctx, sqlc.InsertAssetParams{
		MediabankenID: null.StringFrom(vxID.String()),
		Name:          "test",
		Status:        null.StringFrom("published"),
	})
	if err != nil {
		panic(err)
	}

	s3Client, err := getS3Client(ctx)
	if err != nil {
		panic(err)
	}
	err = uploadAllFilesInFolder(ctx, s3Client, "vod-asset-ingest-sta", "testdata/tm")
	if err != nil {
		panic(err)
	}

	// Execute
	e := cloudevents.NewEvent()
	e.SetSource(events.SourceMediaBanken)
	e.SetType(events.TypeAssetTimedMetadataDelivered)
	e.SetData(cloudevents.ApplicationJSON, &events.AssetTimedMetadataDelivered{
		VXID:     vxID.String(),
		JSONPath: "testdata/tm.json",
	})

	j, err := e.MarshalJSON()
	if err != nil {
		panic(err)
	}
	msg := pubsub.Message{
		Message: pubsub.Msg{
			PublishTime: time.Now(),
			Data:        base64.StdEncoding.EncodeToString(j),
		},
		Subscription: "bgjobs",
	}

	msgBytes, err := json.Marshal(msg)
	if err != nil {
		panic(err)
	}

	resp, err := http.Post("http://localhost:8078/api/message", "application/json", bytes.NewBuffer(msgBytes))
	if err != nil {
		panic(err)
	}
	io.Copy(io.Discard, resp.Body)
	assert.Equal(t, http.StatusOK, resp.StatusCode)

	// Assert
	timedmetadata, err := queries.GetAssetTimedMetadata(ctx, null.IntFrom(int64(assetID)))
	if err != nil {
		log.Panicf("GetAssetTimedMetadata: %v", err)
	}

	if len(timedmetadata) == 0 {
		panic("GetAssetTimedMetadata: timedmetadata is empty")
	}

	uuids := lo.Map(timedmetadata, func(t sqlc.GetAssetTimedMetadataRow, _ int) uuid.UUID {
		return t.ID
	})

	fullTimedMetadata, err := queries.GetTimedMetadata(ctx, uuids)
	if err != nil {
		t.Errorf("GetTimedMetadata: %v", err)
	}

	first := fullTimedMetadata[0]
	if len(first.Images) == 0 {
		t.Errorf("GetTimedMetadata: images is empty")
	}
	for _, images := range first.Images {
		if len(images) == 0 {
			t.Errorf("GetTimedMetadata: images is empty")
		}
	}

}

func getS3Client(ctx context.Context) (*s3.Client, error) {
	awsConfig, err := awsSDKConfig.LoadDefaultConfig(ctx)
	if err != nil {
		return nil, err
	}
	awsConfig.Region = "eu-north-1"
	s3Client := s3.NewFromConfig(awsConfig)
	return s3Client, nil
}

func uploadFile(ctx context.Context, s3Client *s3.Client, file io.Reader, bucket string, key string) error {

	_, err := s3Client.PutObject(ctx, &s3.PutObjectInput{
		Bucket: &bucket,
		Key:    &key,
		Body:   file,
	})
	if err != nil {
		return err
	}

	return nil
}

func uploadAllFilesInFolder(ctx context.Context, s3Client *s3.Client, bucket string, folder string) error {
	dir, err := os.ReadDir(folder)
	if err != nil {
		return err
	}

	for _, file := range dir {
		if file.IsDir() {
			continue
		}

		f, err := os.Open(folder + "/" + file.Name())
		if err != nil {
			return err
		}

		err = uploadFile(ctx, s3Client, f, bucket, file.Name())
		if err != nil {
			return err
		}
	}
	return nil
}
