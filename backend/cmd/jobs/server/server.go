package server

import (
	"context"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"time"

	"github.com/bcc-code/bcc-media-platform/backend/remotecache"
	"github.com/bcc-code/bcc-media-platform/backend/utils"
	sns "github.com/robbiet480/go.sns"

	cache "github.com/Code-Hex/go-generics-cache"
	"github.com/ansel1/merry/v2"
	"github.com/bcc-code/bcc-media-platform/backend/asset"
	"github.com/bcc-code/bcc-media-platform/backend/crowdin"
	"github.com/bcc-code/bcc-media-platform/backend/events"
	externalevents "github.com/bcc-code/bcc-media-platform/backend/external-events"
	"github.com/bcc-code/bcc-media-platform/backend/maintenance"
	"github.com/bcc-code/bcc-media-platform/backend/pubsub"
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
	case events.TypeAssetTimedMetadataDelivered:
		msg := events.AssetTimedMetadataDelivered{}
		err = e.DataAs(&msg)
		if err != nil {
			break
		}
		err = asset.IngestTimedMetadata(ctx, s.services, s.config, asset.IngestTimedMetadataParams{
			VXID:     msg.VXID,
			JSONPath: msg.JSONPath,
		})
	case events.TypeRefreshView:
		err = maintenance.RefreshView(ctx, s.services, e)
	case events.TypeDirectusEvent:
		err = s.services.GetEventHandler().ProcessCloudEvent(ctx, e)
	case events.TypeSearchReindex:
		err = s.services.GetSearchService().Reindex(ctx)
	case events.TypeExportAnswersToBQ:
		err = s.services.GetStatisticHandler().HandleAnswerExportToBQ(ctx)
	case events.TypeTranslationsSync:
		err = s.runIfNotLocked(ctx, fmt.Sprintf("event:%s:%s", e.Type(), e.ID()), func() error {
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
		span.SetStatus(codes.Error, err.Error())
		c.JSON(http.StatusOK, map[string]string{"error": err.Error()})
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
