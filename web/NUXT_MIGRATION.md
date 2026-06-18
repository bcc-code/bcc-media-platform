# Migrating `web/` (Vue 3 SPA) to Nuxt 4

> Status: **plan only** — not started. Drafted 2026-06.
> Goal: adopt **Nuxt conventions + modules** to delete custom plumbing and modernize the code.
> File/line references reflect the repo at drafting time — re-verify before acting.

---

## 1. Decision: run Nuxt in **SPA mode** (`ssr: false`)

`web/` is an auth-gated media app: 32 files touch `window`/`document`/`localStorage`, and core deps
(`bccm-video-player`, `hls.js`, `@auth0/auth0-vue`, `rudder-sdk-js`) are browser-only. SSR would mean
auditing/guarding all of that for little benefit. **SPA mode sidesteps it entirely** while still giving us
file-based routing, auto-imports, layouts, and the module ecosystem.

This also matches **`admin-web/`**, which is already **Nuxt 4.4.7 with `ssr: false`** running essentially the
same stack. Treat `admin-web/` as the reference implementation and copy its patterns wherever possible.

SSR/SEO for public pages (shareable episode/show pages) is a **separate future phase** via Nitro route rules —
out of scope here.

### `admin-web/` already solves (copy from it)

- `nuxt.config.ts` with `ssr: false`, `@tailwindcss/vite` (v4), `runtimeConfig` (incl. auth0)
- `@urql/vue` + `@urql/exchange-auth` client wiring
- `@auth0/auth0-vue` integration
- `@vueuse/nuxt`, `graphql` pinned to 16 (see `[[project-graphql-17-blocked]]` — keep 16)

---

## 2. Current app snapshot (drafting time)

| Metric                                            | Value                                               |
| ------------------------------------------------- | --------------------------------------------------- |
| Total `.vue` components                           | 119                                                 |
| Pages (`src/pages/`)                              | 17                                                  |
| Route records (`src/router/routes.ts`)            | 28                                                  |
| Explicit `@/…` imports                            | 242 (59 components, 123 composables/utils/services) |
| State management                                  | none (composables/refs — nothing to migrate)        |
| `VITE_*` env vars                                 | ~13                                                 |
| Files touching `window`/`document`/`localStorage` | 32 (fine in SPA mode)                               |

---

## 3. What gets DELETED or MODERNIZED

### Tier 1 — biggest wins

- [ ] **Auto-imports** — remove ~242 `@/…` import lines. Nuxt auto-imports `components/`, `composables/`,
      `utils/`. Delete the `src/components/icons/index.ts` barrel too.
- [ ] **File-based routing** — delete `src/router/index.ts` + `src/router/routes.ts`. See §6 mapping.
- [ ] **`@nuxtjs/i18n`** — delete `src/i18n/index.ts` (custom `loadLocaleMessages`/`cleanMessages`/`alternative`).
      Modernize the **`location.reload()` language switch** in `src/services/language.ts` → reactive `setLocale()`.

### Tier 2 — module replacements

- [ ] **`useSeoMeta`/`useHead`** — delete `src/utils/title.ts` and the `router.beforeEach(setTitle)` plumbing;
      set titles/OG tags per page via `definePageMeta`/`useSeoMeta`.
- [ ] **`runtimeConfig`** — delete `src/config.ts`; replace `import.meta.env.VITE_*` reads with `useRuntimeConfig()`. See §7.
- [ ] **`@sentry/nuxt`** — delete the manual PROD-only `Sentry.init` block in `src/main.ts`.
- [ ] **`useCookie` / `@vueuse/nuxt useLocalStorage`** — rewrite `src/services/settings.ts` (hand-rolled
      localStorage-JSON class) and the ad-hoc `localStorage` use in ~9 files as reactive storage.
- [ ] **`@nuxt/eslint`** — regenerate the flat config (auto-import-aware); clears much of the existing lint debt
      (the `no-undef`/unused-import noise).

### Tier 3 — re-home (keep the library, modernize the wiring)

- [ ] **urql** — `src/graph/client.ts` + `provideClient` (in `App.vue` and `Redirect.vue`) → one `plugins/urql.ts`
      (copy `admin-web`'s `@urql/exchange-auth` + auth0 token pattern).
- [ ] **auth0** — `src/services/auth0.ts` → `plugins/auth0.client.ts`.
- [ ] **unleash / feature-flags** — `src/services/unleash.ts` + `feature-flags.ts` → plugin + composable.
- [ ] **service singletons** (`auth.ts`, `app.ts`, `settings.ts`, `cookies.ts`) → `useState` + composables
      (no module-level singletons).

---

## 4. KEEP as-is (just re-homed/re-imported)

- `@urql/vue` + `graphql-codegen` (`codegen.yml`, `src/graph/generated.ts`) — graphql stays at 16.
- `bccm-video-player` + `hls.js` (browser-only; fine in SPA mode — wrap in `<ClientOnly>` only if SSR is ever enabled).
- `swiper`, `@vueuse/motion`.
- The Tailwind 4 CSS-first config (`src/styles/tailwind.css`, `design-system.css`) — moves over unchanged.
- The 119 components' templates/logic (only imports + route-param access change).

---

## 5. `nuxt.config.ts` modules to adopt (mirror admin-web, add web's needs)

```
modules: [
  '@nuxtjs/i18n',
  '@vueuse/nuxt',
  '@vueuse/motion/nuxt',
  '@sentry/nuxt/module',
  '@nuxt/eslint',
]
ssr: false
vite: { plugins: [tailwindcss()] }   // @tailwindcss/vite, like admin-web
runtimeConfig: { public: { … } }      // see §7
```

Plugins (client): `urql`, `auth0.client`, `unleash.client`. (i18n/sentry/motion handled by modules.)

---

## 6. Routing map: `routes.ts` → `pages/` + `layouts/`

> Preserve route **names** via `definePageMeta({ name: '…' })` — `src/utils/items.ts` resolves many routes by
> name (`router.resolve({ name })`, `router.push({ name })`). Changing names means touching every call site.
> Convert every `props: true` page to read params via `useRoute().params`.

`layouts/`: `StackedLayout.vue` → `layouts/stacked.vue`; `Embed.vue` → `layouts/embed.vue`; `Web.vue` → `layouts/web.vue`.

| Current route (name → path)                                       | props                  | Nuxt page file                                                       | Layout / notes                                                                               |
| ----------------------------------------------------------------- | ---------------------- | -------------------------------------------------------------------- | -------------------------------------------------------------------------------------------- |
| `main` `/`                                                        | —                      | (layout wrapper)                                                     | `stacked` layout                                                                             |
| `front-page` `''`                                                 | `{pageId:'frontpage'}` | `pages/index.vue`                                                    | stacked                                                                                      |
| `webview` `/w/:code`                                              | true                   | `pages/w/[code].vue`                                                 | stacked                                                                                      |
| `page` `:pageId`                                                  | true                   | `pages/[pageId].vue`                                                 | stacked                                                                                      |
| `episode-page` `episode/:episodeId`                               | true                   | `pages/episode/[episodeId].vue`                                      | stacked                                                                                      |
| `episode-collection-page` `episode/:collection/:episodeId`        | true                   | `pages/episode/[collection]/[episodeId].vue`                         | stacked                                                                                      |
| `video-page` `videos/:videoId`                                    | true                   | `pages/videos/[videoId].vue`                                         | stacked                                                                                      |
| `episode-lesson-page` `ep/:episodeId/lesson/:lessonId/:subRoute?` | true                   | `pages/ep/[episodeId]/lesson/[lessonId]/[[subRoute]].vue`            | optional param                                                                               |
| `playlist-episode` `playlist/:playlistId/:episodeId`              | true                   | `pages/playlist/[playlistId]/[episodeId].vue`                        | stacked                                                                                      |
| `search` `/search`                                                | —                      | `pages/search.vue`                                                   | stacked                                                                                      |
| `series-redirect` `/series/:episodeId`                            | true                   | `pages/series/[episodeId].vue`                                       | redirect page                                                                                |
| `program-redirect` `/program/:programId`                          | true                   | `pages/program/[programId].vue`                                      | redirect page                                                                                |
| `shorts` `/shorts/:shortId` (alias `/short/:shortId`)             | true                   | `pages/shorts/[shortId].vue`                                         | `definePageMeta({ alias:['/short/:shortId'] })`                                              |
| `show` `/show/:showId`                                            | true                   | `pages/show/[showId].vue`                                            | stacked                                                                                      |
| `live` `/live`                                                    | —                      | route middleware                                                     | external redirect → `navigateTo('https://live.bcc-connect.org', { external:true })`          |
| `embed` `/embed` (+children)                                      | —                      | `pages/embed/…`                                                      | `embed` layout                                                                               |
| `lesson` `embed/episode/:episodeId/lesson/:lessonId/:subRoute?`   | true                   | `pages/embed/episode/[episodeId]/lesson/[lessonId]/[[subRoute]].vue` | embed                                                                                        |
| `comic` `embed/comic/:comicId`                                    | true                   | `pages/embed/comic/[comicId].vue`                                    | embed                                                                                        |
| `quote-of-the-day` `embed/quote-of-the-day`                       | true                   | `pages/embed/quote-of-the-day.vue`                                   | embed                                                                                        |
| `embed-episode` `/embed/:episodeId`                               | true                   | `pages/embed/[episodeId].vue`                                        | ⚠ verify precedence vs `embed/comic`, `embed/quote-of-the-day` (static segments win in Nuxt) |
| `embed-episode-legacy` `/embed/legacy/episode/:legacyId`          | true                   | `pages/embed/legacy/episode/[legacyId].vue`                          | ⚠ dup name in source — give distinct names                                                   |
| `embed-episode-legacy` `/embed/legacy/program/:programId`         | true                   | `pages/embed/legacy/program/[programId].vue`                         | ⚠ dup name in source                                                                         |
| `delete-account` `/delete-account`                                | `{title}`              | `pages/delete-account.vue`                                           |                                                                                              |
| `auth-redirect` `/r/:code`                                        | true                   | `pages/r/[code].vue`                                                 | auth0 callback — test carefully                                                              |
| `login` `/login`                                                  | —                      | `pages/login.vue`                                                    |                                                                                              |
| `web` `/web` (+`material-request`)                                | —                      | `pages/web/…`                                                        | `web` layout; `pages/web/material-request.vue`                                               |
| `not-found` `/:pathMatch(.*)*`                                    | —                      | `pages/[...slug].vue` or `error.vue`                                 | catch-all                                                                                    |

Navigation guards: `router.beforeEach(setTitle)` → replaced by per-page `useSeoMeta` (§3). `/live` `beforeEnter` →
route middleware.

---

## 7. Env var mapping (`config.ts` + scattered `import.meta.env` → `runtimeConfig`)

All are public (SPA). Define under `runtimeConfig.public`, read via `useRuntimeConfig().public.*`.

| Old                                                                  | New (`runtimeConfig.public`)                      |
| -------------------------------------------------------------------- | ------------------------------------------------- |
| `VITE_API_URL`                                                       | `apiUrl`                                          |
| `VITE_AUTH0_DOMAIN` / `VITE_AUTH0_CLIENT_ID` / `VITE_AUTH0_AUDIENCE` | `auth0Domain` / `auth0ClientId` / `auth0Audience` |
| `VITE_AUTH`                                                          | `auth`                                            |
| `VITE_SENTRY_DSN`                                                    | handled by `@sentry/nuxt` config                  |
| `VITE_UNLEASH_URL` / `VITE_UNLEASH_CLIENT_KEY`                       | `unleashUrl` / `unleashClientKey`                 |
| `VITE_RUDDERSTACK_WRITE_KEY` / `VITE_RUDDERSTACK_DATA_PLANE_URL`     | `rudderWriteKey` / `rudderDataPlaneUrl`           |
| `VITE_NPAW_ACCOUNT_CODE`                                             | `npawAccountCode`                                 |
| `import.meta.env.PROD`                                               | `import.meta.dev` (inverted)                      |
| `import.meta.env.MODE`                                               | `runtimeConfig.public.env` or build env           |

> `.env` keys: Nuxt reads `NUXT_PUBLIC_*` → `runtimeConfig.public.*`. Update deploy env names accordingly.

---

## 8. Phased checklist

**Phase 1 — scaffold**

- [ ] Create Nuxt 4 app; copy `admin-web/nuxt.config.ts` as starting point (`ssr:false`, tailwind vite plugin, modules).
- [ ] Port `src/styles/tailwind.css` + `design-system.css` + `barlow.css`; wire global CSS in `nuxt.config`.
- [ ] Set up `runtimeConfig` (§7); confirm `~`/`@` alias → `app/` srcDir.
- [ ] `graphql-codegen`: keep `codegen.yml`, repoint `documents` path, regenerate.

**Phase 2 — routing**

- [ ] Build `pages/` tree + `layouts/` per §6; preserve names; convert `props:true` → `useRoute().params`.
- [ ] `/live` + any guards → `middleware/`.
- [ ] Verify `utils/items.ts` name-based resolution still works.

**Phase 3 — plugins/services**

- [ ] `plugins/urql.ts` (copy admin-web), `plugins/auth0.client.ts`, `plugins/unleash.client.ts`.
- [ ] `@sentry/nuxt` config; delete manual init.

**Phase 4 — components**

- [ ] Move 119 components into `components/`; delete `@/…` imports (auto-import); fix any remaining alias paths.
- [ ] Delete `icons/index.ts` barrel.

**Phase 5 — i18n**

- [ ] `@nuxtjs/i18n` config + lazy locale files (`src/translations/*.json`).
- [ ] Rework `language.ts` switch → `setLocale()` (no reload); verify components react to locale change.

**Phase 6 — modernize storage/services**

- [ ] `settings.ts` → `useCookie`/`useLocalStorage`; same for the ~9 ad-hoc localStorage sites.
- [ ] Singleton services (`auth`, `app`, `cookies`) → `useState`/composables.

**Phase 7 — config/lint cleanup**

- [ ] `@nuxt/eslint` flat config; resolve residual lint findings.
- [ ] Delete `vite.config.ts`, `src/router/`, `src/config.ts`, `src/utils/title.ts`, `src/i18n/index.ts`, `src/main.ts`, `src/App.vue` (→ `app.vue`).

**Phase 8 — build/deploy**

- [ ] `nuxi generate` (static, SPA) → serve via nginx; update `Dockerfile`/`nginx.conf`.
- [ ] Wire env (`NUXT_PUBLIC_*`).

**Phase 9 — QA**

- [ ] Auth0 login + `/r/:code` callback; token refresh via urql auth exchange.
- [ ] Video playback (`bccm-video-player`), audio (`hls.js`).
- [ ] Deep links to every dynamic route; the `shorts` alias; catch-all 404.
- [ ] Locale switch (no full reload); analytics (rudderstack/NPAW); Sentry events; feature flags.

---

## 9. Gotchas

- **Route-name coupling** — `utils/items.ts` is the riskiest; keep names stable via `definePageMeta`.
- **`/embed/:episodeId` vs `/embed/comic|quote-of-the-day`** — confirm static-segment precedence resolves as intended.
- **Auth0 callback** under file routing + SPA — copy admin-web; test the redirect round-trip.
- **No-reload locale switch** — the old `location.reload()` hid components that didn't react to locale; watch for stale strings.
- **Duplicate `embed-episode-legacy`** name — give the two pages distinct names during the move.
- **Keep `ssr:false` honest** — don't flip SSR on without auditing the 32 browser-API files + wrapping player/auth in `<ClientOnly>`.

---

## 10. Rough effort

Components port largely as-is (templates unchanged), and the recent dep modernization (Tailwind 4, vue-i18n 11,
vueuse 14, vite 8, graphql 16) already aligns `web/` with `admin-web`. The real effort is **routing**, **i18n module**,
**plugin/bootstrap rework**, and **storage/service modernization** — a focused multi-session project, low-risk in SPA mode.
