package asset

import (
	"context"
	"fmt"
	"net/url"
	"path"
	"regexp"
	"strings"
	"sync"
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
	"github.com/davecgh/go-spew/spew"
	"github.com/go-resty/resty/v2"
	"github.com/google/uuid"
	"github.com/samber/lo"
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
	Mime             string `json:"mimt"`
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

	a := &directus.Asset{
		Name:            assetMeta.Title,
		MediabankenID:   assetMeta.ID,
		Duration:        assetMeta.Duration,
		EncodingVersion: "btv",
	}

	a, err = directus.SaveItem(services.GetDirectusClient(), *a, true)
	if err != nil {
		return merry.Wrap(err)
	}

	// Generate a sane name, in order to be able to search/browse the bucket
	// This should not required for any functionality and can be changed
	storagePrefix := fmt.Sprintf("%s-%s", SafeString(assetMeta.Title), uuid.NewString())

	spew.Dump(assetMeta)
	smilPath := path.Join(assetMeta.BasePath, assetMeta.SmilFile)
	smil, err := readSmilFroms3(ctx, s3client, config.GetIngestBucket(), smilPath)
	if err != nil {
		return merry.Wrap(err)
	}

	filesToCopy := []string{
		path.Base(assetMeta.SmilFile),
	}

	audioLanguages := []directus.AssetStreamLanguge{}

	for _, file := range smil.Body.Switch.Videos {
		filesToCopy = append(filesToCopy, file.Src)
	}
	for _, file := range smil.Body.Switch.Audios {
		filesToCopy = append(filesToCopy, file.Src)
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
	}

	var wg sync.WaitGroup

	copyErrors := []error{}

	// S3 files added here will be deleted if everyting else is sucessful
	objectsToDelete := []types.ObjectIdentifier{
		{Key: aws.String(msg.JSONMetaPath)},
	}

	for _, fileMeta := range assetMeta.Files {
		wg.Add(1)

		m := fileMeta
		go func() {
			defer wg.Done()
			target := path.Join(storagePrefix, "mux", path.Base(m.Path))
			source := path.Join("/", *config.GetIngestBucket(), assetMeta.BasePath, m.Path)

			_, err := s3client.CopyObject(ctx, &s3.CopyObjectInput{
				Bucket:     config.GetStorageBucket(),
				Key:        aws.String(target),
				CopySource: aws.String(source),
			})

			if err != nil {
				copyErrors = append(copyErrors, merry.Wrap(err).Append(source))
				return
			}

			log.L.Info().Str("file", target).Msg("File copied")

			m.Path = target

			af := directus.Assetfile{
				Path:             m.Path,
				Storage:          "s3_assets",
				Type:             "video",
				MimeType:         m.Mime,
				AssetID:          a.ID,
				AudioLanguge:     m.AudioLanguge,
				SubtitleLanguage: m.SubtitleLanguage,
			}

			_, err = directus.SaveItem(services.GetDirectusClient(), af, false)
			if err != nil {
				copyErrors = append(copyErrors, merry.Wrap(err))
				return
			}

			objectsToDelete = append(objectsToDelete, types.ObjectIdentifier{
				Key: aws.String(path.Join(assetMeta.BasePath, m.Path)),
			})

		}()
	}
	for _, file := range filesToCopy {
		wg.Add(1)

		filePath := path.Join(assetMeta.BasePath, file)
		target := path.Join(storagePrefix, "stream", path.Base(file))

		go func() {
			defer wg.Done()
			_, err := s3client.CopyObject(ctx, &s3.CopyObjectInput{
				Bucket:     config.GetStorageBucket(),
				Key:        aws.String(target),
				CopySource: aws.String(fmt.Sprintf("/%s/%s", *config.GetIngestBucket(), filePath)),
			})

			if err != nil {
				copyErrors = append(copyErrors, merry.Wrap(err).Append(filePath))
				return
			}

			log.L.Info().Str("file", target).Msg("File copied")

			objectsToDelete = append(objectsToDelete, types.ObjectIdentifier{
				Key: aws.String(filePath),
			})
		}()
	}

	wg.Wait()

	if len(copyErrors) > 0 {
		log.L.Error().Errs("copyErrors", copyErrors).Msg("Errors while copying files")
		return ErrDuringCopy.Here()
	}

	log.L.Info().Msg("Done copying files")

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
				Delete: []directus.AssetStreamLanguge{},
			},
			SubtitleLanguages: directus.CRUDArrays[directus.AssetStreamLanguge]{
				Create: []directus.AssetStreamLanguge{},
				Update: []directus.AssetStreamLanguge{},
				Delete: []directus.AssetStreamLanguge{},
			},
			AssetID: a.ID,
		}

		_, err := directus.SaveItem(services.GetDirectusClient(), stream, false)
		if err != nil {
			return merry.Wrap(err)
		}
	}

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
