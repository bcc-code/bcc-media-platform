// sign-url is a command-line utility that signs an arbitrary URL using
// github.com/bcc-media/ioriver-url-signer-golang.
//
// It emits the raw multi-CDN query string (Policy/Signature/Key-Pair-Id for
// CloudFront, FS-* for Fastly, AK-Signature-<id> for Akamai) — the same form
// the stream-proxy produces internally via `signing.Signer.SignRawQuery`.
package main

import (
	"flag"
	"fmt"
	"net/url"
	"os"
	"time"

	urlsigner "github.com/bcc-media/ioriver-url-signer-golang"
	"github.com/joho/godotenv"
)

func envOr(envKey, fallback string) string {
	if v, ok := os.LookupEnv(envKey); ok && v != "" {
		return v
	}
	return fallback
}

func main() {
	// Best-effort: load a local .env so running from any backend service dir picks up its config.
	_ = godotenv.Load()

	keyPath := flag.String("key-path", "", "Path to RSA PEM private key file (env: CF_SIGNING_KEY_PATH)")
	cfKeyID := flag.String("cf-key-id", "", "CloudFront key ID (env: CF_SIGNING_KEY_ID)")
	fastlyKeyID := flag.String("fastly-key-id", "", "Fastly key ID (env: FASTLY_SIGNING_KEY_ID)")
	akamaiKeyID := flag.String("akamai-key-id", "", "Akamai key ID (env: AKAMAI_SIGNING_KEY_ID)")
	akamaiEncKey := flag.String("akamai-enc-key", "", "Akamai HMAC encryption key, hex-encoded (env: AKAMAI_ENCRYPTION_KEY)")
	duration := flag.Duration("duration", 6*time.Hour, "Validity duration of the signed URL")
	resource := flag.String("resource", "", "Override the policy resource pattern (e.g. https://cdn.example.com/path/*). Defaults to scheme://host/path of the input URL.")

	flag.Usage = func() {
		fmt.Fprintf(flag.CommandLine.Output(), "Usage: %s [flags] <url>\n\n", os.Args[0])
		fmt.Fprintln(flag.CommandLine.Output(), "Signs an arbitrary URL using the ioriver-url-signer library.")
		fmt.Fprintln(flag.CommandLine.Output(), "Each flag falls back to its corresponding environment variable.")
		fmt.Fprintln(flag.CommandLine.Output())
		fmt.Fprintln(flag.CommandLine.Output(), "Flags:")
		flag.PrintDefaults()
	}
	flag.Parse()

	if flag.NArg() != 1 {
		flag.Usage()
		os.Exit(2)
	}
	rawURL := flag.Arg(0)

	*keyPath = envOr("CF_SIGNING_KEY_PATH", *keyPath)
	*cfKeyID = envOr("CF_SIGNING_KEY_ID", *cfKeyID)
	*fastlyKeyID = envOr("FASTLY_SIGNING_KEY_ID", *fastlyKeyID)
	*akamaiKeyID = envOr("AKAMAI_SIGNING_KEY_ID", *akamaiKeyID)
	*akamaiEncKey = envOr("AKAMAI_ENCRYPTION_KEY", *akamaiEncKey)

	if *keyPath == "" {
		fail("missing --key-path / CF_SIGNING_KEY_PATH")
	}
	if *cfKeyID == "" && *fastlyKeyID == "" && *akamaiKeyID == "" {
		fail("at least one provider key ID must be set (--cf-key-id, --fastly-key-id, or --akamai-key-id)")
	}
	if *akamaiKeyID != "" && *akamaiEncKey == "" {
		fail("--akamai-enc-key is required when --akamai-key-id is set")
	}

	parsed, err := url.Parse(rawURL)
	if err != nil {
		fail("parse url: %v", err)
	}
	if parsed.Scheme == "" || parsed.Host == "" {
		fail("url must include scheme and host")
	}

	res := *resource
	if res == "" {
		res = (&url.URL{Scheme: parsed.Scheme, Host: parsed.Host, Path: parsed.Path}).String()
	}

	pem, err := os.ReadFile(*keyPath)
	if err != nil {
		fail("read key file: %v", err)
	}

	signer, err := urlsigner.NewSigner(pem, *akamaiEncKey, urlsigner.KeyInfo{
		CloudFrontKeyID: *cfKeyID,
		FastlyKeyID:     *fastlyKeyID,
		AkamaiKeyID:     *akamaiKeyID,
	})
	if err != nil {
		fail("init signer: %v", err)
	}

	q, err := signer.Sign(urlsigner.Policy{
		Resources: res,
		Condition: urlsigner.Condition{
			EndTime: time.Now().Add(*duration).Unix(),
		},
	})
	if err != nil {
		fail("sign: %v", err)
	}

	sep := "?"
	if parsed.RawQuery != "" {
		sep = "&"
	}
	fmt.Println(rawURL + sep + q)
}

func fail(format string, args ...any) {
	fmt.Fprintf(os.Stderr, "sign-url: "+format+"\n", args...)
	os.Exit(1)
}
