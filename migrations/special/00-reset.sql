DROP DATABASE IF EXISTS bccm;

-- Needed so the migrations run
CREATE ROLE manager;
CREATE ROLE directus;
CREATE ROLE api;
CREATE ROLE background_worker;
CREATE ROLE builder;

-- Stuff should be owned by manager
GRANT manager TO bccm;

-- Otherwise DU cant manage the DB
GRANT manager TO directus;
GRANT manager TO builder;

-- Create DB with correct owner
CREATE DATABASE bccm WITH OWNER = manager ENCODING = 'UTF8' CONNECTION LIMIT = -1 IS_TEMPLATE = False;
