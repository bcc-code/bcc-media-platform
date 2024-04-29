-- +goose Up


-- +goose StatementBegin
CREATE OR REPLACE FUNCTION update_primary_episode() RETURNS TRIGGER AS $$
BEGIN
    IF (SELECT primary_episode_id FROM mediaitems WHERE id = NEW.mediaitem_id) IS NULL THEN
        UPDATE mediaitems SET primary_episode_id = NEW.id WHERE id = NEW.mediaitem_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
-- +goose StatementEnd

CREATE TRIGGER set_primary_episode
AFTER INSERT ON episodes
FOR EACH ROW
EXECUTE FUNCTION update_primary_episode();


-- +goose Down

DROP TRIGGER IF EXISTS set_primary_episode ON episodes;
DROP FUNCTION IF EXISTS update_primary_episode();