package server

import (
	"database/sql"
	"github.com/bcc-code/bcc-media-platform/backend/translations"

	"github.com/aws/aws-sdk-go-v2/service/mediapackagevod"
	"github.com/aws/aws-sdk-go-v2/service/s3"
	"github.com/bcc-code/bcc-media-platform/backend/events"
	"github.com/bcc-code/bcc-media-platform/backend/files"
	"github.com/bcc-code/bcc-media-platform/backend/remotecache"
	"github.com/bcc-code/bcc-media-platform/backend/scheduler"
	"github.com/bcc-code/bcc-media-platform/backend/search"
	"github.com/bcc-code/bcc-media-platform/backend/sqlc"
	"github.com/bcc-code/bcc-media-platform/backend/statistics"
	"github.com/bcc-code/bcc-media-platform/backend/videomanipulator"
)

// ExternalServices used by the Server
type ExternalServices struct {
	S3Client                *s3.Client
	MediaPackageVOD         *mediapackagevod.Client
	SearchService           *search.Service
	EventHandler            *events.Handler
	Database                *sql.DB
	RemoteCache             *remotecache.Client
	Queries                 *sqlc.Queries
	Scheduler               *scheduler.Service
	StatisticsHandler       *statistics.Handler
	FileService             files.Service
	VideoManipulatorService *videomanipulator.VideoManipulatorService
	TranslationsService     *translations.Service
}

// GetDatabase as stored in the struct
func (e ExternalServices) GetDatabase() *sql.DB {
	return e.Database
}

// GetS3Client as stored in the struct
func (e ExternalServices) GetS3Client() *s3.Client {
	return e.S3Client
}

// GetMediaPackageVOD as stored in the struct
func (e ExternalServices) GetMediaPackageVOD() *mediapackagevod.Client {
	return e.MediaPackageVOD
}

// GetSearchService as stored in the struct
func (e ExternalServices) GetSearchService() *search.Service {
	return e.SearchService
}

// GetEventHandler as stored in the struct
func (e ExternalServices) GetEventHandler() *events.Handler {
	return e.EventHandler
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

func (e ExternalServices) GetFileService() files.Service {
	return e.FileService
}

func (e ExternalServices) GetVideoManipulatorService() *videomanipulator.VideoManipulatorService {
	return e.VideoManipulatorService
}

func (e ExternalServices) GetTranslationService() *translations.Service {
	return e.TranslationsService
}
