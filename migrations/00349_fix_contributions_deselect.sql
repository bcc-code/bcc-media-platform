-- +goose Up

-- Polymorphic contributions (timedmetadata_id / mediaitem_id / song_id) violate
-- the one_item CHECK when removed from a parent via the admin UI: the default
-- 'nullify' deselect nulls the row's only non-NULL FK, leaving all three NULL.
-- Switch to 'delete' so removing a contributor deletes the contribution row.
UPDATE "public"."directus_relations" SET "one_deselect_action" = 'delete' WHERE "id" = 475; -- contributions.mediaitem_id -> mediaitems
UPDATE "public"."directus_relations" SET "one_deselect_action" = 'delete' WHERE "id" = 476; -- contributions.timedmetadata_id -> timedmetadata
UPDATE "public"."directus_relations" SET "one_deselect_action" = 'delete' WHERE "id" = 490; -- contributions.song_id -> songs

-- +goose Down

UPDATE "public"."directus_relations" SET "one_deselect_action" = 'nullify' WHERE "id" = 475;
UPDATE "public"."directus_relations" SET "one_deselect_action" = 'nullify' WHERE "id" = 476;
UPDATE "public"."directus_relations" SET "one_deselect_action" = 'nullify' WHERE "id" = 490;
