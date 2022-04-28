package server

import (
	"database/sql"

	"github.com/aws/aws-sdk-go/service/s3"
	"github.com/bcc-code/brunstadtv/backend/sqlc"
)

// ExternalServices used by the server
type ExternalServices struct {
	RawDB    *sql.DB
	DB       *sqlc.Queries
	S3Client *s3.S3
}

// GetS3Client as stored in the struct
func (e ExternalServices) GetS3Client() *s3.S3 {
	return e.S3Client
}
