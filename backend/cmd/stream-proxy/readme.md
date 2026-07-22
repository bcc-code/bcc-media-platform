# stream-proxy

HLS playlist proxy that hides per-CDN signing from clients. The API/jobs
services hand clients a stream URL pointing at this proxy with a short
HS256 JWT; the proxy validates the JWT, fetches the upstream playlist
(`index.m3u8` or variant), and rewrites every URI with a fresh
multi-CDN signature minted via
[`signing.Signer.SignRawQuery`](../../signing/signer.go) (CloudFront /
Fastly / Akamai params, depending on which provider key IDs are set).

```
client                    stream-proxy                   CDN
  │  GET /out/v1/.../index.m3u8?jwt=…  │
  │ ─────────────────────────────────► │
  │                                    │  GET /out/v1/.../index.m3u8?<signed>
  │                                    │ ─────────────────────────────────►
  │                                    │ ◄──────────────── playlist
  │  ◄── rewritten playlist ──────     │
```

## Request flow

1. `GET /<stream-path>?jwt=<HS256 token>` (any path — `r.NoRoute` catches
   them all).
2. JWT is validated against `STREAM_JWT_SECRET` and (if set)
   `STREAM_JWT_ISSUER`. The token's `base` claim is treated as a path
   prefix; requests outside it get `403`. `..` segments are rejected
   outright.
3. The raw upstream playlist is fetched once per path with a fresh signed
   query and cached (`STREAM_PROXY_CACHE_TTL`, default 10m). All existing
   query strings on URI lines are stripped and replaced with a sentinel
   placeholder so the cached body is JWT-independent.
4. On serve, the placeholder is swapped:
   - **Master playlist (`index.m3u8`)** — variant URIs stay relative and
     get `?jwt=<token>`, so the client bounces back to the proxy and the
     JWT is re-verified per variant.
   - **Variant playlist** — segment URIs are absolutized to the resolved
     upstream host (`STREAM_PROXY_CDN_DOMAIN_CLOUDFRONT` or `..._IORIVER`,
     per the `provider` claim) and signed with one wildcard covering the
     asset root (`STREAM_PROXY_SIGN_TTL`, default 6h). Clients fetch
     segments straight from the CDN.

## Run

```bash
cd backend/cmd/stream-proxy
cp env.sample .env  # fill in secrets
make run            # go run .
make watch          # fresh-based hot reload (uses ../../cmd/stream-proxy/.fresh.yaml)
```

The minted JWT is produced by [`backend/streamtoken`](../../streamtoken/);
`STREAM_JWT_SECRET` and `STREAM_JWT_ISSUER` **must match** the values
configured in `cmd/api` and `cmd/jobs`, otherwise validation fails.

## Configuration

See [`env.sample`](./env.sample) for the full list. Key vars:

Per-request routing between the two upstream identities is driven by the JWT
`provider` claim (`cloudfront` / `ioriver`); `STREAM_PROXY_DEFAULT_PROVIDER` is
used when the claim is absent. The `live` claim switches to the live upstream,
whose vars default to the VOD equivalents when unset.

| Var                                | Notes                                                                        |
|------------------------------------|------------------------------------------------------------------------------|
| `PORT`                             | Listen port. Default `8081`.                                                 |
| `ENVIRONMENT`                      | Anything other than `development` switches Gin into release mode.            |
| `STREAM_PROXY_CDN_DOMAIN_CLOUDFRONT`| Upstream host for the `cloudfront` provider. **Required.**                  |
| `STREAM_PROXY_CDN_DOMAIN_IORIVER`  | Upstream host for the `ioriver` provider. **Required.**                      |
| `STREAM_PROXY_DEFAULT_PROVIDER`    | `cloudfront` or `ioriver`. Used when the JWT has no `provider` claim. **Required.** |
| `STREAM_PROXY_CACHE_TTL`           | Per-path VOD playlist cache. Default `10m`.                                  |
| `STREAM_PROXY_LIVE_CACHE_TTL`      | Live playlist cache (rewritten every segment). Default `2s`.                 |
| `STREAM_PROXY_SIGN_TTL`            | Validity of the CDN signature stamped onto served URIs. Default `6h`.        |
| `STREAM_JWT_SECRET`                | HS256 shared secret. **Required**, must match `cmd/api` and `cmd/jobs`.      |
| `STREAM_JWT_ISSUER`                | Optional. If set, JWTs without a matching `iss` are rejected.                |
| `CF_SIGNING_KEY_PATH`              | RSA PEM for the direct-CloudFront (`cloudfront` provider) signer. **Required.** |
| `CF_SIGNING_KEY_ID`                | Direct-CloudFront key-pair ID.                                               |
| `IORIVER_SIGNING_KEY_PATH`         | RSA PEM for the ioriver (`ioriver` provider) signer. **Required.**           |
| `IORIVER_CLOUDFRONT_KEY_ID`        | ioriver-issued CloudFront key ID.                                           |
| `IORIVER_FASTLY_KEY_ID`            | ioriver Fastly key ID. Optional — leave empty to skip Fastly params.        |
| `IORIVER_AKAMAI_KEY_ID`            | ioriver Akamai key ID. Optional.                                            |
| `IORIVER_AKAMAI_ENCRYPTION_KEY`    | Hex-encoded Akamai HMAC key. Required if `IORIVER_AKAMAI_KEY_ID` is set.     |
| `STREAM_PROXY_LIVE_CDN_DOMAIN_CLOUDFRONT` / `..._IORIVER` | Live upstream hosts. Optional — default to the VOD hosts. |
| `LIVE_CF_SIGNING_KEY_PATH` / `LIVE_CF_SIGNING_KEY_ID`     | Live direct-CloudFront key material. Optional — default to VOD. |
| `LIVE_IORIVER_SIGNING_KEY_PATH` / `LIVE_IORIVER_CLOUDFRONT_KEY_ID` / `LIVE_IORIVER_FASTLY_KEY_ID` / `LIVE_IORIVER_AKAMAI_KEY_ID` / `LIVE_IORIVER_AKAMAI_ENCRYPTION_KEY` | Live ioriver key material. Optional — default to VOD. |

For ad-hoc signing against the same key material, see
[`cmd/sign-url`](../sign-url/readme.md).

## Tests

```bash
go test ./backend/cmd/stream-proxy/...
```

`playlist_test.go` covers the placeholder-swap and URI-rewriting paths;
the upstream-fetch and JWT layers are exercised by integration use.
