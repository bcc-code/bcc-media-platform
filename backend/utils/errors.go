package utils

import "github.com/bcc-code/mediabank-bridge/log"

// LogError if it occurs
func LogError(f func() error) {
	err := f()
	if err != nil {
		log.L.Error().Err(err).Msg("Error occurred")
	}
}
