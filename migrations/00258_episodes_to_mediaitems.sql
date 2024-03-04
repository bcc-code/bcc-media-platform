-- +goose Up

INSERT INTO mediaitems (id, user_created, user_updated, date_updated, date_created, title, description, asset_id, label,
                        published_at, type)
SELECT uuid, user_created, user_updated, date_updated, date_created, ts.title, ts.description, asset_id, label,
       publish_date, 'video'
FROM episodes
    LEFT JOIN episodes_translations ts ON ts.episodes_id = episodes.id AND ts.languages_code = 'no';

-- +goose Down

DELETE FROM mediaitems WHERE id IN (SELECT uuid FROM episodes);

