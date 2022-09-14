-- +goose Up

UPDATE "public"."directus_fields" SET "options" = '{"choices":[{"text":"HLS CMAF","value":"hls_cmaf"},{"text":"Dash","value":"dash"},{"text":"HLS TS","value":"hls_ts"}]}' WHERE "id" = 50;

UPDATE public."assetstreams" SET type = REPLACE(type, '-',  '_');

-- +goose Down

UPDATE public."assetstreams" SET type = REPLACE(type, '_',  '-');

UPDATE "public"."directus_fields" SET "options" = '{"choices":[{"text":"hls-cmaf","value":"hls-cmaf"},{"text":"dash","value":"dash"},{"text":"hls-ts","value":"hls-ts"}]}' WHERE "id" = 50;
