-- +goose Up

-- Add new UUID column as the primary key
ALTER TABLE users.devices ADD COLUMN id UUID DEFAULT gen_random_uuid();
UPDATE users.devices SET id = gen_random_uuid() WHERE id IS NULL;
ALTER TABLE users.devices ALTER COLUMN id SET NOT NULL;
ALTER TABLE users.devices DROP CONSTRAINT devices_pk;
ALTER TABLE users.devices ADD CONSTRAINT devices_pk PRIMARY KEY (id);

-- Add application_group_id column and back
ALTER TABLE users.devices ADD application_group_id uuid;
UPDATE users.devices dev SET application_group_id = pr.applicationgroup_id FROM users.profiles pr WHERE pr.id = dev.profile_id;
ALTER table users.devices ALTER COLUMN application_group_id SET NOT NULL;

-- Remove duplicates
DELETE FROM users.devices
WHERE id IN (
    SELECT id
    FROM (
             SELECT
                 id,
                 ROW_NUMBER() OVER (
                     PARTITION BY token, application_group_id
                     ORDER BY updated_at DESC, id DESC
                     ) AS rn,
                 COUNT(*) OVER (PARTITION BY token, application_group_id) AS cnt
             FROM users.devices
         ) t
    WHERE t.rn > 1 AND t.cnt > 1
);

-- Allow NULL profile_ids
ALTER TABLE users.devices
    ALTER COLUMN profile_id
        DROP NOT NULL;

-- Prevent duplicates
CREATE UNIQUE INDEX IF NOT EXISTS users_devices_token_appgroup_uidx
    ON users.devices (token, application_group_id);

-- Search index on (token)
CREATE INDEX IF NOT EXISTS users_devices_token_idx
    ON users.devices (token);

-- Search index on (profile_id, application_group_id)
CREATE INDEX IF NOT EXISTS users_devices_profile_appgroup_idx
    ON users.devices (profile_id, application_group_id);

-- Search index on (profile_id)
CREATE INDEX IF NOT EXISTS users_devices_profile_idx
    ON users.devices (profile_id);

-- +goose Down

-- Drop search indexes
DROP INDEX IF EXISTS users_devices_profile_idx;
DROP INDEX IF EXISTS users_devices_profile_appgroup_idx;
DROP INDEX IF EXISTS users_devices_token_idx;
DROP INDEX IF EXISTS users_devices_token_appgroup_uidx;

-- Restore NOT NULL constraint on profile_id
ALTER TABLE users.devices
    ALTER COLUMN profile_id SET NOT NULL;

-- Remove application_group_id column
ALTER TABLE users.devices DROP COLUMN IF EXISTS application_group_id;

-- Drop new UUID primary key and restore old primary key
ALTER TABLE users.devices DROP CONSTRAINT IF EXISTS devices_pk;
ALTER TABLE users.devices DROP COLUMN IF EXISTS id;
ALTER TABLE users.devices ADD CONSTRAINT devices_pk PRIMARY KEY (token, profile_id);
