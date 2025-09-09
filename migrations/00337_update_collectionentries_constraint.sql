-- +goose Up
alter table users.collectionentries
    drop constraint collectionentries_unique_key;

alter table users.collectionentries
    add constraint collectionentries_unique_key
        unique (collection_id, item_id, type);

-- +goose Down
alter table users.collectionentries
    drop constraint if exists collectionentries_unique_key;

alter table users.collectionentries
    add constraint collectionentries_unique_key
        unique (collection_id, item_id);
