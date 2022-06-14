package auth0

import (
	"context"
	"fmt"

	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/lestrrat-go/jwx/jwk"
	"go.opentelemetry.io/otel"
)

var jwksMap map[string]jwk.Set = map[string]jwk.Set{}

// GetKeySet for the specified domain.
// The result is cached for the lifetime of the program
func GetKeySet(ctx context.Context, domain string) jwk.Set {
	ctx, span := otel.Tracer("auth0").Start(ctx, "GetKeySet")
	defer span.End()
	if keySet, ok := jwksMap[domain]; ok {
		span.AddEvent("Returned from memory")
		return keySet
	}

	keyURL := fmt.Sprintf("https://%s/.well-known/jwks.json", domain)
	log.L.Debug().Str("URL", keyURL).Msg("Fetching jwks")
	keySet, err := jwk.Fetch(ctx, keyURL)
	if err != nil {
		log.L.Panic().
			Err(err).
			Msg("Unable to get PEM 1")
		return nil
	}

	jwksMap[domain] = keySet
	span.AddEvent("Fetched from net")
	return keySet
}
