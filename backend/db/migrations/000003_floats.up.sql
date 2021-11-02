-- Diff code generated with pgModeler (PostgreSQL Database Modeler)
-- pgModeler version: 0.9.4-beta
-- Diff date: 2021-10-27 09:38:48
-- Source model: vod
-- Database: vod
-- PostgreSQL version: 13.0

-- [ Diff summary ]
-- Dropped objects: 0
-- Created objects: 0
-- Changed objects: 2

SET check_function_bodies = false;
-- ddl-end --

SET search_path=public,pg_catalog,user_data;
-- ddl-end --


-- [ Changed objects ] --
ALTER TABLE public.media ALTER COLUMN start_time TYPE real;
-- ddl-end --
ALTER TABLE public.media ALTER COLUMN end_time TYPE real;
-- ddl-end --
