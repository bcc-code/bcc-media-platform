package utils

import (
	"os"
	"strconv"

	texporter "github.com/GoogleCloudPlatform/opentelemetry-operations-go/exporter/trace"
	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/uptrace/uptrace-go/uptrace"
	"go.opentelemetry.io/otel"
	stdout "go.opentelemetry.io/otel/exporters/stdout/stdouttrace"
	sdktrace "go.opentelemetry.io/otel/sdk/trace"
)

type TracingConfig struct {
	UptraceDSN        string
	SamplingFrequency string
	TracePrettyPrint  string
}

// MustSetupTracing for Google Stack driver
//
// It uses the following ENV vars to do some auto config:
//   - GOOGLE_CLOUD_PROJECT
//   - TRACE_SAMPLING_FREQUENCY - A number between 0.0 and 1.0 that determines how often requests should be traced.
//     1.0 means every request. Default is 0.1, 10% of requests
func MustSetupTracing(serviceName string, config TracingConfig) {
	frequency := 0.1
	var err error
	if config.SamplingFrequency != "" {
		frequency, err = strconv.ParseFloat(config.SamplingFrequency, 32)
	}
	if err != nil {
		log.L.Info().Err(err).Msg("Error getting samplingFrequencyString, setting to 0.1")
		frequency = 0.1
	}
	if frequency == 0 {
		// Disabled
		log.L.Info().Msg("Tracing disabled")

		return
	}

	if config.UptraceDSN != "" {
		uptrace.ConfigureOpentelemetry(
			uptrace.WithDSN(config.UptraceDSN),
			uptrace.WithServiceName(serviceName),
		)

		// No need to set up more if we are doing uptrace
		return
	}

	var exporter sdktrace.SpanExporter
	exporter, _ = stdout.New(stdout.WithPrettyPrint())

	if config.TracePrettyPrint != "true" {
		project := os.Getenv("GOOGLE_CLOUD_PROJECT")

		log.L.Debug().Msgf("Setting trace sampling probability to %.2f", frequency)

		// Create exporter and trace provider pipeline, and register provider.
		exporter, err = texporter.New(texporter.WithProjectID(project))
		if err != nil {
			log.L.Error().Err(err).Msg("Unable to set up stackdriver")
		}
	}

	traceProvider := sdktrace.NewTracerProvider(sdktrace.WithBatcher(exporter), sdktrace.WithSampler(sdktrace.TraceIDRatioBased(frequency)))
	otel.SetTracerProvider(traceProvider)
}
