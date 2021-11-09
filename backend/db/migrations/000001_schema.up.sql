
SET check_function_bodies = false;
-- ddl-end --

-- object: user_data | type: SCHEMA --
-- DROP SCHEMA IF EXISTS user_data CASCADE;
CREATE SCHEMA user_data;
-- ddl-end --
ALTER SCHEMA user_data OWNER TO postgres;
-- ddl-end --

SET search_path TO pg_catalog,public,user_data;
-- ddl-end --