package log

import (
	"os"

	"github.com/rs/zerolog"
	"github.com/rs/zerolog/pkgerrors"
)

// L is the main exposed logger
var L *zerolog.Logger

// ConfigureGlobalLogger with the correct formatter and debug level
func ConfigureGlobalLogger(logLevel zerolog.Level) {
	zerolog.SetGlobalLevel(logLevel)
	zerolog.LevelFieldName = "severity"

	zerolog.ErrorStackMarshaler = pkgerrors.MarshalStack

	logger := zerolog.
		New(os.Stderr).
		With().
		Timestamp().
		Stack()

	// Automatically detect if we are in GCR and apply Stackdriver log format
	// https://cloud.google.com/run/docs/reference/container-contract#env-vars
	serviceName := os.Getenv("K_SERVICE")
	println("Service Name: " + serviceName)
	if serviceName != "" {
		logger.Str("service", serviceName).
			Str("revision", os.Getenv("K_REVISION")).Logger()
		l := logger.Logger()
		L = &l
		return
	}

	l := logger.Logger().Output(zerolog.ConsoleWriter{Out: os.Stderr, NoColor: false})
	L = &l
}
