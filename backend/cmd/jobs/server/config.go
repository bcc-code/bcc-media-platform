package server

// Config that can be passed to other things
type ConfigData struct {
	IngestBucket string
	JobsUserID   string
}

// GetIngestBucket as defined in the struct
func (c ConfigData) GetIngestBucket() string {
	return c.IngestBucket
}

// GetJobsUserID as defined in the struct
func (c ConfigData) GetJobsUserID() string {
	return c.JobsUserID
}
