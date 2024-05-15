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
	"strings"
	"testing"
	"time"

	"github.com/aws/aws-sdk-go-v2/service/s3"
	"github.com/bcc-code/bcc-media-platform/backend/asset"
	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/events"
	"github.com/bcc-code/bcc-media-platform/backend/pubsub"
	"github.com/bcc-code/bcc-media-platform/backend/sqlc"
	"github.com/bcc-code/bcc-media-platform/backend/utils"
	cloudevents "github.com/cloudevents/sdk-go/v2"
	"github.com/google/uuid"
	"github.com/samber/lo"
	"gopkg.in/guregu/null.v4"

	awsSDKConfig "github.com/aws/aws-sdk-go-v2/config"
	_ "github.com/lib/pq"
	"github.com/shoenig/test"
)

const dbConnectionString = "postgres://bccm@localhost:5432/bccm?sslmode=disable"

func TestIngestTimedMetadata(t *testing.T) {
	ctx := context.Background()

	db := lo.Must(sql.Open("postgres", dbConnectionString))
	defer db.Close()
	queries := sqlc.New(db)

	// Add test data
	vxID := lo.Must(uuid.NewRandom())
	assetID, err := queries.InsertAsset(ctx, sqlc.InsertAssetParams{
		MediabankenID: null.StringFrom(vxID.String()),
		Name:          "test",
		Status:        null.StringFrom("published"),
	})
	if err != nil {
		panic(err)
	}

	var inputData = []asset.TimedMetadata{
		{
			ChapterType:   common.ChapterTypeOther.Value,
			Timestamp:     20,
			Label:         "Some chapter",
			Title:         "Some title",
			Description:   "Some description",
			Highlight:     false,
			ImageFilename: "image.jpg",
			Persons:       []string{"Person1", "God"},
		},
		{
			ChapterType:   common.ChapterTypeSpeech.Value,
			Timestamp:     0,
			Label:         "The Beginning, label",
			Title:         "The Beginning",
			Description:   "The beginning of the story",
			Highlight:     true,
			ImageFilename: "image.jpg",
			Persons:       []string{"God", "Adam", "Eve"},
		},
		{
			ChapterType:    common.ChapterTypeSpeech.Value,
			Timestamp:      0,
			Label:          "The Beginning, label",
			Title:          "The Beginning",
			Description:    "The beginning of the story",
			Highlight:      true,
			ImageFilename:  "image.jpg",
			Persons:        []string{"God", "Adam", "Eve"},
			SongCollection: "WOTL",
			SongNumber:     "123",
		},
	}

	s3Client := lo.Must(getS3Client(ctx))
	jsonData := lo.Must(json.Marshal(inputData))
	lo.Must0(uploadFolderToS3(ctx, s3Client, "vod-asset-ingest-sta", "testdata/"))
	lo.Must0(uploadFileToS3(ctx, s3Client, strings.NewReader(string(jsonData)), "vod-asset-ingest-sta", "testdata/tm.json"))
	defer deleteFolderOnS3(ctx, s3Client, "vod-asset-ingest-sta", "testdata/")

	// Execute
	e := cloudevents.NewEvent()
	e.SetSource(events.SourceMediaBanken)
	e.SetType(events.TypeAssetTimedMetadataDelivered)
	e.SetData(cloudevents.ApplicationJSON, &events.AssetTimedMetadataDelivered{
		VXID:     vxID.String(),
		JSONPath: "testdata/tm.json",
	})

	j := lo.Must(e.MarshalJSON())
	msg := pubsub.Message{
		Message: pubsub.Msg{
			PublishTime: time.Now(),
			Data:        base64.StdEncoding.EncodeToString(j),
		},
		Subscription: "bgjobs",
	}

	msgBytes := lo.Must(json.Marshal(msg))

	resp := lo.Must(http.Post("http://localhost:8078/api/message", "application/json", bytes.NewBuffer(msgBytes)))
	body := lo.Must(io.ReadAll(resp.Body))
	if strings.Contains(string(body), "error") {
		log.Panicf("Error processing message: %s", body)
	}
	test.Eq(t, http.StatusOK, resp.StatusCode)

	// Assert
	timedmetadata, err := queries.GetAssetTimedMetadata(ctx, null.IntFrom(int64(assetID)))
	if err != nil {
		log.Panicf("%v", err)
	}

	if len(timedmetadata) == 0 {
		panic("timedmetadata is empty")
	}

	uuids := lo.Map(timedmetadata, func(t sqlc.GetAssetTimedMetadataRow, _ int) uuid.UUID {
		return t.ID
	})

	fullTimedMetadata, err := queries.GetTimedMetadata(ctx, uuids)
	if err != nil {
		t.Errorf("%v", err)
	}

	if len(fullTimedMetadata) != len(inputData) {
		t.Errorf("length mismatch")
	}

	for index, input := range inputData {
		imported := fullTimedMetadata[index]
		test.Eq(t, input.ChapterType, imported.ChapterType.Value)
		test.Eq(t, input.Timestamp, imported.Timestamp)
		test.Eq(t, input.Title, imported.Title.Get(*utils.FallbackLanguages()))
		test.Eq(t, input.Description, imported.Description.Get(*utils.FallbackLanguages()))
		if input.SongCollection != "" {
			songId := lo.Must(queries.GetCollectionSongID(ctx, sqlc.GetCollectionSongIDParams{
				CollectionKey: input.SongCollection,
				SongKey:       input.SongNumber,
			}))
			test.Eq(t, songId, imported.SongID.UUID)
		}
		if input.ImageFilename != "" {
			image := imported.Images.GetDefault(*utils.FallbackLanguages(), common.ImageStyleDefault)
			test.StrContains(t, *image, input.ImageFilename)
		}
		if len(input.Persons) > 0 {
			if len(input.Persons) != len(imported.PersonIDs) {
				t.Errorf("GetTimedMetadata: persons length mismatch")
			} else {

				dbPersons := lo.Must(queries.GetPersons(ctx, imported.PersonIDs))
				for _, name := range input.Persons {
					anyWithName := lo.SomeBy(dbPersons, func(p common.Person) bool {
						return p.Name == name
					})
					if !anyWithName {
						t.Errorf("person not found")
					}
				}
			}
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

func uploadFileToS3(ctx context.Context, s3Client *s3.Client, file io.Reader, bucket string, key string) error {
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

func uploadFolderToS3(ctx context.Context, s3Client *s3.Client, bucket string, folder string) error {
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

		err = uploadFileToS3(ctx, s3Client, f, bucket, file.Name())
		if err != nil {
			return err
		}
	}
	return nil
}

func deleteFolderOnS3(ctx context.Context, s3Client *s3.Client, bucket string, s3Folder string) error {
	s3Folder = strings.TrimSuffix(s3Folder, "/") + "/"
	objects, err := s3Client.ListObjectsV2(ctx, &s3.ListObjectsV2Input{
		Bucket: &bucket,
		Prefix: &s3Folder,
	})
	if err != nil {
		return err
	}

	for _, obj := range objects.Contents {
		_, err := s3Client.DeleteObject(ctx, &s3.DeleteObjectInput{
			Bucket: &bucket,
			Key:    obj.Key,
		})
		if err != nil {
			return err
		}
	}
	return nil
}
