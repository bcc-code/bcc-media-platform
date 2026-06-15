-- +goose Up

-- last_sent was a plain `timestamp` (without time zone) while ShouldSendTranslations
-- compares it against NOW() (timestamptz). Under a non-UTC database session timezone
-- that comparison is offset, which made the 30-minute dedup window behave differently
-- in prod than locally. Store it as timestamptz so the comparison is unambiguous.
ALTER TABLE translations_hash
    ALTER COLUMN last_sent TYPE timestamptz USING last_sent AT TIME ZONE 'UTC';

-- +goose Down

ALTER TABLE translations_hash
    ALTER COLUMN last_sent TYPE timestamp USING last_sent AT TIME ZONE 'UTC';
