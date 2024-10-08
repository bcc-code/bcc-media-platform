package asset

import (
	"context"
	"encoding/json"
	"errors"
	"io"

	"github.com/ansel1/merry/v2"
	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/service/s3"
	"github.com/aws/aws-sdk-go-v2/service/s3/types"
	"github.com/bcc-code/bcc-media-platform/backend/asset/smil"
	"github.com/bcc-code/bcc-media-platform/backend/log"
	"github.com/bcc-code/bcc-media-platform/backend/utils"
)

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

	jsonBytes, err := io.ReadAll(jsonObjectOut.Body)
	defer utils.LogError(jsonObjectOut.Body.Close)
	if err != nil {
		return merry.Wrap(err)
	}

	err = json.Unmarshal(jsonBytes, obj)
	if err != nil {
		return merry.Wrap(err)
	}

	return nil
}

func readSmilFroms3(ctx context.Context, client *s3.Client, bucket *string, path string) (*smil.Main, error) {
	log.L.Debug().Str("smilPath", path).Msg("reading smil file")
	smilObjectOut, err := client.GetObject(
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
		return nil, merry.Wrap(err)
	}

	xmlBytes, err := io.ReadAll(smilObjectOut.Body)
	if err != nil {
		return nil, merry.Wrap(err)
	}

	result, err := smil.Unmarshall(xmlBytes)

	return &result, merry.Wrap(err)
}

type readFromS3Params struct {
	client *s3.Client
	bucket *string
	path   string
}

// readFromS3 reads a file from S3. It returns a ReadCloser that must be closed by the caller.
func readFromS3(ctx context.Context, params readFromS3Params) (io.ReadCloser, error) {
	object, err := params.client.GetObject(
		ctx,
		&s3.GetObjectInput{
			Bucket: params.bucket,
			Key:    &params.path,
		},
	)
	if err != nil {
		var nsk *types.NoSuchKey
		if errors.As(err, &nsk) {
			log.L.Warn().Err(err).Str("path", params.path).Msg("Unable to download from s3, no such file.")
		}
		return nil, merry.Wrap(err)
	}
	return object.Body, merry.Wrap(err)
}
