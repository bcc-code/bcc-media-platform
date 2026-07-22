package main

import "testing"

// setVODSigning sets the VOD signing env vars. Live signing is fully
// independent of these — the tests below assert VOD values never leak into the
// live configs.
func setVODSigning(t *testing.T) {
	t.Helper()
	t.Setenv("CF_SIGNING_KEY_PATH", "vod-cf.rsa")
	t.Setenv("CF_SIGNING_KEY_ID", "vod-cf-id")
	t.Setenv("IORIVER_SIGNING_KEY_PATH", "vod-ioriver.rsa")
	t.Setenv("IORIVER_CLOUDFRONT_KEY_ID", "vod-ioriver-cf-id")
	t.Setenv("IORIVER_FASTLY_KEY_ID", "vod-ioriver-fastly-id")
	t.Setenv("IORIVER_AKAMAI_KEY_ID", "vod-ioriver-akamai-id")
	t.Setenv("IORIVER_AKAMAI_ENCRYPTION_KEY", "vod-ioriver-akamai-key")
	t.Setenv("STREAM_PROXY_CDN_DOMAIN_CLOUDFRONT", "vod-cf.example.com")
	t.Setenv("STREAM_PROXY_CDN_DOMAIN_IORIVER", "vod.example.com")
}

// TestLiveSigningIsIndependentOfVOD: live signing comes only from LIVE_* vars,
// and VOD signing only from its own vars — no cross-contamination in either
// direction.
func TestLiveSigningIsIndependentOfVOD(t *testing.T) {
	setVODSigning(t)
	t.Setenv("LIVE_CF_SIGNING_KEY_PATH", "live-cf.rsa")
	t.Setenv("LIVE_CF_SIGNING_KEY_ID", "live-cf-id")
	t.Setenv("LIVE_IORIVER_SIGNING_KEY_PATH", "live-ioriver.rsa")
	t.Setenv("LIVE_IORIVER_CLOUDFRONT_KEY_ID", "live-ioriver-cf-id")
	t.Setenv("LIVE_IORIVER_FASTLY_KEY_ID", "live-ioriver-fastly-id")
	t.Setenv("LIVE_IORIVER_AKAMAI_KEY_ID", "live-ioriver-akamai-id")
	t.Setenv("LIVE_IORIVER_AKAMAI_ENCRYPTION_KEY", "live-ioriver-akamai-key")

	cfg := getEnvConfig()

	wantLiveCF := cloudfrontSigningConfig{KeyPath: "live-cf.rsa", KeyID: "live-cf-id"}
	if cfg.LiveCloudFrontSigning != wantLiveCF {
		t.Errorf("live CF signing = %+v, want %+v", cfg.LiveCloudFrontSigning, wantLiveCF)
	}
	wantLiveIoriver := ioriverSigningConfig{
		KeyPath:             "live-ioriver.rsa",
		CloudFrontKeyID:     "live-ioriver-cf-id",
		FastlyKeyID:         "live-ioriver-fastly-id",
		AkamaiKeyID:         "live-ioriver-akamai-id",
		AkamaiEncryptionKey: "live-ioriver-akamai-key",
	}
	if cfg.LiveIoriverSigning != wantLiveIoriver {
		t.Errorf("live ioriver signing = %+v, want %+v", cfg.LiveIoriverSigning, wantLiveIoriver)
	}

	// VOD configs must be untouched by the live vars.
	wantVODCF := cloudfrontSigningConfig{KeyPath: "vod-cf.rsa", KeyID: "vod-cf-id"}
	if cfg.CloudFrontSigning != wantVODCF {
		t.Errorf("VOD CF signing = %+v, want %+v", cfg.CloudFrontSigning, wantVODCF)
	}
}

// TestLiveSigningEmptyWithoutLiveVars: with no LIVE_* set, the live signing
// configs are empty — they do NOT inherit the VOD values. (main.go turns this
// into a fatal startup error via its required-path guards.)
func TestLiveSigningEmptyWithoutLiveVars(t *testing.T) {
	setVODSigning(t)

	cfg := getEnvConfig()

	if cfg.LiveCloudFrontSigning != (cloudfrontSigningConfig{}) {
		t.Errorf("live CF signing = %+v, want zero value (no VOD inheritance)", cfg.LiveCloudFrontSigning)
	}
	if cfg.LiveIoriverSigning != (ioriverSigningConfig{}) {
		t.Errorf("live ioriver signing = %+v, want zero value (no VOD inheritance)", cfg.LiveIoriverSigning)
	}
}

// TestLiveCDNDomainsAreIndependent: live CDN domains come only from the
// STREAM_PROXY_LIVE_* vars and do not fall back to the VOD hosts.
func TestLiveCDNDomainsAreIndependent(t *testing.T) {
	setVODSigning(t)

	t.Run("set from live vars", func(t *testing.T) {
		t.Setenv("STREAM_PROXY_LIVE_CDN_DOMAIN_CLOUDFRONT", "live-cf.example.com")
		t.Setenv("STREAM_PROXY_LIVE_CDN_DOMAIN_IORIVER", "live.example.com")

		cfg := getEnvConfig()

		if cfg.LiveCDNDomainCloudFront != "live-cf.example.com" {
			t.Errorf("live CF domain = %q, want live-cf.example.com", cfg.LiveCDNDomainCloudFront)
		}
		if cfg.LiveCDNDomainIoriver != "live.example.com" {
			t.Errorf("live ioriver domain = %q, want live.example.com", cfg.LiveCDNDomainIoriver)
		}
	})

	t.Run("empty when unset (no VOD fallback)", func(t *testing.T) {
		cfg := getEnvConfig()

		if cfg.LiveCDNDomainCloudFront != "" {
			t.Errorf("live CF domain = %q, want empty", cfg.LiveCDNDomainCloudFront)
		}
		if cfg.LiveCDNDomainIoriver != "" {
			t.Errorf("live ioriver domain = %q, want empty", cfg.LiveCDNDomainIoriver)
		}
	})
}
