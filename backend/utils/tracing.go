package utils

import (
	"net/http"
	"os"
	"strconv"

	"contrib.go.opencensus.io/exporter/stackdriver"
	"contrib.go.opencensus.io/exporter/stackdriver/propagation"
	"github.com/bcc-code/mediabank-bridge/log"
	"go.opencensus.io/plugin/ochttp"
	"go.opencensus.io/trace"
)

// MustSetupTracing for Google Stack driver
//
// It uses the following ENV vars to do some auto config:
// * GOOGLE_CLOUD_PROJECT
// * TRACE_SAMPLING_FREQUENCY - A number between 0.0 and 1.0 that determines how often requests should be traced.
//  1.0 means every request. Default is 0.1, 10% of requests
func MustSetupTracing() *http.Client {
	project := os.Getenv("GOOGLE_CLOUD_PROJECT")

	exporter, err := stackdriver.NewExporter(stackdriver.Options{
		ProjectID: project,
	})

	if err != nil {
		log.L.Fatal().Err(err)
		panic(err)
	}

	samplingFrequencyString := os.Getenv("TRACE_SAMPLING_FREQUENCY")
	frequency, err := strconv.ParseFloat(samplingFrequencyString, 32)
	if err != nil {
		log.L.Warn().Err(err).Msg("Error getting samplingFrequencyString, setting to 0.1")
		frequency = 0.1
	}

	log.L.Debug().Msgf("Setting trace sampling probability to %.2f", frequency)
	trace.RegisterExporter(exporter)
	trace.ApplyConfig(trace.Config{DefaultSampler: trace.ProbabilitySampler(frequency)})

	client := &http.Client{
		Transport: &ochttp.Transport{
			// Use Google Cloud propagation format.
			Propagation: &propagation.HTTPFormat{},
		},
	}

	return client
}
