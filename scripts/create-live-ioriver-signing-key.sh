#!/usr/bin/env bash
#
# One-time bootstrap: create the live-cdn URL signing key on the ioriver live
# account. The terraform provider gutted ioriver_url_signing_key to a
# deprecated stub in v1.0.0 (still documented, but create/update/import all
# error and read drops it from state) — only the REST API supports it, so the
# key is created here
# from material that already lives in terraform state (tls_private_key +
# random_password in live-cdn.tf).
#
# Idempotent: if a key with the expected name already exists on the service,
# it is not recreated — its provider key ids are printed either way. Paste
# those into stream_proxy_env in the env's config.auto.tfvars as
# LIVE_IORIVER_CLOUDFRONT_KEY_ID / LIVE_IORIVER_FASTLY_KEY_ID.
#
# Usage:
#   scripts/create-live-ioriver-signing-key.sh <terragrunt-env-dir>
#   e.g. scripts/create-live-ioriver-signing-key.sh ~/prog/bcc.media/infra/projects/brunstadtv/env/prod
#
# The API token is taken from $IORIVER_LIVE_TOKEN if set, otherwise parsed
# from ioriver_live_token in the env dir's secret.auto.tfvars.

set -euo pipefail

KEY_NAME="live-cdn"
API_BASE="https://manage.ioriver.io/api/v1"

ENV_DIR="${1:?usage: $0 <terragrunt-env-dir>}"
[[ -d "$ENV_DIR" ]] || { echo "error: $ENV_DIR is not a directory" >&2; exit 1; }

command -v jq >/dev/null || { echo "error: jq is required" >&2; exit 1; }

token="${IORIVER_LIVE_TOKEN:-}"
if [[ -z "$token" ]]; then
  token=$(sed -n 's/^ *ioriver_live_token *= *"\(.*\)".*/\1/p' "$ENV_DIR/secret.auto.tfvars" | head -1)
fi
[[ -n "$token" ]] || { echo "error: no token in \$IORIVER_LIVE_TOKEN or $ENV_DIR/secret.auto.tfvars" >&2; exit 1; }

echo "==> pulling terraform state from $ENV_DIR" >&2
state=$(cd "$ENV_DIR" && terragrunt state pull)

state_attr() { # <type> <name> <attribute>
  jq -er --arg t "$1" --arg n "$2" --arg a "$3" '
    .resources[]
    | select(.type == $t and .name == $n)
    | .instances[0].attributes[$a]' <<<"$state"
}

service_id=$(state_attr ioriver_service live id) ||
  { echo "error: ioriver_service.live not in state — apply it first" >&2; exit 1; }
public_key=$(state_attr tls_private_key live_ioriver_signing public_key_pem) ||
  { echo "error: tls_private_key.live_ioriver_signing not in state — apply it first" >&2; exit 1; }
encryption_key=$(state_attr random_password live_ioriver_encryption_key result) ||
  { echo "error: random_password.live_ioriver_encryption_key not in state — apply it first" >&2; exit 1; }

auth=(-H "Authorization: token $token" -H "Content-Type: application/json")
keys_url="$API_BASE/services/$service_id/url-signing-keys/"

echo "==> checking for existing key '$KEY_NAME' on service $service_id" >&2
existing=$(curl -sS --fail "${auth[@]}" "$keys_url" |
  jq --arg n "$KEY_NAME" '[.[] | select(.name == $n)] | first // empty')

if [[ -n "$existing" ]]; then
  echo "==> key already exists, not recreating" >&2
  key_json="$existing"
else
  echo "==> creating key '$KEY_NAME'" >&2
  payload=$(jq -n --arg service "$service_id" --arg name "$KEY_NAME" \
    --arg public_key "$public_key" --arg encryption_key "$encryption_key" \
    '{service: $service, name: $name, public_key: $public_key, encryption_key: $encryption_key}')
  key_json=$(curl -sS --fail "${auth[@]}" -X POST -d "$payload" "$keys_url")
fi

key_id=$(jq -r '.id' <<<"$key_json")

# provider_keys is filled in asynchronously once the key is deployed to the
# underlying CDNs — poll until it shows up.
for _ in $(seq 1 30); do
  count=$(jq -r '.provider_keys | length' <<<"$key_json")
  [[ "$count" -gt 0 ]] && break
  echo "==> waiting for provider_keys to be provisioned..." >&2
  sleep 5
  key_json=$(curl -sS --fail "${auth[@]}" "$keys_url$key_id/")
done

cloudfront_id=$(jq -r '.provider_keys.Cloudfront // ""' <<<"$key_json")
fastly_id=$(jq -r '.provider_keys.Fastly // ""' <<<"$key_json")

if [[ -z "$cloudfront_id" && -z "$fastly_id" ]]; then
  echo "error: provider_keys still empty after polling; raw key object:" >&2
  jq . <<<"$key_json" >&2
  exit 1
fi

echo
echo "provider_keys: $(jq -c '.provider_keys' <<<"$key_json")"
echo
echo "Add to stream_proxy_env in $ENV_DIR/config.auto.tfvars:"
echo
echo "  LIVE_IORIVER_CLOUDFRONT_KEY_ID = \"$cloudfront_id\""
echo "  LIVE_IORIVER_FASTLY_KEY_ID     = \"$fastly_id\""
