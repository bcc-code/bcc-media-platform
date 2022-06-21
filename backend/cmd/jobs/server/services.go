package server

import (
	"github.com/aws/aws-sdk-go-v2/service/mediapackagevod"
	"github.com/aws/aws-sdk-go-v2/service/s3"
	"github.com/bcc-code/brunstadtv/backend/search"
	"github.com/go-resty/resty/v2"
)

// ExternalServices used by the server
type ExternalServices struct {
	S3Client        *s3.Client
	MediaPackageVOD *mediapackagevod.Client
	DirectusClient  *resty.Client
	SearchService   *search.Service
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
