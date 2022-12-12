package translations

import (
	"context"
	"github.com/bcc-code/brunstadtv/backend/crowdin2"
	"github.com/go-resty/resty/v2"
)

// Service contains methods for handling translations
type Service struct {
	directus *resty.Client
	crowdin  *crowdin2.Client
}

// New service
func New(directus *resty.Client, crowdin *crowdin2.Client) *Service {
	return &Service{
		directus: directus,
		crowdin:  crowdin,
	}
}

// Source is a service which can handle translations
type Source interface {
	List(ctx context.Context) ([]Translation, error)
}

// Destination is where the translations should go
type Destination interface {
	Save(ctx context.Context, translations []Translation) error
}

// Sync translations between the source and destination
func (s *Service) Sync(ctx context.Context) {

}
