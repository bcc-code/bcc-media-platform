-- +goose Up

-- +goose StatementBegin
CREATE OR REPLACE FUNCTION update_view(view character varying) returns boolean
    security definer
    language plpgsql
as
$$
BEGIN
    CASE
        WHEN view = 'filter_dataset' THEN
            REFRESH MATERIALIZED VIEW CONCURRENTLY filter_dataset;
        WHEN view = 'episode_availability' THEN
            REFRESH MATERIALIZED VIEW CONCURRENTLY episode_availability;
        WHEN view = 'season_availability' THEN
            REFRESH MATERIALIZED VIEW CONCURRENTLY season_availability;
        WHEN view = 'show_availability' THEN
            REFRESH MATERIALIZED VIEW CONCURRENTLY show_availability;
        ELSE
            RAISE EXCEPTION 'Invalid view';
        END CASE;
    INSERT INTO materialized_views_meta (last_refreshed, view_name)
    VALUES (NOW(), view)
    ON CONFLICT(view_name) DO UPDATE set last_refreshed = now();
    RETURN true;
END
$$;
-- +goose StatementEnd

grant execute on function update_view(varchar) to api;
grant execute on function update_view(varchar) to directus;

-- +goose Down

-- +goose StatementBegin
create function update_view(view character varying) returns boolean
    security definer
    language plpgsql
as
$$
BEGIN
    CASE
        WHEN view = 'filter_dataset' THEN
            REFRESH MATERIALIZED VIEW CONCURRENTLY filter_dataset;
        ELSE
            RAISE EXCEPTION 'Invalid view';
        END CASE;
    INSERT INTO materialized_views_meta (last_refreshed, view_name)
    VALUES (NOW(), view)
    ON CONFLICT(view_name) DO UPDATE set last_refreshed = now();
    RETURN true;
END
$$;
-- +goose StatementEnd

grant execute on function update_view(varchar) to api;
grant execute on function update_view(varchar) to directus;
