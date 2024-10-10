-- +goose Up

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "options" = '{"enableSelect":false,"template":"{{seconds}} - {{label}}"}', "display_options" = '{"template":"{{seconds}} - {{label}}"}' WHERE "id" = 1237;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

-- +goose Down

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "options" = '{"enableSelect":false,"template":"{{timestamp}} - {{label}}"}', "display_options" = '{"template":"{{timestamp}} - {{label}}"}' WHERE "id" = 1237;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---
