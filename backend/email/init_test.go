package email

import (
	"github.com/bcc-code/bcc-media-platform/backend/log"
	"github.com/rs/zerolog"
)

func init() {
	log.ConfigureGlobalLogger(zerolog.DebugLevel)
}