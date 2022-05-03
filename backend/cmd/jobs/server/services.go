package server

import (
	"database/sql"

	"github.com/aws/aws-sdk-go-v2/service/mediapackagevod"
	"github.com/aws/aws-sdk-go-v2/service/s3"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
)

// ExternalServices used by the server
type ExternalServices struct {
	RawDB           *sql.DB
	DB              *sqlc.Queries
	S3Client        *s3.Client
	MediaPackageVOD *mediapackagevod.Client
}

// GetS3Client as stored in the struct
func (e ExternalServices) GetS3Client() *s3.Client {
	return e.S3Client
}

// GetMediaPackageVOD as stored in the struct
func (e ExternalServices) GetMediaPackageVOD() *mediapackagevod.Client {
	return e.MediaPackageVOD
}
