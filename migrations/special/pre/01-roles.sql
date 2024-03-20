-- Create roles and grant permissions in the DB

-- Needed so the migrations run
CREATE ROLE manager;
CREATE ROLE directus;
CREATE ROLE api;
CREATE ROLE background_worker;
CREATE ROLE builder;
CREATE ROLE onsite_backup;

CREATE ROLE staging_sync;

-- Stuff should be owned by manager
GRANT manager TO bccm;

-- Otherwise DU cant manage the DB
GRANT manager TO directus;
GRANT manager TO builder;
