package server

import "github.com/aws/aws-sdk-go-v2/aws"

// ConfigData that can be passed to other things
type ConfigData struct {
	IngestBucket          string
	StorageBucket         string
	PackagingGroupID      string
	MediapackageRole      string
	MediapackageSource    string
	DeleteIngestFilesFlag bool
}

// GetIngestBucket that contains the new assets
func (c ConfigData) GetIngestBucket() *string {
	return aws.String(c.IngestBucket)
}

// GetStorageBucket where the assets are stored for consumption by Mediapackage
func (c ConfigData) GetStorageBucket() *string {
	return aws.String(c.StorageBucket)
}

// GetPackagingGroup that the assets should be ingested into
func (c ConfigData) GetPackagingGroup() *string {
	return aws.String(c.PackagingGroupID)
}

// GetMediapackageRole ARN that should be used for ingesting the assets
func (c ConfigData) GetMediapackageRole() *string {
	return aws.String(c.MediapackageRole)
}

// GetMediapackageSource S3 ARN that the MediapackageRole has access to
func (c ConfigData) GetMediapackageSource() *string {
	return aws.String(c.MediapackageSource)
}

// GetDeleteIngestFilesFlag controls if the ingest files get deleted after
// a successful import
func (c ConfigData) GetDeleteIngestFilesFlag() bool {
	return c.DeleteIngestFilesFlag
}
