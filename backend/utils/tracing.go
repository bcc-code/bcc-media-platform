package utils

import (
	"os"
	"strconv"

	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/uptrace/uptrace-go/uptrace"
)

// MustSetupTracing for Google Stack driver
//
// It uses the following ENV vars to do some auto config:
//   - GOOGLE_CLOUD_PROJECT
//   - TRACE_SAMPLING_FREQUENCY - A number between 0.0 and 1.0 that determines how often requests should be traced.
//     1.0 means every request. Default is 0.1, 10% of requests
func MustSetupTracing() {
	samplingFrequencyString := os.Getenv("TRACE_SAMPLING_FREQUENCY")
	frequency, err := strconv.ParseFloat(samplingFrequencyString, 32)
	if err != nil {
		log.L.Warn().Err(err).Msg("Error getting samplingFrequencyString, setting to 0.1")
		frequency = 0.1
	}

	if frequency == 0 {
		// Disabled
		log.L.Info().Msg("Tracing disabled")

		return
	}

	uptrace.ConfigureOpentelemetry(
		// copy your project DSN here or use UPTRACE_DSN env var
		//uptrace.WithDSN("https://<token>@uptrace.dev/<project_id>"),

		uptrace.WithServiceName("myservice"),
		uptrace.WithServiceVersion("v1.0.0"),
	)

}

/*
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
}*/
