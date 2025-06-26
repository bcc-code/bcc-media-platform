-- +goose Up
-- Propagate new show tags to all seasons, and new season tags to all episodes

-- Function: propagate_show_tags_to_seasons
-- +goose StatementBegin
CREATE OR REPLACE FUNCTION propagate_show_tags_to_seasons() RETURNS trigger AS $$
BEGIN
    IF (TG_OP = 'INSERT') OR (TG_OP = 'UPDATE' AND (NEW.tags_id IS DISTINCT FROM OLD.tags_id)) THEN
        -- Propagate addition
        INSERT INTO seasons_tags (seasons_id, tags_id, date_updated)
        SELECT s.id, NEW.tags_id, now()
        FROM seasons s
        WHERE s.show_id = NEW.shows_id
          AND NOT EXISTS (
                SELECT 1 FROM seasons_tags st
                WHERE st.seasons_id = s.id AND st.tags_id = NEW.tags_id
            );
    ELSIF (TG_OP = 'DELETE') THEN
        -- Propagate removal
        DELETE FROM seasons_tags st
        USING seasons s
        WHERE s.id = st.seasons_id
          AND s.show_id = OLD.shows_id
          AND st.tags_id = OLD.tags_id;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;
-- +goose StatementEnd

-- Function: propagate_season_tags_to_episodes
-- +goose StatementBegin
CREATE OR REPLACE FUNCTION propagate_season_tags_to_episodes() RETURNS trigger AS $$
BEGIN
    IF (TG_OP = 'INSERT') OR (TG_OP = 'UPDATE' AND (NEW.tags_id IS DISTINCT FROM OLD.tags_id)) THEN
        -- Propagate addition
        INSERT INTO episodes_tags (episodes_id, tags_id, date_updated)
        SELECT e.id, NEW.tags_id, now()
        FROM episodes e
        WHERE e.season_id = NEW.seasons_id
          AND NOT EXISTS (
                SELECT 1 FROM episodes_tags et
                WHERE et.episodes_id = e.id AND et.tags_id = NEW.tags_id
            );
    ELSIF (TG_OP = 'DELETE') THEN
        -- Propagate removal
        DELETE FROM episodes_tags et
        USING episodes e
        WHERE e.id = et.episodes_id
          AND e.season_id = OLD.seasons_id
          AND et.tags_id = OLD.tags_id;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;
-- +goose StatementEnd

-- Triggers
DROP TRIGGER IF EXISTS trg_propagate_show_tags_to_seasons ON shows_tags;
CREATE TRIGGER trg_propagate_show_tags_to_seasons
AFTER INSERT OR UPDATE OR DELETE ON shows_tags
FOR EACH ROW EXECUTE FUNCTION propagate_show_tags_to_seasons();

DROP TRIGGER IF EXISTS trg_propagate_season_tags_to_episodes ON seasons_tags;
CREATE TRIGGER trg_propagate_season_tags_to_episodes
AFTER INSERT OR UPDATE OR DELETE ON seasons_tags
FOR EACH ROW EXECUTE FUNCTION propagate_season_tags_to_episodes();

-- +goose Down
DROP TRIGGER IF EXISTS trg_propagate_show_tags_to_seasons ON shows_tags;
DROP FUNCTION IF EXISTS propagate_show_tags_to_seasons;

DROP TRIGGER IF EXISTS trg_propagate_season_tags_to_episodes ON seasons_tags;
DROP FUNCTION IF EXISTS propagate_season_tags_to_episodes;
