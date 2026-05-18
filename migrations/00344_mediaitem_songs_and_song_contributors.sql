-- +goose Up

-- URLs on songs (string array; minimal-first). Empty-array default keeps NULL out
-- of read paths and matches the GraphQL non-null contract.
ALTER TABLE "public"."songs"
    ADD COLUMN IF NOT EXISTS "urls" text[] NOT NULL DEFAULT '{}'::text[];

-- Polymorphic FK from contributions to songs (mirrors mediaitem_id / timedmetadata_id from 00290).
-- ON DELETE RESTRICT: deleting a song with contributions is blocked, forcing editors to
-- repoint or remove the contributions explicitly instead of silently dropping history.
ALTER TABLE "public"."contributions"
    ADD COLUMN IF NOT EXISTS "song_id" uuid NULL;

ALTER TABLE "public"."contributions"
    ADD CONSTRAINT "contributions_song_id_foreign"
    FOREIGN KEY (song_id) REFERENCES songs (id) ON DELETE RESTRICT;

-- Extend the one_item CHECK from 00292 so a contribution may carry a song reference instead.
ALTER TABLE "public"."contributions" DROP CONSTRAINT IF EXISTS "one_item";
ALTER TABLE "public"."contributions"
    ADD CONSTRAINT "one_item"
    CHECK (timedmetadata_id IS NOT NULL OR mediaitem_id IS NOT NULL OR song_id IS NOT NULL);

-- M2M junction between mediaitems and songs.
CREATE SEQUENCE IF NOT EXISTS "public"."mediaitems_songs_id_seq"
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 2147483647
    START WITH 1
    CACHE 1
    NO CYCLE;

GRANT SELECT, USAGE, UPDATE ON SEQUENCE "public"."mediaitems_songs_id_seq" TO directus;

CREATE TABLE IF NOT EXISTS "public"."mediaitems_songs" (
    "id"            int4 NOT NULL DEFAULT nextval('mediaitems_songs_id_seq'::regclass),
    "mediaitems_id" uuid NOT NULL,
    "songs_id"      uuid NOT NULL,
    CONSTRAINT "mediaitems_songs_pkey" PRIMARY KEY (id),
    CONSTRAINT "mediaitems_songs_unique" UNIQUE (mediaitems_id, songs_id),
    CONSTRAINT "mediaitems_songs_mediaitems_id_foreign"
        FOREIGN KEY (mediaitems_id) REFERENCES mediaitems (id) ON DELETE CASCADE,
    CONSTRAINT "mediaitems_songs_songs_id_foreign"
        FOREIGN KEY (songs_id) REFERENCES songs (id) ON DELETE CASCADE
);

GRANT SELECT ON TABLE "public"."mediaitems_songs" TO directus, api;
GRANT INSERT, UPDATE, DELETE ON TABLE "public"."mediaitems_songs" TO directus;

-- Directus admin-UI registration.
INSERT INTO "public"."directus_collections"
    ("collection", "icon", "note", "display_template", "hidden", "singleton", "translations",
     "archive_field", "archive_app_filter", "archive_value", "unarchive_value", "sort_field",
     "accountability", "color", "item_duplication_fields", "sort", "group", "collapse",
     "preview_url", "versioning")
VALUES ('mediaitems_songs', 'import_export', NULL, NULL, true, false, NULL, NULL, true, NULL,
        NULL, NULL, 'all', NULL, NULL, NULL, NULL, 'open', NULL, false);

INSERT INTO "public"."directus_fields"
    ("id", "collection", "field", "special", "interface", "options", "display", "display_options",
     "readonly", "hidden", "sort", "width", "translations", "note", "conditions", "required",
     "group", "validation", "validation_message")
VALUES
    -- songs.urls (string array UI)
    (3090, 'songs', 'urls', 'cast-json', 'tags', '{"presets":[],"alphabetize":false,"allowCustom":true,"whitespace":"-"}',
     'formatted-value', NULL, false, false, 6, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL),
    -- songs.contributions (o2m via contributions.song_id, mirrors mediaitems.contributions field 3038 from 00290)
    (3091, 'songs', 'contributions', 'o2m', 'list-o2m',
     '{"template":"{{type}}{{person_id}}","layout":"table","fields":["person_id.name","type"],"tableSpacing":"compact","enableSelect":false}',
     NULL, NULL, false, false, 7, 'full', NULL, NULL, NULL, false, NULL, NULL, NULL),
    -- contributions.song_id (hidden m2o)
    (3092, 'contributions', 'song_id', 'm2o', 'select-dropdown-m2o', NULL, NULL, NULL, false, true, 10,
     'full', NULL, NULL, NULL, false, NULL, NULL, NULL),
    -- mediaitems.songs (m2m via mediaitems_songs)
    (3093, 'mediaitems', 'songs', 'm2m', 'list-m2m',
     '{"layout":"table","tableSpacing":"compact"}', NULL, NULL, false, false, 17, 'full', NULL, NULL,
     NULL, false, 'metadata', NULL, NULL),
    -- mediaitems_songs.id (hidden)
    (3094, 'mediaitems_songs', 'id', NULL, NULL, NULL, NULL, NULL, false, true, 1, 'full', NULL, NULL,
     NULL, false, NULL, NULL, NULL),
    -- mediaitems_songs.mediaitems_id (hidden)
    (3095, 'mediaitems_songs', 'mediaitems_id', NULL, NULL, NULL, NULL, NULL, false, true, 2, 'full',
     NULL, NULL, NULL, false, NULL, NULL, NULL),
    -- mediaitems_songs.songs_id (hidden)
    (3096, 'mediaitems_songs', 'songs_id', NULL, NULL, NULL, NULL, NULL, false, true, 3, 'full',
     NULL, NULL, NULL, false, NULL, NULL, NULL);

SELECT setval(pg_get_serial_sequence('"public"."directus_fields"', 'id'), max("id"), true)
FROM "public"."directus_fields";

INSERT INTO "public"."directus_relations"
    ("id", "many_collection", "many_field", "one_collection", "one_field", "one_collection_field",
     "one_allowed_collections", "junction_field", "sort_field", "one_deselect_action")
VALUES
    -- contributions.song_id -> songs (one_field "contributions" on songs, no junction = direct o2m)
    (490, 'contributions', 'song_id', 'songs', 'contributions', NULL, NULL, NULL, NULL, 'nullify'),
    -- mediaitems_songs.mediaitems_id -> mediaitems (one_field "songs", junction songs_id)
    (491, 'mediaitems_songs', 'mediaitems_id', 'mediaitems', 'songs', NULL, NULL, 'songs_id', NULL, 'nullify'),
    -- mediaitems_songs.songs_id -> songs (no one_field; songs side uses contributions m2m if any. Keep nullify.)
    (492, 'mediaitems_songs', 'songs_id', 'songs', NULL, NULL, NULL, 'mediaitems_id', NULL, 'nullify');

SELECT setval(pg_get_serial_sequence('"public"."directus_relations"', 'id'), max("id"), true)
FROM "public"."directus_relations";


-- +goose Down

DELETE FROM "public"."directus_relations" WHERE "id" IN (490, 491, 492);

DELETE FROM "public"."directus_fields"
WHERE "id" IN (3090, 3091, 3092, 3093, 3094, 3095, 3096);

DELETE FROM "public"."directus_collections" WHERE "collection" = 'mediaitems_songs';

DROP TABLE IF EXISTS "public"."mediaitems_songs";
DROP SEQUENCE IF EXISTS "public"."mediaitems_songs_id_seq";

-- Restore the original one_item CHECK from 00292. Drop any song-only rows so the
-- pre-00344 invariant (timedmetadata_id IS NOT NULL OR mediaitem_id IS NOT NULL) holds.
ALTER TABLE "public"."contributions" DROP CONSTRAINT IF EXISTS "one_item";
DELETE FROM "public"."contributions"
WHERE timedmetadata_id IS NULL AND mediaitem_id IS NULL;
ALTER TABLE "public"."contributions"
    ADD CONSTRAINT "one_item"
    CHECK (timedmetadata_id IS NOT NULL OR mediaitem_id IS NOT NULL);

ALTER TABLE IF EXISTS "public"."contributions"
    DROP CONSTRAINT IF EXISTS "contributions_song_id_foreign";

ALTER TABLE IF EXISTS "public"."contributions"
    DROP COLUMN IF EXISTS "song_id";

ALTER TABLE IF EXISTS "public"."songs"
    DROP COLUMN IF EXISTS "urls";
