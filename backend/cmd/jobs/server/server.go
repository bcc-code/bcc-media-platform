package server

import (
	"context"
	"encoding/json"
	"fmt"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/s3"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/samber/lo"
	"gopkg.in/guregu/null.v4"
	"io"
	"net/http"
	"time"

	"github.com/bcc-code/brunstadtv/backend/remotecache"
	"github.com/bcc-code/brunstadtv/backend/utils"
	sns "github.com/robbiet480/go.sns"

	cache "github.com/Code-Hex/go-generics-cache"
	"github.com/ansel1/merry/v2"
	"github.com/bcc-code/brunstadtv/backend/asset"
	"github.com/bcc-code/brunstadtv/backend/crowdin"
	"github.com/bcc-code/brunstadtv/backend/events"
	externalevents "github.com/bcc-code/brunstadtv/backend/external-events"
	"github.com/bcc-code/brunstadtv/backend/maintenance"
	"github.com/bcc-code/brunstadtv/backend/pubsub"
	"github.com/bcc-code/mediabank-bridge/log"
	cloudevents "github.com/cloudevents/sdk-go/v2"
	"github.com/davecgh/go-spew/spew"
	"github.com/gin-gonic/gin"
	"go.opentelemetry.io/otel"
	"go.opentelemetry.io/otel/attribute"
	"go.opentelemetry.io/otel/codes"
)

var (
	errUndefinedHandler = merry.New("Handler for this message type is not defined")
)

var (
	messageCache = cache.New[string, bool]()
)

var (
	runOnceOnNode = map[string]struct{}{
		events.TypeSearchReindex:    {},
		events.TypeTranslationsSync: {},
		events.TypeDirectusEvent:    {},
	}
)

// NewServer returns a new Server for handling the HTTP requests
// Yes, go, I know it's "annoying to work with" but in this case you will have to deal with it
func NewServer(s ExternalServices, c ConfigData) *Server {
	return &Server{
		services: s,
		config:   c,
	}
}

// Server is the base for all HTTP handler
type Server struct {
	services ExternalServices
	config   ConfigData
}

func (s Server) runIfNotLocked(ctx context.Context, lockID string, task func() error) error {
	res, err := s.services.RemoteCache.Client().Get(ctx, lockID).Result()
	if err != nil && err != remotecache.Nil {
		return err
	}
	if res != "" {
		log.L.Debug().Msg("Ignoring message as it is most likely running already")
		return nil
	}
	_, err = s.services.RemoteCache.Client().Set(ctx, lockID, "running", time.Minute*10).Result()
	if err != nil {
		return err
	}
	defer func() {
		s.services.RemoteCache.Client().Del(ctx, lockID)
	}()
	return task()
}

// ProcessMessage processes the message for ingesting a VOD asset
func (s Server) ProcessMessage(c *gin.Context) {
	ctx := c.Request.Context()
	ctx, span := otel.Tracer("jobs/core").Start(ctx, "ProcessMessage")
	defer span.End()

	msg, err := pubsub.MessageFromCtx(c)
	if err != nil {
		span.SetStatus(codes.Error, err.Error())
		log.L.Error().Err(err).Msgf("Could not extract message from context")
		c.Status(http.StatusOK)
		return
	}
	span.AddEvent("message extracted from ctx")

	e := cloudevents.NewEvent()
	err = pubsub.ExtractData(*msg, &e)
	if err != nil {
		span.SetStatus(codes.Error, err.Error())
		log.L.Error().
			Err(err).
			Str("msg", spew.Sdump(msg)).
			Msgf("Could not create cloud event. Likely bad format")
		c.Status(http.StatusOK)
		return
	}
	span.AddEvent("extracted event data")

	span.SetAttributes(attribute.String("MsgId", e.ID()), attribute.String("MessageSource", e.Source()))

	log.L.Debug().
		Str("MsgId", e.ID()).
		Str("Source", e.Source()).
		Msg("processing message")

	// Mostly for local development. Run exactly once is enabled in cloud
	if _, ok := runOnceOnNode[e.Type()]; ok {
		if messageCache.Contains(e.ID()) {
			log.L.Debug().Str("MsgId", e.ID()).Msg("ignoring processed message")
			c.Status(http.StatusOK)
			return
		}

		messageCache.Set(e.ID(), true, cache.WithExpiration(time.Minute*5))
	}

	switch e.Type() {
	case events.TypeAssetDelivered:
		err = asset.Ingest(ctx, s.services, s.config, e)
	case events.TypeRefreshView:
		err = maintenance.RefreshView(ctx, s.services, e)
	case events.TypeDirectusEvent:
		err = s.services.GetDirectusEventHandler().ProcessCloudEvent(ctx, e)
	case events.TypeSearchReindex:
		err = s.services.GetSearchService().Reindex(ctx)
	case events.TypeExportAnswersToBQ:
		err = s.services.GetStatisticHandler().HandleAnswerExportToBQ(ctx)
	case events.TypeTranslationsSync:
		err = s.runIfNotLocked(ctx, fmt.Sprintf("event:%s", e.Type()), func() error {
			return crowdin.HandleEvent(ctx, s.services, e)
		})
	default:
		err = merry.Wrap(errUndefinedHandler)
	}

	if err != nil {
		log.L.Error().
			Err(err).
			Str("msg", spew.Sdump(msg)).
			Msgf("Error processing message. See log for more details")
		c.Status(http.StatusOK)
		return
	}
}

// IngestEventMeta ingests the event meta
func (s Server) IngestEventMeta(c *gin.Context) {
	jsonData, err := io.ReadAll(c.Request.Body)
	defer utils.LogError(c.Request.Body.Close)
	if err != nil {
		_ = c.Error(err)
		c.AbortWithStatus(http.StatusBadRequest)
	}

	event, err := externalevents.ParseEvent(jsonData)
	if err != nil {
		_ = c.Error(err)
		c.AbortWithStatus(http.StatusBadRequest)
	}

	// TODO: Do something with the data :D.
	log.L.Debug().Str("eventType", event.Type.S()).Msg("Got new event Meta")
}

// ProcessAwsMessage process an event for AWS
func (s Server) ProcessAwsMessage(c *gin.Context) {
	ctx := c.Request.Context()
	ctx, span := otel.Tracer("jobs/core").Start(ctx, "ProcessAWSMessage")
	defer span.End()

	jsonData, err := io.ReadAll(c.Request.Body)
	defer utils.LogError(c.Request.Body.Close)

	if err != nil {
		log.L.Error().Err(err).Send()
		c.AbortWithStatus(http.StatusBadRequest)
		return
	}

	var notificationPayload sns.Payload
	err = json.Unmarshal(jsonData, &notificationPayload)
	if err != nil {
		log.L.Error().Err(err).Send()
		_ = c.Error(err)
		c.AbortWithStatus(http.StatusBadRequest)
		return
	}

	err = notificationPayload.VerifyPayload()
	if err != nil {

		// TEMP DEBUG
		log.L.Debug().Str("payload", string(jsonData)).Msg("Could not verify payload")

		err = merry.Wrap(err)
		log.L.Error().Err(err).Send()
		_ = c.Error(err)
		c.AbortWithStatus(http.StatusBadRequest)
		return
	}

	span.AddEvent("AWSSNS Message validated")

	switch notificationPayload.Type {
	case "SubscriptionConfirmation":
		_, err := notificationPayload.Subscribe()
		if err != nil {
			log.L.Error().Err(err).Send()
			_ = c.Error(err)
			c.AbortWithStatus(http.StatusBadRequest)
			return
		}
		span.AddEvent("Confirmed AWS SNS subscription")
		c.Status(http.StatusOK)
		return
	case "Notification":
		n, err := pubsub.ParseMediaPackageNotification(notificationPayload.Message)
		if err != nil {
			log.L.Error().Err(err).Send()
			_ = c.Error(err)
			c.AbortWithStatus(http.StatusBadRequest)
			return
		}
		err = asset.UpdateIngestStatus(ctx, s.services, s.config, *n)
		if err != nil {
			log.L.Error().Err(err).Send()
			_ = c.Error(err)
			c.AbortWithStatus(http.StatusBadRequest)
			return
		}
		return
	default:
		log.L.Warn().Str("message", string(jsonData)).Msg("Unable to process AWS SNS Message")
	}
}

// ProcessScheduledTask processes the scheduled task.
func (s Server) ProcessScheduledTask(ctx *gin.Context) {
	s.services.Scheduler.HandleRequest(ctx)
}

// ExportUnusedAssets exports paths of unused assets.
func (s Server) ExportUnusedAssets(ctx *gin.Context) {

	assets, err := s.services.Queries.ListAssets(ctx)
	if err != nil {
		log.L.Error().Err(err).Send()
		ctx.Status(500)
		return
	}

	episodes, err := s.services.Queries.ListEpisodes(ctx)
	if err != nil {
		log.L.Error().Err(err).Send()
		ctx.Status(500)
		return
	}

	var usedIDs []int32
	var paths []string

	for _, e := range episodes {
		if e.AssetID.Valid {
			a, found := lo.Find(assets, func(a sqlc.Asset) bool {
				return a.ID == int32(e.AssetID.Int64)
			})
			if found {
				if a.EncodingVersion.String == "azure_media_services" || a.DateCreated.After(time.Now().Add(time.Hour*24*7*-1)) {
					continue
				}
				usedIDs = append(usedIDs, a.ID)
				if a.MainStoragePath.Valid {
					paths = append(paths, a.MainStoragePath.String)
				}
			}
		}
	}

	var unusedIDs []int32
	var unusedPaths []string

	for _, a := range assets {
		if a.EncodingVersion.String == "azure_media_services" || a.DateCreated.After(time.Now().Add(time.Hour*24*7*-1)) {
			continue
		}
		if !lo.Contains(usedIDs, a.ID) {
			unusedIDs = append(unusedIDs, a.ID)
		}
		if a.MainStoragePath.Valid && !lo.Contains(paths, a.MainStoragePath.String) {
			unusedPaths = append(unusedPaths, a.MainStoragePath.String)
		}
	}

	cfg, err := config.LoadDefaultConfig(ctx, config.WithRegion("eu-north-1"), config.WithSharedConfigProfile("bccm-prod"))
	if err != nil {
		log.L.Error().Err(err).Send()
		return
	}

	service := s3.NewFromConfig(cfg)

	bucket := "vod-asset-storage-prod"

	i := 0

	for _, path := range unusedPaths {
		if i >= 200 {
			break
		}
		i++
		objs, err := service.ListObjects(ctx, &s3.ListObjectsInput{
			Bucket: &bucket,
			Prefix: &path,
		})
		if err != nil {
			log.L.Error().Err(err).Send()
			return
		}
		for _, obj := range objs.Contents {
			log.L.Debug().Str("key", *obj.Key).Msg("Deleting blob")
			_, err := service.DeleteObject(ctx, &s3.DeleteObjectInput{
				Bucket: &bucket,
				Key:    obj.Key,
			})
			if err != nil {
				log.L.Error().Err(err).Send()
				return
			}
		}
		log.L.Debug().Str("path", path).Msg("Deleting asset from db")
		err = s.services.Queries.DeletePath(ctx, null.StringFrom(path))
		if err != nil {
			log.L.Error().Err(err).Send()
			return
		}
	}

	ctx.JSON(200, map[string]any{
		"paths":            paths,
		"pathsCount":       len(paths),
		"usedIds":          usedIDs,
		"usedIdsCount":     len(usedIDs),
		"unusedIds":        unusedIDs,
		"unusedIdsCount":   len(unusedIDs),
		"unusedPaths":      unusedPaths,
		"unusedPathsCount": len(unusedPaths),
	})
}
