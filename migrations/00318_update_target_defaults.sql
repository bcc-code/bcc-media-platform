-- +goose Up

UPDATE "public"."directus_fields" SET "required" = false WHERE "id" = 3058;
UPDATE "public"."directus_fields" SET "required" = false WHERE "id" = 3059;
ALTER TABLE IF EXISTS "public"."targets" ALTER COLUMN "type" SET DEFAULT 'usergroups';

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
-- +goose Down

UPDATE "public"."directus_fields" SET "required" = true WHERE "id" = 3058;
UPDATE "public"."directus_fields" SET "required" = true WHERE "id" = 3059;
ALTER TABLE IF EXISTS "public"."targets" ALTER COLUMN "type" DROP DEFAULT;

