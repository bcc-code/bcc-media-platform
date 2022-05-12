package asset

import (
	"context"
	"encoding/json"
	"errors"
	"io/ioutil"

	"github.com/ansel1/merry"
	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/service/s3"
	"github.com/aws/aws-sdk-go-v2/service/s3/types"
	"github.com/bcc-code/brunstadtv/backend/asset/smil"
	"github.com/bcc-code/mediabank-bridge/log"
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

	xmlBytes, err := ioutil.ReadAll(smilObjectOut.Body)
	if err != nil {
		return nil, merry.Wrap(err)
	}

	result, err := smil.Unmarshall(xmlBytes)

	return &result, merry.Wrap(err)
}
