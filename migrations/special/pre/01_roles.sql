-- +goose Up
-- Create roles and grant permissions in the DB

-- Needed so the migrations run
CREATE ROLE manager;
CREATE ROLE directus;
CREATE ROLE api;
CREATE ROLE background_worker;
CREATE ROLE builder;
CREATE ROLE onsite_backup;

CREATE ROLE bccm;

CREATE ROLE staging_sync;

GRANT manager TO current_user;

-- Stuff should be owned by manager
GRANT manager TO bccm;

-- Otherwise DU cant manage the DB
GRANT manager TO directus;
GRANT manager TO builder;


CREATE ROLE pgtdbuser WITH LOGIN PASSWORD 'pgtdbpass' SUPERUSER;
GRANT manager TO pgtdbuser;
