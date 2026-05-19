package utils

import (
	"context"
	"os"
	"strconv"
	"time"

	"github.com/bcc-code/bcc-media-platform/backend/log"

	mexporter "github.com/GoogleCloudPlatform/opentelemetry-operations-go/exporter/metric"
	texporter "github.com/GoogleCloudPlatform/opentelemetry-operations-go/exporter/trace"
	"github.com/uptrace/uptrace-go/uptrace"
	"go.opentelemetry.io/otel"
	stdout "go.opentelemetry.io/otel/exporters/stdout/stdouttrace"
	"go.opentelemetry.io/otel/propagation"
	sdkmetric "go.opentelemetry.io/otel/sdk/metric"
	"go.opentelemetry.io/otel/sdk/resource"
	sdktrace "go.opentelemetry.io/otel/sdk/trace"
	semconv "go.opentelemetry.io/otel/semconv/v1.4.0"
)

type TracingConfig struct {
	UptraceDSN        string
	SamplingFrequency string
	TracePrettyPrint  string
}

// parseSamplingFrequency returns the parsed frequency from config, or 0.1 on
// missing/invalid input. A return of 0 means tracing is disabled.
func parseSamplingFrequency(config TracingConfig) float64 {
	if config.SamplingFrequency == "" {
		return 0.1
	}
	freq, err := strconv.ParseFloat(config.SamplingFrequency, 64)
	if err != nil {
		log.L.Info().Err(err).Msg("Error parsing TRACE_SAMPLING_FREQUENCY, defaulting to 0.1")
		return 0.1
	}
	return freq
}

// resolveServiceName returns the effective service.name to attach to spans
// and metrics, applying the precedence: OTEL_SERVICE_NAME > K_SERVICE
// (Cloud Run) > hardcoded fallback. OTEL_SERVICE_NAME is also picked up by
// resource.WithFromEnv() further down, but we read it here so it wins even
// when K_SERVICE is present.
func resolveServiceName(fallback string) string {
	if v := os.Getenv("OTEL_SERVICE_NAME"); v != "" {
		return v
	}
	if v := os.Getenv("K_SERVICE"); v != "" {
		return v
	}
	return fallback
}

// buildResource constructs an OTel resource carrying service.name plus any
// attrs from OTEL_RESOURCE_ATTRIBUTES / OTEL_SERVICE_NAME.
func buildResource(ctx context.Context, serviceName string) (*resource.Resource, error) {
	return resource.New(ctx,
		resource.WithAttributes(semconv.ServiceNameKey.String(resolveServiceName(serviceName))),
		resource.WithTelemetrySDK(),
		resource.WithProcessRuntimeName(),
		resource.WithProcessRuntimeVersion(),
		resource.WithFromEnv(),
	)
}

// MustSetupTracing installs a global TracerProvider and propagator.
//
// It uses the following ENV vars for auto config:
//   - GOOGLE_CLOUD_PROJECT
//   - TRACE_SAMPLING_FREQUENCY - A number between 0.0 and 1.0 that determines
//     how often requests should be traced. 1.0 means every request. Default
//     is 0.1.
//   - OTEL_SERVICE_NAME / OTEL_RESOURCE_ATTRIBUTES - if set, override the
//     hardcoded serviceName argument.
func MustSetupTracing(serviceName string, config TracingConfig) {
	frequency := parseSamplingFrequency(config)
	if frequency == 0 {
		// Tracing disabled. We intentionally leave the global noop provider
		// installed, so all otel.Tracer(...) calls become no-ops.
		log.L.Info().Msg("Tracing disabled")
		return
	}

	res, err := buildResource(context.Background(), serviceName)
	if err != nil {
		log.L.Error().Err(err).Msg("Unable to build OTel resource; tracing not configured")
		return
	}

	if config.UptraceDSN != "" {
		uptrace.ConfigureOpentelemetry(
			uptrace.WithDSN(config.UptraceDSN),
			uptrace.WithResource(res),
		)
		// Uptrace sets the global propagator as part of ConfigureOpentelemetry.
		return
	}

	var exporter sdktrace.SpanExporter
	if config.TracePrettyPrint == "true" {
		exporter, err = stdout.New(stdout.WithPrettyPrint())
		if err != nil {
			log.L.Error().Err(err).Msg("Unable to set up stdout trace exporter")
			return
		}
	} else {
		project := os.Getenv("GOOGLE_CLOUD_PROJECT")
		log.L.Debug().Msgf("Setting trace sampling probability to %.2f", frequency)
		exporter, err = texporter.New(texporter.WithProjectID(project))
		if err != nil {
			log.L.Error().Err(err).Msg("Unable to set up Google Cloud Trace exporter")
			return
		}
	}

	traceProvider := sdktrace.NewTracerProvider(
		sdktrace.WithBatcher(exporter),
		sdktrace.WithSampler(sdktrace.TraceIDRatioBased(frequency)),
		sdktrace.WithResource(res),
	)
	otel.SetTracerProvider(traceProvider)
	otel.SetTextMapPropagator(propagation.NewCompositeTextMapPropagator(
		propagation.TraceContext{},
		propagation.Baggage{},
	))
}

// MustSetupMetrics installs a global MeterProvider.
//
// Uses the same env vars as MustSetupTracing for service identity and the
// sampling-frequency-as-master-switch.
//
// When config.UptraceDSN is set, MustSetupTracing has already installed a
// MeterProvider via uptrace.ConfigureOpentelemetry; this function is a no-op
// in that branch and must be called *after* MustSetupTracing.
func MustSetupMetrics(serviceName string, config TracingConfig) {
	if parseSamplingFrequency(config) == 0 {
		// Same master switch as tracing. Leaves the noop meter provider in
		// place.
		return
	}

	if config.UptraceDSN != "" {
		// Uptrace's ConfigureOpentelemetry already wired a MeterProvider with
		// the shared resource.
		return
	}

	if config.TracePrettyPrint == "true" {
		// Local dev: skip the GCP metric exporter (would require credentials)
		// and leave the noop meter provider in place.
		return
	}

	res, err := buildResource(context.Background(), serviceName)
	if err != nil {
		log.L.Error().Err(err).Msg("Unable to build OTel resource; metrics not configured")
		return
	}

	project := os.Getenv("GOOGLE_CLOUD_PROJECT")
	exporter, err := mexporter.New(mexporter.WithProjectID(project))
	if err != nil {
		log.L.Error().Err(err).Msg("Unable to set up Google Cloud Metric exporter")
		return
	}

	meterProvider := sdkmetric.NewMeterProvider(
		sdkmetric.WithResource(res),
		sdkmetric.WithReader(sdkmetric.NewPeriodicReader(
			exporter,
			sdkmetric.WithInterval(60*time.Second),
		)),
	)
	otel.SetMeterProvider(meterProvider)
}
