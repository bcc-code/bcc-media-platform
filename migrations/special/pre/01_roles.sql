-- +goose Up
-- Create roles and grant permissions in the DB.
-- Idempotent: each CREATE ROLE is wrapped in a DO block that swallows
-- duplicate_object errors so this script can be re-run safely.

DO $$ BEGIN CREATE ROLE manager; EXCEPTION WHEN duplicate_object THEN NULL; END $$;
DO $$ BEGIN CREATE ROLE directus; EXCEPTION WHEN duplicate_object THEN NULL; END $$;
DO $$ BEGIN CREATE ROLE api; EXCEPTION WHEN duplicate_object THEN NULL; END $$;
DO $$ BEGIN CREATE ROLE background_worker; EXCEPTION WHEN duplicate_object THEN NULL; END $$;
DO $$ BEGIN CREATE ROLE builder; EXCEPTION WHEN duplicate_object THEN NULL; END $$;
DO $$ BEGIN CREATE ROLE onsite_backup; EXCEPTION WHEN duplicate_object THEN NULL; END $$;
DO $$ BEGIN CREATE ROLE bccm; EXCEPTION WHEN duplicate_object THEN NULL; END $$;
DO $$ BEGIN CREATE ROLE staging_sync; EXCEPTION WHEN duplicate_object THEN NULL; END $$;
DO $$ BEGIN CREATE ROLE pgtdbuser WITH LOGIN PASSWORD 'pgtdbpass' SUPERUSER; EXCEPTION WHEN duplicate_object THEN NULL; END $$;

-- GRANTs are inherently idempotent (re-granting the same membership is a no-op).
GRANT manager TO current_user;
GRANT manager TO bccm;
GRANT manager TO directus;
GRANT manager TO builder;
GRANT manager TO pgtdbuser;
