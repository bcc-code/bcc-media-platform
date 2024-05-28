-- +goose Up
-- +goose StatementBegin
ALTER TABLE contributions
DROP CONSTRAINT contributions_timedmetadata_id_foreign;

ALTER TABLE contributions
ADD CONSTRAINT contributions_timedmetadata_id_foreign
FOREIGN KEY (timedmetadata_id)
REFERENCES timedmetadata(id)
ON DELETE CASCADE;

ALTER TABLE contributions
DROP CONSTRAINT contributions_mediaitem_id_foreign;

ALTER TABLE contributions
ADD CONSTRAINT contributions_mediaitem_id_foreign
FOREIGN KEY (mediaitem_id)
REFERENCES mediaitems(id)
ON DELETE CASCADE;

-- Clean up, then enforce that there's always either a timedmetadata_id or mediaitem_id
DELETE FROM contributions WHERE timedmetadata_id IS NULL AND mediaitem_id IS NULL;
ALTER TABLE contributions ADD CONSTRAINT one_item CHECK (timedmetadata_id IS NOT NULL OR mediaitem_id IS NOT NULL);
-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
ALTER TABLE contributions
DROP CONSTRAINT contributions_timedmetadata_id_foreign;

ALTER TABLE contributions
ADD CONSTRAINT contributions_timedmetadata_id_foreign
FOREIGN KEY (timedmetadata_id)
REFERENCES timedmetadata(id)
ON DELETE SET NULL;

ALTER TABLE contributions
DROP CONSTRAINT contributions_mediaitem_id_foreign;

ALTER TABLE contributions
ADD CONSTRAINT contributions_mediaitem_id_foreign
FOREIGN KEY (mediaitem_id)
REFERENCES mediaitems(id)
ON DELETE SET NULL;

-- Drop the check constraint
ALTER TABLE contributions DROP CONSTRAINT one_item;
-- +goose StatementEnd