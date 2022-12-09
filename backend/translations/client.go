package translations

import (
	"context"
	"github.com/bcc-code/brunstadtv/backend/common"
)

// TranslationService is a service which can handle translations
type TranslationService interface {
	Get(ctx context.Context, collection string, identifier string) common.LocaleMap[string]
	GetMany(ctx context.Context, collection string, identifiers []string) map[string]common.LocaleMap[string]
	List(ctx context.Context, collection string) map[string]common.LocaleMap[string]
}
