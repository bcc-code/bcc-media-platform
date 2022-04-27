package asset

import (
	"context"
	"io/ioutil"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/s3"
	"github.com/bcc-code/brunstadtv/backend/events"
	cloudevents "github.com/cloudevents/sdk-go/v2"
	"github.com/davecgh/go-spew/spew"
)

// Ingest asset from storage based on the prefix.
func Ingest(ctx context.Context, event cloudevents.Event) error {
	msg := events.AssetDelivered{}
	err := event.DataAs(&msg)
	if err != nil {
		return err
	}

	sess := session.Must(session.NewSession())
	sess.Config.Region = aws.String("eu-north-1")
	storageClient := s3.New(sess)
	jsonObjectOut, err := storageClient.GetObject(&s3.GetObjectInput{
		Bucket: aws.String("vod-asset-ingest-dev"),
		Key:    aws.String("/" + msg.Prefix + "/meta.json"),
	})
	if err != nil {
		return err
	}

	jsonBytes, err := ioutil.ReadAll(jsonObjectOut.Body)
	if err != nil {
		return err
	}

	spew.Dump(jsonBytes)

	return nil
}
