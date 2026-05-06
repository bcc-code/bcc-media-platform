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
   - **Variant playlist** — segment URIs are absolutized to
     `https://<STREAM_PROXY_CDN_DOMAIN>/…` and signed with one wildcard
     covering the playlist's directory (`STREAM_PROXY_SIGN_TTL`, default
     6h). Clients fetch segments straight from the CDN.

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

| Var                       | Notes                                                                                |
|---------------------------|--------------------------------------------------------------------------------------|
| `PORT`                    | Listen port. Default `8081`.                                                         |
| `ENVIRONMENT`             | Anything other than `development` switches Gin into release mode.                    |
| `STREAM_PROXY_CDN_DOMAIN` | Upstream CDN host. **Required.**                                                     |
| `STREAM_PROXY_CACHE_TTL`  | Per-path playlist cache. Default `10m`.                                              |
| `STREAM_PROXY_SIGN_TTL`   | Validity of the CDN signature stamped onto served URIs. Default `6h`.                |
| `STREAM_JWT_SECRET`       | HS256 shared secret. **Required**, must match `cmd/api` and `cmd/jobs`.              |
| `STREAM_JWT_ISSUER`       | Optional. If set, JWTs without a matching `iss` are rejected.                        |
| `CF_SIGNING_KEY_PATH`     | RSA PEM for CloudFront signing. **Required.**                                        |
| `CF_SIGNING_KEY_ID`       | CloudFront key ID.                                                                   |
| `FASTLY_SIGNING_KEY_ID`   | Fastly key ID. Optional — leave empty to skip Fastly params.                         |
| `AKAMAI_SIGNING_KEY_ID`   | Akamai key ID. Optional.                                                             |
| `AKAMAI_ENCRYPTION_KEY`   | Hex-encoded Akamai HMAC key. Required if `AKAMAI_SIGNING_KEY_ID` is set.             |

For ad-hoc signing against the same key material, see
[`cmd/sign-url`](../sign-url/readme.md).

## Tests

```bash
go test ./backend/cmd/stream-proxy/...
```

`playlist_test.go` covers the placeholder-swap and URI-rewriting paths;
the upstream-fetch and JWT layers are exercised by integration use.
