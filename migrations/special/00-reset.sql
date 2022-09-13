DROP DATABASE IF EXISTS btv;

-- Needed so the migrations run
CREATE ROLE manager;
CREATE ROLE directus;
CREATE ROLE api;
CREATE ROLE background_worker;
CREATE ROLE builder;

-- Stuff should be owned by manager
GRANT manager TO btv;

-- Otherwise DU cant manage the DB
GRANT manager TO directus;
GRANT manager TO builder;

-- Create DB with correct owner
CREATE DATABASE btv WITH OWNER = manager ENCODING = 'UTF8' CONNECTION LIMIT = -1 IS_TEMPLATE = False;
