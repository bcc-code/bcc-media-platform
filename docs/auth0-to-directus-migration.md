# Auth0 → Directus authentication migration

Status: **backend + admin-web frontend done, working locally.** Remaining:
verify against staging, configure cross-origin cookies/CORS for real domains,
and finish Auth0 cleanup.

Note: the `/admin` `x-api-key` path is **permanent, not a migration fallback** —
the Directus `endpoint-tools` extension
(`cms/extensions/endpoint-tools/src/index.ts`) calls `/admin` server-to-server
with `X-Api-Key: API_SECRET` to resolve `preview { collection }` / `preview
{ asset }`, backing the video-preview and query-builder interfaces. `/admin`
therefore accepts **either** the `x-api-key` (Directus server) **or** a Directus
user access token (admin-web browser), and both must keep working.

Goal: stop using Auth0 for `admin-web` authentication and instead reuse the
authentication that Directus already provides (its own users, roles and
`/auth/*` endpoints). Users log into Directus, and the admin GraphQL API
(`/admin`) authorizes requests by validating the Directus-issued access token.

## Decisions

- **Login flow**: `admin-web` calls Directus `POST /auth/login` with
  `{ email, password }`. Directus returns a short-lived (15 min default)
  `access_token` JWT, a `refresh_token`, and `expires`. The access token is sent
  as `Authorization: Bearer <token>` on API calls. Refresh via
  `POST /auth/refresh`. Preferred refresh mode is **cookie mode** (refresh token
  in an httpOnly cookie managed by Directus, access token kept in memory) so the
  access token can still be attached as a Bearer for the backend to validate.
- **Backend authz**: the Go `/admin` endpoint validates the Directus access
  token per request and only allows users with Directus **app access**.

## Key architectural facts (discovered)

- `admin-web` Auth0 usage is isolated to 4 files:
  `app/plugins/auth0.ts`, `app/middleware/auth.global.ts`,
  `app/plugins/urql.ts`, `app/components/layout/AppSidebar.vue`.
- The `/admin` GraphQL endpoint (`backend/cmd/api/handlers.go`) did **not**
  validate the Auth0 Bearer token. It only checked a shared secret header
  `x-api-key == SERVICE_SECRET_DIRECTUS`. So Auth0 login was only a client-side
  gate.
- **Two different Directus secrets exist — do not confuse them:**
  - `SERVICE_SECRET_DIRECTUS` (API env, `env.go`) — a shared password used as the
    `/admin` `x-api-key`. Not a JWT key.
  - Directus `SECRET` (infra `gcp-secrets.tf` → `random_password.directus_secret`,
    injected into the Directus container as env `SECRET`) — the HS256 signing key
    for every Directus access/session JWT. The API needs **this** to validate
    Directus tokens, and it did not previously have it.
- Directus access tokens are HS256 JWTs signed with `SECRET`, with claims:
  `id` (user uuid), `role` (role uuid), `app_access`, `admin_access`,
  `iss: "directus"`, `exp`, `iat`.
- `directus_users` schema (from `migrations/00001_init.sql`): `id uuid NOT NULL`,
  `email varchar(128) NULL`, `first_name/last_name varchar(50) NULL`,
  `status varchar(16) NOT NULL DEFAULT 'active'`, `role uuid NULL`.

## Backend changes (done)

1. `queries/directus-users.sql` — added `GetDirectusUserByID` (id → email,
   names, role, status); regenerated `backend/sqlc/directus-users.sql.go` with
   `sqlc generate`. (The regen also bumped the file's version header comment
   from sqlc 1.29.0 → 1.31.1 — cosmetic.)
2. New package `backend/directus` (`token.go` + `token_test.go`) — HS256 token
   validator mirroring the `backend/cmd/stream-proxy/jwt.go` pattern using
   `lestrrat-go/jwx/v2`. Validates signature, issuer `directus`, and expiry
   (1-minute skew); returns `Claims{UserID, Role, AppAccess, AdminAccess}`.
3. `backend/cmd/api/env.go` — added `serviceSecrets.DirectusJWT` from
   `DIRECTUS_JWT_SECRET`. Also documented in `env.sample`.
4. `backend/cmd/api/handlers.go` — `adminGraphqlHandler` now accepts **either**
   the legacy `x-api-key` (server-to-server, kept during migration) **or** a
   valid Directus Bearer token via `authorizeDirectusUser`, which requires
   `admin_access` (this is the frontend for the Directus admin) and a DB lookup
   confirming the user exists and `status == "active"` (so a deactivated user is
   rejected even with a live token).
5. Infra: exposed the Directus `SECRET` to the API service as
   `DIRECTUS_JWT_SECRET` (added to `module.api_secrets` in
   `infra/gcp-secrets.tf`; auto-injected as env by the existing
   `module.api_secrets.data` loop in `infra/api.tf`).

Verified: `go build ./backend/...`, `go vet`, and `go test ./backend/directus/...`
all pass; `terraform fmt` clean.

### Follow-up fix: global Auth0 middleware rejected Directus tokens (401)

Discovered while testing locally: `r.Use(authClient.ValidateToken())`
(`main.go`) runs on every route and **aborts with 401 when a bearer token is
present but fails Auth0 validation** (`auth0/authentication.go`). A Directus
token is not an Auth0 token, so it was rejected globally before reaching the
`/admin` handler. (`/query` relies on that 401 to trigger token refresh, so we
can't just stop aborting.)

Fix (keeps the `auth0` package Directus-agnostic):

- `auth0.Client` gained an optional `secondaryValidator func(token string) bool`
  - `SetSecondaryValidator`. `validateTokenAndFillCtx` consults it when the
    Auth0 validators fail; if it accepts the token the request is marked
    authenticated and continues (the route handler still authorizes).
- `main.go` builds the `directus.TokenValidator` once, registers it as the
  secondary validator, and passes it into `adminGraphqlHandler`
  (which no longer builds its own).

## Frontend changes (admin-web, done)

Uses `$fetch` directly against Directus (no `@directus/sdk` dependency), cookie
mode.

1. `app/composables/useAuth.ts` (NEW) — singleton auth state (module-scoped
   refs; fine because `ssr: false`). `login`/`logout`/`refresh`/
   `getAccessToken`/`ensureAuthenticated`/`currentUser`/`avatarUrl`. Access
   token + expiry kept in memory; refresh token lives in Directus's httpOnly
   cookie. `getAccessToken` transparently refreshes when the token is missing
   (e.g. after reload) or within 10s of expiry; concurrent refreshes are
   de-duped via a shared promise.
2. `app/pages/login.vue` (NEW) — email/password form (`layout: false`), posts to
   `login()`, redirects to `?redirect=` or `/`.
3. `app/middleware/auth.global.ts` — now redirects to `/login` (with `redirect`
   query) when `ensureAuthenticated()` fails; skips the guard on `/login`.
4. `app/plugins/urql.ts` — `authExchange` pulls the token from `useAuth`;
   `refreshAuth` calls `refresh()` and navigates to `/login` if it fails. No
   longer `dependsOn: ['auth0']`.
5. `app/plugins/auth0.ts` — DELETED.
6. `app/components/layout/AppSidebar.vue` — user info from `currentUser`
   (`displayName` from first/last name or email, `avatarUrl()` from the Directus
   file id); logout via `useAuth`.
7. `app/components/design/DesignInput.vue` — added `'password'` to the `type`
   union.
8. `nuxt.config.ts` — dropped `auth0Domain`/`auth0ClientId`, added
   `directusUrl` (default `https://admin.brunstad.tv`); removed
   `@auth0/auth0-vue` from `optimizeDeps`.
9. `package.json` — removed `@auth0/auth0-vue` (lockfile synced).

Verified: `pnpm typecheck`, `pnpm lint` (0 errors), and `pnpm dev` boot all
clean. Not yet exercised against a live Directus login.

## Rollout / sequencing

1. Ship backend accepting both credentials (no breakage). ✅
2. Switch `admin-web` to Directus login. ✅
3. Once verified in staging, remove the Auth0 code/deps that are no longer
   used. Keep the `x-api-key` path — it is used by the Directus extension (see
   the note at the top), not a migration leftover.

## Open questions / follow-ups

- Role mapping: currently the admin resolvers don't enforce per-field roles
  (`Roles: nil`). Endpoint-level gate on `admin_access` is the meaningful
  control for now. Decide later whether platform roles should be derived from
  Directus roles or stay email-driven via `GetRolesForEmail`.
- Cross-subdomain cookies: `admin-web` vs `api.<domain>` vs `admin.<domain>` —
  if not same-site, cookie-mode refresh needs `SameSite=None; Secure` + CORS
  `credentials`. Fallback: `json` mode with refresh token in memory.
