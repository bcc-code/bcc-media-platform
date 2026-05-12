-- +goose Up

ALTER TABLE IF EXISTS "public"."persons"
    ADD COLUMN IF NOT EXISTS "type" varchar NOT NULL DEFAULT 'person';

ALTER TABLE "public"."persons"
    ADD CONSTRAINT "persons_type_check"
    CHECK ("type" IN ('person', 'organization'));

INSERT INTO "public"."directus_fields"
    ("id", "collection", "field", "special", "interface", "options",
     "display", "display_options", "readonly", "hidden", "sort", "width",
     "translations", "note", "conditions", "required", "group", "validation", "validation_message")
VALUES
    (3086, 'persons', 'type', NULL, 'select-dropdown',
     '{"choices":[{"text":"Person","value":"person"},{"text":"Organization","value":"organization"}]}',
     NULL, NULL, false, false, 3, 'half', NULL, NULL, NULL, true, NULL, NULL, NULL);

INSERT INTO "public"."persons" ("id", "name", "type")
VALUES
    ('c56597a0-1f4e-4ca2-ba28-3dc07d1f5e51', 'BCC Media STI', 'organization'),
    ('1d6a2218-ed97-441d-a3ac-3f8eaa708fff', 'Stiftelsen Skjulte Skatters Forlag', 'organization')
ON CONFLICT (id) DO NOTHING;

-- +goose Down

DELETE FROM "public"."persons"
    WHERE id IN ('c56597a0-1f4e-4ca2-ba28-3dc07d1f5e51',
                 '1d6a2218-ed97-441d-a3ac-3f8eaa708fff');

DELETE FROM "public"."directus_fields" WHERE id = 3086;

ALTER TABLE "public"."persons" DROP CONSTRAINT IF EXISTS "persons_type_check";

ALTER TABLE IF EXISTS "public"."persons" DROP COLUMN IF EXISTS "type";
