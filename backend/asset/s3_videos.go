package asset

import (
	"context"
	"strings"
	"time"

	"github.com/ansel1/merry/v2"
	"github.com/aws/aws-sdk-go-v2/service/s3"
	"github.com/aws/aws-sdk-go-v2/service/s3/types"
)

func getSignedAudiolessVideoURLForAssetID(context context.Context, services externalServices, config config, assetID int32) (*string, error) {
	queries := services.GetQueries()

	storagePath, err := queries.GetAssetStoragePath(context, assetID)
	if err != nil {
		return nil, merry.Wrap(err)
	}

	if storagePath.String == "" {
		return nil, merry.New("no storage path found for assetID", merry.WithUserMessage("no storage path found for assetID: "+string(assetID)))
	}

	s3client := services.GetS3Client()
	objects, err := s3client.ListObjectsV2(context, &s3.ListObjectsV2Input{
		Bucket: config.GetStorageBucket(),
		Prefix: &storagePath.String,
	})
	if err != nil {
		return nil, merry.Wrap(err)
	}

	// Find the biggest mp4 file
	var biggestObject *types.Object
	for _, object := range objects.Contents {
		if !strings.HasSuffix(*object.Key, ".mp4") {
			continue
		}
		if biggestObject == nil || object.Size > biggestObject.Size {
			x := object
			biggestObject = &x
		}
	}

	if biggestObject == nil {
		return nil, merry.New("no objects found", merry.WithUserMessage("no objects found for assetID: "+string(assetID)))
	}

	// generate a signed URL
	presignClient := s3.NewPresignClient(s3client)

	url, err := presignClient.PresignGetObject(context, &s3.GetObjectInput{
		Bucket: config.GetStorageBucket(),
		Key:    biggestObject.Key,
	}, func(opts *s3.PresignOptions) {
		opts.Expires = 15 * time.Minute
	})
	if err != nil {
		return nil, merry.Wrap(err)
	}

	return &url.URL, nil
}
