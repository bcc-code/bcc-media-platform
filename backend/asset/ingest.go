package asset

import (
	"context"
	"fmt"
	"net/url"
	"path"
	"path/filepath"
	"regexp"
	"strconv"
	"strings"

	"github.com/bcc-code/bcc-media-platform/backend/sqlc"
	"github.com/davecgh/go-spew/spew"
	"gopkg.in/guregu/null.v4"

	"github.com/bcc-code/bcc-media-platform/backend/pubsub"

	"github.com/bcc-code/bcc-media-platform/backend/asset/smil"
	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/utils"

	"github.com/ansel1/merry/v2"
	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/service/mediapackagevod"
	"github.com/aws/aws-sdk-go-v2/service/s3"
	"github.com/aws/aws-sdk-go-v2/service/s3/types"
	"github.com/bcc-code/bcc-media-platform/backend/events"
	"github.com/bcc-code/mediabank-bridge/log"
	cloudevents "github.com/cloudevents/sdk-go/v2"
	"github.com/google/uuid"
	"github.com/samber/lo"
	"go.opentelemetry.io/otel"
)

// Sentinel errors
var (
	ErrResourcesEmpty = merry.Sentinel("AWS assets list empty")
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
	GetQueries() *sqlc.Queries
}

type config interface {
	GetIngestBucket() *string
	GetStorageBucket() *string
	GetPackagingGroup() *string
	GetMediapackageRole() *string
	GetMediapackageSource() *string
	GetDeleteIngestFilesFlag() bool
}

// CalculateDuration calculates the asset duration and assigns it to the meta
func (a *IngestJSONMeta) CalculateDuration() {
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
func GetLanguagesFromVideoElement(videoElement smil.Video) []string {

	var systemLanguages []string
	var languages []string

	if videoElement.IncludeAudio != "true" && videoElement.IncludeAudio != "" { // "" == "true" as per https://docs.aws.amazon.com/mediapackage/latest/ug/supported-inputs-vod-smil.html
		return languages
	}

	systemLanguages = lo.Map(strings.Split(videoElement.SystemLanguage, ","), func(s string, _ int) string { return strings.TrimSpace(s) })
	systemLanguages = lo.Filter(systemLanguages, func(s string, _ int) bool { return s != "" })

	for i := range systemLanguages {
		langCode := utils.LegacyLanguageCodeTo639_1(systemLanguages[i])
		if langCode != "" {
			languages = append(languages, langCode)
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

	queries := services.GetQueries()

	s3client := services.GetS3Client()

	assetMeta := IngestJSONMeta{}
	err = readJSONFromS3(ctx, s3client, config.GetIngestBucket(), msg.JSONMetaPath, &assetMeta)
	if err != nil {
		return merry.Wrap(err)
	}
	assetMeta.CalculateDuration()

	//oldAsset, err := queries.NewestPreviousAssetByMediabankenID(ctx, assetMeta.ID)
	//if err != nil && !errors.Is(err, sql.ErrNoRows) {
	//	return err
	//}

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
	//log.L.Debug().Msg("Prepare to copy old files")
	//if oldAsset.ID != 0 {
	//	res, err := s3client.ListObjectsV2(ctx, &s3.ListObjectsV2Input{
	//		Bucket: config.GetStorageBucket(),
	//		Prefix: aws.String(oldAsset.MainStoragePath.String),
	//	})
	//
	//	if err != nil {
	//		return merry.Wrap(err)
	//	}
	//
	//	for _, x := range res.Contents {
	//		key := strings.Replace(*x.Key, oldAsset.MainStoragePath.String, storagePrefix, 1)
	//		coi := &s3.CopyObjectInput{
	//			Bucket:     config.GetStorageBucket(),
	//			Key:        aws.String(key),
	//			CopySource: aws.String(path.Join(*config.GetStorageBucket(), *x.Key)),
	//		}
	//
	//		filesToCopy[*coi.Key] = coi
	//	}
	//}

	// Create BASE asset
	assetID, err := queries.InsertAsset(ctx, sqlc.InsertAssetParams{
		Name:            assetMeta.Title,
		MediabankenID:   null.StringFrom(assetMeta.ID),
		Duration:        int32(assetMeta.DurationInS),
		EncodingVersion: null.StringFrom("btv"),
		MainStoragePath: null.StringFrom(storagePrefix),
		Status:          null.StringFrom(string(common.StatusDraft)),
		Source:          null.StringFrom(assetMeta.Source),
	})
	if err != nil {
		return merry.Wrap(err)
	}

	// S3 files added here will be deleted if everything else is successful
	objectsToDelete := []types.ObjectIdentifier{
		{Key: aws.String(msg.JSONMetaPath)},
	}

	var audioLanguages []string
	var subLanguages []string
	var assetfiles []sqlc.InsertAssetFileParams

	// If we have a "smilFile" then we have defined streams
	hasStreams := assetMeta.SmilFile != ""

	log.L.Debug().Str("smilFile", assetMeta.SmilFile).Msg("Smil Path")
	if hasStreams {
		smilPath := path.Join(assetMeta.BasePath, assetMeta.SmilFile)
		smilValue, err := readSmilFroms3(ctx, s3client, config.GetIngestBucket(), smilPath)
		if err != nil {
			return merry.Wrap(err)
		}

		coi := &s3.CopyObjectInput{
			Bucket:     config.GetStorageBucket(),
			Key:        aws.String(path.Join(storagePrefix, "stream", path.Base(assetMeta.SmilFile))),
			CopySource: aws.String(path.Join(*config.GetIngestBucket(), assetMeta.BasePath, assetMeta.SmilFile)),
		}

		filesToCopy[*coi.Key] = coi

		for _, file := range smilValue.Body.Switch.Videos {
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

		for _, sub := range smilValue.Body.Switch.Subs {
			target := path.Join(storagePrefix, "stream", path.Base(sub.Src))
			src := path.Join(*config.GetIngestBucket(), assetMeta.BasePath, sub.Src)
			coi := &s3.CopyObjectInput{
				Bucket:     config.GetStorageBucket(),
				Key:        aws.String(target),
				CopySource: aws.String(src),
			}

			langCode := utils.LegacyLanguageCodeTo639_1(sub.SystemLanguage)
			subLanguages = append(subLanguages, langCode)

			filesToCopy[*coi.Key] = coi
			objectsToDelete = append(objectsToDelete, types.ObjectIdentifier{Key: aws.String(src)})
		}
	}

	if assetMeta.ChaptersFile != "" {
		var chapters []Chapter
		chaptersPath := filepath.Join(assetMeta.BasePath, assetMeta.ChaptersFile)
		err = readJSONFromS3(ctx, s3client, config.GetIngestBucket(), chaptersPath, &chapters)
		if err != nil {
			return merry.Wrap(err)
		}

		for _, chapter := range chapters {
			t := common.ChapterTypes.Parse(chapter.ChapterType)
			if t == nil {
				continue
			}
			timedMetadata := sqlc.InsertTimedMetadataParams{
				ID:          uuid.New(),
				ChapterType: null.StringFrom(t.Value),
				Title:       chapter.Title,
				AssetID:     null.IntFrom(int64(assetID)),
				Highlight:   chapter.Highlight,
				Description: chapter.Description,
				Status:      string(common.StatusPublished),
				Label:       chapter.Label,
				Type:        "chapter",
				Seconds:     float32(chapter.Timestamp),
			}

			var personIDs []uuid.UUID
			switch *t {
			case common.ChapterTypeSong:
				// We only want to insert the song number if it is present
				songID, err := getOrInsertSongID(ctx, queries, chapter.SongCollection, chapter.SongNumber)
				if err != nil {
					return merry.Wrap(err)
				}
				timedMetadata.SongID = uuid.NullUUID{
					Valid: true,
					UUID:  songID,
				}
			case common.ChapterTypeTestimony, common.ChapterTypeAppeal, common.ChapterTypeSpeech:
				// We only want to insert the persons if they are present
				personIDs, err = getOrInsertPersonIDs(ctx, queries, chapter.Persons)
				if err != nil {
					return merry.Wrap(err)
				}
			}
			err = queries.InsertTimedMetadata(ctx, timedMetadata)
			if err != nil {
				return merry.Wrap(err)
			}
			for _, p := range personIDs {
				err = queries.InsertTimedMetadataPerson(ctx, sqlc.InsertTimedMetadataPersonParams{
					PersonsID:       p,
					TimedmetadataID: timedMetadata.ID,
				})
				if err != nil {
					return merry.Wrap(err)
				}
			}
		}
	}

	var fileSizeErrors []error
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

		af := sqlc.InsertAssetFileParams{
			Path:               target,
			Storage:            "s3_assets",
			Type:               "video",
			MimeType:           m.Mime,
			AssetID:            assetID,
			AudioLanguageID:    null.StringFrom(m.AudioLanguage),
			SubtitleLanguageID: null.StringFrom(m.SubtitleLanguage),
			Resolution:         null.StringFrom(m.Resolution),
			Size:               fileSizeInBytes,
		}

		assetfiles = append(assetfiles, af)

	}

	if len(fileSizeErrors) > 0 {
		// We just warn here as this can be fixed manually if needed and it is not a critical error
		log.L.Warn().Errs("fileSizeErrors", fileSizeErrors).Msg("Errors while getting file sizes")
	}

	// This will copy the objects in parallel and return upon completion of all tasks
	copyErrors := copyObjects(ctx, *s3client, config.GetIngestBucket(), filesToCopy)
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
			err = queries.UpdateAssetArn(ctx, sqlc.UpdateAssetArnParams{
				ID:     assetID,
				AwsArn: null.StringFromPtr(asset.Arn),
			})
			if err != nil {
				return merry.Wrap(err)
			}
		}

		// Insert all stream endpoints into the CMS
		for _, e := range asset.EgressEndpoints {
			log.L.Debug().
				Str("status", *e.Status).
				Str("url", *e.Url).
				Msg("Egress endpoints")

			streamURL, _ := url.Parse(*e.Url)

			streamType := common.TypeHLSCmaf
			if strings.HasSuffix(*e.Url, "index.mpd") {
				streamType = common.TypeDash
			}

			stream := sqlc.InsertAssetStreamParams{
				Type:            streamType,
				Url:             *e.Url,
				Path:            streamURL.Path,
				Service:         "mediapackage",
				AssetID:         assetID,
				ConfigurationID: null.StringFromPtr(e.PackagingConfigurationId),
			}

			streamID, err := queries.InsertAssetStream(ctx, stream)
			if err != nil {
				return merry.Wrap(err)
			}

			for _, l := range audioLanguages {
				_, err = queries.InsertAssetStreamAudioLanguage(ctx, sqlc.InsertAssetStreamAudioLanguageParams{
					AssetstreamsID: streamID,
					LanguagesCode:  l,
				})
				if err != nil {
					return merry.Wrap(err)
				}
			}

			for _, l := range subLanguages {
				_, err = queries.InsertAssetStreamSubtitleLanguage(ctx, sqlc.InsertAssetStreamSubtitleLanguageParams{
					AssetstreamsID: streamID,
					LanguagesCode:  l,
				})
				if err != nil {
					return merry.Wrap(err)
				}
			}
		}
		log.L.Debug().Msg("Done creating streams")
	}

	log.L.Debug().Msg("Insert stuff into Directus")
	for _, af := range assetfiles {
		_, err = queries.InsertAssetFile(ctx, af)
		if err != nil {
			log.L.Error().Err(err).Str("language", af.AudioLanguageID.String).Msg("failed to insert asset file")
		}
	}

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

// UpdateIngestStatus parses the event and updates the status of an asset in the database
func UpdateIngestStatus(ctx context.Context, services externalServices, _ config, event pubsub.MediaPackageInputNotification) error {
	ctx, span := otel.Tracer("asset").Start(ctx, "updateIngestStatus")
	defer span.End()

	log.L.Debug().Str("EventType", event.Detail.Event).Msg("Processing event type")
	if event.Detail.Event == "IngestStarted" {
		return nil
	}
	if event.Detail.Event != "IngestComplete" {
		// We don't currently want to do anything for the other events
		log.L.Debug().Str("event", spew.Sdump(event)).Msg("Ignoring event")
		return nil
	}

	if len(event.Resources) < 1 {
		return merry.Wrap(ErrResourcesEmpty)
	}

	queries := services.GetQueries()

	asset, err := queries.AssetIDByARN(ctx, event.Resources[0])
	if err != nil {
		log.L.Warn().Err(err).Strs("arn", event.Resources).Msg("Error finding the asset to update")
		return merry.Wrap(err)
	}

	return queries.UpdateAssetStatus(ctx, sqlc.UpdateAssetStatusParams{
		ID:     asset,
		Status: string(common.StatusPublished),
	})
}
