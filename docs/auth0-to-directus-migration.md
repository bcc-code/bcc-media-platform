# Auth0 → Directus authentication migration

Status: **backend + admin-web frontend done, verified locally end-to-end.**
Remaining: apply infra (new `ADMIN_JWT_SECRET` secret + api env vars), set the
real `admin_cors_origins` once admin-web hosting is defined, verify in
staging, and finish Auth0 dependency cleanup in admin-web.

## Final architecture

Everything runs in the **single `cmd/api` binary** with two completely
separate auth realms — no fallback between them:

- **Consumer realm** (`/query`, `/` playground, `/public`,
  `/topbarsearch`, `/versionz`, jwks): the unchanged Auth0 middleware chain
  (`ValidateToken` → application → languages → user → fake-user → profile →
  role → ratelimit), now mounted on a route group instead of the engine.
- **Admin realm** (`/admin`, the admin GraphQL endpoint): never touches the
  Auth0 chain. Tokens the API mints itself; an Auth0 token on `/admin` gets
  UNAUTHENTICATED, an admin token on `/query` gets 401.

Admin auth is **GraphQL all the way** — `auth` mutations on the `/admin`
schema, no REST side-channel:

1. `mutation { auth { login(email, password, otp) } }` — the resolver
   forwards the credentials to `{DIRECTUS_URL}/auth/login` (mode `json`,
   server-to-server; `backend/directus` login client). The returned Directus
   JWT is parsed **without signature verification** (`jwt.ParseInsecure`) —
   safe because it came directly from Directus over TLS and is never accepted
   from clients. Admission requires the `admin_access` claim (authoritative:
   Directus 11 computes it from `directus_policies`; the flag no longer lives
   on `directus_roles`) and an `active` `directus_users` row. The API then
   mints its **own HS256 access token** (`ADMIN_JWT_SECRET`, iss
   `bccm-admin`, 15 min; claims: sub = user uuid, email, name, role_id,
   role_name) and sets an opaque **refresh cookie** (`admin_session`:
   httpOnly, `Path=/admin`, `SameSite=Lax`, `Secure` outside local dev,
   7-day sliding). Result: `AuthResult { accessToken, expiresInMs, user
   { id, email, firstName, lastName, avatarUrl } }`.
2. `mutation { auth { refresh } }` — looks up the session by sha256 hash
   (only digests are stored in `users.admin_sessions`), re-checks the user is
   still active (instant lockout), **rotates** the token (replayed old
   cookies die), and returns the same `AuthResult` — so a page reload
   restores the session and user with one operation.
3. `mutation { auth { logout } }` — deletes the session row, clears the
   cookie.
4. **Per-operation access control** (`graphadmin.AuthExtension`,
   `backend/graph/admin/auth.go`): every operation on `/admin` requires
   `x-api-key == SERVICE_SECRET_DIRECTUS` (the Directus `endpoint-tools`
   extension, `cms/extensions/endpoint-tools/src/index.ts`, calls it
   server-to-server — permanent, not a migration fallback) OR a Bearer token
   this service minted (admin-web; the user's `active` status is re-checked
   per request). The **only** exception: mutations whose root selections are
   exclusively the `auth` namespace — that's where clients obtain tokens.
   Auth failures are GraphQL errors with `extensions.code: UNAUTHENTICATED`
   (HTTP stays 200); admin-web's urql `didAuthError` keys on that code.

CORS is split by an engine-level dispatcher: `/admin` gets an explicit origin
allowlist (`ADMIN_CORS_ORIGINS`) with credentials (cookies forbid wildcards);
everything else keeps the wildcard policy.

Directus JWTs and the Directus `SECRET` never leave Directus: the browser
never holds a Directus-scoped token, and the API no longer knows the signing
secret at all (the old shared-secret validator and its rotation-drift failure
mode are gone).

## Decisions

- **Login flow**: admin-web sends credentials to OUR `auth.login` GraphQL
  mutation; the API proxies to Directus and hands back only our own token.
  Frontend keeps the access token in memory; the refresh cookie survives
  reloads. Everything stays on the one GraphQL endpoint — no REST
  side-channel.
- **Backend authz**: `admin_access` is checked at login (see above); role id
  and name are embedded in our token as the seed for our own permissions
  management (reusing `directus_roles`: Administrator, Editor, the
  early-access-manager roles). Per-field enforcement is intentionally
  deferred (`Roles: nil` in the admin resolvers).
- **One binary, path-scoped verifiers**: an earlier iteration ran the admin
  realm as a separate `cmd/admin` Cloud Run service; it was merged back to
  avoid a second service. Before that, an even earlier iteration had the
  Auth0 middleware accepting Directus tokens via a "secondary validator"
  fallback — rejected because it mixed token realms on every path.
- **OTP**: the backend forwards `otp` to Directus; no login-form field yet
  (no local users have `tfa_secret`). Wrong-credential responses are a
  generic 401 that doesn't reveal which factor failed.
- **Brute force**: delegated to Directus's own login throttling (the API's
  `ratelimit.Middleware` depends on the Auth0 user middleware and can't be
  reused here); own limiter is a possible follow-up.

## Key implementation facts

- `backend/directus` is now a server-to-server **login client**
  (`NewClient(baseURL)`, `Login(ctx, email, password, otp)` →
  `Claims{UserID, Role, AppAccess, AdminAccess}`, typed `LoginError` with
  `IsCredentialError()`); the old `TokenValidator` is deleted along with the
  `DIRECTUS_JWT_SECRET` env consumption.
- Token/cookie/session primitives + the per-operation guard
  (`AuthExtension`): `backend/graph/admin/auth.go`; mutation resolvers:
  `backend/graph/admin/schema.resolvers.go`; wiring:
  `adminGraphqlHandler` in `backend/cmd/api/handlers.go` (resolver
  `AuthConfig` + `h.Use(AuthExtension)`).
- Sessions: `users.admin_sessions` (migration `00360`), sha256-hashed opaque
  tokens, expired rows swept opportunistically on login (no cron).
- Grants (migration `00359`): the `api` role had NO grant on
  `directus_users`; column-level `SELECT (id, email, first_name, last_name,
  role, status, avatar)` keeps `password`/`tfa_secret` unreadable, plus
  `SELECT (id, name)` on `directus_roles` for the role-name join in
  `GetDirectusUserByID`.
- Env (cmd/api): `DIRECTUS_URL`, `ADMIN_JWT_SECRET`, `ADMIN_CORS_ORIGINS`
  (comma-separated), `ADMIN_COOKIE_SECURE` (default true; local dev sets
  `false`). When JWT secret or Directus URL is missing the auth mutations
  return "auth is not configured" and a warning is logged (the api still
  boots for its other consumers; x-api-key access keeps working).
- Infra: `random_password.admin_jwt_secret` → `ADMIN_JWT_SECRET` in
  `module.api_secrets` (auto-injected into the api container);
  `DIRECTUS_URL=https://admin.${base_platform_domain}`;
  `var.admin_cors_origins` (placeholder default until admin-web hosting is
  defined). The old `DIRECTUS_JWT_SECRET` secret entry is **unused but
  retained** — the gcp-secrets module sets `prevent_destroy`, so removing the
  entry would fail to apply.
- Directus access tokens are HS256 JWTs with claims `id`, `role`,
  `app_access`, `admin_access`, `iss: "directus"` — the login client checks
  the issuer and extracts these.

## Frontend (admin-web)

All auth goes through the API; nothing in the browser talks to Directus
anymore (`directusUrl` runtime config is gone; the avatar arrives as a full
URL built server-side).

1. `app/composables/useAuth.ts` — login/refresh/logout as GraphQL mutations
   against `${apiUrl}/admin` via `$fetch` with `credentials: 'include'`
   (urql can't be used here — its authExchange calls `refresh()` itself);
   access token + expiry in memory; login/refresh results carry the user
   (`fetchCurrentUser` and `/users/me` are gone); concurrent refreshes
   de-duped. urql's `didAuthError` also recognizes the `UNAUTHENTICATED`
   GraphQL error code.
2. `nuxt.config.ts` — `public.apiUrl` is the host base
   (`https://api.brunstad.tv`); urql appends `/admin`.
3. `app/plugins/urql.ts` — unchanged apart from the `/admin` suffix; 401 →
   `refresh()` → `/login` redirect as before.
4. `AppSidebar.vue` — user fields are camelCase (`firstName`/`lastName`).
5. `login.vue`, `auth.global.ts` — unchanged contracts.
6. `codegen.ts` — still introspects via x-api-key (build-time flow).

## Rollout / sequencing

1. Ship the backend + migrations `00359`/`00360` (deploy pipeline runs
   migrations before routing traffic). The endpoint-tools x-api-key path is
   untouched throughout.
2. Apply infra so `ADMIN_JWT_SECRET`/`DIRECTUS_URL`/`ADMIN_CORS_ORIGINS`
   reach the api container; set real `admin_cors_origins` per env.
3. admin-web needs no coordination beyond `apiUrl` (already the api host).
4. Once verified in staging, remove the remaining Auth0 code/deps in
   admin-web.

## Open questions / follow-ups

- Per-field/role permissions in the admin schema: our token now carries
  `role_id`/`role_name` — build the authz layer on those when needed.
- Optional: an OTP field in the login form (backend already forwards it),
  and login rate limiting in the API itself.
