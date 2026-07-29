# Live-proxy rollout checklist

Rollout runbook for the `live-proxy` PR (livestream manifests through stream-proxy).
Each phase is independently safe: nothing changes client behavior until the Unleash
flag flips in phase D, and ongoing transmissions are never touched (already-issued
legacy URLs stay valid, the Lambda@Edge path stays deployed).

## A. Direct-CloudFront distribution

- [ ] Configure the live **direct-CF** distribution (the `cloudfront` provider
      claim, not via ioriver): validate manifests **and** segments natively
      (no Lambda@Edge on this path — the proxy does the manifest rewriting),
      with a trusted key group containing the **existing legacy livestream
      public key** (stream-proxy reuses that pair; terraform wires the PEM and
      key-pair ID).
- [ ] Add its hostname to `env/prod/config.auto.tfvars` → `stream_proxy_env`
      as `STREAM_PROXY_LIVE_CDN_DOMAIN_CLOUDFRONT`; commit (git-crypt unlocked).

## B. ioriver URL signing key — **before merging this PR**

Not terraform-manageable (`ioriver_url_signing_key` was removed in provider
v1.0.0; see the note in `infra/live-cdn.tf`). Applies run via `src/override.tf`
pointing at the local working tree, as now.

- [ ] `scripts/create-live-ioriver-signing-key.sh ~/prog/bcc.media/infra/projects/brunstadtv/env/prod`
      — idempotent; prints the per-CDN key IDs.
- [ ] Paste them into `env/prod/config.auto.tfvars` → `stream_proxy_env` as
      `LIVE_IORIVER_CLOUDFRONT_KEY_ID` / `LIVE_IORIVER_FASTLY_KEY_ID`.
- [ ] Set `url_signing = true` in `infra/live-cdn.tf`, then `make infra.prod`
      (also picks up the key-ID and phase-A env vars).
- [ ] Verify stream-proxy stayed healthy — the currently-deployed (old) binary
      ignores the new env vars/mounts:

  ```sh
  gcloud run revisions list --service stream-proxy-prod --region europe-west4
  # newest revision Ready=True; then confirm a known VOD manifest still plays through the proxy
  ```

## C. Merge and deploy

- [ ] Land the current `infra/` changes on master (update `live-proxy-infra` or
      merge with the PR), then remove `src/override.tf` so terragrunt reads
      merged master (state already matches, next plan should be a no-op).
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

## D. Activate via the new flag, gradually

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
