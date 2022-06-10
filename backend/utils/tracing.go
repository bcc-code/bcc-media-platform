package utils

import (
	"os"
	"strconv"

	texporter "github.com/GoogleCloudPlatform/opentelemetry-operations-go/exporter/trace"
	"github.com/bcc-code/mediabank-bridge/log"
	"go.opentelemetry.io/otel"
	stdout "go.opentelemetry.io/otel/exporters/stdout/stdouttrace"
	sdktrace "go.opentelemetry.io/otel/sdk/trace"
)

// MustSetupTracing for Google Stack driver
//
// It uses the following ENV vars to do some auto config:
// * GOOGLE_CLOUD_PROJECT
// * TRACE_SAMPLING_FREQUENCY - A number between 0.0 and 1.0 that determines how often requests should be traced.
//  1.0 means every request. Default is 0.1, 10% of requests
func MustSetupTracing() {
	samplingFrequencyString := os.Getenv("TRACE_SAMPLING_FREQUENCY")
	frequency, err := strconv.ParseFloat(samplingFrequencyString, 32)
	if err != nil {
		log.L.Warn().Err(err).Msg("Error getting samplingFrequencyString, setting to 0.1")
		frequency = 0.1
	}

	if frequency == 0 {
		// Disabled
		return
	}

	var exporter sdktrace.SpanExporter
	exporter, _ = stdout.New(stdout.WithPrettyPrint())

	if os.Getenv("TRACE_PRETTY") != "true" {
		project := os.Getenv("GOOGLE_CLOUD_PROJECT")

		log.L.Debug().Msgf("Setting trace sampling probability to %.2f", frequency)

		// Create exporter and trace provider pipeline, and register provider.
		exporter, err = texporter.New(texporter.WithProjectID(project))
		if err != nil {
			log.L.Error().Err(err).Msg("Unable to set up stackdriver")
		}
	}

	traceProvider := sdktrace.NewTracerProvider(sdktrace.WithBatcher(exporter))
	otel.SetTracerProvider(traceProvider)
}
