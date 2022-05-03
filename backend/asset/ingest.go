package asset

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"io/ioutil"
	"time"

	"github.com/ansel1/merry"
	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/service/mediapackagevod"
	"github.com/aws/aws-sdk-go-v2/service/s3"
	"github.com/aws/aws-sdk-go-v2/service/s3/types"
	"github.com/bcc-code/brunstadtv/backend/events"
	"github.com/bcc-code/mediabank-bridge/log"
	cloudevents "github.com/cloudevents/sdk-go/v2"
	"github.com/google/uuid"
)

// Sentinel errors
var (
	ErrDurationEmpty = merry.New("duration string can not be empty")
)

type smilFormat struct {
}

type externalServices interface {
	GetS3Client() *s3.Client
	GetMediaPackageVOD() *mediapackagevod.Client
}

type config interface {
	GetIngestBucket() *string
	GetPackagingGroup() *string
	GetMediapackageRole() *string
	GetMediapackageSource() *string
}

type assetIngestJSONMeta struct {
	Duration string `json:"duration"`
	Title    string `json:"title"`
	ID       string `json:"id"`
	duration time.Duration
}

func (a *assetIngestJSONMeta) parseDuration() error {
	// TODO: Implement
	// This should chop off the frame count, and convert x:y:z format to seconds
	if a.Duration == "" {
		return ErrDurationEmpty.Here()
	}

	return nil
}

func readJSONFromS3[T any](ctx context.Context, client *s3.Client, bucket *string, path string, obj *T) error {

	jsonObjectOut, err := client.GetObject(
		ctx,
		&s3.GetObjectInput{
			Bucket: bucket,
			Key:    aws.String(path),
		},
	)

	if err != nil {
		var nsk *types.NoSuchKey
		if errors.As(err, &nsk) {
			log.L.Warn().Err(err).Str("path", path).Msg("Unable to retrieve json")
		}
		return merry.Wrap(err)

	}

	jsonBytes, err := ioutil.ReadAll(jsonObjectOut.Body)
	if err != nil {
		return merry.Wrap(err)
	}

	err = json.Unmarshal(jsonBytes, obj)
	if err != nil {
		return merry.Wrap(err)
	}

	return nil
}

// Ingest asset from storage based on the prefix.
func Ingest(ctx context.Context, services externalServices, config config, event cloudevents.Event) error {
	msg := events.AssetDelivered{}
	err := event.DataAs(&msg)
	if err != nil {
		return merry.Wrap(err)
	}

	jsonPath := msg.Prefix + "/meta.json"
	assetMeta := assetIngestJSONMeta{}
	err = readJSONFromS3(ctx, services.GetS3Client(), config.GetIngestBucket(), jsonPath, &assetMeta)
	if err != nil {
		return merry.Wrap(err)
	}

	source := fmt.Sprintf("%s/%s/meta.smil", *config.GetMediapackageSource(), msg.Prefix)
	mpc := services.GetMediaPackageVOD()
	asset, err := mpc.CreateAsset(ctx,
		&mediapackagevod.CreateAssetInput{
			Id:               aws.String(uuid.New().String()),
			PackagingGroupId: config.GetPackagingGroup(),
			SourceArn:        aws.String(source),
			SourceRoleArn:    config.GetMediapackageRole(),
		})
	if err != nil {
		return merry.Wrap(err)
	}

	for _, e := range asset.EgressEndpoints {
		log.L.Debug().
			Str("status", *e.Status).
			Str("url", *e.Url).
			Msg("")
	}

	return nil
}
