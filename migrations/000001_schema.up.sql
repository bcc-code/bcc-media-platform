--
-- PostgreSQL database dump
--

-- Dumped from database version 13.7 (Debian 13.7-1.pgdg110+1)
-- Dumped by pg_dump version 14.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: update_access(character varying); Type: FUNCTION; Schema: public; Owner: btv
--

CREATE FUNCTION public.update_access(view character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
    lr timestamptz;
BEGIN
    SELECT last_refreshed INTO lr FROM materialized_views_meta WHERE view_name = view;
    IF (
            lr IS NULL OR
            (SELECT MAX(date_updated) FROM shows) > lr OR
            (SELECT MAX(date_updated) FROM seasons) > lr OR
            (SELECT MAX(date_updated) FROM episodes) > lr OR
            (SELECT MAX(date_updated) FROM episodes_usergroups) > lr OR
            (SELECT MAX(date_updated) FROM episodes_usergroups_download) > lr OR
            (SELECT MAX(date_updated) FROM episodes_usergroups_earlyaccess) > (lr)) THEN
        RAISE NOTICE 'Refreshing view';
        CASE
            WHEN view = 'episodes_access' THEN
                REFRESH MATERIALIZED VIEW CONCURRENTLY episodes_access;
            WHEN view = 'seasons_access' THEN
                REFRESH MATERIALIZED VIEW CONCURRENTLY seasons_access;
            WHEN view = 'shows_access' THEN
                REFRESH MATERIALIZED VIEW CONCURRENTLY shows_access;
            ELSE
                RAISE EXCEPTION 'Invalid view';
        END CASE;
        INSERT INTO materialized_views_meta (last_refreshed, view_name)
        VALUES (NOW(), view)
        ON CONFLICT(view_name) DO UPDATE set last_refreshed = now();
        RETURN true;
    END IF;
    RETURN false;
END
$$;


ALTER FUNCTION public.update_access(view character varying) OWNER TO btv;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: ageratings; Type: TABLE; Schema: public; Owner: btv
--

CREATE TABLE public.ageratings (
    code character varying(255) DEFAULT NULL::character varying NOT NULL,
    date_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    date_updated timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    sort integer,
    title character varying(255) DEFAULT NULL::character varying
);


ALTER TABLE public.ageratings OWNER TO btv;

--
-- Name: ageratings_translations; Type: TABLE; Schema: public; Owner: btv
--

CREATE TABLE public.ageratings_translations (
    ageratings_code character varying(255) DEFAULT NULL::character varying NOT NULL,
    description character varying(255) DEFAULT NULL::character varying,
    id integer NOT NULL,
    languages_code character varying(255) DEFAULT NULL::character varying NOT NULL
);


ALTER TABLE public.ageratings_translations OWNER TO btv;

--
-- Name: ageratings_translations_id_seq; Type: SEQUENCE; Schema: public; Owner: btv
--

CREATE SEQUENCE public.ageratings_translations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ageratings_translations_id_seq OWNER TO btv;

--
-- Name: ageratings_translations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: btv
--

ALTER SEQUENCE public.ageratings_translations_id_seq OWNED BY public.ageratings_translations.id;


--
-- Name: assetfiles; Type: TABLE; Schema: public; Owner: btv
--

CREATE TABLE public.assetfiles (
    asset_id integer NOT NULL,
    audio_language_id character varying(255) DEFAULT NULL::character varying,
    date_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    date_updated timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    extra_metadata json,
    id integer NOT NULL,
    mime_type character varying(255) DEFAULT NULL::character varying NOT NULL,
    path character varying(255) DEFAULT NULL::character varying NOT NULL,
    storage character varying(255) DEFAULT NULL::character varying NOT NULL,
    subtitle_language_id character varying(255) DEFAULT NULL::character varying,
    type character varying(255) DEFAULT NULL::character varying NOT NULL,
    user_created uuid,
    user_updated uuid
);


ALTER TABLE public.assetfiles OWNER TO btv;

--
-- Name: assetfiles_id_seq; Type: SEQUENCE; Schema: public; Owner: btv
--

CREATE SEQUENCE public.assetfiles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.assetfiles_id_seq OWNER TO btv;

--
-- Name: assetfiles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: btv
--

ALTER SEQUENCE public.assetfiles_id_seq OWNED BY public.assetfiles.id;


--
-- Name: assets; Type: TABLE; Schema: public; Owner: btv
--

CREATE TABLE public.assets (
    date_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    date_updated timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    duration integer NOT NULL,
    encoding_version character varying(255) DEFAULT NULL::character varying,
    id integer NOT NULL,
    legacy_id integer,
    main_storage_path text,
    mediabanken_id character varying(255) DEFAULT NULL::character varying,
    name character varying(255) DEFAULT NULL::character varying NOT NULL,
    status character varying(255) DEFAULT 'draft'::character varying,
    user_created uuid,
    user_updated uuid
);


ALTER TABLE public.assets OWNER TO btv;

--
-- Name: assets_id_seq; Type: SEQUENCE; Schema: public; Owner: btv
--

CREATE SEQUENCE public.assets_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.assets_id_seq OWNER TO btv;

--
-- Name: assets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: btv
--

ALTER SEQUENCE public.assets_id_seq OWNED BY public.assets.id;


--
-- Name: assetstreams; Type: TABLE; Schema: public; Owner: btv
--

CREATE TABLE public.assetstreams (
    asset_id integer NOT NULL,
    date_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    date_updated timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    encryption_key_id character varying(255) DEFAULT NULL::character varying,
    extra_metadata json,
    id integer NOT NULL,
    legacy_videourl_id integer,
    path character varying(255) DEFAULT NULL::character varying NOT NULL,
    service character varying(255) DEFAULT NULL::character varying NOT NULL,
    status character varying(255) DEFAULT 'draft'::character varying NOT NULL,
    type character varying(255) DEFAULT NULL::character varying NOT NULL,
    url character varying(255) DEFAULT NULL::character varying NOT NULL,
    user_created uuid,
    user_updated uuid
);


ALTER TABLE public.assetstreams OWNER TO btv;

--
-- Name: assetstreams_audio_languages; Type: TABLE; Schema: public; Owner: btv
--

CREATE TABLE public.assetstreams_audio_languages (
    assetstreams_id integer,
    id integer NOT NULL,
    languages_code character varying(255) DEFAULT NULL::character varying
);


ALTER TABLE public.assetstreams_audio_languages OWNER TO btv;

--
-- Name: assetstreams_audio_languages_id_seq; Type: SEQUENCE; Schema: public; Owner: btv
--

CREATE SEQUENCE public.assetstreams_audio_languages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.assetstreams_audio_languages_id_seq OWNER TO btv;

--
-- Name: assetstreams_audio_languages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: btv
--

ALTER SEQUENCE public.assetstreams_audio_languages_id_seq OWNED BY public.assetstreams_audio_languages.id;


--
-- Name: assetstreams_id_seq; Type: SEQUENCE; Schema: public; Owner: btv
--

CREATE SEQUENCE public.assetstreams_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.assetstreams_id_seq OWNER TO btv;

--
-- Name: assetstreams_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: btv
--

ALTER SEQUENCE public.assetstreams_id_seq OWNED BY public.assetstreams.id;


--
-- Name: assetstreams_subtitle_languages; Type: TABLE; Schema: public; Owner: btv
--

CREATE TABLE public.assetstreams_subtitle_languages (
    assetstreams_id integer,
    id integer NOT NULL,
    languages_code character varying(255) DEFAULT NULL::character varying
);


ALTER TABLE public.assetstreams_subtitle_languages OWNER TO btv;

--
-- Name: assetstreams_subtitle_languages_id_seq; Type: SEQUENCE; Schema: public; Owner: btv
--

CREATE SEQUENCE public.assetstreams_subtitle_languages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.assetstreams_subtitle_languages_id_seq OWNER TO btv;

--
-- Name: assetstreams_subtitle_languages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: btv
--

ALTER SEQUENCE public.assetstreams_subtitle_languages_id_seq OWNED BY public.assetstreams_subtitle_languages.id;


--
-- Name: calendarevent; Type: TABLE; Schema: public; Owner: btv
--

CREATE TABLE public.calendarevent (
    date_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    date_updated timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "end" timestamp without time zone,
    id integer NOT NULL,
    start timestamp without time zone NOT NULL,
    status character varying(255) DEFAULT 'draft'::character varying NOT NULL,
    title character varying(255) DEFAULT NULL::character varying,
    user_created uuid,
    user_updated uuid
);


ALTER TABLE public.calendarevent OWNER TO btv;

--
-- Name: calendarevent_id_seq; Type: SEQUENCE; Schema: public; Owner: btv
--

CREATE SEQUENCE public.calendarevent_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.calendarevent_id_seq OWNER TO btv;

--
-- Name: calendarevent_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: btv
--

ALTER SEQUENCE public.calendarevent_id_seq OWNED BY public.calendarevent.id;


--
-- Name: categories; Type: TABLE; Schema: public; Owner: btv
--

CREATE TABLE public.categories (
    appear_in_search boolean DEFAULT false,
    date_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    date_updated timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    id integer NOT NULL,
    legacy_id integer,
    parent_id integer,
    sort integer,
    user_created uuid,
    user_updated uuid
);


ALTER TABLE public.categories OWNER TO btv;

--
-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: btv
--

CREATE SEQUENCE public.categories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.categories_id_seq OWNER TO btv;

--
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: btv
--

ALTER SEQUENCE public.categories_id_seq OWNED BY public.categories.id;


--
-- Name: categories_translations; Type: TABLE; Schema: public; Owner: btv
--

CREATE TABLE public.categories_translations (
    categories_id integer NOT NULL,
    id integer NOT NULL,
    languages_code character varying(255) DEFAULT NULL::character varying NOT NULL,
    name character varying(255) DEFAULT NULL::character varying NOT NULL
);


ALTER TABLE public.categories_translations OWNER TO btv;

--
-- Name: categories_translations_id_seq; Type: SEQUENCE; Schema: public; Owner: btv
--

CREATE SEQUENCE public.categories_translations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.categories_translations_id_seq OWNER TO btv;

--
-- Name: categories_translations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: btv
--

ALTER SEQUENCE public.categories_translations_id_seq OWNED BY public.categories_translations.id;


--
-- Name: collections; Type: TABLE; Schema: public; Owner: btv
--

CREATE TABLE public.collections (
    date_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    date_updated timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    id integer NOT NULL,
    sort integer,
    user_created uuid,
    user_updated uuid,
    collection character varying(255) DEFAULT 'shows'::character varying,
    shows_query_filter json,
    seasons_query_filter json,
    episodes_query_filter json,
    name character varying(255)
);


ALTER TABLE public.collections OWNER TO btv;

--
-- Name: collections_episodes; Type: TABLE; Schema: public; Owner: btv
--

CREATE TABLE public.collections_episodes (
    collections_id integer,
    episodes_id integer,
    id integer NOT NULL,
    sort integer
);


ALTER TABLE public.collections_episodes OWNER TO btv;

--
-- Name: collections_episodes_id_seq; Type: SEQUENCE; Schema: public; Owner: btv
--

CREATE SEQUENCE public.collections_episodes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.collections_episodes_id_seq OWNER TO btv;

--
-- Name: collections_episodes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: btv
--

ALTER SEQUENCE public.collections_episodes_id_seq OWNED BY public.collections_episodes.id;


--
-- Name: collections_id_seq; Type: SEQUENCE; Schema: public; Owner: btv
--

CREATE SEQUENCE public.collections_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.collections_id_seq OWNER TO btv;

--
-- Name: collections_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: btv
--

ALTER SEQUENCE public.collections_id_seq OWNED BY public.collections.id;


--
-- Name: collections_relations; Type: TABLE; Schema: public; Owner: btv
--

CREATE TABLE public.collections_relations (
    collection character varying(255) DEFAULT NULL::character varying,
    collections_id integer,
    id integer NOT NULL,
    item character varying(255) DEFAULT NULL::character varying
);


ALTER TABLE public.collections_relations OWNER TO btv;

--
-- Name: collections_relations_id_seq; Type: SEQUENCE; Schema: public; Owner: btv
--

CREATE SEQUENCE public.collections_relations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.collections_relations_id_seq OWNER TO btv;

--
-- Name: collections_relations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: btv
--

ALTER SEQUENCE public.collections_relations_id_seq OWNED BY public.collections_relations.id;


--
-- Name: collections_seasons; Type: TABLE; Schema: public; Owner: btv
--

CREATE TABLE public.collections_seasons (
    collections_id integer,
    id integer NOT NULL,
    seasons_id integer
);


ALTER TABLE public.collections_seasons OWNER TO btv;

--
-- Name: collections_seasons_id_seq; Type: SEQUENCE; Schema: public; Owner: btv
--

CREATE SEQUENCE public.collections_seasons_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.collections_seasons_id_seq OWNER TO btv;

--
-- Name: collections_seasons_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: btv
--

ALTER SEQUENCE public.collections_seasons_id_seq OWNED BY public.collections_seasons.id;


--
-- Name: collections_shows; Type: TABLE; Schema: public; Owner: btv
--

CREATE TABLE public.collections_shows (
    collections_id integer,
    id integer NOT NULL,
    shows_id integer
);


ALTER TABLE public.collections_shows OWNER TO btv;

--
-- Name: collections_shows_id_seq; Type: SEQUENCE; Schema: public; Owner: btv
--

CREATE SEQUENCE public.collections_shows_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.collections_shows_id_seq OWNER TO btv;

--
-- Name: collections_shows_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: btv
--

ALTER SEQUENCE public.collections_shows_id_seq OWNED BY public.collections_shows.id;


--
-- Name: collections_translations; Type: TABLE; Schema: public; Owner: btv
--

CREATE TABLE public.collections_translations (
    collections_id integer NOT NULL,
    id integer NOT NULL,
    languages_code character varying(255) DEFAULT NULL::character varying NOT NULL,
    title character varying(255) DEFAULT NULL::character varying
);


ALTER TABLE public.collections_translations OWNER TO btv;

--
-- Name: collections_translations_id_seq; Type: SEQUENCE; Schema: public; Owner: btv
--

CREATE SEQUENCE public.collections_translations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.collections_translations_id_seq OWNER TO btv;

--
-- Name: collections_translations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: btv
--

ALTER SEQUENCE public.collections_translations_id_seq OWNED BY public.collections_translations.id;


--
-- Name: directus_activity; Type: TABLE; Schema: public; Owner: btv
--

CREATE TABLE public.directus_activity (
    id integer NOT NULL,
    action character varying(45) NOT NULL,
    "user" uuid,
    "timestamp" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    ip character varying(50),
    user_agent character varying(255),
    collection character varying(64) NOT NULL,
    item character varying(255) NOT NULL,
    comment text
);


ALTER TABLE public.directus_activity OWNER TO btv;

--
-- Name: directus_activity_id_seq; Type: SEQUENCE; Schema: public; Owner: btv
--

CREATE SEQUENCE public.directus_activity_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.directus_activity_id_seq OWNER TO btv;

--
-- Name: directus_activity_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: btv
--

ALTER SEQUENCE public.directus_activity_id_seq OWNED BY public.directus_activity.id;


--
-- Name: directus_collections; Type: TABLE; Schema: public; Owner: btv
--

CREATE TABLE public.directus_collections (
    collection character varying(64) NOT NULL,
    icon character varying(30),
    note text,
    display_template character varying(255),
    hidden boolean DEFAULT false NOT NULL,
    singleton boolean DEFAULT false NOT NULL,
    translations json,
    archive_field character varying(64),
    archive_app_filter boolean DEFAULT true NOT NULL,
    archive_value character varying(255),
    unarchive_value character varying(255),
    sort_field character varying(64),
    accountability character varying(255) DEFAULT 'all'::character varying,
    color character varying(255),
    item_duplication_fields json,
    sort integer,
    "group" character varying(64),
    collapse character varying(255) DEFAULT 'open'::character varying NOT NULL
);


ALTER TABLE public.directus_collections OWNER TO btv;

--
-- Name: directus_dashboards; Type: TABLE; Schema: public; Owner: btv
--

CREATE TABLE public.directus_dashboards (
    id uuid NOT NULL,
    name character varying(255) NOT NULL,
    icon character varying(30) DEFAULT 'dashboard'::character varying NOT NULL,
    note text,
    date_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    user_created uuid
);


ALTER TABLE public.directus_dashboards OWNER TO btv;

--
-- Name: directus_fields; Type: TABLE; Schema: public; Owner: btv
--

CREATE TABLE public.directus_fields (
    id integer NOT NULL,
    collection character varying(64) NOT NULL,
    field character varying(64) NOT NULL,
    special character varying(64),
    interface character varying(64),
    options json,
    display character varying(64),
    display_options json,
    readonly boolean DEFAULT false NOT NULL,
    hidden boolean DEFAULT false NOT NULL,
    sort integer,
    width character varying(30) DEFAULT 'full'::character varying,
    translations json,
    note text,
    conditions json,
    required boolean DEFAULT false,
    "group" character varying(64),
    validation json,
    validation_message text
);


ALTER TABLE public.directus_fields OWNER TO btv;

--
-- Name: directus_fields_id_seq; Type: SEQUENCE; Schema: public; Owner: btv
--

CREATE SEQUENCE public.directus_fields_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.directus_fields_id_seq OWNER TO btv;

--
-- Name: directus_fields_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: btv
--

ALTER SEQUENCE public.directus_fields_id_seq OWNED BY public.directus_fields.id;


--
-- Name: directus_files; Type: TABLE; Schema: public; Owner: btv
--

CREATE TABLE public.directus_files (
    id uuid NOT NULL,
    storage character varying(255) NOT NULL,
    filename_disk character varying(255),
    filename_download character varying(255) NOT NULL,
    title character varying(255),
    type character varying(255),
    folder uuid,
    uploaded_by uuid,
    uploaded_on timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    modified_by uuid,
    modified_on timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    charset character varying(50),
    filesize bigint,
    width integer,
    height integer,
    duration integer,
    embed character varying(200),
    description text,
    location text,
    tags text,
    metadata json
);


ALTER TABLE public.directus_files OWNER TO btv;

--
-- Name: directus_flows; Type: TABLE; Schema: public; Owner: btv
--

CREATE TABLE public.directus_flows (
    id uuid NOT NULL,
    name character varying(255) NOT NULL,
    icon character varying(30),
    color character varying(255),
    description text,
    status character varying(255) DEFAULT 'active'::character varying NOT NULL,
    trigger character varying(255),
    accountability character varying(255) DEFAULT 'all'::character varying,
    options json,
    operation uuid,
    date_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    user_created uuid
);


ALTER TABLE public.directus_flows OWNER TO btv;

--
-- Name: directus_folders; Type: TABLE; Schema: public; Owner: btv
--

CREATE TABLE public.directus_folders (
    id uuid NOT NULL,
    name character varying(255) NOT NULL,
    parent uuid
);


ALTER TABLE public.directus_folders OWNER TO btv;

--
-- Name: directus_migrations; Type: TABLE; Schema: public; Owner: btv
--

CREATE TABLE public.directus_migrations (
    version character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    "timestamp" timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.directus_migrations OWNER TO btv;

--
-- Name: directus_notifications; Type: TABLE; Schema: public; Owner: btv
--

CREATE TABLE public.directus_notifications (
    id integer NOT NULL,
    "timestamp" timestamp with time zone NOT NULL,
    status character varying(255) DEFAULT 'inbox'::character varying,
    recipient uuid NOT NULL,
    sender uuid,
    subject character varying(255) NOT NULL,
    message text,
    collection character varying(64),
    item character varying(255)
);


ALTER TABLE public.directus_notifications OWNER TO btv;

--
-- Name: directus_notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: btv
--

CREATE SEQUENCE public.directus_notifications_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.directus_notifications_id_seq OWNER TO btv;

--
-- Name: directus_notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: btv
--

ALTER SEQUENCE public.directus_notifications_id_seq OWNED BY public.directus_notifications.id;


--
-- Name: directus_operations; Type: TABLE; Schema: public; Owner: btv
--

CREATE TABLE public.directus_operations (
    id uuid NOT NULL,
    name character varying(255),
    key character varying(255) NOT NULL,
    type character varying(255) NOT NULL,
    position_x integer NOT NULL,
    position_y integer NOT NULL,
    options json,
    resolve uuid,
    reject uuid,
    flow uuid NOT NULL,
    date_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    user_created uuid
);


ALTER TABLE public.directus_operations OWNER TO btv;

--
-- Name: directus_panels; Type: TABLE; Schema: public; Owner: btv
--

CREATE TABLE public.directus_panels (
    id uuid NOT NULL,
    dashboard uuid NOT NULL,
    name character varying(255),
    icon character varying(30) DEFAULT NULL::character varying,
    color character varying(10),
    show_header boolean DEFAULT false NOT NULL,
    note text,
    type character varying(255) NOT NULL,
    position_x integer NOT NULL,
    position_y integer NOT NULL,
    width integer NOT NULL,
    height integer NOT NULL,
    options json,
    date_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    user_created uuid
);


ALTER TABLE public.directus_panels OWNER TO btv;

--
-- Name: directus_permissions; Type: TABLE; Schema: public; Owner: btv
--

CREATE TABLE public.directus_permissions (
    id integer NOT NULL,
    role uuid,
    collection character varying(64) NOT NULL,
    action character varying(10) NOT NULL,
    permissions json,
    validation json,
    presets json,
    fields text
);


ALTER TABLE public.directus_permissions OWNER TO btv;

--
-- Name: directus_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: btv
--

CREATE SEQUENCE public.directus_permissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.directus_permissions_id_seq OWNER TO btv;

--
-- Name: directus_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: btv
--

ALTER SEQUENCE public.directus_permissions_id_seq OWNED BY public.directus_permissions.id;


--
-- Name: directus_presets; Type: TABLE; Schema: public; Owner: btv
--

CREATE TABLE public.directus_presets (
    id integer NOT NULL,
    bookmark character varying(255),
    "user" uuid,
    role uuid,
    collection character varying(64),
    search character varying(100),
    layout character varying(100) DEFAULT 'tabular'::character varying,
    layout_query json,
    layout_options json,
    refresh_interval integer,
    filter json,
    icon character varying(30) DEFAULT 'bookmark_outline'::character varying NOT NULL,
    color character varying(255)
);


ALTER TABLE public.directus_presets OWNER TO btv;

--
-- Name: directus_presets_id_seq; Type: SEQUENCE; Schema: public; Owner: btv
--

CREATE SEQUENCE public.directus_presets_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.directus_presets_id_seq OWNER TO btv;

--
-- Name: directus_presets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: btv
--

ALTER SEQUENCE public.directus_presets_id_seq OWNED BY public.directus_presets.id;


--
-- Name: directus_relations; Type: TABLE; Schema: public; Owner: btv
--

CREATE TABLE public.directus_relations (
    id integer NOT NULL,
    many_collection character varying(64) NOT NULL,
    many_field character varying(64) NOT NULL,
    one_collection character varying(64),
    one_field character varying(64),
    one_collection_field character varying(64),
    one_allowed_collections text,
    junction_field character varying(64),
    sort_field character varying(64),
    one_deselect_action character varying(255) DEFAULT 'nullify'::character varying NOT NULL
);


ALTER TABLE public.directus_relations OWNER TO btv;

--
-- Name: directus_relations_id_seq; Type: SEQUENCE; Schema: public; Owner: btv
--

CREATE SEQUENCE public.directus_relations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.directus_relations_id_seq OWNER TO btv;

--
-- Name: directus_relations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: btv
--

ALTER SEQUENCE public.directus_relations_id_seq OWNED BY public.directus_relations.id;


--
-- Name: directus_revisions; Type: TABLE; Schema: public; Owner: btv
--

CREATE TABLE public.directus_revisions (
    id integer NOT NULL,
    activity integer NOT NULL,
    collection character varying(64) NOT NULL,
    item character varying(255) NOT NULL,
    data json,
    delta json,
    parent integer
);


ALTER TABLE public.directus_revisions OWNER TO btv;

--
-- Name: directus_revisions_id_seq; Type: SEQUENCE; Schema: public; Owner: btv
--

CREATE SEQUENCE public.directus_revisions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.directus_revisions_id_seq OWNER TO btv;

--
-- Name: directus_revisions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: btv
--

ALTER SEQUENCE public.directus_revisions_id_seq OWNED BY public.directus_revisions.id;


--
-- Name: directus_roles; Type: TABLE; Schema: public; Owner: btv
--

CREATE TABLE public.directus_roles (
    id uuid NOT NULL,
    name character varying(100) NOT NULL,
    icon character varying(30) DEFAULT 'supervised_user_circle'::character varying NOT NULL,
    description text,
    ip_access text,
    enforce_tfa boolean DEFAULT false NOT NULL,
    admin_access boolean DEFAULT false NOT NULL,
    app_access boolean DEFAULT true NOT NULL
);


ALTER TABLE public.directus_roles OWNER TO btv;

--
-- Name: directus_sessions; Type: TABLE; Schema: public; Owner: btv
--

CREATE TABLE public.directus_sessions (
    token character varying(64) NOT NULL,
    "user" uuid,
    expires timestamp with time zone NOT NULL,
    ip character varying(255),
    user_agent character varying(255),
    share uuid
);


ALTER TABLE public.directus_sessions OWNER TO btv;

--
-- Name: directus_settings; Type: TABLE; Schema: public; Owner: btv
--

CREATE TABLE public.directus_settings (
    id integer NOT NULL,
    project_name character varying(100) DEFAULT 'Directus'::character varying NOT NULL,
    project_url character varying(255),
    project_color character varying(50) DEFAULT NULL::character varying,
    project_logo uuid,
    public_foreground uuid,
    public_background uuid,
    public_note text,
    auth_login_attempts integer DEFAULT 25,
    auth_password_policy character varying(100),
    storage_asset_transform character varying(7) DEFAULT 'all'::character varying,
    storage_asset_presets json,
    custom_css text,
    storage_default_folder uuid,
    basemaps json,
    mapbox_key character varying(255),
    module_bar json,
    project_descriptor character varying(100),
    translation_strings json,
    default_language character varying(255) DEFAULT 'en-US'::character varying NOT NULL
);


ALTER TABLE public.directus_settings OWNER TO btv;

--
-- Name: directus_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: btv
--

CREATE SEQUENCE public.directus_settings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.directus_settings_id_seq OWNER TO btv;

--
-- Name: directus_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: btv
--

ALTER SEQUENCE public.directus_settings_id_seq OWNED BY public.directus_settings.id;


--
-- Name: directus_shares; Type: TABLE; Schema: public; Owner: btv
--

CREATE TABLE public.directus_shares (
    id uuid NOT NULL,
    name character varying(255),
    collection character varying(64),
    item character varying(255),
    role uuid,
    password character varying(255),
    user_created uuid,
    date_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    date_start timestamp with time zone,
    date_end timestamp with time zone,
    times_used integer DEFAULT 0,
    max_uses integer
);


ALTER TABLE public.directus_shares OWNER TO btv;

--
-- Name: directus_users; Type: TABLE; Schema: public; Owner: btv
--

CREATE TABLE public.directus_users (
    id uuid NOT NULL,
    first_name character varying(50),
    last_name character varying(50),
    email character varying(128),
    password character varying(255),
    location character varying(255),
    title character varying(50),
    description text,
    tags json,
    avatar uuid,
    language character varying(255) DEFAULT NULL::character varying,
    theme character varying(20) DEFAULT 'auto'::character varying,
    tfa_secret character varying(255),
    status character varying(16) DEFAULT 'active'::character varying NOT NULL,
    role uuid,
    token character varying(255),
    last_access timestamp with time zone,
    last_page character varying(255),
    provider character varying(128) DEFAULT 'default'::character varying NOT NULL,
    external_identifier character varying(255),
    auth_data json,
    email_notifications boolean DEFAULT true
);


ALTER TABLE public.directus_users OWNER TO btv;

--
-- Name: directus_webhooks; Type: TABLE; Schema: public; Owner: btv
--

CREATE TABLE public.directus_webhooks (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    method character varying(10) DEFAULT 'POST'::character varying NOT NULL,
    url character varying(255) NOT NULL,
    status character varying(10) DEFAULT 'active'::character varying NOT NULL,
    data boolean DEFAULT true NOT NULL,
    actions character varying(100) NOT NULL,
    collections character varying(255) NOT NULL,
    headers json
);


ALTER TABLE public.directus_webhooks OWNER TO btv;

--
-- Name: directus_webhooks_id_seq; Type: SEQUENCE; Schema: public; Owner: btv
--

CREATE SEQUENCE public.directus_webhooks_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.directus_webhooks_id_seq OWNER TO btv;

--
-- Name: directus_webhooks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: btv
--

ALTER SEQUENCE public.directus_webhooks_id_seq OWNED BY public.directus_webhooks.id;


--
-- Name: episodes; Type: TABLE; Schema: public; Owner: btv
--

CREATE TABLE public.episodes (
    agerating_code character varying(255) DEFAULT NULL::character varying,
    asset_id integer,
    available_from timestamp without time zone,
    available_to timestamp without time zone,
    date_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    date_updated timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    episode_number integer,
    id integer NOT NULL,
    image_file_id uuid,
    legacy_description_id integer,
    legacy_extra_description_id integer,
    legacy_id integer,
    legacy_program_id integer,
    legacy_tags_id integer,
    legacy_title_id integer,
    migration_data json,
    publish_date timestamp without time zone NOT NULL,
    season_id integer,
    status character varying(255) DEFAULT 'draft'::character varying NOT NULL,
    type character varying(255) DEFAULT 'episode'::character varying NOT NULL,
    user_created uuid,
    user_updated uuid
);


ALTER TABLE public.episodes OWNER TO btv;

--
-- Name: seasons; Type: TABLE; Schema: public; Owner: btv
--

CREATE TABLE public.seasons (
    agerating_code character varying(255) DEFAULT NULL::character varying,
    available_from timestamp without time zone,
    available_to timestamp without time zone,
    date_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    date_updated timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    id integer NOT NULL,
    image_file_id uuid,
    legacy_description_id integer,
    legacy_id integer,
    legacy_title_id integer,
    publish_date timestamp without time zone NOT NULL,
    season_number integer NOT NULL,
    show_id integer NOT NULL,
    status character varying(255) DEFAULT 'draft'::character varying NOT NULL,
    user_created uuid,
    user_updated uuid
);


ALTER TABLE public.seasons OWNER TO btv;

--
-- Name: shows; Type: TABLE; Schema: public; Owner: btv
--

CREATE TABLE public.shows (
    agerating_code character varying(255) DEFAULT NULL::character varying,
    available_from timestamp without time zone,
    available_to timestamp without time zone,
    date_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    date_updated timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    id integer NOT NULL,
    image_file_id uuid,
    legacy_description_id integer,
    legacy_id integer,
    legacy_title_id integer,
    publish_date timestamp without time zone NOT NULL,
    status character varying(255) DEFAULT 'draft'::character varying NOT NULL,
    type character varying(255) DEFAULT NULL::character varying NOT NULL,
    user_created uuid,
    user_updated uuid
);


ALTER TABLE public.shows OWNER TO btv;

--
-- Name: episodes_availability; Type: VIEW; Schema: public; Owner: btv
--

CREATE VIEW public.episodes_availability AS
 SELECT e.id,
    (((e.status)::text = 'published'::text) AND ((se.status)::text = 'published'::text) AND ((s.status)::text = 'published'::text)) AS published,
    COALESCE(GREATEST(e.available_from, se.available_from, s.available_from), '1800-01-01 00:00:00'::timestamp without time zone) AS available_from,
    COALESCE(LEAST(e.available_to, se.available_to, s.available_to), '3000-01-01 00:00:00'::timestamp without time zone) AS available_to
   FROM ((public.episodes e
     LEFT JOIN public.seasons se ON ((e.season_id = se.id)))
     LEFT JOIN public.shows s ON ((se.show_id = s.id)));


ALTER TABLE public.episodes_availability OWNER TO btv;

--
-- Name: episodes_usergroups; Type: TABLE; Schema: public; Owner: btv
--

CREATE TABLE public.episodes_usergroups (
    episodes_id integer NOT NULL,
    id integer NOT NULL,
    type character varying(255) DEFAULT NULL::character varying,
    usergroups_code character varying(255) DEFAULT NULL::character varying NOT NULL,
    date_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    date_updated timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.episodes_usergroups OWNER TO btv;

--
-- Name: episodes_usergroups_download; Type: TABLE; Schema: public; Owner: btv
--

CREATE TABLE public.episodes_usergroups_download (
    episodes_id integer NOT NULL,
    id integer NOT NULL,
    usergroups_code character varying(255) DEFAULT NULL::character varying NOT NULL,
    date_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    date_updated timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.episodes_usergroups_download OWNER TO btv;

--
-- Name: episodes_usergroups_earlyaccess; Type: TABLE; Schema: public; Owner: btv
--

CREATE TABLE public.episodes_usergroups_earlyaccess (
    episodes_id integer NOT NULL,
    id integer NOT NULL,
    usergroups_code character varying(255) DEFAULT NULL::character varying NOT NULL,
    date_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    date_updated timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.episodes_usergroups_earlyaccess OWNER TO btv;

--
-- Name: episodes_roles; Type: VIEW; Schema: public; Owner: btv
--

CREATE VIEW public.episodes_roles AS
 SELECT e.id,
    COALESCE(( SELECT array_agg(DISTINCT eu.usergroups_code) AS code
           FROM public.episodes_usergroups eu
          WHERE (eu.episodes_id = e.id)), ARRAY[]::character varying[]) AS roles,
    COALESCE(( SELECT array_agg(DISTINCT eu.usergroups_code) AS code
           FROM public.episodes_usergroups_download eu
          WHERE (eu.episodes_id = e.id)), ARRAY[]::character varying[]) AS roles_download,
    COALESCE(( SELECT array_agg(DISTINCT eu.usergroups_code) AS code
           FROM public.episodes_usergroups_earlyaccess eu
          WHERE (eu.episodes_id = e.id)), ARRAY[]::character varying[]) AS roles_earlyaccess
   FROM public.episodes e;


ALTER TABLE public.episodes_roles OWNER TO btv;

--
-- Name: episodes_access_view; Type: VIEW; Schema: public; Owner: btv
--

CREATE VIEW public.episodes_access_view AS
 SELECT e.id,
    ea.published,
    ea.available_from,
    ea.available_to,
    roles.roles AS usergroups,
    roles.roles_download AS usergroups_downloads,
    roles.roles_earlyaccess AS usergroups_earlyaccess
   FROM ((public.episodes e
     LEFT JOIN public.episodes_availability ea ON ((ea.id = e.id)))
     LEFT JOIN public.episodes_roles roles ON ((roles.id = e.id)));


ALTER TABLE public.episodes_access_view OWNER TO btv;

--
-- Name: episodes_access; Type: MATERIALIZED VIEW; Schema: public; Owner: btv
--

CREATE MATERIALIZED VIEW public.episodes_access AS
 SELECT episodes_access_view.id,
    episodes_access_view.published,
    episodes_access_view.available_from,
    episodes_access_view.available_to,
    episodes_access_view.usergroups,
    episodes_access_view.usergroups_downloads,
    episodes_access_view.usergroups_earlyaccess
   FROM public.episodes_access_view
  WITH NO DATA;


ALTER TABLE public.episodes_access OWNER TO btv;

--
-- Name: episodes_categories; Type: TABLE; Schema: public; Owner: btv
--

CREATE TABLE public.episodes_categories (
    categories_id integer NOT NULL,
    episodes_id integer NOT NULL,
    id integer NOT NULL
);


ALTER TABLE public.episodes_categories OWNER TO btv;

--
-- Name: episodes_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: btv
--

CREATE SEQUENCE public.episodes_categories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.episodes_categories_id_seq OWNER TO btv;

--
-- Name: episodes_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: btv
--

ALTER SEQUENCE public.episodes_categories_id_seq OWNED BY public.episodes_categories.id;


--
-- Name: episodes_translations; Type: TABLE; Schema: public; Owner: btv
--

CREATE TABLE public.episodes_translations (
    description text,
    episodes_id integer NOT NULL,
    extra_description text,
    id integer NOT NULL,
    is_primary boolean DEFAULT true NOT NULL,
    languages_code character varying(255) DEFAULT NULL::character varying NOT NULL,
    title character varying(255) DEFAULT NULL::character varying
);


ALTER TABLE public.episodes_translations OWNER TO btv;

--
-- Name: episodes_expanded; Type: VIEW; Schema: public; Owner: btv
--

CREATE VIEW public.episodes_expanded AS
 WITH t AS (
         SELECT t_1.episodes_id,
            json_object_agg(t_1.languages_code, t_1.title) AS title,
            json_object_agg(t_1.languages_code, t_1.description) AS description,
            json_object_agg(t_1.languages_code, t_1.extra_description) AS extra_description
           FROM public.episodes_translations t_1
          GROUP BY t_1.episodes_id
        )
 SELECT e.id,
    e.asset_id,
    e.episode_number,
    e.image_file_id,
    e.season_id,
    e.type,
    t.title,
    t.description,
    t.extra_description,
    ea.published,
    (ea.available_from)::timestamp with time zone AS available_from,
    (ea.available_to)::timestamp with time zone AS available_to,
    (ea.usergroups)::text[] AS usergroups,
    (ea.usergroups_downloads)::text[] AS download_groups,
    (ea.usergroups_earlyaccess)::text[] AS early_access_groups
   FROM ((public.episodes e
     JOIN t ON ((e.id = t.episodes_id)))
     JOIN public.episodes_access ea ON ((ea.id = e.id)));


ALTER TABLE public.episodes_expanded OWNER TO btv;

--
-- Name: episodes_id_seq; Type: SEQUENCE; Schema: public; Owner: btv
--

CREATE SEQUENCE public.episodes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.episodes_id_seq OWNER TO btv;

--
-- Name: episodes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: btv
--

ALTER SEQUENCE public.episodes_id_seq OWNED BY public.episodes.id;


--
-- Name: episodes_tags; Type: TABLE; Schema: public; Owner: btv
--

CREATE TABLE public.episodes_tags (
    episodes_id integer NOT NULL,
    id integer NOT NULL,
    tags_id integer NOT NULL
);


ALTER TABLE public.episodes_tags OWNER TO btv;

--
-- Name: episodes_tags_id_seq; Type: SEQUENCE; Schema: public; Owner: btv
--

CREATE SEQUENCE public.episodes_tags_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.episodes_tags_id_seq OWNER TO btv;

--
-- Name: episodes_tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: btv
--

ALTER SEQUENCE public.episodes_tags_id_seq OWNED BY public.episodes_tags.id;


--
-- Name: episodes_translations_id_seq; Type: SEQUENCE; Schema: public; Owner: btv
--

CREATE SEQUENCE public.episodes_translations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.episodes_translations_id_seq OWNER TO btv;

--
-- Name: episodes_translations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: btv
--

ALTER SEQUENCE public.episodes_translations_id_seq OWNED BY public.episodes_translations.id;


--
-- Name: episodes_usergroups_download_id_seq; Type: SEQUENCE; Schema: public; Owner: btv
--

CREATE SEQUENCE public.episodes_usergroups_download_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.episodes_usergroups_download_id_seq OWNER TO btv;

--
-- Name: episodes_usergroups_download_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: btv
--

ALTER SEQUENCE public.episodes_usergroups_download_id_seq OWNED BY public.episodes_usergroups_download.id;


--
-- Name: episodes_usergroups_earlyaccess_id_seq; Type: SEQUENCE; Schema: public; Owner: btv
--

CREATE SEQUENCE public.episodes_usergroups_earlyaccess_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.episodes_usergroups_earlyaccess_id_seq OWNER TO btv;

--
-- Name: episodes_usergroups_earlyaccess_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: btv
--

ALTER SEQUENCE public.episodes_usergroups_earlyaccess_id_seq OWNED BY public.episodes_usergroups_earlyaccess.id;


--
-- Name: episodes_usergroups_id_seq; Type: SEQUENCE; Schema: public; Owner: btv
--

CREATE SEQUENCE public.episodes_usergroups_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.episodes_usergroups_id_seq OWNER TO btv;

--
-- Name: episodes_usergroups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: btv
--

ALTER SEQUENCE public.episodes_usergroups_id_seq OWNED BY public.episodes_usergroups.id;


--
-- Name: languages; Type: TABLE; Schema: public; Owner: btv
--

CREATE TABLE public.languages (
    code character varying(255) DEFAULT NULL::character varying NOT NULL,
    legacy_2_letter_code character varying(255) DEFAULT NULL::character varying,
    legacy_3_letter_code character varying(255) DEFAULT NULL::character varying,
    name character varying(255) DEFAULT NULL::character varying
);


ALTER TABLE public.languages OWNER TO btv;

--
-- Name: lists; Type: TABLE; Schema: public; Owner: btv
--

CREATE TABLE public.lists (
    date_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    date_updated timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    id integer NOT NULL,
    legacy_category_id integer,
    legacy_name_id integer,
    name character varying(255) DEFAULT NULL::character varying NOT NULL,
    user_created uuid,
    user_updated uuid
);


ALTER TABLE public.lists OWNER TO btv;

--
-- Name: lists_id_seq; Type: SEQUENCE; Schema: public; Owner: btv
--

CREATE SEQUENCE public.lists_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.lists_id_seq OWNER TO btv;

--
-- Name: lists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: btv
--

ALTER SEQUENCE public.lists_id_seq OWNED BY public.lists.id;


--
-- Name: lists_relations; Type: TABLE; Schema: public; Owner: btv
--

CREATE TABLE public.lists_relations (
    collection character varying(255) DEFAULT NULL::character varying,
    id integer NOT NULL,
    item character varying(255) DEFAULT NULL::character varying,
    lists_id integer,
    sort integer
);


ALTER TABLE public.lists_relations OWNER TO btv;

--
-- Name: lists_relations_id_seq; Type: SEQUENCE; Schema: public; Owner: btv
--

CREATE SEQUENCE public.lists_relations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.lists_relations_id_seq OWNER TO btv;

--
-- Name: lists_relations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: btv
--

ALTER SEQUENCE public.lists_relations_id_seq OWNED BY public.lists_relations.id;


--
-- Name: materialized_views_meta; Type: TABLE; Schema: public; Owner: btv
--

CREATE TABLE public.materialized_views_meta (
    last_refreshed timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    view_name text NOT NULL
);


ALTER TABLE public.materialized_views_meta OWNER TO btv;

--
-- Name: pages; Type: TABLE; Schema: public; Owner: btv
--

CREATE TABLE public.pages (
    code character varying(255) DEFAULT NULL::character varying,
    date_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    date_updated timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    id integer NOT NULL,
    sort integer,
    status character varying(255) DEFAULT 'draft'::character varying NOT NULL,
    user_created uuid,
    user_updated uuid,
    type character varying(255),
    episode_id integer,
    show_id integer,
    collection character varying(255) DEFAULT NULL::character varying,
    season_id integer
);


ALTER TABLE public.pages OWNER TO btv;

--
-- Name: pages_id_seq; Type: SEQUENCE; Schema: public; Owner: btv
--

CREATE SEQUENCE public.pages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pages_id_seq OWNER TO btv;

--
-- Name: pages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: btv
--

ALTER SEQUENCE public.pages_id_seq OWNED BY public.pages.id;


--
-- Name: seasons_availability; Type: VIEW; Schema: public; Owner: btv
--

CREATE VIEW public.seasons_availability AS
 SELECT se.id,
    (((se.status)::text = 'published'::text) AND ((s.status)::text = 'published'::text)) AS published,
    COALESCE(GREATEST(se.available_from, s.available_from), '1800-01-01 00:00:00'::timestamp without time zone) AS available_from,
    COALESCE(LEAST(se.available_to, s.available_to), '3000-01-01 00:00:00'::timestamp without time zone) AS available_to
   FROM (public.seasons se
     LEFT JOIN public.shows s ON ((se.show_id = s.id)));


ALTER TABLE public.seasons_availability OWNER TO btv;

--
-- Name: seasons_roles; Type: VIEW; Schema: public; Owner: btv
--

CREATE VIEW public.seasons_roles AS
 SELECT se.id,
    COALESCE(( SELECT array_agg(DISTINCT eu.usergroups_code) AS code
           FROM public.episodes_usergroups eu
          WHERE (eu.episodes_id IN ( SELECT e.id
                   FROM public.episodes e
                  WHERE (e.season_id = se.id)))), ARRAY[]::character varying[]) AS roles,
    COALESCE(( SELECT array_agg(DISTINCT eu.usergroups_code) AS code
           FROM public.episodes_usergroups_download eu
          WHERE (eu.episodes_id IN ( SELECT e.id
                   FROM public.episodes e
                  WHERE (e.season_id = se.id)))), ARRAY[]::character varying[]) AS roles_download,
    COALESCE(( SELECT array_agg(DISTINCT eu.usergroups_code) AS code
           FROM public.episodes_usergroups_earlyaccess eu
          WHERE (eu.episodes_id IN ( SELECT e.id
                   FROM public.episodes e
                  WHERE (e.season_id = se.id)))), ARRAY[]::character varying[]) AS roles_earlyaccess
   FROM public.seasons se;


ALTER TABLE public.seasons_roles OWNER TO btv;

--
-- Name: seasons_access_view; Type: VIEW; Schema: public; Owner: btv
--

CREATE VIEW public.seasons_access_view AS
 SELECT se.id,
    a.published,
    a.available_from,
    a.available_to,
    r.roles AS usergroups,
    r.roles_download AS usergroups_downloads,
    r.roles_earlyaccess AS usergroups_earlyaccess
   FROM ((public.seasons se
     LEFT JOIN public.seasons_availability a ON ((a.id = se.id)))
     LEFT JOIN public.seasons_roles r ON ((r.id = se.id)));


ALTER TABLE public.seasons_access_view OWNER TO btv;

--
-- Name: seasons_access; Type: MATERIALIZED VIEW; Schema: public; Owner: btv
--

CREATE MATERIALIZED VIEW public.seasons_access AS
 SELECT seasons_access_view.id,
    seasons_access_view.published,
    seasons_access_view.available_from,
    seasons_access_view.available_to,
    seasons_access_view.usergroups,
    seasons_access_view.usergroups_downloads,
    seasons_access_view.usergroups_earlyaccess
   FROM public.seasons_access_view
  WITH NO DATA;


ALTER TABLE public.seasons_access OWNER TO btv;

--
-- Name: seasons_translations; Type: TABLE; Schema: public; Owner: btv
--

CREATE TABLE public.seasons_translations (
    description text,
    id integer NOT NULL,
    is_primary boolean DEFAULT false NOT NULL,
    languages_code character varying(255) DEFAULT NULL::character varying NOT NULL,
    legacy_description_id integer,
    legacy_title_id integer,
    seasons_id integer NOT NULL,
    title character varying(255) DEFAULT NULL::character varying
);


ALTER TABLE public.seasons_translations OWNER TO btv;

--
-- Name: seasons_expanded; Type: VIEW; Schema: public; Owner: btv
--

CREATE VIEW public.seasons_expanded AS
 WITH t AS (
         SELECT t_1.seasons_id,
            json_object_agg(t_1.languages_code, t_1.title) AS title,
            json_object_agg(t_1.languages_code, t_1.description) AS description
           FROM public.seasons_translations t_1
          GROUP BY t_1.seasons_id
        )
 SELECT se.id,
    se.season_number,
    se.image_file_id,
    se.show_id,
    t.title,
    t.description,
    access.published,
    (access.available_from)::timestamp with time zone AS available_from,
    (access.available_to)::timestamp with time zone AS available_to,
    (access.usergroups)::text[] AS usergroups,
    (access.usergroups_downloads)::text[] AS download_groups,
    (access.usergroups_earlyaccess)::text[] AS early_access_groups
   FROM ((public.seasons se
     JOIN t ON ((se.id = t.seasons_id)))
     JOIN public.seasons_access access ON ((access.id = se.id)));


ALTER TABLE public.seasons_expanded OWNER TO btv;

--
-- Name: seasons_id_seq; Type: SEQUENCE; Schema: public; Owner: btv
--

CREATE SEQUENCE public.seasons_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seasons_id_seq OWNER TO btv;

--
-- Name: seasons_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: btv
--

ALTER SEQUENCE public.seasons_id_seq OWNED BY public.seasons.id;


--
-- Name: seasons_translations_id_seq; Type: SEQUENCE; Schema: public; Owner: btv
--

CREATE SEQUENCE public.seasons_translations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seasons_translations_id_seq OWNER TO btv;

--
-- Name: seasons_translations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: btv
--

ALTER SEQUENCE public.seasons_translations_id_seq OWNED BY public.seasons_translations.id;


--
-- Name: seasons_usergroups; Type: TABLE; Schema: public; Owner: btv
--

CREATE TABLE public.seasons_usergroups (
    id integer NOT NULL,
    seasons_id integer NOT NULL,
    usergroups_code character varying(255) DEFAULT NULL::character varying NOT NULL
);


ALTER TABLE public.seasons_usergroups OWNER TO btv;

--
-- Name: seasons_usergroups_id_seq; Type: SEQUENCE; Schema: public; Owner: btv
--

CREATE SEQUENCE public.seasons_usergroups_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seasons_usergroups_id_seq OWNER TO btv;

--
-- Name: seasons_usergroups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: btv
--

ALTER SEQUENCE public.seasons_usergroups_id_seq OWNED BY public.seasons_usergroups.id;


--
-- Name: sections; Type: TABLE; Schema: public; Owner: btv
--

CREATE TABLE public.sections (
    collection_id integer,
    date_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    date_updated timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    id integer NOT NULL,
    page integer NOT NULL,
    status character varying(255) DEFAULT 'draft'::character varying NOT NULL,
    user_created uuid,
    user_updated uuid,
    sort integer
);


ALTER TABLE public.sections OWNER TO btv;

--
-- Name: sections_id_seq; Type: SEQUENCE; Schema: public; Owner: btv
--

CREATE SEQUENCE public.sections_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sections_id_seq OWNER TO btv;

--
-- Name: sections_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: btv
--

ALTER SEQUENCE public.sections_id_seq OWNED BY public.sections.id;


--
-- Name: sections_translations; Type: TABLE; Schema: public; Owner: btv
--

CREATE TABLE public.sections_translations (
    id integer NOT NULL,
    languages_code character varying(255) DEFAULT NULL::character varying NOT NULL,
    legacy_title_id integer,
    sections_id integer NOT NULL,
    title character varying(255) DEFAULT NULL::character varying NOT NULL
);


ALTER TABLE public.sections_translations OWNER TO btv;

--
-- Name: sections_translations_id_seq; Type: SEQUENCE; Schema: public; Owner: btv
--

CREATE SEQUENCE public.sections_translations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sections_translations_id_seq OWNER TO btv;

--
-- Name: sections_translations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: btv
--

ALTER SEQUENCE public.sections_translations_id_seq OWNED BY public.sections_translations.id;


--
-- Name: sections_usergroups; Type: TABLE; Schema: public; Owner: btv
--

CREATE TABLE public.sections_usergroups (
    id integer NOT NULL,
    sections_id integer NOT NULL,
    usergroups_code character varying(255) DEFAULT NULL::character varying NOT NULL
);


ALTER TABLE public.sections_usergroups OWNER TO btv;

--
-- Name: sections_usergroups_id_seq; Type: SEQUENCE; Schema: public; Owner: btv
--

CREATE SEQUENCE public.sections_usergroups_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sections_usergroups_id_seq OWNER TO btv;

--
-- Name: sections_usergroups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: btv
--

ALTER SEQUENCE public.sections_usergroups_id_seq OWNED BY public.sections_usergroups.id;


--
-- Name: shows_availability; Type: VIEW; Schema: public; Owner: btv
--

CREATE VIEW public.shows_availability AS
 SELECT sh.id,
    ((sh.status)::text = 'published'::text) AS published,
    COALESCE(sh.available_from, '1800-01-01 00:00:00'::timestamp without time zone) AS available_from,
    COALESCE(sh.available_to, '3000-01-01 00:00:00'::timestamp without time zone) AS available_to
   FROM public.shows sh;


ALTER TABLE public.shows_availability OWNER TO btv;

--
-- Name: shows_roles; Type: VIEW; Schema: public; Owner: btv
--

CREATE VIEW public.shows_roles AS
 SELECT sh.id,
    COALESCE(( SELECT array_agg(DISTINCT eu.usergroups_code) AS code
           FROM public.episodes_usergroups eu
          WHERE (eu.episodes_id IN ( SELECT e.id
                   FROM public.episodes e
                  WHERE (e.season_id IN ( SELECT se.id
                           FROM public.seasons se
                          WHERE (se.show_id = sh.id)))))), ARRAY[]::character varying[]) AS roles,
    COALESCE(( SELECT array_agg(DISTINCT eu.usergroups_code) AS code
           FROM public.episodes_usergroups_download eu
          WHERE (eu.episodes_id IN ( SELECT e.id
                   FROM public.episodes e
                  WHERE (e.season_id IN ( SELECT se.id
                           FROM public.seasons se
                          WHERE (se.show_id = sh.id)))))), ARRAY[]::character varying[]) AS roles_download,
    COALESCE(( SELECT array_agg(DISTINCT eu.usergroups_code) AS code
           FROM public.episodes_usergroups_earlyaccess eu
          WHERE (eu.episodes_id IN ( SELECT e.id
                   FROM public.episodes e
                  WHERE (e.season_id IN ( SELECT se.id
                           FROM public.seasons se
                          WHERE (se.show_id = sh.id)))))), ARRAY[]::character varying[]) AS roles_earlyaccess
   FROM public.shows sh;


ALTER TABLE public.shows_roles OWNER TO btv;

--
-- Name: shows_access_view; Type: VIEW; Schema: public; Owner: btv
--

CREATE VIEW public.shows_access_view AS
 SELECT sh.id,
    a.published,
    a.available_from,
    a.available_to,
    r.roles AS usergroups,
    r.roles_download AS usergroups_downloads,
    r.roles_earlyaccess AS usergroups_earlyaccess
   FROM ((public.shows sh
     LEFT JOIN public.shows_availability a ON ((a.id = sh.id)))
     LEFT JOIN public.shows_roles r ON ((r.id = sh.id)));


ALTER TABLE public.shows_access_view OWNER TO btv;

--
-- Name: shows_access; Type: MATERIALIZED VIEW; Schema: public; Owner: btv
--

CREATE MATERIALIZED VIEW public.shows_access AS
 SELECT shows_access_view.id,
    shows_access_view.published,
    shows_access_view.available_from,
    shows_access_view.available_to,
    shows_access_view.usergroups,
    shows_access_view.usergroups_downloads,
    shows_access_view.usergroups_earlyaccess
   FROM public.shows_access_view
  WITH NO DATA;


ALTER TABLE public.shows_access OWNER TO btv;

--
-- Name: shows_translations; Type: TABLE; Schema: public; Owner: btv
--

CREATE TABLE public.shows_translations (
    description text,
    id integer NOT NULL,
    is_primary boolean DEFAULT false NOT NULL,
    languages_code character varying(255) DEFAULT NULL::character varying NOT NULL,
    legacy_description_id integer,
    legacy_tags character varying(255) DEFAULT NULL::character varying,
    legacy_tags_id integer,
    legacy_title_id bigint,
    shows_id integer NOT NULL,
    title character varying(255) DEFAULT NULL::character varying
);


ALTER TABLE public.shows_translations OWNER TO btv;

--
-- Name: shows_expanded; Type: VIEW; Schema: public; Owner: btv
--

CREATE VIEW public.shows_expanded AS
 WITH t AS (
         SELECT t_1.shows_id,
            json_object_agg(t_1.languages_code, t_1.title) AS title,
            json_object_agg(t_1.languages_code, t_1.description) AS description
           FROM public.shows_translations t_1
          GROUP BY t_1.shows_id
        )
 SELECT sh.id,
    sh.image_file_id,
    t.title,
    t.description,
    access.published,
    (access.available_from)::timestamp with time zone AS available_from,
    (access.available_to)::timestamp with time zone AS available_to,
    (access.usergroups)::text[] AS usergroups,
    (access.usergroups_downloads)::text[] AS download_groups,
    (access.usergroups_earlyaccess)::text[] AS early_access_groups
   FROM ((public.shows sh
     JOIN t ON ((sh.id = t.shows_id)))
     JOIN public.shows_access access ON ((access.id = sh.id)));


ALTER TABLE public.shows_expanded OWNER TO btv;

--
-- Name: shows_id_seq; Type: SEQUENCE; Schema: public; Owner: btv
--

CREATE SEQUENCE public.shows_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.shows_id_seq OWNER TO btv;

--
-- Name: shows_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: btv
--

ALTER SEQUENCE public.shows_id_seq OWNED BY public.shows.id;


--
-- Name: shows_translations_id_seq; Type: SEQUENCE; Schema: public; Owner: btv
--

CREATE SEQUENCE public.shows_translations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.shows_translations_id_seq OWNER TO btv;

--
-- Name: shows_translations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: btv
--

ALTER SEQUENCE public.shows_translations_id_seq OWNED BY public.shows_translations.id;


--
-- Name: shows_usergroups; Type: TABLE; Schema: public; Owner: btv
--

CREATE TABLE public.shows_usergroups (
    id integer NOT NULL,
    shows_id integer NOT NULL,
    usergroups_code character varying(255) DEFAULT NULL::character varying NOT NULL
);


ALTER TABLE public.shows_usergroups OWNER TO btv;

--
-- Name: shows_usergroups_id_seq; Type: SEQUENCE; Schema: public; Owner: btv
--

CREATE SEQUENCE public.shows_usergroups_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.shows_usergroups_id_seq OWNER TO btv;

--
-- Name: shows_usergroups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: btv
--

ALTER SEQUENCE public.shows_usergroups_id_seq OWNED BY public.shows_usergroups.id;


--
-- Name: tags; Type: TABLE; Schema: public; Owner: btv
--

CREATE TABLE public.tags (
    code character varying(255) DEFAULT NULL::character varying,
    date_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    date_updated timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    id integer NOT NULL,
    name character varying(255) DEFAULT NULL::character varying NOT NULL,
    user_created uuid,
    user_updated uuid
);


ALTER TABLE public.tags OWNER TO btv;

--
-- Name: tags_id_seq; Type: SEQUENCE; Schema: public; Owner: btv
--

CREATE SEQUENCE public.tags_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tags_id_seq OWNER TO btv;

--
-- Name: tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: btv
--

ALTER SEQUENCE public.tags_id_seq OWNED BY public.tags.id;


--
-- Name: tvguideentry; Type: TABLE; Schema: public; Owner: btv
--

CREATE TABLE public.tvguideentry (
    date_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    date_updated timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    description character varying(255) DEFAULT NULL::character varying,
    "end" timestamp without time zone,
    event integer,
    id integer NOT NULL,
    image uuid,
    start timestamp without time zone,
    status character varying(255) DEFAULT 'published'::character varying,
    title character varying(255) DEFAULT NULL::character varying,
    use_image_from_link boolean DEFAULT true NOT NULL,
    user_created uuid,
    user_updated uuid
);


ALTER TABLE public.tvguideentry OWNER TO btv;

--
-- Name: tvguideentry_id_seq; Type: SEQUENCE; Schema: public; Owner: btv
--

CREATE SEQUENCE public.tvguideentry_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tvguideentry_id_seq OWNER TO btv;

--
-- Name: tvguideentry_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: btv
--

ALTER SEQUENCE public.tvguideentry_id_seq OWNED BY public.tvguideentry.id;


--
-- Name: tvguideentry_link; Type: TABLE; Schema: public; Owner: btv
--

CREATE TABLE public.tvguideentry_link (
    collection character varying(255) DEFAULT NULL::character varying,
    id integer NOT NULL,
    item character varying(255) DEFAULT NULL::character varying,
    tvguideentry_id integer
);


ALTER TABLE public.tvguideentry_link OWNER TO btv;

--
-- Name: tvguideentry_link_id_seq; Type: SEQUENCE; Schema: public; Owner: btv
--

CREATE SEQUENCE public.tvguideentry_link_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tvguideentry_link_id_seq OWNER TO btv;

--
-- Name: tvguideentry_link_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: btv
--

ALTER SEQUENCE public.tvguideentry_link_id_seq OWNED BY public.tvguideentry_link.id;


--
-- Name: usergroups; Type: TABLE; Schema: public; Owner: btv
--

CREATE TABLE public.usergroups (
    code character varying(255) DEFAULT NULL::character varying NOT NULL,
    date_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    date_updated timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    emails text,
    name character varying(255) DEFAULT NULL::character varying NOT NULL,
    sort integer,
    user_created uuid,
    user_updated uuid
);


ALTER TABLE public.usergroups OWNER TO btv;

--
-- Name: ageratings_translations id; Type: DEFAULT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.ageratings_translations ALTER COLUMN id SET DEFAULT nextval('public.ageratings_translations_id_seq'::regclass);


--
-- Name: assetfiles id; Type: DEFAULT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.assetfiles ALTER COLUMN id SET DEFAULT nextval('public.assetfiles_id_seq'::regclass);


--
-- Name: assets id; Type: DEFAULT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.assets ALTER COLUMN id SET DEFAULT nextval('public.assets_id_seq'::regclass);


--
-- Name: assetstreams id; Type: DEFAULT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.assetstreams ALTER COLUMN id SET DEFAULT nextval('public.assetstreams_id_seq'::regclass);


--
-- Name: assetstreams_audio_languages id; Type: DEFAULT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.assetstreams_audio_languages ALTER COLUMN id SET DEFAULT nextval('public.assetstreams_audio_languages_id_seq'::regclass);


--
-- Name: assetstreams_subtitle_languages id; Type: DEFAULT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.assetstreams_subtitle_languages ALTER COLUMN id SET DEFAULT nextval('public.assetstreams_subtitle_languages_id_seq'::regclass);


--
-- Name: calendarevent id; Type: DEFAULT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.calendarevent ALTER COLUMN id SET DEFAULT nextval('public.calendarevent_id_seq'::regclass);


--
-- Name: categories id; Type: DEFAULT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.categories ALTER COLUMN id SET DEFAULT nextval('public.categories_id_seq'::regclass);


--
-- Name: categories_translations id; Type: DEFAULT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.categories_translations ALTER COLUMN id SET DEFAULT nextval('public.categories_translations_id_seq'::regclass);


--
-- Name: collections id; Type: DEFAULT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.collections ALTER COLUMN id SET DEFAULT nextval('public.collections_id_seq'::regclass);


--
-- Name: collections_episodes id; Type: DEFAULT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.collections_episodes ALTER COLUMN id SET DEFAULT nextval('public.collections_episodes_id_seq'::regclass);


--
-- Name: collections_relations id; Type: DEFAULT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.collections_relations ALTER COLUMN id SET DEFAULT nextval('public.collections_relations_id_seq'::regclass);


--
-- Name: collections_seasons id; Type: DEFAULT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.collections_seasons ALTER COLUMN id SET DEFAULT nextval('public.collections_seasons_id_seq'::regclass);


--
-- Name: collections_shows id; Type: DEFAULT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.collections_shows ALTER COLUMN id SET DEFAULT nextval('public.collections_shows_id_seq'::regclass);


--
-- Name: collections_translations id; Type: DEFAULT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.collections_translations ALTER COLUMN id SET DEFAULT nextval('public.collections_translations_id_seq'::regclass);


--
-- Name: directus_activity id; Type: DEFAULT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.directus_activity ALTER COLUMN id SET DEFAULT nextval('public.directus_activity_id_seq'::regclass);


--
-- Name: directus_fields id; Type: DEFAULT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.directus_fields ALTER COLUMN id SET DEFAULT nextval('public.directus_fields_id_seq'::regclass);


--
-- Name: directus_notifications id; Type: DEFAULT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.directus_notifications ALTER COLUMN id SET DEFAULT nextval('public.directus_notifications_id_seq'::regclass);


--
-- Name: directus_permissions id; Type: DEFAULT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.directus_permissions ALTER COLUMN id SET DEFAULT nextval('public.directus_permissions_id_seq'::regclass);


--
-- Name: directus_presets id; Type: DEFAULT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.directus_presets ALTER COLUMN id SET DEFAULT nextval('public.directus_presets_id_seq'::regclass);


--
-- Name: directus_relations id; Type: DEFAULT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.directus_relations ALTER COLUMN id SET DEFAULT nextval('public.directus_relations_id_seq'::regclass);


--
-- Name: directus_revisions id; Type: DEFAULT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.directus_revisions ALTER COLUMN id SET DEFAULT nextval('public.directus_revisions_id_seq'::regclass);


--
-- Name: directus_settings id; Type: DEFAULT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.directus_settings ALTER COLUMN id SET DEFAULT nextval('public.directus_settings_id_seq'::regclass);


--
-- Name: directus_webhooks id; Type: DEFAULT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.directus_webhooks ALTER COLUMN id SET DEFAULT nextval('public.directus_webhooks_id_seq'::regclass);


--
-- Name: episodes id; Type: DEFAULT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.episodes ALTER COLUMN id SET DEFAULT nextval('public.episodes_id_seq'::regclass);


--
-- Name: episodes_categories id; Type: DEFAULT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.episodes_categories ALTER COLUMN id SET DEFAULT nextval('public.episodes_categories_id_seq'::regclass);


--
-- Name: episodes_tags id; Type: DEFAULT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.episodes_tags ALTER COLUMN id SET DEFAULT nextval('public.episodes_tags_id_seq'::regclass);


--
-- Name: episodes_translations id; Type: DEFAULT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.episodes_translations ALTER COLUMN id SET DEFAULT nextval('public.episodes_translations_id_seq'::regclass);


--
-- Name: episodes_usergroups id; Type: DEFAULT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.episodes_usergroups ALTER COLUMN id SET DEFAULT nextval('public.episodes_usergroups_id_seq'::regclass);


--
-- Name: episodes_usergroups_download id; Type: DEFAULT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.episodes_usergroups_download ALTER COLUMN id SET DEFAULT nextval('public.episodes_usergroups_download_id_seq'::regclass);


--
-- Name: episodes_usergroups_earlyaccess id; Type: DEFAULT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.episodes_usergroups_earlyaccess ALTER COLUMN id SET DEFAULT nextval('public.episodes_usergroups_earlyaccess_id_seq'::regclass);


--
-- Name: lists id; Type: DEFAULT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.lists ALTER COLUMN id SET DEFAULT nextval('public.lists_id_seq'::regclass);


--
-- Name: lists_relations id; Type: DEFAULT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.lists_relations ALTER COLUMN id SET DEFAULT nextval('public.lists_relations_id_seq'::regclass);


--
-- Name: pages id; Type: DEFAULT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.pages ALTER COLUMN id SET DEFAULT nextval('public.pages_id_seq'::regclass);


--
-- Name: seasons id; Type: DEFAULT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.seasons ALTER COLUMN id SET DEFAULT nextval('public.seasons_id_seq'::regclass);


--
-- Name: seasons_translations id; Type: DEFAULT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.seasons_translations ALTER COLUMN id SET DEFAULT nextval('public.seasons_translations_id_seq'::regclass);


--
-- Name: seasons_usergroups id; Type: DEFAULT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.seasons_usergroups ALTER COLUMN id SET DEFAULT nextval('public.seasons_usergroups_id_seq'::regclass);


--
-- Name: sections id; Type: DEFAULT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.sections ALTER COLUMN id SET DEFAULT nextval('public.sections_id_seq'::regclass);


--
-- Name: sections_translations id; Type: DEFAULT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.sections_translations ALTER COLUMN id SET DEFAULT nextval('public.sections_translations_id_seq'::regclass);


--
-- Name: sections_usergroups id; Type: DEFAULT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.sections_usergroups ALTER COLUMN id SET DEFAULT nextval('public.sections_usergroups_id_seq'::regclass);


--
-- Name: shows id; Type: DEFAULT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.shows ALTER COLUMN id SET DEFAULT nextval('public.shows_id_seq'::regclass);


--
-- Name: shows_translations id; Type: DEFAULT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.shows_translations ALTER COLUMN id SET DEFAULT nextval('public.shows_translations_id_seq'::regclass);


--
-- Name: shows_usergroups id; Type: DEFAULT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.shows_usergroups ALTER COLUMN id SET DEFAULT nextval('public.shows_usergroups_id_seq'::regclass);


--
-- Name: tags id; Type: DEFAULT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.tags ALTER COLUMN id SET DEFAULT nextval('public.tags_id_seq'::regclass);


--
-- Name: tvguideentry id; Type: DEFAULT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.tvguideentry ALTER COLUMN id SET DEFAULT nextval('public.tvguideentry_id_seq'::regclass);


--
-- Name: tvguideentry_link id; Type: DEFAULT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.tvguideentry_link ALTER COLUMN id SET DEFAULT nextval('public.tvguideentry_link_id_seq'::regclass);


--
-- Name: ageratings ageratings_pkey; Type: CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.ageratings
    ADD CONSTRAINT ageratings_pkey PRIMARY KEY (code);


--
-- Name: ageratings_translations ageratings_translations_pkey; Type: CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.ageratings_translations
    ADD CONSTRAINT ageratings_translations_pkey PRIMARY KEY (id);


--
-- Name: assetfiles assetfiles_pkey; Type: CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.assetfiles
    ADD CONSTRAINT assetfiles_pkey PRIMARY KEY (id);


--
-- Name: assets assets_pkey; Type: CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.assets
    ADD CONSTRAINT assets_pkey PRIMARY KEY (id);


--
-- Name: assetstreams_audio_languages assetstreams_audio_languages_pkey; Type: CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.assetstreams_audio_languages
    ADD CONSTRAINT assetstreams_audio_languages_pkey PRIMARY KEY (id);


--
-- Name: assetstreams assetstreams_pkey; Type: CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.assetstreams
    ADD CONSTRAINT assetstreams_pkey PRIMARY KEY (id);


--
-- Name: assetstreams_subtitle_languages assetstreams_subtitle_languages_pkey; Type: CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.assetstreams_subtitle_languages
    ADD CONSTRAINT assetstreams_subtitle_languages_pkey PRIMARY KEY (id);


--
-- Name: calendarevent calendarevent_pkey; Type: CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.calendarevent
    ADD CONSTRAINT calendarevent_pkey PRIMARY KEY (id);


--
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: categories_translations categories_translations_pkey; Type: CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.categories_translations
    ADD CONSTRAINT categories_translations_pkey PRIMARY KEY (id);


--
-- Name: collections_episodes collections_episodes_pkey; Type: CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.collections_episodes
    ADD CONSTRAINT collections_episodes_pkey PRIMARY KEY (id);


--
-- Name: collections collections_pkey; Type: CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.collections
    ADD CONSTRAINT collections_pkey PRIMARY KEY (id);


--
-- Name: collections_relations collections_relations_pkey; Type: CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.collections_relations
    ADD CONSTRAINT collections_relations_pkey PRIMARY KEY (id);


--
-- Name: collections_seasons collections_seasons_pkey; Type: CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.collections_seasons
    ADD CONSTRAINT collections_seasons_pkey PRIMARY KEY (id);


--
-- Name: collections_shows collections_shows_pkey; Type: CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.collections_shows
    ADD CONSTRAINT collections_shows_pkey PRIMARY KEY (id);


--
-- Name: collections_translations collections_translations_pkey; Type: CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.collections_translations
    ADD CONSTRAINT collections_translations_pkey PRIMARY KEY (id);


--
-- Name: directus_activity directus_activity_pkey; Type: CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.directus_activity
    ADD CONSTRAINT directus_activity_pkey PRIMARY KEY (id);


--
-- Name: directus_collections directus_collections_pkey; Type: CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.directus_collections
    ADD CONSTRAINT directus_collections_pkey PRIMARY KEY (collection);


--
-- Name: directus_dashboards directus_dashboards_pkey; Type: CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.directus_dashboards
    ADD CONSTRAINT directus_dashboards_pkey PRIMARY KEY (id);


--
-- Name: directus_fields directus_fields_pkey; Type: CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.directus_fields
    ADD CONSTRAINT directus_fields_pkey PRIMARY KEY (id);


--
-- Name: directus_files directus_files_pkey; Type: CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.directus_files
    ADD CONSTRAINT directus_files_pkey PRIMARY KEY (id);


--
-- Name: directus_flows directus_flows_operation_unique; Type: CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.directus_flows
    ADD CONSTRAINT directus_flows_operation_unique UNIQUE (operation);


--
-- Name: directus_flows directus_flows_pkey; Type: CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.directus_flows
    ADD CONSTRAINT directus_flows_pkey PRIMARY KEY (id);


--
-- Name: directus_folders directus_folders_pkey; Type: CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.directus_folders
    ADD CONSTRAINT directus_folders_pkey PRIMARY KEY (id);


--
-- Name: directus_migrations directus_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.directus_migrations
    ADD CONSTRAINT directus_migrations_pkey PRIMARY KEY (version);


--
-- Name: directus_notifications directus_notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.directus_notifications
    ADD CONSTRAINT directus_notifications_pkey PRIMARY KEY (id);


--
-- Name: directus_operations directus_operations_pkey; Type: CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.directus_operations
    ADD CONSTRAINT directus_operations_pkey PRIMARY KEY (id);


--
-- Name: directus_operations directus_operations_reject_unique; Type: CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.directus_operations
    ADD CONSTRAINT directus_operations_reject_unique UNIQUE (reject);


--
-- Name: directus_operations directus_operations_resolve_unique; Type: CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.directus_operations
    ADD CONSTRAINT directus_operations_resolve_unique UNIQUE (resolve);


--
-- Name: directus_panels directus_panels_pkey; Type: CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.directus_panels
    ADD CONSTRAINT directus_panels_pkey PRIMARY KEY (id);


--
-- Name: directus_permissions directus_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.directus_permissions
    ADD CONSTRAINT directus_permissions_pkey PRIMARY KEY (id);


--
-- Name: directus_presets directus_presets_pkey; Type: CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.directus_presets
    ADD CONSTRAINT directus_presets_pkey PRIMARY KEY (id);


--
-- Name: directus_relations directus_relations_pkey; Type: CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.directus_relations
    ADD CONSTRAINT directus_relations_pkey PRIMARY KEY (id);


--
-- Name: directus_revisions directus_revisions_pkey; Type: CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.directus_revisions
    ADD CONSTRAINT directus_revisions_pkey PRIMARY KEY (id);


--
-- Name: directus_roles directus_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.directus_roles
    ADD CONSTRAINT directus_roles_pkey PRIMARY KEY (id);


--
-- Name: directus_sessions directus_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.directus_sessions
    ADD CONSTRAINT directus_sessions_pkey PRIMARY KEY (token);


--
-- Name: directus_settings directus_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.directus_settings
    ADD CONSTRAINT directus_settings_pkey PRIMARY KEY (id);


--
-- Name: directus_shares directus_shares_pkey; Type: CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.directus_shares
    ADD CONSTRAINT directus_shares_pkey PRIMARY KEY (id);


--
-- Name: directus_users directus_users_email_unique; Type: CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.directus_users
    ADD CONSTRAINT directus_users_email_unique UNIQUE (email);


--
-- Name: directus_users directus_users_external_identifier_unique; Type: CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.directus_users
    ADD CONSTRAINT directus_users_external_identifier_unique UNIQUE (external_identifier);


--
-- Name: directus_users directus_users_pkey; Type: CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.directus_users
    ADD CONSTRAINT directus_users_pkey PRIMARY KEY (id);


--
-- Name: directus_users directus_users_token_unique; Type: CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.directus_users
    ADD CONSTRAINT directus_users_token_unique UNIQUE (token);


--
-- Name: directus_webhooks directus_webhooks_pkey; Type: CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.directus_webhooks
    ADD CONSTRAINT directus_webhooks_pkey PRIMARY KEY (id);


--
-- Name: episodes_categories episodes_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.episodes_categories
    ADD CONSTRAINT episodes_categories_pkey PRIMARY KEY (id);


--
-- Name: episodes episodes_legacy_id_unique; Type: CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.episodes
    ADD CONSTRAINT episodes_legacy_id_unique UNIQUE (legacy_id);


--
-- Name: episodes episodes_legacy_program_id_unique; Type: CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.episodes
    ADD CONSTRAINT episodes_legacy_program_id_unique UNIQUE (legacy_program_id);


--
-- Name: episodes episodes_pkey; Type: CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.episodes
    ADD CONSTRAINT episodes_pkey PRIMARY KEY (id);


--
-- Name: episodes_tags episodes_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.episodes_tags
    ADD CONSTRAINT episodes_tags_pkey PRIMARY KEY (id);


--
-- Name: episodes_translations episodes_translations_pkey; Type: CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.episodes_translations
    ADD CONSTRAINT episodes_translations_pkey PRIMARY KEY (id);


--
-- Name: episodes_usergroups_download episodes_usergroups_download_pkey; Type: CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.episodes_usergroups_download
    ADD CONSTRAINT episodes_usergroups_download_pkey PRIMARY KEY (id);


--
-- Name: episodes_usergroups_earlyaccess episodes_usergroups_earlyaccess_pkey; Type: CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.episodes_usergroups_earlyaccess
    ADD CONSTRAINT episodes_usergroups_earlyaccess_pkey PRIMARY KEY (id);


--
-- Name: episodes_usergroups episodes_usergroups_pkey; Type: CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.episodes_usergroups
    ADD CONSTRAINT episodes_usergroups_pkey PRIMARY KEY (id);


--
-- Name: languages languages_pkey; Type: CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.languages
    ADD CONSTRAINT languages_pkey PRIMARY KEY (code);


--
-- Name: lists lists_pkey; Type: CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.lists
    ADD CONSTRAINT lists_pkey PRIMARY KEY (id);


--
-- Name: lists_relations lists_relations_pkey; Type: CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.lists_relations
    ADD CONSTRAINT lists_relations_pkey PRIMARY KEY (id);


--
-- Name: materialized_views_meta materialized_views_meta_pkey; Type: CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.materialized_views_meta
    ADD CONSTRAINT materialized_views_meta_pkey PRIMARY KEY (view_name);


--
-- Name: pages pages_code_unique; Type: CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.pages
    ADD CONSTRAINT pages_code_unique UNIQUE (code);


--
-- Name: pages pages_collection_unique; Type: CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.pages
    ADD CONSTRAINT pages_collection_unique UNIQUE (collection);


--
-- Name: pages pages_pkey; Type: CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.pages
    ADD CONSTRAINT pages_pkey PRIMARY KEY (id);


--
-- Name: seasons seasons_pkey; Type: CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.seasons
    ADD CONSTRAINT seasons_pkey PRIMARY KEY (id);


--
-- Name: seasons_translations seasons_translations_pkey; Type: CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.seasons_translations
    ADD CONSTRAINT seasons_translations_pkey PRIMARY KEY (id);


--
-- Name: seasons_usergroups seasons_usergroups_pkey; Type: CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.seasons_usergroups
    ADD CONSTRAINT seasons_usergroups_pkey PRIMARY KEY (id);


--
-- Name: sections sections_pkey; Type: CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.sections
    ADD CONSTRAINT sections_pkey PRIMARY KEY (id);


--
-- Name: sections_translations sections_translations_pkey; Type: CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.sections_translations
    ADD CONSTRAINT sections_translations_pkey PRIMARY KEY (id);


--
-- Name: sections_usergroups sections_usergroups_pkey; Type: CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.sections_usergroups
    ADD CONSTRAINT sections_usergroups_pkey PRIMARY KEY (id);


--
-- Name: shows shows_pkey; Type: CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.shows
    ADD CONSTRAINT shows_pkey PRIMARY KEY (id);


--
-- Name: shows_translations shows_translations_pkey; Type: CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.shows_translations
    ADD CONSTRAINT shows_translations_pkey PRIMARY KEY (id);


--
-- Name: shows_usergroups shows_usergroups_pkey; Type: CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.shows_usergroups
    ADD CONSTRAINT shows_usergroups_pkey PRIMARY KEY (id);


--
-- Name: tags tags_pkey; Type: CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- Name: tvguideentry_link tvguideentry_link_pkey; Type: CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.tvguideentry_link
    ADD CONSTRAINT tvguideentry_link_pkey PRIMARY KEY (id);


--
-- Name: tvguideentry tvguideentry_pkey; Type: CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.tvguideentry
    ADD CONSTRAINT tvguideentry_pkey PRIMARY KEY (id);


--
-- Name: usergroups usergroups_pkey; Type: CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.usergroups
    ADD CONSTRAINT usergroups_pkey PRIMARY KEY (code);


--
-- Name: episodes_access_idx; Type: INDEX; Schema: public; Owner: btv
--

CREATE UNIQUE INDEX episodes_access_idx ON public.episodes_access USING btree (id);


--
-- Name: pages_code_uindex; Type: INDEX; Schema: public; Owner: btv
--

CREATE UNIQUE INDEX pages_code_uindex ON public.pages USING btree (code);


--
-- Name: seasons_access_idx; Type: INDEX; Schema: public; Owner: btv
--

CREATE UNIQUE INDEX seasons_access_idx ON public.seasons_access USING btree (id);


--
-- Name: shows_access_idx; Type: INDEX; Schema: public; Owner: btv
--

CREATE UNIQUE INDEX shows_access_idx ON public.shows_access USING btree (id);


--
-- Name: ageratings_translations ageratings_translations_ageratings_code_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.ageratings_translations
    ADD CONSTRAINT ageratings_translations_ageratings_code_foreign FOREIGN KEY (ageratings_code) REFERENCES public.ageratings(code);


--
-- Name: ageratings_translations ageratings_translations_languages_code_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.ageratings_translations
    ADD CONSTRAINT ageratings_translations_languages_code_foreign FOREIGN KEY (languages_code) REFERENCES public.languages(code);


--
-- Name: assetfiles assetfiles_asset_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.assetfiles
    ADD CONSTRAINT assetfiles_asset_id_foreign FOREIGN KEY (asset_id) REFERENCES public.assets(id) ON DELETE CASCADE;


--
-- Name: assetfiles assetfiles_audio_language_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.assetfiles
    ADD CONSTRAINT assetfiles_audio_language_id_foreign FOREIGN KEY (audio_language_id) REFERENCES public.languages(code) ON DELETE SET NULL;


--
-- Name: assetfiles assetfiles_subtitle_language_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.assetfiles
    ADD CONSTRAINT assetfiles_subtitle_language_id_foreign FOREIGN KEY (subtitle_language_id) REFERENCES public.languages(code) ON DELETE SET NULL;


--
-- Name: assetfiles assetfiles_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.assetfiles
    ADD CONSTRAINT assetfiles_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id);


--
-- Name: assetfiles assetfiles_user_updated_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.assetfiles
    ADD CONSTRAINT assetfiles_user_updated_foreign FOREIGN KEY (user_updated) REFERENCES public.directus_users(id);


--
-- Name: assets assets_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.assets
    ADD CONSTRAINT assets_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id);


--
-- Name: assets assets_user_updated_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.assets
    ADD CONSTRAINT assets_user_updated_foreign FOREIGN KEY (user_updated) REFERENCES public.directus_users(id);


--
-- Name: assetstreams assetstreams_asset_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.assetstreams
    ADD CONSTRAINT assetstreams_asset_id_foreign FOREIGN KEY (asset_id) REFERENCES public.assets(id) ON DELETE CASCADE;


--
-- Name: assetstreams_audio_languages assetstreams_audio_languages_assetstreams_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.assetstreams_audio_languages
    ADD CONSTRAINT assetstreams_audio_languages_assetstreams_id_foreign FOREIGN KEY (assetstreams_id) REFERENCES public.assetstreams(id) ON DELETE CASCADE;


--
-- Name: assetstreams_audio_languages assetstreams_audio_languages_languages_code_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.assetstreams_audio_languages
    ADD CONSTRAINT assetstreams_audio_languages_languages_code_foreign FOREIGN KEY (languages_code) REFERENCES public.languages(code);


--
-- Name: assetstreams_subtitle_languages assetstreams_subtitle_languages_assetstreams_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.assetstreams_subtitle_languages
    ADD CONSTRAINT assetstreams_subtitle_languages_assetstreams_id_foreign FOREIGN KEY (assetstreams_id) REFERENCES public.assetstreams(id) ON DELETE CASCADE;


--
-- Name: assetstreams_subtitle_languages assetstreams_subtitle_languages_languages_code_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.assetstreams_subtitle_languages
    ADD CONSTRAINT assetstreams_subtitle_languages_languages_code_foreign FOREIGN KEY (languages_code) REFERENCES public.languages(code);


--
-- Name: assetstreams assetstreams_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.assetstreams
    ADD CONSTRAINT assetstreams_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id);


--
-- Name: assetstreams assetstreams_user_updated_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.assetstreams
    ADD CONSTRAINT assetstreams_user_updated_foreign FOREIGN KEY (user_updated) REFERENCES public.directus_users(id);


--
-- Name: calendarevent calendarevent_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.calendarevent
    ADD CONSTRAINT calendarevent_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id);


--
-- Name: calendarevent calendarevent_user_updated_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.calendarevent
    ADD CONSTRAINT calendarevent_user_updated_foreign FOREIGN KEY (user_updated) REFERENCES public.directus_users(id);


--
-- Name: categories categories_parent_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_parent_id_foreign FOREIGN KEY (parent_id) REFERENCES public.categories(id);


--
-- Name: categories_translations categories_translations_categories_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.categories_translations
    ADD CONSTRAINT categories_translations_categories_id_foreign FOREIGN KEY (categories_id) REFERENCES public.categories(id);


--
-- Name: categories_translations categories_translations_languages_code_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.categories_translations
    ADD CONSTRAINT categories_translations_languages_code_foreign FOREIGN KEY (languages_code) REFERENCES public.languages(code);


--
-- Name: categories categories_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id);


--
-- Name: categories categories_user_updated_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_user_updated_foreign FOREIGN KEY (user_updated) REFERENCES public.directus_users(id);


--
-- Name: collections_episodes collections_episodes_collections_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.collections_episodes
    ADD CONSTRAINT collections_episodes_collections_id_foreign FOREIGN KEY (collections_id) REFERENCES public.collections(id) ON DELETE CASCADE;


--
-- Name: collections_episodes collections_episodes_episodes_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.collections_episodes
    ADD CONSTRAINT collections_episodes_episodes_id_foreign FOREIGN KEY (episodes_id) REFERENCES public.episodes(id) ON DELETE CASCADE;


--
-- Name: collections_relations collections_relations_collections_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.collections_relations
    ADD CONSTRAINT collections_relations_collections_id_foreign FOREIGN KEY (collections_id) REFERENCES public.collections(id) ON DELETE CASCADE;


--
-- Name: collections_seasons collections_seasons_collections_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.collections_seasons
    ADD CONSTRAINT collections_seasons_collections_id_foreign FOREIGN KEY (collections_id) REFERENCES public.collections(id) ON DELETE CASCADE;


--
-- Name: collections_seasons collections_seasons_seasons_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.collections_seasons
    ADD CONSTRAINT collections_seasons_seasons_id_foreign FOREIGN KEY (seasons_id) REFERENCES public.seasons(id) ON DELETE CASCADE;


--
-- Name: collections_shows collections_shows_collections_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.collections_shows
    ADD CONSTRAINT collections_shows_collections_id_foreign FOREIGN KEY (collections_id) REFERENCES public.collections(id) ON DELETE CASCADE;


--
-- Name: collections_shows collections_shows_shows_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.collections_shows
    ADD CONSTRAINT collections_shows_shows_id_foreign FOREIGN KEY (shows_id) REFERENCES public.shows(id) ON DELETE CASCADE;


--
-- Name: collections_translations collections_translations_collections_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.collections_translations
    ADD CONSTRAINT collections_translations_collections_id_foreign FOREIGN KEY (collections_id) REFERENCES public.collections(id) ON DELETE SET NULL;


--
-- Name: collections_translations collections_translations_languages_code_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.collections_translations
    ADD CONSTRAINT collections_translations_languages_code_foreign FOREIGN KEY (languages_code) REFERENCES public.languages(code) ON DELETE SET NULL;


--
-- Name: collections collections_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.collections
    ADD CONSTRAINT collections_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id);


--
-- Name: collections collections_user_updated_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.collections
    ADD CONSTRAINT collections_user_updated_foreign FOREIGN KEY (user_updated) REFERENCES public.directus_users(id);


--
-- Name: directus_collections directus_collections_group_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.directus_collections
    ADD CONSTRAINT directus_collections_group_foreign FOREIGN KEY ("group") REFERENCES public.directus_collections(collection);


--
-- Name: directus_dashboards directus_dashboards_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.directus_dashboards
    ADD CONSTRAINT directus_dashboards_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id) ON DELETE SET NULL;


--
-- Name: directus_files directus_files_folder_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.directus_files
    ADD CONSTRAINT directus_files_folder_foreign FOREIGN KEY (folder) REFERENCES public.directus_folders(id) ON DELETE SET NULL;


--
-- Name: directus_files directus_files_modified_by_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.directus_files
    ADD CONSTRAINT directus_files_modified_by_foreign FOREIGN KEY (modified_by) REFERENCES public.directus_users(id);


--
-- Name: directus_files directus_files_uploaded_by_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.directus_files
    ADD CONSTRAINT directus_files_uploaded_by_foreign FOREIGN KEY (uploaded_by) REFERENCES public.directus_users(id);


--
-- Name: directus_flows directus_flows_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.directus_flows
    ADD CONSTRAINT directus_flows_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id) ON DELETE SET NULL;


--
-- Name: directus_folders directus_folders_parent_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.directus_folders
    ADD CONSTRAINT directus_folders_parent_foreign FOREIGN KEY (parent) REFERENCES public.directus_folders(id);


--
-- Name: directus_notifications directus_notifications_recipient_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.directus_notifications
    ADD CONSTRAINT directus_notifications_recipient_foreign FOREIGN KEY (recipient) REFERENCES public.directus_users(id) ON DELETE CASCADE;


--
-- Name: directus_notifications directus_notifications_sender_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.directus_notifications
    ADD CONSTRAINT directus_notifications_sender_foreign FOREIGN KEY (sender) REFERENCES public.directus_users(id);


--
-- Name: directus_operations directus_operations_flow_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.directus_operations
    ADD CONSTRAINT directus_operations_flow_foreign FOREIGN KEY (flow) REFERENCES public.directus_flows(id) ON DELETE CASCADE;


--
-- Name: directus_operations directus_operations_reject_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.directus_operations
    ADD CONSTRAINT directus_operations_reject_foreign FOREIGN KEY (reject) REFERENCES public.directus_operations(id);


--
-- Name: directus_operations directus_operations_resolve_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.directus_operations
    ADD CONSTRAINT directus_operations_resolve_foreign FOREIGN KEY (resolve) REFERENCES public.directus_operations(id);


--
-- Name: directus_operations directus_operations_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.directus_operations
    ADD CONSTRAINT directus_operations_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id) ON DELETE SET NULL;


--
-- Name: directus_panels directus_panels_dashboard_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.directus_panels
    ADD CONSTRAINT directus_panels_dashboard_foreign FOREIGN KEY (dashboard) REFERENCES public.directus_dashboards(id) ON DELETE CASCADE;


--
-- Name: directus_panels directus_panels_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.directus_panels
    ADD CONSTRAINT directus_panels_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id) ON DELETE SET NULL;


--
-- Name: directus_permissions directus_permissions_role_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.directus_permissions
    ADD CONSTRAINT directus_permissions_role_foreign FOREIGN KEY (role) REFERENCES public.directus_roles(id) ON DELETE CASCADE;


--
-- Name: directus_presets directus_presets_role_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.directus_presets
    ADD CONSTRAINT directus_presets_role_foreign FOREIGN KEY (role) REFERENCES public.directus_roles(id) ON DELETE CASCADE;


--
-- Name: directus_presets directus_presets_user_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.directus_presets
    ADD CONSTRAINT directus_presets_user_foreign FOREIGN KEY ("user") REFERENCES public.directus_users(id) ON DELETE CASCADE;


--
-- Name: directus_revisions directus_revisions_activity_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.directus_revisions
    ADD CONSTRAINT directus_revisions_activity_foreign FOREIGN KEY (activity) REFERENCES public.directus_activity(id) ON DELETE CASCADE;


--
-- Name: directus_revisions directus_revisions_parent_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.directus_revisions
    ADD CONSTRAINT directus_revisions_parent_foreign FOREIGN KEY (parent) REFERENCES public.directus_revisions(id);


--
-- Name: directus_sessions directus_sessions_share_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.directus_sessions
    ADD CONSTRAINT directus_sessions_share_foreign FOREIGN KEY (share) REFERENCES public.directus_shares(id) ON DELETE CASCADE;


--
-- Name: directus_sessions directus_sessions_user_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.directus_sessions
    ADD CONSTRAINT directus_sessions_user_foreign FOREIGN KEY ("user") REFERENCES public.directus_users(id) ON DELETE CASCADE;


--
-- Name: directus_settings directus_settings_project_logo_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.directus_settings
    ADD CONSTRAINT directus_settings_project_logo_foreign FOREIGN KEY (project_logo) REFERENCES public.directus_files(id);


--
-- Name: directus_settings directus_settings_public_background_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.directus_settings
    ADD CONSTRAINT directus_settings_public_background_foreign FOREIGN KEY (public_background) REFERENCES public.directus_files(id);


--
-- Name: directus_settings directus_settings_public_foreground_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.directus_settings
    ADD CONSTRAINT directus_settings_public_foreground_foreign FOREIGN KEY (public_foreground) REFERENCES public.directus_files(id);


--
-- Name: directus_settings directus_settings_storage_default_folder_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.directus_settings
    ADD CONSTRAINT directus_settings_storage_default_folder_foreign FOREIGN KEY (storage_default_folder) REFERENCES public.directus_folders(id) ON DELETE SET NULL;


--
-- Name: directus_shares directus_shares_collection_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.directus_shares
    ADD CONSTRAINT directus_shares_collection_foreign FOREIGN KEY (collection) REFERENCES public.directus_collections(collection) ON DELETE CASCADE;


--
-- Name: directus_shares directus_shares_role_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.directus_shares
    ADD CONSTRAINT directus_shares_role_foreign FOREIGN KEY (role) REFERENCES public.directus_roles(id) ON DELETE CASCADE;


--
-- Name: directus_shares directus_shares_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.directus_shares
    ADD CONSTRAINT directus_shares_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id) ON DELETE SET NULL;


--
-- Name: directus_users directus_users_role_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.directus_users
    ADD CONSTRAINT directus_users_role_foreign FOREIGN KEY (role) REFERENCES public.directus_roles(id) ON DELETE SET NULL;


--
-- Name: episodes episodes_agerating_code_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.episodes
    ADD CONSTRAINT episodes_agerating_code_foreign FOREIGN KEY (agerating_code) REFERENCES public.ageratings(code) ON DELETE SET NULL;


--
-- Name: episodes episodes_asset_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.episodes
    ADD CONSTRAINT episodes_asset_id_foreign FOREIGN KEY (asset_id) REFERENCES public.assets(id) ON DELETE SET NULL;


--
-- Name: episodes_categories episodes_categories_categories_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.episodes_categories
    ADD CONSTRAINT episodes_categories_categories_id_foreign FOREIGN KEY (categories_id) REFERENCES public.categories(id) ON DELETE CASCADE;


--
-- Name: episodes_categories episodes_categories_episodes_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.episodes_categories
    ADD CONSTRAINT episodes_categories_episodes_id_foreign FOREIGN KEY (episodes_id) REFERENCES public.episodes(id) ON DELETE CASCADE;


--
-- Name: episodes episodes_image_file_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.episodes
    ADD CONSTRAINT episodes_image_file_id_foreign FOREIGN KEY (image_file_id) REFERENCES public.directus_files(id) ON DELETE SET NULL;


--
-- Name: episodes episodes_season_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.episodes
    ADD CONSTRAINT episodes_season_id_foreign FOREIGN KEY (season_id) REFERENCES public.seasons(id) ON DELETE CASCADE;


--
-- Name: episodes_tags episodes_tags_episodes_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.episodes_tags
    ADD CONSTRAINT episodes_tags_episodes_id_foreign FOREIGN KEY (episodes_id) REFERENCES public.episodes(id) ON DELETE CASCADE;


--
-- Name: episodes_tags episodes_tags_tags_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.episodes_tags
    ADD CONSTRAINT episodes_tags_tags_id_foreign FOREIGN KEY (tags_id) REFERENCES public.tags(id) ON DELETE CASCADE;


--
-- Name: episodes_translations episodes_translations_episodes_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.episodes_translations
    ADD CONSTRAINT episodes_translations_episodes_id_foreign FOREIGN KEY (episodes_id) REFERENCES public.episodes(id) ON DELETE CASCADE;


--
-- Name: episodes_translations episodes_translations_languages_code_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.episodes_translations
    ADD CONSTRAINT episodes_translations_languages_code_foreign FOREIGN KEY (languages_code) REFERENCES public.languages(code) ON DELETE CASCADE;


--
-- Name: episodes episodes_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.episodes
    ADD CONSTRAINT episodes_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id);


--
-- Name: episodes episodes_user_updated_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.episodes
    ADD CONSTRAINT episodes_user_updated_foreign FOREIGN KEY (user_updated) REFERENCES public.directus_users(id);


--
-- Name: episodes_usergroups_download episodes_usergroups_download_episodes_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.episodes_usergroups_download
    ADD CONSTRAINT episodes_usergroups_download_episodes_id_foreign FOREIGN KEY (episodes_id) REFERENCES public.episodes(id) ON DELETE CASCADE;


--
-- Name: episodes_usergroups_download episodes_usergroups_download_usergroups_code_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.episodes_usergroups_download
    ADD CONSTRAINT episodes_usergroups_download_usergroups_code_foreign FOREIGN KEY (usergroups_code) REFERENCES public.usergroups(code) ON DELETE CASCADE;


--
-- Name: episodes_usergroups_earlyaccess episodes_usergroups_earlyaccess_episodes_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.episodes_usergroups_earlyaccess
    ADD CONSTRAINT episodes_usergroups_earlyaccess_episodes_id_foreign FOREIGN KEY (episodes_id) REFERENCES public.episodes(id) ON DELETE CASCADE;


--
-- Name: episodes_usergroups_earlyaccess episodes_usergroups_earlyaccess_usergroups_code_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.episodes_usergroups_earlyaccess
    ADD CONSTRAINT episodes_usergroups_earlyaccess_usergroups_code_foreign FOREIGN KEY (usergroups_code) REFERENCES public.usergroups(code) ON DELETE CASCADE;


--
-- Name: episodes_usergroups episodes_usergroups_episodes_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.episodes_usergroups
    ADD CONSTRAINT episodes_usergroups_episodes_id_foreign FOREIGN KEY (episodes_id) REFERENCES public.episodes(id) ON DELETE CASCADE;


--
-- Name: episodes_usergroups episodes_usergroups_usergroups_code_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.episodes_usergroups
    ADD CONSTRAINT episodes_usergroups_usergroups_code_foreign FOREIGN KEY (usergroups_code) REFERENCES public.usergroups(code) ON DELETE CASCADE;


--
-- Name: lists_relations lists_relations_lists_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.lists_relations
    ADD CONSTRAINT lists_relations_lists_id_foreign FOREIGN KEY (lists_id) REFERENCES public.lists(id) ON DELETE CASCADE;


--
-- Name: lists lists_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.lists
    ADD CONSTRAINT lists_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id);


--
-- Name: lists lists_user_updated_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.lists
    ADD CONSTRAINT lists_user_updated_foreign FOREIGN KEY (user_updated) REFERENCES public.directus_users(id);


--
-- Name: pages pages_episode_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.pages
    ADD CONSTRAINT pages_episode_id_foreign FOREIGN KEY (episode_id) REFERENCES public.episodes(id) ON DELETE SET NULL;


--
-- Name: pages pages_season_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.pages
    ADD CONSTRAINT pages_season_id_foreign FOREIGN KEY (season_id) REFERENCES public.seasons(id) ON DELETE SET NULL;


--
-- Name: pages pages_show_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.pages
    ADD CONSTRAINT pages_show_id_foreign FOREIGN KEY (show_id) REFERENCES public.shows(id) ON DELETE SET NULL;


--
-- Name: pages pages_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.pages
    ADD CONSTRAINT pages_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id);


--
-- Name: pages pages_user_updated_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.pages
    ADD CONSTRAINT pages_user_updated_foreign FOREIGN KEY (user_updated) REFERENCES public.directus_users(id);


--
-- Name: seasons seasons_agerating_code_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.seasons
    ADD CONSTRAINT seasons_agerating_code_foreign FOREIGN KEY (agerating_code) REFERENCES public.ageratings(code) ON DELETE SET NULL;


--
-- Name: seasons seasons_image_file_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.seasons
    ADD CONSTRAINT seasons_image_file_id_foreign FOREIGN KEY (image_file_id) REFERENCES public.directus_files(id) ON DELETE SET NULL;


--
-- Name: seasons seasons_show_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.seasons
    ADD CONSTRAINT seasons_show_id_foreign FOREIGN KEY (show_id) REFERENCES public.shows(id) ON DELETE CASCADE;


--
-- Name: seasons_translations seasons_translations_languages_code_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.seasons_translations
    ADD CONSTRAINT seasons_translations_languages_code_foreign FOREIGN KEY (languages_code) REFERENCES public.languages(code) ON DELETE CASCADE;


--
-- Name: seasons_translations seasons_translations_seasons_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.seasons_translations
    ADD CONSTRAINT seasons_translations_seasons_id_foreign FOREIGN KEY (seasons_id) REFERENCES public.seasons(id) ON DELETE CASCADE;


--
-- Name: seasons seasons_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.seasons
    ADD CONSTRAINT seasons_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id);


--
-- Name: seasons seasons_user_updated_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.seasons
    ADD CONSTRAINT seasons_user_updated_foreign FOREIGN KEY (user_updated) REFERENCES public.directus_users(id);


--
-- Name: seasons_usergroups seasons_usergroups_seasons_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.seasons_usergroups
    ADD CONSTRAINT seasons_usergroups_seasons_id_foreign FOREIGN KEY (seasons_id) REFERENCES public.seasons(id);


--
-- Name: seasons_usergroups seasons_usergroups_usergroups_code_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.seasons_usergroups
    ADD CONSTRAINT seasons_usergroups_usergroups_code_foreign FOREIGN KEY (usergroups_code) REFERENCES public.usergroups(code);


--
-- Name: sections sections_collection_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.sections
    ADD CONSTRAINT sections_collection_id_foreign FOREIGN KEY (collection_id) REFERENCES public.collections(id) ON DELETE SET NULL;


--
-- Name: sections sections_page_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.sections
    ADD CONSTRAINT sections_page_foreign FOREIGN KEY (page) REFERENCES public.pages(id);


--
-- Name: sections_translations sections_translations_languages_code_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.sections_translations
    ADD CONSTRAINT sections_translations_languages_code_foreign FOREIGN KEY (languages_code) REFERENCES public.languages(code);


--
-- Name: sections_translations sections_translations_sections_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.sections_translations
    ADD CONSTRAINT sections_translations_sections_id_foreign FOREIGN KEY (sections_id) REFERENCES public.sections(id) ON DELETE CASCADE;


--
-- Name: sections sections_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.sections
    ADD CONSTRAINT sections_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id);


--
-- Name: sections sections_user_updated_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.sections
    ADD CONSTRAINT sections_user_updated_foreign FOREIGN KEY (user_updated) REFERENCES public.directus_users(id);


--
-- Name: sections_usergroups sections_usergroups_sections_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.sections_usergroups
    ADD CONSTRAINT sections_usergroups_sections_id_foreign FOREIGN KEY (sections_id) REFERENCES public.sections(id) ON DELETE CASCADE;


--
-- Name: sections_usergroups sections_usergroups_usergroups_code_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.sections_usergroups
    ADD CONSTRAINT sections_usergroups_usergroups_code_foreign FOREIGN KEY (usergroups_code) REFERENCES public.usergroups(code) ON DELETE CASCADE;


--
-- Name: shows shows_agerating_code_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.shows
    ADD CONSTRAINT shows_agerating_code_foreign FOREIGN KEY (agerating_code) REFERENCES public.ageratings(code) ON DELETE SET NULL;


--
-- Name: shows shows_image_file_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.shows
    ADD CONSTRAINT shows_image_file_id_foreign FOREIGN KEY (image_file_id) REFERENCES public.directus_files(id) ON DELETE SET NULL;


--
-- Name: shows_translations shows_translations_languages_code_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.shows_translations
    ADD CONSTRAINT shows_translations_languages_code_foreign FOREIGN KEY (languages_code) REFERENCES public.languages(code) ON DELETE CASCADE;


--
-- Name: shows_translations shows_translations_shows_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.shows_translations
    ADD CONSTRAINT shows_translations_shows_id_foreign FOREIGN KEY (shows_id) REFERENCES public.shows(id) ON DELETE CASCADE;


--
-- Name: shows shows_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.shows
    ADD CONSTRAINT shows_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id);


--
-- Name: shows shows_user_updated_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.shows
    ADD CONSTRAINT shows_user_updated_foreign FOREIGN KEY (user_updated) REFERENCES public.directus_users(id);


--
-- Name: shows_usergroups shows_usergroups_shows_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.shows_usergroups
    ADD CONSTRAINT shows_usergroups_shows_id_foreign FOREIGN KEY (shows_id) REFERENCES public.shows(id);


--
-- Name: shows_usergroups shows_usergroups_usergroups_code_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.shows_usergroups
    ADD CONSTRAINT shows_usergroups_usergroups_code_foreign FOREIGN KEY (usergroups_code) REFERENCES public.usergroups(code);


--
-- Name: tags tags_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tags_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id);


--
-- Name: tags tags_user_updated_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tags_user_updated_foreign FOREIGN KEY (user_updated) REFERENCES public.directus_users(id);


--
-- Name: tvguideentry tvguideentry_event_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.tvguideentry
    ADD CONSTRAINT tvguideentry_event_foreign FOREIGN KEY (event) REFERENCES public.calendarevent(id) ON DELETE SET NULL;


--
-- Name: tvguideentry tvguideentry_image_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.tvguideentry
    ADD CONSTRAINT tvguideentry_image_foreign FOREIGN KEY (image) REFERENCES public.directus_files(id) ON DELETE SET NULL;


--
-- Name: tvguideentry_link tvguideentry_link_tvguideentry_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.tvguideentry_link
    ADD CONSTRAINT tvguideentry_link_tvguideentry_id_foreign FOREIGN KEY (tvguideentry_id) REFERENCES public.tvguideentry(id) ON DELETE SET NULL;


--
-- Name: tvguideentry tvguideentry_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.tvguideentry
    ADD CONSTRAINT tvguideentry_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id);


--
-- Name: tvguideentry tvguideentry_user_updated_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.tvguideentry
    ADD CONSTRAINT tvguideentry_user_updated_foreign FOREIGN KEY (user_updated) REFERENCES public.directus_users(id);


--
-- Name: usergroups usergroups_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.usergroups
    ADD CONSTRAINT usergroups_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id);


--
-- Name: usergroups usergroups_user_updated_foreign; Type: FK CONSTRAINT; Schema: public; Owner: btv
--

ALTER TABLE ONLY public.usergroups
    ADD CONSTRAINT usergroups_user_updated_foreign FOREIGN KEY (user_updated) REFERENCES public.directus_users(id);


--
-- PostgreSQL database dump complete
--

