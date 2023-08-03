package server

import (
	"database/sql"
	"github.com/aws/aws-sdk-go-v2/service/mediapackagevod"
	"github.com/aws/aws-sdk-go-v2/service/s3"
	"github.com/bcc-code/brunstadtv/backend/crowdin"
	"github.com/bcc-code/brunstadtv/backend/directus"
	"github.com/bcc-code/brunstadtv/backend/remotecache"
	"github.com/bcc-code/brunstadtv/backend/scheduler"
	"github.com/bcc-code/brunstadtv/backend/search"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
	"github.com/bcc-code/brunstadtv/backend/statistics"
	"github.com/go-resty/resty/v2"
)

// ExternalServices used by the Server
type ExternalServices struct {
	S3Client             *s3.Client
	MediaPackageVOD      *mediapackagevod.Client
	DirectusClient       *resty.Client
	SearchService        *search.Service
	DirectusEventHandler *directus.EventHandler
	Database             *sql.DB
	RemoteCache          *remotecache.Client
	Queries              *sqlc.Queries
	CrowdinClient        *crowdin.Client
	Scheduler            *scheduler.Service
	StatisticsHandler    *statistics.Handler
}

// GetS3Client as stored in the struct
func (e ExternalServices) GetS3Client() *s3.Client {
	return e.S3Client
}

// GetMediaPackageVOD as stored in the struct
func (e ExternalServices) GetMediaPackageVOD() *mediapackagevod.Client {
	return e.MediaPackageVOD
}

// GetDirectusClient as stored in the struct
func (e ExternalServices) GetDirectusClient() *resty.Client {
	return e.DirectusClient
}

// GetSearchService as stored in the struct
func (e ExternalServices) GetSearchService() *search.Service {
	return e.SearchService
}

// GetDirectusEventHandler as stored in the struct
func (e ExternalServices) GetDirectusEventHandler() *directus.EventHandler {
	return e.DirectusEventHandler
}

// GetCrowdinClient as stored in the struct
func (e ExternalServices) GetCrowdinClient() *crowdin.Client {
	return e.CrowdinClient
}

// GetQueries as stored in the struct
func (e ExternalServices) GetQueries() *sqlc.Queries {
	return e.Queries
}

// GetScheduler as stored in the struct
func (e ExternalServices) GetScheduler() *scheduler.Service {
	return e.Scheduler
}

func (e ExternalServices) GetStatisticHandler() *statistics.Handler {
	return e.StatisticsHandler
}
