
-- +goose Up

CREATE INDEX mediaitems_published_at_index ON public.mediaitems USING btree (published_at);
CREATE INDEX timedmetadata_mediaitem_id_index ON public.timedmetadata USING btree (mediaitem_id);
CREATE INDEX timedmetadata_seconds_index ON public.timedmetadata USING btree ("seconds");

-- +goose Down

DROP INDEX IF EXISTS mediaitems_published_at_index;
DROP INDEX IF EXISTS timedmetadata_mediaitem_id_index;
DROP INDEX IF EXISTS timedmetadata_seconds_index;