package asset

import (
	"context"
	"errors"
	"fmt"
	"net/url"
	"path"
	"regexp"
	"strconv"
	"strings"

	"github.com/bcc-code/brunstadtv/backend/pubsub"

	"github.com/bcc-code/brunstadtv/backend/asset/smil"
	"github.com/bcc-code/brunstadtv/backend/common"
	"github.com/bcc-code/brunstadtv/backend/utils"

	"github.com/ansel1/merry/v2"
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
	"go.opentelemetry.io/otel"
)

// Sentinel errors
var (
	ErrResourcesEmpty = merry.Sentinel("AWS assets list empty")
	ErrDurationEmpty  = merry.Sentinel("duration string can not be empty")
	ErrDuringCopy     = merry.Sentinel("error copying files on S3. See log for more details")
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
	GetDeleteIngestFilesFlag() bool
}

type ingestFileMeta struct {
	Mime             string `json:"mime"`
	Path             string `json:"path"`
	AudioLanguge     string `json:"audiolanguage"`
	SubtitleLanguage string `json:"subtitlelanguage"`
	Resolution       string `json:"resolution"`
}

type assetIngestJSONMeta struct {
	Duration string           `json:"duration"`
	Title    string           `json:"title"`
	ID       string           `json:"id"`
	SmilFile string           `json:"smil_file"`
	Files    []ingestFileMeta `json:"files"`
	BasePath string

	DurationInS int64
}

func (a *assetIngestJSONMeta) CalculateDuration() {
	r := regexp.MustCompile(`([0-9]{1,2}):([0-9]{1,2}):([0-9]{1,2}):[0-9]{1,2}`)
	matches := r.FindStringSubmatch(a.Duration)

	if len(matches) != 4 {
		return
	}

	seconds, err := strconv.ParseInt(matches[3], 10, 0)
	if err != nil {
		log.L.Warn().Err(err).Str("BasePath", a.BasePath).Msg("Unable to parse duration")
	}

	minutes, err := strconv.ParseInt(matches[2], 10, 0)
	if err != nil {
		log.L.Warn().Err(err).Str("BasePath", a.BasePath).Msg("Unable to parse duration")
	}

	hours, err := strconv.ParseInt(matches[1], 10, 0)
	if err != nil {
		log.L.Warn().Err(err).Str("BasePath", a.BasePath).Msg("Unable to parse duration")
	}

	seconds += minutes*60 + hours*60*60
	a.DurationInS = seconds
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

// GetLanguagesFromVideoElement formatted as per AWS:
// https://aws.amazon.com/blogs/media/smil-using-aws-elemental-mediapackage-vod/
// For example:
// ```
//
//	<video name="example_1080.mp4" systemLanguage="eng,spa,fra" audioName="English,Spanish,French"/>
//
// ```
// If systemLanguage param is not present the return will be an empty array
func GetLanguagesFromVideoElement(videoElement smil.Video) []directus.AssetStreamLanguage {

	systemLanguages := []string{}
	languages := []directus.AssetStreamLanguage{}

	if videoElement.IncludeAudio != "true" && videoElement.IncludeAudio != "" { // "" == "true" as per https://docs.aws.amazon.com/mediapackage/latest/ug/supported-inputs-vod-smil.html
		return languages
	}

	systemLanguages = lo.Map(strings.Split(videoElement.SystemLanguage, ","), func(s string, _ int) string { return strings.TrimSpace(s) })
	systemLanguages = lo.Filter(systemLanguages, func(s string, _ int) bool { return s != "" })

	for i := range systemLanguages {
		langCode := utils.LegacyLanguageCodeTo639_1(systemLanguages[i])
		if langCode != "" {
			languages = append(languages, directus.AssetStreamLanguage{
				AssetStreamID: "+", // Directus requirement
				LanguagesCode: directus.LanguagesCode{Code: langCode},
			})
		}
	}

	return languages
}

// Ingest asset from storage based on the prefix.
func Ingest(ctx context.Context, services externalServices, config config, event cloudevents.Event) error {
	ctx, span := otel.Tracer("asset").Start(ctx, "ingest")
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
	assetMeta.CalculateDuration()

	oldAsset, err := directus.FindNewestAssetByMediabankenID(services.GetDirectusClient(), assetMeta.ID)

	if err != nil && !errors.Is(err, directus.ErrNotFound) {
		return err
	}

	log.L.Debug().Msg("Start processing JSON")
	// Calculate the base path on the ingest S3 bucket
	assetMeta.BasePath = path.Dir(msg.JSONMetaPath)

	// Generate a sane name, in order to be able to search/browse the bucket
	// This should not be required for any functionality and can be changed
	storagePrefix := fmt.Sprintf("%s-%s", SafeString(assetMeta.Title), uuid.NewString())

	filesToCopy := map[string]*s3.CopyObjectInput{}

	// Prepare to copy the old files. Because the new files get the same destination,
	// they will replace the copy instructions and we will not unnecessarily copy old files
	// that will just get replaced
	log.L.Debug().Msg("Prepare to copy old files")
	if oldAsset != nil {
		res, err := s3client.ListObjectsV2(ctx, &s3.ListObjectsV2Input{
			Bucket: config.GetStorageBucket(),
			Prefix: aws.String(oldAsset.MainStoragePath),
		})

		if err != nil {
			return merry.Wrap(err)
		}

		for _, x := range res.Contents {
			key := strings.Replace(*x.Key, oldAsset.MainStoragePath, storagePrefix, 1)
			coi := &s3.CopyObjectInput{
				Bucket:     config.GetStorageBucket(),
				Key:        aws.String(key),
				CopySource: aws.String(path.Join(*config.GetStorageBucket(), *x.Key)),
			}

			filesToCopy[*coi.Key] = coi
		}
	}

	// Create BASE Directus asset
	a := &directus.Asset{
		Name:            assetMeta.Title,
		MediabankenID:   assetMeta.ID,
		Duration:        assetMeta.DurationInS,
		EncodingVersion: "btv",
		MainStoragePath: storagePrefix,
		Status:          common.StatusDraft,
	}

	log.L.Debug().Msg("Save Directus Asset object")
	a, err = directus.SaveItem(ctx, services.GetDirectusClient(), *a, true)
	if err != nil {
		return merry.Wrap(err)
	}

	// S3 files added here will be deleted if everything else is successful
	objectsToDelete := []types.ObjectIdentifier{
		{Key: aws.String(msg.JSONMetaPath)},
	}

	audioLanguages := []directus.AssetStreamLanguage{}
	subLanguages := []directus.AssetStreamLanguage{}
	assetfiles := []directus.AssetFile{}

	// If we have a "smilFile" then we have defined streams
	hasStreams := assetMeta.SmilFile != ""

	log.L.Debug().Str("smilFile", assetMeta.SmilFile).Msg("Smil Path")
	if hasStreams {
		smilPath := path.Join(assetMeta.BasePath, assetMeta.SmilFile)
		smil, err := readSmilFroms3(ctx, s3client, config.GetIngestBucket(), smilPath)
		if err != nil {
			return merry.Wrap(err)
		}

		coi := &s3.CopyObjectInput{
			Bucket:     config.GetStorageBucket(),
			Key:        aws.String(path.Join(storagePrefix, "stream", path.Base(assetMeta.SmilFile))),
			CopySource: aws.String(path.Join(*config.GetIngestBucket(), assetMeta.BasePath, assetMeta.SmilFile)),
		}

		filesToCopy[*coi.Key] = coi

		for _, file := range smil.Body.Switch.Videos {
			target := path.Join(storagePrefix, "stream", path.Base(file.Src))
			src := path.Join(*config.GetIngestBucket(), assetMeta.BasePath, file.Src)
			coi := &s3.CopyObjectInput{
				Bucket:     config.GetStorageBucket(),
				Key:        aws.String(target),
				CopySource: aws.String(src),
			}

			audioLanguages = append(audioLanguages, GetLanguagesFromVideoElement(file)...)

			filesToCopy[*coi.Key] = coi
			objectsToDelete = append(objectsToDelete, types.ObjectIdentifier{Key: aws.String(src)})
		}

		for _, sub := range smil.Body.Switch.Subs {
			target := path.Join(storagePrefix, "stream", path.Base(sub.Src))
			src := path.Join(*config.GetIngestBucket(), assetMeta.BasePath, sub.Src)
			coi := &s3.CopyObjectInput{
				Bucket:     config.GetStorageBucket(),
				Key:        aws.String(target),
				CopySource: aws.String(src),
			}

			langCode := utils.LegacyLanguageCodeTo639_1(sub.SystemLanguage)
			subLanguages = append(subLanguages, directus.AssetStreamLanguage{
				LanguagesCode: directus.LanguagesCode{Code: langCode},
				AssetStreamID: "+", // Directus requirement
			})

			filesToCopy[*coi.Key] = coi
			objectsToDelete = append(objectsToDelete, types.ObjectIdentifier{Key: aws.String(src)})
		}
	}

	fileSizeErrors := []error{}
	for _, fileMeta := range assetMeta.Files {
		m := fileMeta
		target := path.Join(storagePrefix, "mux", path.Base(m.Path))
		source := path.Join(*config.GetIngestBucket(), assetMeta.BasePath, m.Path)

		coi := &s3.CopyObjectInput{
			Bucket:     config.GetStorageBucket(),
			Key:        aws.String(target),
			CopySource: aws.String(source),
		}

		filesToCopy[*coi.Key] = coi

		objectsToDelete = append(objectsToDelete, types.ObjectIdentifier{
			Key: aws.String(path.Join(assetMeta.BasePath, m.Path)),
		})

		result, err := s3client.HeadObject(ctx, &s3.HeadObjectInput{
			Bucket: config.GetIngestBucket(),
			Key:    aws.String(path.Join(assetMeta.BasePath, m.Path)),
		})

		fileSizeInBytes := int64(-1)
		if err == nil {
			fileSizeInBytes = result.ContentLength
		} else {
			fileSizeErrors = append(fileSizeErrors, merry.Wrap(err))
		}

		af := directus.AssetFile{
			Path:             target,
			Storage:          "s3_assets",
			Type:             "video",
			MimeType:         m.Mime,
			AssetID:          a.ID,
			AudioLanguage:    m.AudioLanguge,
			SubtitleLanguage: m.SubtitleLanguage,
			Resolution:       m.Resolution,
			Size:             fileSizeInBytes,
		}

		assetfiles = append(assetfiles, af)

	}

	if len(fileSizeErrors) > 0 {
		// We just warn here as this can be fixed manually if needed and it is not a critical error
		log.L.Warn().Errs("fileSizeErrors", fileSizeErrors).Msg("Errors while getting file sizes")
	}

	// This will copy the objects in parallel and return upon completion of all tasks
	copyErrors := copyObjects(ctx, *s3client, filesToCopy)
	if len(copyErrors) > 0 {
		log.L.Error().Errs("copyErrors", copyErrors).Msg("Errors while copying files")
		return merry.Wrap(ErrDuringCopy)
	}
	log.L.Info().Msg("Done copying files")

	log.L.Info().Msg("Creating Streams")
	// Construct the source as an ARN
	source := fmt.Sprintf("arn:aws:s3:::%s", path.Join(*config.GetStorageBucket(), storagePrefix, "stream", path.Base(assetMeta.SmilFile)))
	log.L.Debug().Str("Smil source ARN", source).Msg("Calculated source ARN for MediaPackager")

	if hasStreams {
		mpc := services.GetMediaPackageVOD()
		log.L.Debug().Msg("Creating MediaPackager Asset")
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

		if asset.Arn != nil {
			a.ARN = *asset.Arn
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
				AudioLanguages: directus.CRUDArrays[directus.AssetStreamLanguage]{
					Create: audioLanguages,
					Update: []directus.AssetStreamLanguage{},
					Delete: []int{},
				},
				SubtitleLanguages: directus.CRUDArrays[directus.AssetStreamLanguage]{
					Create: subLanguages,
					Update: []directus.AssetStreamLanguage{},
					Delete: []int{},
				},
				AssetID: a.ID,
			}

			_, err := directus.SaveItem(ctx, services.GetDirectusClient(), stream, false)
			if err != nil {
				return merry.Wrap(err)
			}
		}
		log.L.Debug().Msg("Done creating streams")
	}

	log.L.Debug().Msg("Insert stuff into Directus")
	for _, af := range assetfiles {
		_, err = directus.SaveItem(ctx, services.GetDirectusClient(), af, false)
		if err != nil {
			return merry.Wrap(err)
		}
	}

	a.Status = common.StatusDraft
	_, err = directus.SaveItem(ctx, services.GetDirectusClient(), *a, false)
	if err != nil {
		return merry.Wrap(err)
	}

	log.L.Debug().Msg("Inserted asset in DRAFT state")

	deleteInputs := &s3.DeleteObjectsInput{
		Bucket: config.GetIngestBucket(),
		Delete: &types.Delete{
			Objects: objectsToDelete,
		},
	}

	fileList := lo.Map(objectsToDelete, func(x types.ObjectIdentifier, _ int) string {
		return *x.Key
	})

	if config.GetDeleteIngestFilesFlag() {
		log.L.Debug().Str("objectsToDelete", fmt.Sprintf("%v", fileList)).Msg("Deleting files")
		_, err := s3client.DeleteObjects(ctx, deleteInputs)
		if err != nil {
			log.L.Warn().Err(err).Msg("Error deleting files")
			return merry.Wrap(err)
		}
	} else {
		log.L.Debug().Str("objectsToDelete", fmt.Sprintf("%v", fileList)).Msg("Deleting disabled. Would have deleted this files")
	}

	return nil
}

func UpdateIngestStatus(ctx context.Context, services externalServices, config config, event pubsub.MediaPackageInputNotification) error {
	ctx, span := otel.Tracer("asset").Start(ctx, "updateIngestStatus")
	defer span.End()

	log.L.Debug().Str("EventType", event.Detail.Event).Msg("Processing event type")
	if event.Detail.Event != "IngestComplete" {
		// We don't currently want to do anything for the other events
		return nil
	}

	if len(event.Resources) < 1 {
		return merry.Wrap(ErrResourcesEmpty)
	}

	asset, err := directus.FindAssetByAWSArn(services.GetDirectusClient(), event.Resources[0])
	if err != nil {
		log.L.Warn().Err(err).Strs("arn", event.Resources).Msg("Error finding the asset to update")
		return merry.Wrap(err)
	}

	asset.Status = common.StatusPublished
	_, err = directus.SaveItem(ctx, services.GetDirectusClient(), asset, false)
	return err
}
