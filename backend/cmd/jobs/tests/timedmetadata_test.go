package tests

import (
	"bytes"
	"cmp"
	"context"
	"database/sql"
	"encoding/base64"
	"encoding/json"
	"io"
	"net/http"
	"slices"
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
	"github.com/stretchr/testify/assert"
	"gopkg.in/guregu/null.v4"

	awsSDKConfig "github.com/aws/aws-sdk-go-v2/config"
	_ "github.com/lib/pq"
	"github.com/shoenig/test"
)

const dbConnectionString = "postgres://bccm@localhost:5432/bccm?sslmode=disable"

func TestTimedMetadataDurations(t *testing.T) {
	if utils.SkipTestIfCI(t) {
		return
	}
	ctx := context.Background()

	db := lo.Must(sql.Open("postgres", dbConnectionString))
	defer db.Close()
	queries := sqlc.New(db)

	vxID := lo.Must(uuid.NewRandom()).String()
	assetID := lo.Must(queries.InsertAsset(ctx, sqlc.InsertAssetParams{
		MediabankenID: null.StringFrom(vxID),
		Name:          "test",
		Status:        null.StringFrom("published"),
		Duration:      70,
	}))

	tm10sec := lo.Must(queries.InsertTimedMetadata(ctx, sqlc.InsertTimedMetadataParams{
		AssetID:     null.IntFrom(int64(assetID)),
		ContentType: null.StringFrom(common.ContentTypeSpeech.Value),
		Seconds:     10,
		Title:       "@10",
		Highlight:   true,
		Type:        "chapter",
	}))

	tm30sec := lo.Must(queries.InsertTimedMetadata(ctx, sqlc.InsertTimedMetadataParams{
		AssetID:     null.IntFrom(int64(assetID)),
		ContentType: null.StringFrom(common.ContentTypeSpeech.Value),
		Seconds:     30,
		Title:       "@30",
		Highlight:   true,
		Type:        "chapter",
	}))

	mediaItemID := lo.Must(queries.InsertMediaItem(ctx, sqlc.InsertMediaItemParams{
		AssetID:     null.IntFrom(int64(assetID)),
		PublishedAt: null.TimeFrom(time.Now().Add(-1 * time.Hour)),
		Label:       "test",
		ContentType: null.StringFrom(common.ContentTypeSpeech.Value),
	}))

	tmMediaItemID := lo.Must(queries.InsertTimedMetadata(ctx, sqlc.InsertTimedMetadataParams{
		MediaitemID: uuid.NullUUID{UUID: mediaItemID, Valid: true},
		ContentType: null.StringFrom(common.ContentTypeSpeech.Value),
		Seconds:     10,
		Title:       "The Beginning",
		Description: "The beginning of the story",
		Highlight:   true,
		Type:        "chapter",
	}))

	tm10secResult := lo.Must(queries.GetTimedMetadata(ctx, []uuid.UUID{tm10sec}))
	test.Eq(t, 10, tm10secResult[0].Timestamp)
	test.Eq(t, 20, tm10secResult[0].Duration)

	tm30secResult := lo.Must(queries.GetTimedMetadata(ctx, []uuid.UUID{tm30sec}))
	test.Eq(t, 30, tm30secResult[0].Timestamp)
	test.Eq(t, 40, tm30secResult[0].Duration)

	tmMediaItemResult := lo.Must(queries.GetTimedMetadata(ctx, []uuid.UUID{tmMediaItemID}))
	test.Eq(t, 10, tmMediaItemResult[0].Timestamp)
	test.Eq(t, 60, tmMediaItemResult[0].Duration)
}

func TestIngestTimedMetadataAvoidDurationMismatch(t *testing.T) {
	if utils.SkipTestIfCI(t) {
		return
	}
	ctx := context.Background()

	db := lo.Must(sql.Open("postgres", dbConnectionString))
	defer db.Close()
	queries := sqlc.New(db)

	vxID := lo.Must(uuid.NewRandom()).String()
	assetID := lo.Must(queries.InsertAsset(ctx, sqlc.InsertAssetParams{
		MediabankenID: null.StringFrom(vxID),
		Name:          "test",
		Status:        null.StringFrom("published"),
		Duration:      60,
	}))

	inputData := []asset.TimedMetadata{
		{
			ContentType: common.ContentTypeSpeech.Value,
			Timestamp:   120,
			Label:       "The Beginning, label",
			Title:       "The Beginning",
			Description: "The beginning of the story",
			Highlight:   true,
			Persons:     []string{"God", "Adam", "Eve"},
		},
		{
			ContentType: common.ContentTypeSpeech.Value,
			Timestamp:   0,
			Label:       "The Beginning, label",
			Title:       "The Beginning",
			Description: "The beginning of the story",
			Highlight:   true,
			Persons:     []string{"God", "Adam", "Eve"},
		},
	}

	uploadTestTimedMetadata(ctx, inputData)
	defer cleanupS3Folder(ctx, "vod-asset-ingest-sta", "testdata/")
	executeIngestTimedMetadata(ctx, t, vxID)

	timedmetadata := lo.Must(queries.GetAssetTimedMetadata(ctx, null.IntFrom(int64(assetID))))
	assert.Len(t, timedmetadata, 0)
}

func TestIngestTimedMetadata(t *testing.T) {
	if utils.SkipTestIfCI(t) {
		return
	}
	ctx := context.Background()

	db := lo.Must(sql.Open("postgres", dbConnectionString))
	defer db.Close()
	queries := sqlc.New(db)

	// Add test data
	vxID := lo.Must(uuid.NewRandom()).String()
	assetID := lo.Must(queries.InsertAsset(ctx, sqlc.InsertAssetParams{
		MediabankenID: null.StringFrom(vxID),
		Name:          "test",
		Status:        null.StringFrom("published"),
		Duration:      600,
	}))

	inputData := []asset.TimedMetadata{
		{
			ContentType: common.ContentTypeSpeech.Value,
			Timestamp:   0,
			Label:       "The Beginning, label",
			Title:       "The Beginning",
			Description: "The beginning of the story",
			Highlight:   true,
			Persons:     []string{"God", "Adam", "Eve"},
		},
		{
			ContentType:    common.ContentTypeSpeech.Value,
			Timestamp:      1,
			Label:          "The Beginning, label",
			Title:          "The Beginning",
			Description:    "The beginning of the story",
			Highlight:      true,
			Persons:        []string{"God", "Adam", "Eve"},
			SongCollection: "WOTL",
			SongNumber:     "123",
		},
		{
			ContentType: common.ContentTypeOther.Value,
			Timestamp:   20,
			Label:       "Some chapter",
			Title:       "Some title",
			Description: "Some description",
			Highlight:   false,
			Persons:     []string{"Person1", "God"},
		},
	}

	uploadTestTimedMetadata(ctx, inputData)
	defer cleanupS3Folder(ctx, "vod-asset-ingest-sta", "testdata/")
	executeIngestTimedMetadata(ctx, t, vxID)

	timedmetadata := lo.Must(queries.GetAssetTimedMetadata(ctx, null.IntFrom(int64(assetID))))
	uuids := lo.Map(timedmetadata, func(t sqlc.GetAssetTimedMetadataRow, _ int) uuid.UUID {
		return t.ID
	})
	fullTimedMetadata := lo.Must(queries.GetTimedMetadata(ctx, uuids))
	assert.Len(t, fullTimedMetadata, len(inputData))

	slices.SortStableFunc(fullTimedMetadata, func(i, j common.TimedMetadata) int {
		return cmp.Compare(i.Timestamp, j.Timestamp)
	})

	for index, input := range inputData {
		imported := fullTimedMetadata[index]
		test.Eq(t, input.ContentType, imported.ContentType.Value)
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
			// check contributions
			// make sure that each person has exactly 1 contribution with the correct type
			for _, personID := range imported.PersonIDs {
				dbContributions := lo.Must(queries.GetContributionsForPerson(ctx, personID))
				contributions := lo.Filter(dbContributions, func(c sqlc.Contribution, _ int) bool {
					return c.TimedmetadataID.UUID == imported.ID
				})
				if len(contributions) != 1 {
					t.Errorf("expected 1 contribution for person %s on timedmetadata %s, got %d", personID, imported.ID, len(contributions))
				}
				inputContentType := *common.ContentTypes.Parse(input.ContentType)
				expectedCntributionType := asset.MapContributionTypeFromContentType(inputContentType)
				if contributions[0].Type != expectedCntributionType.Value {
					t.Errorf("expected contribution type %s, got %s", expectedCntributionType, contributions[0].Type)
				}
			}
		}
	}
}

func uploadTestTimedMetadata(ctx context.Context, inputData []asset.TimedMetadata) {
	jsonData := lo.Must(json.Marshal(inputData))
	lo.Must0(uploadFileToS3(ctx, strings.NewReader(string(jsonData)), "vod-asset-ingest-sta", "testdata/tm.json"))
}

func executeIngestTimedMetadata(ctx context.Context, t *testing.T, vxID string) {
	e := cloudevents.NewEvent()
	e.SetSource(events.SourceMediaBanken)
	e.SetType(events.TypeAssetTimedMetadataDelivered)
	e.SetData(cloudevents.ApplicationJSON, &events.AssetTimedMetadataDelivered{
		VXID:     vxID,
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
		t.Fatalf("Error processing message: %s", body)
	}
	test.Eq(t, http.StatusOK, resp.StatusCode)
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

func uploadFileToS3(ctx context.Context, file io.Reader, bucket string, key string) error {
	s3Client := lo.Must(getS3Client(ctx))
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

func cleanupS3Folder(ctx context.Context, bucket string, s3Folder string) error {
	s3Client := lo.Must(getS3Client(ctx))

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
