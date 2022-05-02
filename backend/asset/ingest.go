package asset

import (
	"context"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"time"

	"github.com/ansel1/merry"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/service/mediapackagevod"
	"github.com/aws/aws-sdk-go/service/s3"
	"github.com/bcc-code/brunstadtv/backend/events"
	cloudevents "github.com/cloudevents/sdk-go/v2"
	"github.com/davecgh/go-spew/spew"
)

// Sentinel errors
var (
	ErrDurationEmpty = merry.New("duration string can not be empty")
)

type smilFormat struct {
}

type externalServices interface {
	GetS3Client() *s3.S3
	GetMediaPackageVOD() *mediapackagevod.MediaPackageVod
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

func (a *assetIngestJSONMeta) FromJSON(data []byte) error {
	err := json.Unmarshal(data, &a)
	if err != nil {
		return merry.Wrap(err)
	}

	return a.parseDuration()
}

func (a *assetIngestJSONMeta) parseDuration() error {
	// TODO: Implement
	// This should chop off the frame count, and convert x:y:z format to seconds
	if a.Duration == "" {
		return ErrDurationEmpty.Here()
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

	jsonObjectOut, err := services.GetS3Client().GetObject(&s3.GetObjectInput{
		Bucket: config.GetIngestBucket(),
		Key:    aws.String("/" + msg.Prefix + "/meta.json"),
	})
	if err != nil {
		return merry.Wrap(err)
	}

	jsonBytes, err := ioutil.ReadAll(jsonObjectOut.Body)
	if err != nil {
		return merry.Wrap(err)
	}

	assetMeta := assetIngestJSONMeta{}
	err = assetMeta.FromJSON(jsonBytes)
	if err != nil {
		return merry.Wrap(err)
	}

	spew.Dump(assetMeta)

	/*
	   // Don't need to do that yet
	   	xmlObjOut, err := services.GetS3Client().GetObject(&s3.GetObjectInput{
	   		Bucket: config.GetIngestBucket(),
	   		Key:    aws.String("/" + msg.Prefix + "/meta.smil"),
	   	})
	   	if err != nil {
	   		return merry.Wrap(err)
	   	}
	   	xmlBytes, err := ioutil.ReadAll(xmlObjOut.Body)
	   	if err != nil {
	   		return merry.Wrap(err)
	   	}

	   	xml.Unmarshal(xmlBytes, &smil)
	*/

	source := fmt.Sprintf("%s/%s/meta.smil", *config.GetMediapackageSource(), msg.Prefix)

	mpc := services.GetMediaPackageVOD()
	_, err = mpc.CreateAsset(&mediapackagevod.CreateAssetInput{
		Id:               aws.String("TODO"),
		PackagingGroupId: config.GetPackagingGroup(),
		SourceArn:        aws.String(source),
		SourceRoleArn:    config.GetMediapackageRole(),
	})

	pg, err := mpc.ListPackagingGroups(&mediapackagevod.ListPackagingGroupsInput{})
	if err != nil {
		return merry.Wrap(err)
	}

	spew.Dump(pg)

	return nil
}
