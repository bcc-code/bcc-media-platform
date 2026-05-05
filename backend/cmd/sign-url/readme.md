# sign-url

Command-line utility for signing arbitrary URLs using
[`ioriver-url-signer-golang`](https://github.com/bcc-code/ioriver-url-signer-golang) —
the same library the backend uses for stream URLs.

The tool emits the **raw** multi-CDN query string
(`Policy=...&Signature=...&Key-Pair-Id=...&FS-...&AK-Signature-...`) — the
same form the stream-proxy produces internally via `signing.Signer.SignRawQuery`.

## Usage

```bash
go run ./backend/cmd/sign-url \
  --key-path /path/to/cf.pem \
  --cf-key-id ABC123 \
  https://vod2.example.com/out/v1/abc/def/index.m3u8
```

By default the policy resource is `scheme://host/path` of the input URL
(matches a single asset). Use `--resource` to sign a wildcard:

```bash
go run ./backend/cmd/sign-url \
  --resource 'https://vod2.example.com/out/v1/abc/def/*' \
  https://vod2.example.com/out/v1/abc/def/ghi/index.m3u8
```

## Flags

| Flag                | Env fallback              | Notes                                                |
|---------------------|---------------------------|------------------------------------------------------|
| `--key-path`        | `CF_SIGNING_KEY_PATH`     | RSA PEM private key. Required.                       |
| `--cf-key-id`       | `CF_SIGNING_KEY_ID`       | CloudFront key ID.                                   |
| `--fastly-key-id`   | `FASTLY_SIGNING_KEY_ID`   | Fastly key ID.                                       |
| `--akamai-key-id`   | `AKAMAI_SIGNING_KEY_ID`   | Akamai key ID.                                       |
| `--akamai-enc-key`  | `AKAMAI_ENCRYPTION_KEY`   | Hex-encoded HMAC key. Required if `--akamai-key-id`. |
| `--duration`        | —                         | Validity, e.g. `6h`. Default `6h`.                   |
| `--resource`        | —                         | Override resource pattern (CF wildcard).             |

At least one provider key ID must be set. `.env` in the current directory
is loaded automatically (best-effort), so running with the API or jobs
service env vars exported is enough.
