# admin-web scope notes

Design notes for `admin-web/`, written 2026-08-24. Records what the primary
content admin actually does, what the backend requires for each of those tasks,
and which Directus concepts we intend to hide.

`admin-web` is currently a UI prototype: only `useEpisodes` talks to the real API
(`preview.collection`), everything else is a local ref over `app/utils/mock-*.ts`.
The admin GraphQL surface (`backend/graph/admin/schema.graphqls`) is still tiny —
preview, statistics, timed-metadata import, auth. Writing anything from admin-web
means extending it.

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

Closest match to what already exists. Gaps: the CMS models entry type as
`link_type` (`episode | season | show`, null = simple) plus the matching
`episode_id`/`season_id`/`show_id` m2o — the prototype's type picker never asks
_which_ item to link, which is the defining field. `ShowCalendarEntry` is missing
from the prototype's three options. Also missing: `status`, `image` +
`image_from_link`, and the buffer group (`buffer_available_hours`,
`buffer_start`, `buffer_end`, `buffer_usergroups`, migrations 355–356).

The prototype's calendar _events_ form has an `image` field that does not exist
on `events` — that collection has only 9 fields (status, start, end,
translations).

### 3. Push notifications

Prototype model is invented and needs replacing. Reality: title and body come
from `template_id` → `notificationtemplates` translations, not typed inline.
Audience is `applicationgroup_id` (an application _group_, not a per-app code)
plus a `targets` m2m, where a target is a rule object (`type`, build-number
range, `inactive_days_min/max`, `languages`, `device_os`). Missing from the
prototype: `action` (`deep_link` / `clear_cache`), `deep_link`, `high_priority`.
State is `send_started` / `send_completed`, not a status enum.

### 4–5. Pages, sections, collections

Sections: the prototype collapses `type` (item/link) + `style` (carousel/cards) +
`size` + `grid_size` into the public API type names (`PosterSection`,
`IconGridSection`, …). **This is the right abstraction** — an editor thinks
"poster row", not three orthogonal columns. Keep it. It covers 6 of the 16 public
types today.

`continueWatching` in the prototype's section metadata is real but at the wrong
level — it is `collections.advanced_type = 'continue_watching'`. `myList` is not
editorial at all; it is a per-user feature.

Collections are the most expensive item, since both modes are in real use:
`filter_type` is `select` or `query`, and query mode drives four separate query
builders (`episodes_query_filter`, `shows_query_filter`, …). Suggested shape:
hand-picked as the default path over `collections_items`, query mode behind an
explicit "Avansert" switch. If her queries cluster into recurring patterns, named
presets beat a general rules builder.

### 6. Shorts

The one place the mediaitem chain genuinely leaks. A short is
`mediaitem + status + roles + score`, where the mediaitem is a **clip** —
`parent_episode_id` plus `parent_starts_at` / `parent_ends_at`. A short is not a
thing you attach a video file to; it is a time range carved out of an episode.
Build it as "lag en short fra denne episoden" with a range scrubber. A flat CRUD
form over `shorts` would force her back to hand-creating mediaitems.

### Maintenance message

Currently a four-collection dance: create a `messagetemplates` row (`type`:
warning/error/info, plus `style` and translations) → attach to a `messages` row
via m2m → set `enabled` → ensure a `MessageSection` on the right page points at
it. One screen (severity, text, which apps, on/off) collapses all four. Probably
the best simplification-per-effort item on the list.

### Livestream on/off

`globalconfig.live_online`, a single boolean on a singleton row
(`livestream_url` and `npaw_enabled` live there too). One toggle with a confirm
dialog. Done in an afternoon, and used under time pressure during maintenance
windows — which is exactly when navigating Directus is worst.

## Suggested build order

Cheapest-and-most-used first:

1. Livestream toggle
2. Maintenance message
3. Episode publish flow (asset list + link + metadata + publish,
   `translations_required` defaulting true)
4. Calendar (linked item picker, `ShowCalendarEntry`, buffer fields)
5. Shorts (as clip-from-episode)
6. Push notifications (remodel onto applicationgroup + targets + templates)
7. Pages / sections
8. Collections — most design work, do it last with real examples of her queries

Keep `SeasonForm` (yearly use is real; needs the required `publish_date`). Shows
can drop to read-only or move out of the main flow.

## Other cross-cutting gaps

- **Images**: prototype uses a free-text URL input. Reality is `image_file_id`
  (a file picker) plus an `images` o2m for style variants.
- **Availability / access**: absent from the prototype entirely. The CMS has
  `available_from`, `available_to` and `usergroups` on shows/seasons/episodes.
- **Statuses** match: `published | unlisted | draft | archived` across
  shows/seasons/episodes (base migration had three; `unlisted` added in 00107
  and 00090).

## Open questions

- Do her collection queries fall into a few reusable patterns?
- Which of the 16 public section types does she actually place?
- Does the episode flow need a "waiting for video" view, or is searching assets
  enough?
