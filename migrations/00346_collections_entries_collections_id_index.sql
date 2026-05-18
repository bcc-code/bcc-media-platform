-- +goose Up

-- collections_entries previously had no index on collections_id, so every
-- "select"-type collection load (the hot path in personalized loaders) was
-- driven by a seq scan over the full table. The query filters by
-- collections_id = ANY($1::int[]), which is the natural shape for a btree.
CREATE INDEX IF NOT EXISTS collections_entries_collections_id_index
    ON public.collections_entries (collections_id);

-- +goose Down
DROP INDEX IF EXISTS collections_entries_collections_id_index;
