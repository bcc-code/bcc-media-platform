package asset

import (
	"context"
	"fmt"
	"net/url"
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
	"github.com/samber/lo"
	"go.opencensus.io/trace"
)

// Sentinel errors
var (
	ErrDurationEmpty = merry.New("duration string can not be empty")
	ErrDuringCopy    = merry.New("error copying files on S3. See log for more details")
)

// Regexes
var (
	regexSafeStringReplace = regexp.MustCompile("[" + regexp.QuoteMeta(" !:?/|\\<{[(')]}>~@#$%^&*+=") + "]")
	regexSafeStringChars   = regexp.MustCompile("[^0-9A-Z_.]")
)

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
	Mime             string `json:"mime"`
	Path             string `json:"path"`
	AudioLanguge     string `json:"audio_language"`
	SubtitleLanguage string `json:"subtitle_language"`
}

type assetIngestJSONMeta struct {
	Duration int              `json:"duration"`
	Title    string           `json:"title"`
	ID       string           `json:"id"`
	SmilFile string           `json:"smil_file"`
	Files    []ingestFileMeta `json:"files"`
	BasePath string

	duration time.Duration
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
	ctx, span := trace.StartSpan(ctx, "ingest")
	defer span.End()
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

	// Calculate the base path on the ingest S3 bucket
	assetMeta.BasePath = path.Dir(msg.JSONMetaPath)

	// Generate a sane name, in order to be able to search/browse the bucket
	// This should not required for any functionality and can be changed
	storagePrefix := fmt.Sprintf("%s-%s", SafeString(assetMeta.Title), uuid.NewString())

	// Create BASE Directus asset
	a := &directus.Asset{
		Name:            assetMeta.Title,
		MediabankenID:   assetMeta.ID,
		Duration:        assetMeta.Duration,
		EncodingVersion: "btv",
		MainStoragePath: storagePrefix,
	}

	a, err = directus.SaveItem(services.GetDirectusClient(), *a, true)
	if err != nil {
		return merry.Wrap(err)
	}

	// S3 files added here will be deleted if everyting else is sucessful
	objectsToDelete := []types.ObjectIdentifier{
		{Key: aws.String(msg.JSONMetaPath)},
	}

	filesToCopy := []*s3.CopyObjectInput{}
	audioLanguages := []directus.AssetStreamLanguge{}
	assetfiles := []directus.Assetfile{}

	// If we have a "smilFile" then we have defined streams
	hasStreams := assetMeta.SmilFile != ""

	if hasStreams {
		smilPath := path.Join(assetMeta.BasePath, assetMeta.SmilFile)
		smil, err := readSmilFroms3(ctx, s3client, config.GetIngestBucket(), smilPath)
		if err != nil {
			return merry.Wrap(err)
		}

		filesToCopy = append(filesToCopy, &s3.CopyObjectInput{
			Bucket:     config.GetStorageBucket(),
			Key:        aws.String(path.Join(storagePrefix, "stream", path.Base(assetMeta.SmilFile))),
			CopySource: aws.String(path.Join(*config.GetIngestBucket(), assetMeta.BasePath, assetMeta.SmilFile)),
		})

		for _, file := range smil.Body.Switch.Videos {
			target := path.Join(storagePrefix, "stream", path.Base(file.Src))
			src := fmt.Sprintf("/%s/%s/%s", *config.GetIngestBucket(), assetMeta.BasePath, file.Src)
			co := &s3.CopyObjectInput{
				Bucket:     config.GetStorageBucket(),
				Key:        aws.String(target),
				CopySource: aws.String(src),
			}
			filesToCopy = append(filesToCopy, co)
			objectsToDelete = append(objectsToDelete, types.ObjectIdentifier{Key: aws.String(src)})
		}

		for _, file := range smil.Body.Switch.Audios {
			target := path.Join(storagePrefix, "stream", path.Base(file.Src))
			src := path.Join(*config.GetIngestBucket(), assetMeta.BasePath, file.Src)
			co := &s3.CopyObjectInput{
				Bucket:     config.GetStorageBucket(),
				Key:        aws.String(target),
				CopySource: aws.String(src),
			}
			filesToCopy = append(filesToCopy, co)
			for _, p := range file.Params {
				if p.Name == "systemLanguage" {
					audioLanguages = append(audioLanguages, directus.AssetStreamLanguge{
						AssetStreamID: "+", // This is a placeholder for "new asset" in Directus
						LanguagesCode: directus.LanguagesCode{
							Code: p.Value,
						},
					})
				}
			}

			objectsToDelete = append(objectsToDelete, types.ObjectIdentifier{Key: aws.String(src)})
		}
	}

	for _, fileMeta := range assetMeta.Files {
		m := fileMeta
		target := path.Join(storagePrefix, "mux", path.Base(m.Path))
		source := path.Join("/", *config.GetIngestBucket(), assetMeta.BasePath, m.Path)

		co := &s3.CopyObjectInput{
			Bucket:     config.GetStorageBucket(),
			Key:        aws.String(target),
			CopySource: aws.String(source),
		}

		filesToCopy = append(filesToCopy, co)

		objectsToDelete = append(objectsToDelete, types.ObjectIdentifier{
			Key: aws.String(path.Join(assetMeta.BasePath, m.Path)),
		})

		af := directus.Assetfile{
			Path:             target,
			Storage:          "s3_assets",
			Type:             "video",
			MimeType:         m.Mime,
			AssetID:          a.ID,
			AudioLanguge:     m.AudioLanguge,
			SubtitleLanguage: m.SubtitleLanguage,
		}

		assetfiles = append(assetfiles, af)

	}

	// This will copy the objects in parallel and return upon completion of all tasks
	copyErrors := copyObjects(ctx, *s3client, filesToCopy)
	if len(copyErrors) > 0 {
		log.L.Error().Errs("copyErrors", copyErrors).Msg("Errors while copying files")
		return ErrDuringCopy.Here()
	}
	log.L.Info().Msg("Done copying files")

	log.L.Info().Msg("Creating Streams")
	// Construct the source as an ARN
	source := fmt.Sprintf("arn:aws:s3:::%s", path.Join(*config.GetStorageBucket(), storagePrefix, "stream", path.Base(assetMeta.SmilFile)))
	log.L.Debug().Str("Smil source ARN", source).Msg("Calculated source ARN for MediaPackager")

	mpc := services.GetMediaPackageVOD()
	asset, err := mpc.CreateAsset(ctx,
		&mediapackagevod.CreateAssetInput{
			Id:               &storagePrefix,
			PackagingGroupId: config.GetPackagingGroup(),
			SourceArn:        aws.String(source),
			SourceRoleArn:    config.GetMediapackageRole(),
		})
	if err != nil {
		return merry.Wrap(err)
	}

	// Insert all stream endpoints into the CMS
	for _, e := range asset.EgressEndpoints {
		log.L.Debug().
			Str("status", *e.Status).
			Str("url", *e.Url).
			Msg("Egress endpoints")

		streamURL, _ := url.Parse(*e.Url)

		streamType := directus.HLSCmaf
		if strings.HasSuffix(*e.Url, "index.mpd") {
			streamType = directus.Dash
		}

		stream := directus.AssetStream{
			Type:    streamType,
			URL:     *e.Url,
			Path:    streamURL.Path,
			Service: "mediapackage",
			AudioLanguges: directus.CRUDArrays[directus.AssetStreamLanguge]{
				Create: audioLanguages,
				Update: []directus.AssetStreamLanguge{},
				Delete: []int{},
			},
			SubtitleLanguages: directus.CRUDArrays[directus.AssetStreamLanguge]{
				Create: []directus.AssetStreamLanguge{},
				Update: []directus.AssetStreamLanguge{},
				Delete: []int{},
			},
			AssetID: a.ID,
		}

		_, err := directus.SaveItem(services.GetDirectusClient(), stream, false)
		if err != nil {
			return merry.Wrap(err)
		}
	}
	log.L.Debug().Msg("Done creating streams")

	log.L.Debug().Msg("Insert stuff into Directus")
	for _, af := range assetfiles {
		_, err = directus.SaveItem(services.GetDirectusClient(), af, false)
		if err != nil {
			return merry.Wrap(err)
		}
	}
	log.L.Debug().Msg("Done inserting stuff into Directus")

	deleteInputs := &s3.DeleteObjectsInput{
		Bucket: config.GetIngestBucket(),
		Delete: &types.Delete{
			Objects: objectsToDelete,
		},
	}

	if false {
		s3client.DeleteObjects(ctx, deleteInputs)
	} else {
		fileList := lo.Map(objectsToDelete, func(x types.ObjectIdentifier, _ int) string {
			return *x.Key
		})

		log.L.Debug().Str("objectsToDelete", fmt.Sprintf("%v", fileList)).Msg("Deleting disabled. Would have deleted this files")
	}

	return nil
}
