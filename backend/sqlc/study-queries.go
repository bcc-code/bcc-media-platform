package sqlc

import (
	"context"
	"github.com/bcc-code/brunstadtv/backend/studies"
)

// GetStudies returns studies
func GetStudies(ctx context.Context) ([]studies.Topic, error) {
	return nil, nil
}
