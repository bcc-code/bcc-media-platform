package analytics

import (
	"github.com/bcc-code/bcc-media-platform/backend/applications"
	"github.com/bcc-code/bcc-media-platform/backend/common"
	"github.com/bcc-code/bcc-media-platform/backend/log"
	"github.com/gin-gonic/gin"
	r "github.com/rudderlabs/analytics-go/v4"
	"time"
)

type Service struct {
	rudderClient r.Client
}

type Config struct {
	WriteKey  string
	DataPlane string
	Verbose   bool
}

func NewService(config Config) *Service {
	if config.WriteKey == "" || config.DataPlane == "" {
		log.L.Warn().Msg("Rudderstack is not configured, data will not be sent to Rudderstack")
	}

	c, err := r.NewWithConfig(config.WriteKey,
		r.Config{
			DataPlaneUrl: config.DataPlane,
			Interval:     1 * time.Second,
			BatchSize:    100,
			Verbose:      config.Verbose,
			DisableGzip:  false,
		})

	if err != nil {
		log.L.Fatal().Err(err).Msg("Failed to create rudderstack client")
	}

	return &Service{
		rudderClient: c,
	}
}

func (s *Service) trackEvent(ctx *gin.Context, analyticsID string, event string, props r.Properties) {
	app, _ := applications.GetFromCtx(ctx)

	props = props.Set("requestId", ctx.GetHeader("X-Request-ID")).
		Set("sessionId", ctx.GetHeader("X-Session-ID")).
		Set("searchSessionId", ctx.GetHeader("X-Search-Session-ID")).
		Set("application", app.Code).
		Set("applicationVersion", app.ClientVersion)

	err := s.rudderClient.Enqueue(
		r.Track{
			UserId:     analyticsID,
			Event:      event,
			Properties: props,
		},
	)

	if err != nil {
		log.L.Warn().Err(err).Msg("Failed to send search event to rudderstack")
	}
}

func (s *Service) SearchEvent(
	ctx *gin.Context,
	analyticsID string,
	queryString string,
	typeArg *string,
	searchProvider string,
	searchResult common.SearchResult,
	duration time.Duration,
) {
	props := r.NewProperties().
		Set("query", queryString).
		Set("type", typeArg).
		Set("provider", searchProvider).
		Set("resultCount", searchResult.ResultCount).
		Set("topScore", searchResult.TopScore).
		Set("duration", duration.Milliseconds())

	s.trackEvent(ctx, analyticsID, "search", props)
}
