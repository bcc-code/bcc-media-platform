# admin-web scope notes

Design notes for `admin-web/`, written 2026-08-24. Records what the primary
content admin actually does, what the backend requires for each of those tasks,
and which Directus concepts we intend to hide.

**Status:** all eight of her tasks now have a UI flow, built as demos to try the
UX. Nothing is wired to the backend — every page runs on a local ref over
`app/utils/mock-*.ts`. See [What is built](#what-is-built) for routes, and
[Wiring it up](#wiring-it-up) for what that would take.

The admin GraphQL surface (`backend/graph/admin/schema.graphqls`) is still tiny —
preview, statistics, timed-metadata import, auth. Writing anything from admin-web
means extending it. `app/composables/useEpisodeSearch.ts` holds the one real
query (`preview.collection`), currently unused but kept as the working reference
for the urql + codegen wiring.

## Guiding principle

Do not mirror the Directus UI. Directus exposes the storage model; admin-web
should expose the jobs. In particular the admin should not need to know about the
`assets` → `mediaitems` → `episodes` chain.

## The admin's tasks

Her own list, in her words:

Main tasks:

1. Klargjøre + publisere episoder i VOD (sjekke eksportere assets)
2. Lage calendar for TV-guide på Live
3. Klargjøre pushvarsler til appene
4. Page management
5. Oppretter og vedlikeholder sections, collections osv
6. Publisere shorts

Rarer:

- Legge ut maintenance-melding
- Slå av og på streamingen (for vedlikehold fra Brunstad)

Clarifications she gave:

- Shows are created rarely; **seasons at least once a year** (season 2026, 2027…).
- Collections are a genuine mix of hand-picked and query-driven.
- Asset export happens in a **separate system**. Her job here is only to verify
  the media she exported shows up as an asset — she never triggers anything.
- **She does not translate.** Strings go to translation in the background, and we
  do not want "translations" exposed in the admin UI at all.
- The maintenance message is **not** a single dedicated thing. It is a general
  messages system used for all kinds of user-facing info, and **several can be
  active at once**.

## Translations

Resolved: admin-web only ever reads and writes the **Norwegian** row.

`backend/translations/collection_handlers_export.go` hardcodes `Language: "no"`
in all 19 collection handlers, and the queries filter on `languages_code = 'no'`
(`queries/translations.sql:39`). Phrase writes the other languages back via the
`UpdateXTranslation` upserts. Coverage includes everything on her list: shows,
seasons, episodes, events, calendar entries, sections, pages, mediaitems.

So forms keep one plain "Tittel" / "Beskrivelse" per entity — the shape the
prototype already has — pointed at the `no` translation row rather than a column.

### The trap

Export is gated on two conditions (`queries/translations.sql:42-43`):

```sql
AND s.translations_required
AND s.status = ANY ('{published,unlisted}')
```

Content created with `translations_required = false` **silently never reaches
Phrase**. No error, no queue, it just stays Norwegian-only. Hiding the translation
UI is fine; hiding this flag while leaving it false is not. Default it to `true`
on create, or surface it as something meaningful ("Send til oversettelse").

Related: `GetEventTranslatable` gates only on status, not on
`translations_required` — events behave differently from shows here.

Also relevant: a 2025-01-22 cutoff date on unmodified rows
(`translationsCutoffDate`), and a 30-minute dedup window via
`translations_hash.last_sent` (see migration 00358).

## Per-task backend notes

### 1. Episodes / VOD

Playback still resolves from `episodes.asset_id`
(`backend/graph/api/episodes.resolvers.go:138`); `mediaitem_id` exists alongside
but is not what the player uses. So for ordinary VOD the essential link is just
**episode → asset**, and the mediaitem row can be created behind the scenes.

Ingest is automatic (`backend/asset/ingest.go:145`) — assets arrive from
Mediabanken and are inserted with `status = draft` and a `mediabanken_id`.

Since her task is verification only, the screen is a searchable asset list —
name, `mediabanken_id`, duration, arrival time, linked-or-not — plus a "link to
episode" action. No ingest controls, no re-export button.

### 2. Calendar

The CMS models entry type as `link_type` (`episode | season | show`, null =
simple) plus the matching `episode_id`/`season_id`/`show_id` m2o. The UI shows
four types and asks which item to link — that is the defining field, and the
first version of the prototype never asked for it. `status`, `image` +
`image_from_link` and the buffer group (`buffer_available_hours`,
`buffer_start`, `buffer_end`, migrations 355–356) are all present; the buffer is
presented as "Start forfra" rather than as four columns.

`buffer_usergroups` is not in the UI — see the access-control gap below.

`events` has only 9 fields (status, start, end, translations). The prototype's
event form used to carry an `image` field that does not exist there; images
belong on the entries.

### 3. Push notifications

Title and body come from `template_id` → `notificationtemplates` translations,
not typed inline — the template indirection is hidden the same way mediaitems
are. Audience is `applicationgroup_id` (an application _group_, not a per-app
code) plus a `targets` m2m, where a target is a rule object (`type`,
build-number range, `inactive_days_min/max`, `languages`, `device_os`). Targets
are picked as chips with the rule spelled out in plain language; authoring them
is deliberately out of scope.

`action` (`deep_link` / `clear_cache`), `deep_link` and `high_priority` are all
in the form. State is derived from `send_started` / `send_completed` rather than
a status enum, which is why "Sender…" exists as a real state.

### 4–5. Pages, sections, collections

Sections collapse `type` (item/link) + `style` (carousel/cards) + `size` +
`grid_size` into the public API type names (`PosterSection`, `IconGridSection`,
…). **This is the right abstraction** — an editor thinks "poster row", not three
orthogonal columns. All 16 public types are covered, grouped by family
(karuseller / rutenett / spesial) in `sectionTypes` in `app/utils/mock-pages.ts`,
which is the single source both the add dialog and the config panel read from.

Section metadata is the real set: `showTitle`, `needsAuthentication`,
`collectionId`, `limit`, `secondaryTitles`, `useContext`, `prependLiveElement`,
plus `embedUrl` / `messageId` / `achievementsSource` for the non-item types. An
early version carried `continueWatching` and `myList` — the first is real but
belongs on the collection (`advanced_type = 'continue_watching'`), and the second
is a per-user feature, not editorial.

Pages themselves had no editable fields at first; `code` (required), `title`,
`description`, `applicationCode` and `status` are now behind a settings dialog.

Collections were the most expensive item, since both modes are in real use:
`filter_type` is `select` or `query`, and query mode drives four separate query
builders (`episodes_query_filter`, `shows_query_filter`, …). Hand-picked is the
default path; query mode sits behind the mode toggle with a live match count. If
her queries cluster into recurring patterns, named presets would still beat the
general builder.

### 6. Shorts

The one place the mediaitem chain genuinely leaks. A short is
`mediaitem + status + roles + score`, where the mediaitem is a **clip** —
`parent_episode_id` plus `parent_starts_at` / `parent_ends_at`. A short is not a
thing you attach a video file to; it is a time range carved out of an episode.
Built as "hent fra episode" plus a range scrubber, so the clip is expressed as a
range and the mediaitem is created behind it. A flat CRUD form over `shorts`
would force her back to hand-creating mediaitems.

`roles` (the usergroup access m2m) is not in the UI — see the access-control gap
below.

### Messages

In Directus this is a four-collection dance: create a `messagetemplates` row
(`type`: warning/error/info, plus `style` and translations) → attach to a
`messages` row via m2m → set `enabled` → ensure a `MessageSection` on the right
page points at it. One screen (severity, text, which apps, on/off) collapses all
four.

Each `messages` row has its own `enabled` flag, so several being live at once is
native to the model, not something we bolt on.

### Livestream on/off

`globalconfig.live_online`, a single boolean on a singleton row
(`livestream_url` and `npaw_enabled` live there too). One toggle with a confirm
dialog. Done in an afternoon, and used under time pressure during maintenance
windows — which is exactly when navigating Directus is worst.

## What is built

Built cheapest-and-most-used first, in the order listed here. All mock-backed.

| Task        | Routes                                                        |
| ----------- | ------------------------------------------------------------- |
| Livestream  | `/livestream`                                                 |
| Messages    | `/messages`, `/messages/new`, `/messages/[id]`                |
| Episodes    | `/episodes`, `/episodes/new`, `/episodes/[id]`, `/assets`     |
| Calendar    | `/calendar/entries/*`, `/calendar/events/*`                   |
| Shorts      | `/shorts`, `/shorts/new`, `/shorts/[id]`                      |
| Push        | `/notifications`, `/notifications/new`, `/notifications/[id]` |
| Pages       | `/pages`, `/pages/[id]`                                       |
| Collections | `/collections`, `/collections/new`, `/collections/[id]`       |

Decisions worth keeping when this gets wired up:

- **Livestream** is a labelled button ("Ta av luften" / "Sett på luften"), not a
  switch, and only going off air is confirmed. It is used under time pressure.
- **Episodes** never mention mediaitems. The Video field picks an arrived asset;
  duration is read off the file rather than typed. Publishing is blocked without
  a video. No age rating field — the CMS hides `agerating_code` on episodes.
- **`translations_required` defaults on**, surfaced as "Send til oversettelse".
  See [the trap](#the-trap).
- **Assets** (`/assets`) is verification-only — what arrived, when, whether it is
  in use. No ingest or re-export controls, because ingest runs on its own.
- **Shorts** are a time range dragged over an episode, with ±1s nudges. Episodes
  without video are not offered.
- **Push** audience is an application group plus saved target rules, shown as
  chips with the rule spelled out. Rules are picked, never authored.
- **Sections** keep the public type names (`PosterSection`, …) instead of the
  raw type/style/size/grid_size columns. All 16 types, grouped by family.
- **Collections** default to hand-picked; query mode has a live "Treff nå (N)"
  panel so rules are not written blind.

The app filter (`stores/appFilter.ts`) now filters by **application group**
rather than app code, since that is what notifications target and what the admin
thinks in. `applicationGroupForCode()` maps the two.

`SeasonForm` was kept (yearly use is real). Shows are still full CRUD and could
drop to read-only.

## Wiring it up

Nothing here talks to the backend. Each flow needs, roughly in order:

1. Mutations on `backend/graph/admin/schema.graphqls` — it currently has no
   write surface beyond auth.
2. Reads that return the `no` translation row alongside each record, so the
   single "Tittel" / "Beskrivelse" fields keep working.
3. `translations_required` set true on create, or the export silently skips it.
4. Replacing `app/utils/mock-*.ts` and the matching composables. The composables
   are already the seam — pages never touch the mocks directly.

## Other cross-cutting gaps

- **Images**: still a free-text URL input everywhere. Reality is `image_file_id`
  (a file picker) plus an `images` o2m for style variants. Not addressed.
- **Availability**: `available_from` / `available_to` are in the episode form,
  but not on shows or seasons.
- **Access control is absent everywhere.** `usergroups` on shows/seasons/
  episodes, `earlyaccess_usergroups` and `download_usergroups` on mediaitems,
  `buffer_usergroups` on calendar entries, and `roles` on shorts all exist in
  the CMS and have no UI. This is the largest remaining hole, and it spans
  enough entities that it wants one deliberate design rather than a field bolted
  onto each form.
- **Statuses** match: `published | unlisted | draft | archived` across
  shows/seasons/episodes (base migration had three; `unlisted` added in 00107
  and 00090).

## Open questions

- Do her collection queries fall into a few reusable patterns? The query builder
  is generic today; presets would beat it if the answer is yes.
- Which of the 16 public section types does she actually place?
- Where should `usergroups` live in the UI, given it spans several entities?
- Does the episode flow need a "waiting for video" view beyond the count banner
  on `/episodes`?
