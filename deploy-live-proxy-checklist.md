# Live-proxy rollout checklist

Rollout runbook for the `live-proxy` PR (livestream manifests through stream-proxy).
Everything here happens **after** the code changes on the branch are done. Each phase
is independently safe: nothing changes client behavior until the Unleash flag flips
in phase E, and ongoing transmissions are never touched (already-issued legacy URLs
stay valid, the Lambda@Edge path stays deployed).

## A. Provision live CDN prerequisites

The ioriver half (service, origin, domain, signing key, DNS) is terraform-managed
in `infra/live-cdn.tf` — nothing to click together in the ioriver dashboard. Still
manual:

- [ ] Create the live ioriver **vCDN account** (separate account from VOD) and issue
      an API token for terraform.
- [ ] Live **direct-CloudFront** distribution (the `cloudfront` provider claim, not
      via ioriver): attach a **new** live key pair via a trusted key group, validating
      manifests **and** segments natively (no Lambda@Edge on this path — the proxy
      does the manifest rewriting). Note the key-pair ID.
- [ ] Find the live MediaPackage endpoint host (the ioriver origin).
- [ ] Collect: the direct-CF RSA private key (PEM), `LIVE_CF_SIGNING_KEY_ID`, the
      direct-CF hostname for `STREAM_PROXY_LIVE_CDN_DOMAIN_CLOUDFRONT`, the ioriver
      API token, and the MediaPackage endpoint host.
      (The ioriver key pair, key IDs, and `live-cdn.bcc.media` are generated/wired
      by terraform.)

## B. Private infra repo (`~/prog/bcc.media/infra/projects/brunstadtv`)

- [ ] Add the direct-CF PEM as `env/prod/keys/live_cf.secret.key` (must match
      `*.secret.*` for git-crypt).
- [ ] `env/prod/secret.auto.tfvars` → `api_secret_files` — mount point must match
      `infra/api.tf` exactly (`/secrets5/live_cf.pem`); the tf locals filter by name
      and silently produce no volume on a mismatch:

  ```hcl
  live_cf_signing_key = { mount_point = "/secrets5/live_cf.pem", local_path = "keys/live_cf.secret.key" }
  ```

- [ ] `env/prod/secret.auto.tfvars` → `stream_proxy_secrets`: add `LIVE_CF_SIGNING_KEY_ID`.
- [ ] `env/prod/secret.auto.tfvars`: add `ioriver_live_token = "<live account API token>"`.
- [ ] `env/prod/config.auto.tfvars` → `stream_proxy_env`: add
      `STREAM_PROXY_LIVE_CDN_DOMAIN_CLOUDFRONT` (direct-CF hostname only — the
      ioriver domain is set by terraform).
- [ ] `env/prod/config.auto.tfvars`: add

  ```hcl
  live_cdn = {
    hostname    = "live-cdn.bcc.media"
    origin_host = "<live MediaPackage endpoint host>"
  }
  ```

- [ ] Commit (git-crypt unlocked).

## C. Terraform apply — **before merging the PR**

- [ ] Ensure `src/override.tf` points the module source at the local
      `~/prog/bcc.media/brunstadtv/infra`, with the `live-proxy` branch checked out there
      (terragrunt otherwise reads `infra/` from GitHub master, which doesn't have the
      new tf yet).
- [ ] `make infra.prod` — review the plan before confirming. Expected changes, nothing else:
  - ioriver: certificate, service (origin + domain + default behavior), URL signing key
  - DNS: `live-cdn.bcc.media` CNAME + `_acme-challenge.live-cdn.bcc.media` CNAME
    in the `bcc-media` zone (project `dns-managmenet`)
  - Secret Manager: `live_cf_signing_key` (from tfvars) and
    `live_ioriver_signing_key` (terraform-generated) + accessor bindings
  - stream-proxy Cloud Run service: `LIVE_*` env vars (key paths, ioriver domain,
    ioriver key IDs) + 2 volumes/mounts
- [ ] If the ioriver MANAGED certificate is not ISSUED after the first apply (ACME
      validation needs the challenge CNAME to propagate), re-run the apply once DNS
      is live. If the challenge parse ever fails, the raw challenge string is in the
      certificate state — create the CNAME by hand.
- [ ] Note: with vCDN, explicit `ioriver_service_provider` resources may not be
      needed; if the first apply complains the service has no providers, add them
      (without `account_provider`) to `infra/live-cdn.tf`.
- [ ] Verify stream-proxy stayed healthy — the currently-deployed (old) binary ignores
      the new env vars/mounts:

  ```sh
  gcloud run revisions list --service stream-proxy-prod --region europe-west4
  # newest revision Ready=True; then confirm a known VOD manifest still plays through the proxy
  ```

## D. Merge and deploy

- [ ] PR CI green → merge to `master`. Semaphore auto-deploys all backend services
      (`--no-traffic` deploy, then traffic route — a crash-looping revision never
      takes traffic).
- [ ] Verify behavior-neutrality — live URL minting is unchanged because
      `STREAM_PRIMARY_PROVIDER=cloudfront` and the `live-cdn-provider` flag doesn't
      exist yet:

  ```sh
  curl -s https://api.brunstad.tv/query -H "Authorization: Bearer $TOKEN" \
    -H 'Content-Type: application/json' \
    -d '{"query":"{ live { isOnline url expiresAt } }"}'
  # url must be a legacy CloudFront-signed URL: NOT on the stream-proxy domain, no ?jwt=
  ```

- [ ] Verify VOD playback through the proxy is unaffected.
- [ ] Remove/repoint `src/override.tf` so future terragrunt runs read merged master
      (state is already identical, so the next plan should be a no-op).

## E. Activate via the new flag, gradually

- [ ] Create Unleash flag `live-cdn-provider` with variants `cloudfront-direct`,
      `cloudfront`, `ioriver`. Initially target only internal test users with
      variant `ioriver`.
- [ ] As a flagged test user, ideally during a live transmission:
  - [ ] `Query.live` returns a stream-proxy URL; master playlist variant URIs carry `?jwt=`.
  - [ ] Variant playlists have segment URIs absolutized to the **live** CDN host and
        signed; the manifest response has `Cache-Control: no-store`.
  - [ ] Playback works, including join-from-program-start (the time-shift `start`
        param must propagate onto child `.m3u8` URIs).
  - [ ] `CalendarEntry.buffer` URL plays with the correct `start`/`end` window.
- [ ] Ramp the flag percentage. Watch:
  - stream-proxy error rate / latency — note Cloud Run `timeout_seconds = 2` and
    `maxScale = 50`; live manifest polling at scale is new load for this service
  - Unleash exposure metrics for `live-cdn-provider`
- [ ] Steady state (later, optional): 100% on the flag. Moving the env-level default
      (`STREAM_PRIMARY_PROVIDER=streamproxy`) also flips VOD — only do that when VOD
      is ready too.

## Rollback (any time, live-only, instant)

- Flip `live-cdn-provider` off or to variant `cloudfront-direct` → new URL mints go
  legacy immediately. URLs already handed out on either path keep working, since both
  paths stay deployed.
- Deploy-level fallback:

  ```sh
  gcloud run services update-traffic stream-proxy-prod --region europe-west4 \
    --to-revisions=<previous-revision>=100
  ```
