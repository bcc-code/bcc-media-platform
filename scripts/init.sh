#! /bin/bash

set -euf -o pipefail

## Uncomment the following line to debug this script
# set -x

## This script is used to validate that all needed tools are installed
## and that the environment is setup correctly.

SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
REPO_ROOT="$( cd "$SCRIPTPATH/.." >/dev/null 2>&1 ; pwd -P )"

ENVPATHS="${SCRIPTPATH}/../cms ${SCRIPTPATH}/../backend/cmd/api ${SCRIPTPATH}/.."
COMMANDS="cp realpath go gum docker docker-compose pg-diff goose psql node npm"
OPTIONAL_COMMANDS="op"
SECRETS_FILE="${REPO_ROOT}/local-secrets.env"
SECRETS_OP_ITEM="hojv2qkqucqw2yf5g5wfbg2p3u"

## Check if all required commands are installed
echo "Checking commands..."
MISSING=()
for command in $COMMANDS; do
	if ! command -v "$command" &> /dev/null; then
		echo "  [missing]  $command"
		MISSING+=("$command")
	else
		echo "  [ok]       $command"
	fi
done

## Optional commands — checked but not required
for command in $OPTIONAL_COMMANDS; do
	if ! command -v "$command" &> /dev/null; then
		case "$command" in
			op) opt_hint=" (1Password CLI — install: brew install 1password-cli)" ;;
			*) opt_hint="" ;;
		esac
		echo "  [optional] $command — not installed${opt_hint}"
	else
		echo "  [optional] $command — ok"
	fi
done

if [ ${#MISSING[@]} -gt 0 ]; then
	echo
	echo "The following commands are missing. Install them with:"
	for cmd in "${MISSING[@]}"; do
		case "$cmd" in
			go) hint="install from https://golang.org/dl/ or via your package manager" ;;
			gum) hint="go install github.com/charmbracelet/gum@latest (or see https://github.com/charmbracelet/gum#installation)" ;;
			pg-diff) hint="npm install -g pg-diff-cli" ;;
			goose) hint="go install github.com/pressly/goose/v3/cmd/goose@latest" ;;
			psql)
				if command -v brew &> /dev/null; then
					hint="brew install libpq"
				else
					hint="install via your package manager"
				fi
				;;
			*) hint="install via your package manager" ;;
		esac
		echo "  - $cmd: $hint"
	done
	exit 1
fi
echo

# Merge the matching section of local-secrets.env into an .env file:
#   - existing keys are replaced in-place (preserving their position)
#   - duplicate occurrences of replaced keys are removed (self-heals prior runs)
#   - keys that don't exist yet are appended at the end
# Idempotent: re-running produces the same file.
apply_secrets() {
	local envfile="$1"
	local section="$2"
	[ -f "$SECRETS_FILE" ] || return 0
	[ -f "$envfile" ] || return 0

	local section_content
	section_content=$(awk -v sec="$section" '
		$0 == "# === Path: " sec " ===" { capture = 1; next }
		/^# === Path: / { capture = 0; next }
		capture && /^[A-Za-z_][A-Za-z0-9_]*=/ { print }
	' "$SECRETS_FILE")

	if [ -z "$section_content" ]; then
		return 0
	fi

	local tmpfile
	tmpfile=$(mktemp)
	SECTION_CONTENT="$section_content" awk '
		BEGIN {
			n = split(ENVIRON["SECTION_CONTENT"], lines, "\n")
			for (i = 1; i <= n; i++) {
				line = lines[i]
				if (line == "") continue
				eq = index(line, "=")
				if (eq <= 0) continue
				k = substr(line, 1, eq - 1)
				vals[k] = substr(line, eq + 1)
				order[++keycount] = k
			}
		}
		{
			if (match($0, /^[A-Za-z_][A-Za-z0-9_]*=/)) {
				key = substr($0, RSTART, RLENGTH - 1)
				if (key in vals) {
					if (key in used) { next }            # drop duplicate
					print key "=" vals[key]
					used[key] = 1
					next
				}
			}
			print
		}
		END {
			for (i = 1; i <= keycount; i++) {
				k = order[i]
				if (!(k in used)) print k "=" vals[k]
			}
		}
	' "$envfile" > "$tmpfile" && mv "$tmpfile" "$envfile"

	echo "  merged secrets from local-secrets.env into $envfile"
}

# Ensure backend/cmd/api/.env has a valid REDIRECT_JWT_KEY by generating
# backend/cmd/api/key.local.rsa (if missing) and inlining its PEM contents
# as a multi-line quoted value. Idempotent — re-running rewrites the same value.
ensure_redirect_jwt_key() {
	local keyfile="$REPO_ROOT/backend/cmd/api/key.local.rsa"
	local envfile="$REPO_ROOT/backend/cmd/api/.env"

	[ -f "$envfile" ] || return 0

	if [ ! -f "$keyfile" ]; then
		if ! command -v openssl &> /dev/null; then
			echo ":warning:  openssl not installed — cannot generate REDIRECT_JWT_KEY." | gum format -t emoji
			return 0
		fi
		echo "Generating $(basename "$keyfile") for REDIRECT_JWT_KEY..."
		openssl genrsa -out "$keyfile" 4096 &> /dev/null
	fi

	# Strip any existing REDIRECT_JWT_KEY (single- or multi-line quoted) from .env
	local tmpfile
	tmpfile=$(mktemp)
	awk '
		/^REDIRECT_JWT_KEY=/ {
			rest = substr($0, length("REDIRECT_JWT_KEY=") + 1)
			if (substr(rest, 1, 1) == "\"") {
				if (length(rest) < 2 || substr(rest, length(rest), 1) != "\"") {
					in_block = 1
				}
			}
			next
		}
		in_block {
			if (substr($0, length($0), 1) == "\"") in_block = 0
			next
		}
		{ print }
	' "$envfile" > "$tmpfile"
	mv "$tmpfile" "$envfile"

	# Append the inlined PEM as a multi-line quoted value (godotenv-compatible)
	{
		printf 'REDIRECT_JWT_KEY="'
		cat "$keyfile"
		printf '"\n'
	} >> "$envfile"

	echo "  inlined REDIRECT_JWT_KEY from $(basename "$keyfile") into $envfile"
}

# Check if the .env file exists and create it if it doesn't
gum style --bold "Checking .env files..."
if [ ! -f "$SECRETS_FILE" ]; then
	if command -v op &> /dev/null; then
		if gum confirm "No local-secrets.env found. Try fetching it from 1Password? (only works for BCC Media Developers)"; then
			tmpfile="$(mktemp)"
			if op item get "$SECRETS_OP_ITEM" --fields notesPlain --reveal > "$tmpfile" 2>/dev/null && [ -s "$tmpfile" ]; then
				mv "$tmpfile" "$SECRETS_FILE"
				echo ":heavy_check_mark:  Fetched local-secrets.env from 1Password" | gum format -t emoji
			else
				rm -f "$tmpfile"
				echo ":x:  Could not fetch from 1Password. Sign in with 'op signin', or confirm you have access to this item if you're a BCC Media Developer." | gum format -t emoji
			fi
		fi
	fi
	if [ ! -f "$SECRETS_FILE" ]; then
		echo ":warning:  No local-secrets.env at repo root — placeholders in samples will not be filled in. See the file's docs for how to obtain it from 1Password." | gum format -t emoji
	fi
fi
for path in $ENVPATHS; do
	abspath="$(cd "$path" && pwd -P)/.env"
	visualpath="${abspath#$REPO_ROOT/}"
	if [ ! -f "$path/.env" ]; then
		# Look for a sample file under several known names
		sample=""
		for candidate in env.sample .env.sample .env.example .template.env env.example; do
			if [ -f "$path/$candidate" ]; then
				sample="$path/$candidate"
				break
			fi
		done
		if [ -z "$sample" ]; then
			echo ":x:  $visualpath does not exist and no sample file found in $path — create it manually." | gum format -t emoji
			continue
		fi
		echo ":warning:  $visualpath does not exist. Creating from $(basename "$sample")..." | gum format -t emoji
		cp -v "$sample" "$path/.env"
		apply_secrets "$path/.env" "$visualpath"
		gum confirm "Edit the file now?" && $EDITOR $path/.env
	else
		echo ":heavy_check_mark:  $visualpath" | gum format -t emoji
		apply_secrets "$path/.env" "$visualpath"
	fi
done
ensure_redirect_jwt_key
echo

gum confirm "Set up and validate the database?" && DB_SETUP=true || DB_SETUP=false
gum style --bold "Checking database..."
if [[ $DB_SETUP == true ]]; then
	# Check if the database is running
	if ! docker-compose -f $SCRIPTPATH/../docker-compose.yml ps | grep -q "db"; then
		echo ":warning:  The database is not running. Starting..." | gum format -t emoji
		docker-compose -f $SCRIPTPATH/../docker-compose.yml up -d db
	else
		echo ":heavy_check_mark:  The database is running" | gum format -t emoji
	fi

	set -o allexport
	source $SCRIPTPATH/../.env
	set +o allexport
	sleep 5
	# Check if the configured role exists; if not, create it via the default `postgres` superuser
	if ! psql -h localhost -U "$PGUSER" -d postgres -tAc 'SELECT 1' &> /dev/null; then
		echo ":warning:  Role '$PGUSER' does not exist. Attempting to create it via the 'postgres' superuser..." | gum format -t emoji
		if ! psql -h localhost -U postgres -d postgres -c "CREATE ROLE \"$PGUSER\" WITH SUPERUSER LOGIN PASSWORD '$PGPASSWORD';" &> /dev/null; then
			echo ":x:  Could not create role '$PGUSER'. Run this manually as a Postgres superuser:" | gum format -t emoji
			echo "    CREATE ROLE \"$PGUSER\" WITH SUPERUSER LOGIN PASSWORD '<your password>';"
			exit 1
		fi
		echo ":heavy_check_mark:  Role '$PGUSER' created" | gum format -t emoji
	else
		echo ":heavy_check_mark:  Role '$PGUSER' exists" | gum format -t emoji
	fi

	# Pre-migration scripts (idempotent — create roles, etc.)
	echo "Running pre-migration scripts..." | gum format -t emoji
	for f in $(find "$SCRIPTPATH/../migrations/special/pre" -name '*.sql' | sort -V); do
		echo "  - $(basename "$f")"
		psql -h localhost -U "$PGUSER" -d postgres -f "$f"
	done

	# Create the database if it doesn't exist (CREATE DATABASE has no IF NOT EXISTS in Postgres)
	if ! psql -h localhost -U "$PGUSER" -d postgres -lqt | cut -d \| -f 1 | grep -qw "$LOCALDB"; then
		echo ":warning:  The database is not initialized. Creating '$LOCALDB'..." | gum format -t emoji
		echo "CREATE DATABASE ${LOCALDB} WITH OWNER = manager;" | psql -h localhost -U "$PGUSER" -d postgres
		echo ":heavy_check_mark:  Database created" | gum format -t emoji
	else
		echo ":heavy_check_mark:  The database is initialized" | gum format -t emoji
	fi

	cd $SCRIPTPATH/../migrations
	goose postgres "postgres://${PGUSER}@localhost:5432/${LOCALDB}?sslmode=disable" up
	echo ":heavy_check_mark:  DB is up to date" | gum format -t emoji
	cd -

	# Post-migration scripts (idempotent — admin user, seed data, sequence fixes)
	echo "Running post-migration scripts..." | gum format -t emoji
	for f in $(find "$SCRIPTPATH/../migrations/special/post" -name '*.sql' | sort -V); do
		echo "  - $(basename "$f")"
		psql -h localhost -U "$PGUSER" -d "$LOCALDB" -f "$f"
	done
fi
echo
