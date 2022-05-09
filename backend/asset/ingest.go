package asset

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"io/ioutil"
	"path"
	"regexp"
	"strings"
	"time"

	"github.com/ansel1/merry"
	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/service/mediapackagevod"
	"github.com/aws/aws-sdk-go-v2/service/s3"
	"github.com/aws/aws-sdk-go-v2/service/s3/types"
	"github.com/bcc-code/brunstadtv/backend/directus"
	"github.com/bcc-code/brunstadtv/backend/events"
	"github.com/bcc-code/mediabank-bridge/log"
	cloudevents "github.com/cloudevents/sdk-go/v2"
	"github.com/go-resty/resty/v2"
	"github.com/google/uuid"
)

// Sentinel errors
var (
	ErrDurationEmpty = merry.New("duration string can not be empty")
)

// Regexes
var (
	regexSafeStringReplace = regexp.MustCompile("[" + regexp.QuoteMeta(" !:?/|\\<{[(')]}>~@#$%^&*+=") + "]")
	regexSafeStringChars   = regexp.MustCompile("[^0-9A-Z_.]")
)

type smilFormat struct {
}

type externalServices interface {
	GetS3Client() *s3.Client
	GetMediaPackageVOD() *mediapackagevod.Client
	GetDirectusClient() *resty.Client
}

type config interface {
	GetIngestBucket() *string
	GetStorageBucket() *string
	GetPackagingGroup() *string
	GetMediapackageRole() *string
	GetMediapackageSource() *string
}

type ingestFileMeta struct {
	Mime     string `json:"mimt"`
	Path     string `json:"path"`
	Language string `json:"lang"`
	FileSize uint64 `json:"fileSize"`
}

type smilFileMeta struct {
	Path        string   `json:"path"`
	Languages   []string `json:"lang"`
	Resolutions []string `json:"resolutions"`
}

type assetIngestJSONMeta struct {
	Duration int              `json:"duration"`
	Title    string           `json:"title"`
	ID       string           `json:"id"`
	SmilFile smilFileMeta     `json:"smilFile"`
	Files    []ingestFileMeta `json:"files"`

	duration time.Duration
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

// SafeString takes an arbitrary string and returns a safe version.
//
// The following actions are performed:
// * Remove/Replace invalid UTF8
// * Spaces are trimmed
// * Everything is converted to UPPER CASE
// * characters in regexSafeStringReplace are replaced by _
// * Everythin else except regexSafeStringChars is removed
func SafeString(s string) string {
	s = strings.ToValidUTF8(s, "")
	s = strings.TrimSpace(s)
	s = strings.ToUpper(s)
	s = regexSafeStringReplace.ReplaceAllLiteralString(s, "_")
	s = regexSafeStringChars.ReplaceAllLiteralString(s, "")
	return s
}

// Ingest asset from storage based on the prefix.
func Ingest(ctx context.Context, services externalServices, config config, event cloudevents.Event) error {
	msg := events.AssetDelivered{}
	err := event.DataAs(&msg)
	if err != nil {
		return merry.Wrap(err)
	}

	s3client := services.GetS3Client()

	assetMeta := assetIngestJSONMeta{}
	err = readJSONFromS3(ctx, s3client, config.GetIngestBucket(), msg.JSONMetaPath, &assetMeta)
	if err != nil {
		return merry.Wrap(err)
	}

	a := &directus.Asset{
		Name:            assetMeta.Title,
		MediabankenID:   assetMeta.ID,
		Duration:        assetMeta.Duration,
		EncodingVersion: "btv",
	}

	a, err = directus.SaveItem(services.GetDirectusClient(), *a)
	if err != nil {
		return merry.Wrap(err)
	}

	// Generate a sane name, in order to be able to search/browse the bucket
	// This should not required for any functionality and can be changed
	storagePrefix := fmt.Sprintf("%s-%s", SafeString(assetMeta.Title), uuid.NewString())

	for _, fileMeta := range assetMeta.Files {
		// TODO: Parallelize?
		target := path.Join(storagePrefix, "mux", path.Base(fileMeta.Path))

		_, err := s3client.CopyObject(ctx, &s3.CopyObjectInput{
			Bucket:     config.GetStorageBucket(),
			Key:        aws.String(target),
			CopySource: aws.String(fmt.Sprintf("/%s/%s", *config.GetIngestBucket(), fileMeta.Path)),
		})

		if err != nil {
			return merry.Wrap(err)
		}

		fileMeta.Path = target

		af := directus.Assetfile{
			Path:             fileMeta.Path,
			Storage:          "s3_assets",
			Type:             "video",
			MimeType:         fileMeta.Mime,
			AssetID:          a.ID,
			AudioLanguge:     fileMeta.Language,
			SubtitleLanguage: fileMeta.Language,
		}

		_, err = directus.SaveItem(services.GetDirectusClient(), af)
		if err != nil {
			return merry.Wrap(err)
		}
	}

	// TODO: Delete files. Should be done async as a message

	// TODO: For now we just asume that there is no pre-existing asset. Implement updates/replaces

	/*
		storageBucketARN := fmt.Sprintf("arn:aws:s3:::%s", *config.GetStorageBucket())
			source := fmt.Sprintf("%s/%s/meta.smil", *config.GetMediapackageSource(), ass)
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
	*/
	return nil
}
