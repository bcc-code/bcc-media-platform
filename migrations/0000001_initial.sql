-- +goose Up
-- PostgreSQL database dump
--

-- Dumped from database version 13.7
-- Dumped by pg_dump version 14.5 (Ubuntu 14.5-1.pgdg22.04+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
--SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: nametolowercase(); Type: FUNCTION; Schema: public; Owner: directus@btv-platform-dev-2.iam
--
-- +goose StatementBegin
CREATE FUNCTION public.nametolowercase() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	NEW.Name = lower(NEW.Name);
	RETURN NEW;
END;
$$;
-- +goose StatementEnd


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: ageratings; Type: TABLE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE TABLE public.ageratings (
    code character varying(255) DEFAULT NULL::character varying NOT NULL,
    sort integer,
    date_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    date_updated timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    title character varying(255) DEFAULT NULL::character varying
);



--
-- Name: ageratings_translations; Type: TABLE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE TABLE public.ageratings_translations (
    id integer NOT NULL,
    ageratings_code character varying(255) DEFAULT NULL::character varying NOT NULL,
    languages_code character varying(255) DEFAULT NULL::character varying NOT NULL,
    description character varying(255) DEFAULT NULL::character varying
);



--
-- Name: ageratings_translations_id_seq; Type: SEQUENCE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE SEQUENCE public.ageratings_translations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
--



--
-- Name: appconfig; Type: TABLE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE TABLE public.appconfig (
    app_version character varying(255) DEFAULT NULL::character varying NOT NULL,
    date_updated timestamp with time zone NOT NULL,
    id integer NOT NULL,
    user_updated uuid NOT NULL
);



--
-- Name: appconfig_id_seq; Type: SEQUENCE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE SEQUENCE public.appconfig_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
--



--
-- Name: assetfiles; Type: TABLE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE TABLE public.assetfiles (
    id integer NOT NULL,
    user_created uuid,
    date_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    user_updated uuid,
    date_updated timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    type character varying(255) DEFAULT NULL::character varying NOT NULL,
    asset_id integer NOT NULL,
    extra_metadata json,
    path character varying(255) DEFAULT NULL::character varying NOT NULL,
    audio_language_id character varying(255) DEFAULT NULL::character varying,
    subtitle_language_id character varying(255) DEFAULT NULL::character varying,
    mime_type character varying(255) DEFAULT NULL::character varying NOT NULL,
    storage character varying(255) DEFAULT NULL::character varying NOT NULL
);



--
-- Name: assetfiles_id_seq; Type: SEQUENCE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE SEQUENCE public.assetfiles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
--



--
-- Name: assets; Type: TABLE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE TABLE public.assets (
    id integer NOT NULL,
    user_created uuid,
    date_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    user_updated uuid,
    date_updated timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    name character varying(255) DEFAULT NULL::character varying NOT NULL,
    duration integer NOT NULL,
    mediabanken_id character varying(255) DEFAULT NULL::character varying,
    legacy_id integer,
    encoding_version character varying(255) DEFAULT NULL::character varying,
    main_storage_path text,
    status character varying(255) DEFAULT 'draft'::character varying
);



--
-- Name: assets_id_seq; Type: SEQUENCE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE SEQUENCE public.assets_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
--



--
-- Name: assetstreams; Type: TABLE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE TABLE public.assetstreams (
    id integer NOT NULL,
    status character varying(255) DEFAULT 'draft'::character varying NOT NULL,
    user_created uuid,
    date_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    user_updated uuid,
    date_updated timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    url character varying(255) DEFAULT NULL::character varying NOT NULL,
    type character varying(255) DEFAULT NULL::character varying NOT NULL,
    extra_metadata json,
    asset_id integer NOT NULL,
    path character varying(255) DEFAULT NULL::character varying NOT NULL,
    service character varying(255) DEFAULT NULL::character varying NOT NULL,
    encryption_key_id character varying(255) DEFAULT NULL::character varying,
    legacy_videourl_id integer
);



--
-- Name: assetstreams_audio_languages; Type: TABLE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE TABLE public.assetstreams_audio_languages (
    id integer NOT NULL,
    assetstreams_id integer,
    languages_code character varying(255) DEFAULT NULL::character varying
);



--
-- Name: assetstreams_audio_languages_id_seq; Type: SEQUENCE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE SEQUENCE public.assetstreams_audio_languages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
--



--
-- Name: assetstreams_id_seq; Type: SEQUENCE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE SEQUENCE public.assetstreams_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
--



--
-- Name: assetstreams_subtitle_languages; Type: TABLE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE TABLE public.assetstreams_subtitle_languages (
    id integer NOT NULL,
    assetstreams_id integer,
    languages_code character varying(255) DEFAULT NULL::character varying
);



--
-- Name: assetstreams_subtitle_languages_id_seq; Type: SEQUENCE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE SEQUENCE public.assetstreams_subtitle_languages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
--



--
-- Name: calendarentries; Type: TABLE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE TABLE public.calendarentries (
    date_created timestamp with time zone,
    date_updated timestamp with time zone,
    "end" timestamp without time zone NOT NULL,
    episode_id integer,
    event_id integer,
    id integer NOT NULL,
    image uuid,
    image_from_link boolean DEFAULT true NOT NULL,
    link_type character varying(255) DEFAULT NULL::character varying,
    season_id integer,
    show_id integer,
    start timestamp without time zone NOT NULL,
    status character varying(255) DEFAULT 'draft'::character varying NOT NULL,
    user_created uuid,
    user_updated uuid
);



--
-- Name: calendarentries_id_seq; Type: SEQUENCE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE SEQUENCE public.calendarentries_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
--



--
-- Name: calendarentries_translations; Type: TABLE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE TABLE public.calendarentries_translations (
    calendarentries_id integer,
    description character varying(255) DEFAULT NULL::character varying,
    id integer NOT NULL,
    languages_code character varying(255) DEFAULT NULL::character varying,
    title character varying(255) DEFAULT NULL::character varying
);



--
-- Name: calendarentries_translations_id_seq; Type: SEQUENCE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE SEQUENCE public.calendarentries_translations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
--



--
-- Name: calendarevent; Type: TABLE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE TABLE public.calendarevent (
    id integer NOT NULL,
    status character varying(255) DEFAULT 'draft'::character varying NOT NULL,
    user_created uuid,
    date_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    user_updated uuid,
    date_updated timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    start timestamp without time zone NOT NULL,
    "end" timestamp without time zone,
    title character varying(255) DEFAULT NULL::character varying
);



--
-- Name: calendarevent_id_seq; Type: SEQUENCE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE SEQUENCE public.calendarevent_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
--



--
-- Name: categories; Type: TABLE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE TABLE public.categories (
    id integer NOT NULL,
    sort integer,
    user_created uuid,
    date_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    user_updated uuid,
    date_updated timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    appear_in_search boolean DEFAULT false,
    parent_id integer,
    legacy_id integer
);



--
-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE SEQUENCE public.categories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
--



--
-- Name: categories_translations; Type: TABLE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE TABLE public.categories_translations (
    id integer NOT NULL,
    categories_id integer NOT NULL,
    languages_code character varying(255) DEFAULT NULL::character varying NOT NULL,
    name character varying(255) DEFAULT NULL::character varying NOT NULL
);



--
-- Name: categories_translations_id_seq; Type: SEQUENCE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE SEQUENCE public.categories_translations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
--



--
-- Name: collections; Type: TABLE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE TABLE public.collections (
    id integer NOT NULL,
    sort integer,
    user_created uuid,
    date_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    user_updated uuid,
    date_updated timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    collection character varying(255) DEFAULT 'pages'::character varying,
    episodes_query_filter json,
    filter_type character varying(255) DEFAULT 'select'::character varying,
    name character varying(255) DEFAULT NULL::character varying,
    pages_query_filter json,
    seasons_query_filter json,
    shows_query_filter json
);



--
-- Name: collections_id_seq; Type: SEQUENCE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE SEQUENCE public.collections_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
--



--
-- Name: collections_items; Type: TABLE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE TABLE public.collections_items (
    collection_id integer,
    date_created timestamp with time zone,
    date_updated timestamp with time zone,
    episode_id integer,
    id integer NOT NULL,
    page_id integer,
    season_id integer,
    show_id integer,
    sort integer,
    type character varying(255) DEFAULT NULL::character varying,
    user_created uuid,
    user_updated uuid
);



--
-- Name: collections_items_id_seq; Type: SEQUENCE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE SEQUENCE public.collections_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
--



--
-- Name: directus_activity; Type: TABLE; Schema: public; Owner: directus@btv-platform-dev-2.iam
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



--
-- Name: directus_activity_id_seq; Type: SEQUENCE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE SEQUENCE public.directus_activity_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
--



--
-- Name: directus_collections; Type: TABLE; Schema: public; Owner: directus@btv-platform-dev-2.iam
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



--
-- Name: directus_dashboards; Type: TABLE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE TABLE public.directus_dashboards (
    id uuid NOT NULL,
    name character varying(255) NOT NULL,
    icon character varying(30) DEFAULT 'dashboard'::character varying NOT NULL,
    note text,
    date_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    user_created uuid
);



--
-- Name: directus_fields; Type: TABLE; Schema: public; Owner: directus@btv-platform-dev-2.iam
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



--
-- Name: directus_fields_id_seq; Type: SEQUENCE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE SEQUENCE public.directus_fields_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
--



--
-- Name: directus_files; Type: TABLE; Schema: public; Owner: directus@btv-platform-dev-2.iam
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



--
-- Name: directus_flows; Type: TABLE; Schema: public; Owner: directus@btv-platform-dev-2.iam
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



--
-- Name: directus_folders; Type: TABLE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE TABLE public.directus_folders (
    id uuid NOT NULL,
    name character varying(255) NOT NULL,
    parent uuid
);



--
-- Name: directus_migrations; Type: TABLE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE TABLE public.directus_migrations (
    version character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    "timestamp" timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);



--
-- Name: directus_notifications; Type: TABLE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE TABLE public.directus_notifications (
    id integer NOT NULL,
    "timestamp" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    status character varying(255) DEFAULT 'inbox'::character varying,
    recipient uuid NOT NULL,
    sender uuid,
    subject character varying(255) NOT NULL,
    message text,
    collection character varying(64),
    item character varying(255)
);



--
-- Name: directus_notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE SEQUENCE public.directus_notifications_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
--



--
-- Name: directus_operations; Type: TABLE; Schema: public; Owner: directus@btv-platform-dev-2.iam
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



--
-- Name: directus_panels; Type: TABLE; Schema: public; Owner: directus@btv-platform-dev-2.iam
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



--
-- Name: directus_permissions; Type: TABLE; Schema: public; Owner: directus@btv-platform-dev-2.iam
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



--
-- Name: directus_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE SEQUENCE public.directus_permissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
--



--
-- Name: directus_presets; Type: TABLE; Schema: public; Owner: directus@btv-platform-dev-2.iam
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



--
-- Name: directus_presets_id_seq; Type: SEQUENCE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE SEQUENCE public.directus_presets_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
--



--
-- Name: directus_relations; Type: TABLE; Schema: public; Owner: directus@btv-platform-dev-2.iam
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



--
-- Name: directus_relations_id_seq; Type: SEQUENCE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE SEQUENCE public.directus_relations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
--



--
-- Name: directus_revisions; Type: TABLE; Schema: public; Owner: directus@btv-platform-dev-2.iam
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



--
-- Name: directus_revisions_id_seq; Type: SEQUENCE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE SEQUENCE public.directus_revisions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
--



--
-- Name: directus_roles; Type: TABLE; Schema: public; Owner: directus@btv-platform-dev-2.iam
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



--
-- Name: directus_sessions; Type: TABLE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE TABLE public.directus_sessions (
    token character varying(64) NOT NULL,
    "user" uuid,
    expires timestamp with time zone NOT NULL,
    ip character varying(255),
    user_agent character varying(255),
    share uuid
);



--
-- Name: directus_settings; Type: TABLE; Schema: public; Owner: directus@btv-platform-dev-2.iam
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
    default_language character varying(255) DEFAULT 'en-US'::character varying NOT NULL,
    custom_aspect_ratios json
);



--
-- Name: directus_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE SEQUENCE public.directus_settings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
--



--
-- Name: directus_shares; Type: TABLE; Schema: public; Owner: directus@btv-platform-dev-2.iam
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



--
-- Name: directus_users; Type: TABLE; Schema: public; Owner: directus@btv-platform-dev-2.iam
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



--
-- Name: directus_webhooks; Type: TABLE; Schema: public; Owner: directus@btv-platform-dev-2.iam
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



--
-- Name: directus_webhooks_id_seq; Type: SEQUENCE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE SEQUENCE public.directus_webhooks_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
--



--
-- Name: episodes; Type: TABLE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE TABLE public.episodes (
    id integer NOT NULL,
    status character varying(255) DEFAULT 'draft'::character varying NOT NULL,
    user_created uuid,
    date_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    user_updated uuid,
    date_updated timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    available_from timestamp without time zone,
    available_to timestamp without time zone,
    agerating_code character varying(255) DEFAULT NULL::character varying,
    season_id integer,
    migration_data json,
    publish_date timestamp without time zone NOT NULL,
    type character varying(255) DEFAULT 'episode'::character varying NOT NULL,
    image_file_id uuid,
    legacy_id integer,
    episode_number integer,
    legacy_program_id integer,
    asset_id integer,
    legacy_title_id integer,
    legacy_description_id integer,
    legacy_extra_description_id integer,
    legacy_tags_id integer
);



--
-- Name: episodes_categories; Type: TABLE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE TABLE public.episodes_categories (
    id integer NOT NULL,
    episodes_id integer NOT NULL,
    categories_id integer NOT NULL
);



--
-- Name: episodes_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE SEQUENCE public.episodes_categories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
--



--
-- Name: episodes_id_seq; Type: SEQUENCE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE SEQUENCE public.episodes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
--



--
-- Name: episodes_tags; Type: TABLE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE TABLE public.episodes_tags (
    id integer NOT NULL,
    episodes_id integer NOT NULL,
    tags_id integer NOT NULL
);



--
-- Name: episodes_tags_id_seq; Type: SEQUENCE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE SEQUENCE public.episodes_tags_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
--



--
-- Name: episodes_translations; Type: TABLE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE TABLE public.episodes_translations (
    id integer NOT NULL,
    episodes_id integer NOT NULL,
    languages_code character varying(255) DEFAULT NULL::character varying NOT NULL,
    title character varying(255) DEFAULT NULL::character varying,
    description text,
    extra_description text,
    is_primary boolean DEFAULT true NOT NULL
);



--
-- Name: episodes_translations_id_seq; Type: SEQUENCE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE SEQUENCE public.episodes_translations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
--



--
-- Name: episodes_usergroups; Type: TABLE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE TABLE public.episodes_usergroups (
    id integer NOT NULL,
    episodes_id integer NOT NULL,
    usergroups_code character varying(255) DEFAULT NULL::character varying NOT NULL,
    type character varying(255) DEFAULT NULL::character varying,
    date_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    date_updated timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);



--
-- Name: episodes_usergroups_download; Type: TABLE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE TABLE public.episodes_usergroups_download (
    id integer NOT NULL,
    episodes_id integer NOT NULL,
    usergroups_code character varying(255) DEFAULT NULL::character varying NOT NULL,
    date_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    date_updated timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);



--
-- Name: episodes_usergroups_download_id_seq; Type: SEQUENCE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE SEQUENCE public.episodes_usergroups_download_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
--



--
-- Name: episodes_usergroups_earlyaccess; Type: TABLE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE TABLE public.episodes_usergroups_earlyaccess (
    id integer NOT NULL,
    episodes_id integer NOT NULL,
    usergroups_code character varying(255) DEFAULT NULL::character varying NOT NULL,
    date_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    date_updated timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);



--
-- Name: episodes_usergroups_earlyaccess_id_seq; Type: SEQUENCE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE SEQUENCE public.episodes_usergroups_earlyaccess_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
--



--
-- Name: episodes_usergroups_id_seq; Type: SEQUENCE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE SEQUENCE public.episodes_usergroups_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
--



--
-- Name: events; Type: TABLE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE TABLE public.events (
    date_created timestamp with time zone,
    date_updated timestamp with time zone,
    "end" timestamp without time zone NOT NULL,
    id integer NOT NULL,
    start timestamp without time zone NOT NULL,
    status character varying(255) DEFAULT 'draft'::character varying NOT NULL,
    user_created uuid,
    user_updated uuid
);



--
-- Name: events_id_seq; Type: SEQUENCE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE SEQUENCE public.events_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
--



--
-- Name: events_translations; Type: TABLE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE TABLE public.events_translations (
    description character varying(255) DEFAULT NULL::character varying,
    events_id integer,
    id integer NOT NULL,
    languages_code character varying(255) DEFAULT NULL::character varying,
    title character varying(255) DEFAULT NULL::character varying
);



--
-- Name: events_translations_id_seq; Type: SEQUENCE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE SEQUENCE public.events_translations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
--



--
-- Name: faq_categories; Type: TABLE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE TABLE public.faq_categories (
    id integer NOT NULL,
    sort integer,
    status character varying(255) DEFAULT 'draft'::character varying NOT NULL
);



--
-- Name: faq_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE SEQUENCE public.faq_categories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
--



--
-- Name: faq_categories_translations; Type: TABLE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE TABLE public.faq_categories_translations (
    faq_categories_id integer,
    id integer NOT NULL,
    languages_code character varying(255) DEFAULT NULL::character varying,
    title character varying(255) DEFAULT NULL::character varying
);



--
-- Name: faq_categories_translations_id_seq; Type: SEQUENCE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE SEQUENCE public.faq_categories_translations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
--



--
-- Name: faqs; Type: TABLE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE TABLE public.faqs (
    category integer NOT NULL,
    date_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    date_updated timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    id integer NOT NULL,
    sort integer,
    status character varying(255) DEFAULT 'draft'::character varying NOT NULL,
    user_created uuid NOT NULL,
    user_updated uuid NOT NULL
);



--
-- Name: faqs_id_seq; Type: SEQUENCE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE SEQUENCE public.faqs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
--



--
-- Name: faqs_translations; Type: TABLE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE TABLE public.faqs_translations (
    answer text,
    faqs_id integer,
    id integer NOT NULL,
    languages_code character varying(255) DEFAULT NULL::character varying,
    question character varying(255) DEFAULT NULL::character varying
);



--
-- Name: faqs_translations_id_seq; Type: SEQUENCE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE SEQUENCE public.faqs_translations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
--



--
-- Name: faqs_usergroups; Type: TABLE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE TABLE public.faqs_usergroups (
    faqs_id integer,
    id integer NOT NULL,
    usergroups_code character varying(255) DEFAULT NULL::character varying
);



--
-- Name: faqs_usergroups_id_seq; Type: SEQUENCE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE SEQUENCE public.faqs_usergroups_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
--



--
-- Name: globalconfig; Type: TABLE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE TABLE public.globalconfig (
    date_updated timestamp with time zone NOT NULL,
    id integer NOT NULL,
    live_online boolean DEFAULT false,
    npaw_enabled boolean DEFAULT false,
    user_updated uuid NOT NULL
);



--
-- Name: globalconfig_id_seq; Type: SEQUENCE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE SEQUENCE public.globalconfig_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
--



--
-- Name: languages; Type: TABLE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE TABLE public.languages (
    code character varying(255) DEFAULT NULL::character varying NOT NULL,
    name character varying(255) DEFAULT NULL::character varying,
    legacy_3_letter_code character varying(255) DEFAULT NULL::character varying,
    legacy_2_letter_code character varying(255) DEFAULT NULL::character varying
);



--
-- Name: lists; Type: TABLE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE TABLE public.lists (
    id integer NOT NULL,
    user_created uuid,
    date_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    user_updated uuid,
    date_updated timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    name character varying(255) DEFAULT NULL::character varying NOT NULL,
    legacy_category_id integer,
    legacy_name_id integer
);



--
-- Name: lists_id_seq; Type: SEQUENCE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE SEQUENCE public.lists_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
--



--
-- Name: lists_relations; Type: TABLE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE TABLE public.lists_relations (
    id integer NOT NULL,
    lists_id integer,
    item character varying(255) DEFAULT NULL::character varying,
    collection character varying(255) DEFAULT NULL::character varying,
    sort integer
);



--
-- Name: lists_relations_id_seq; Type: SEQUENCE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE SEQUENCE public.lists_relations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
--



--
-- Name: maintenancemessage; Type: TABLE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE TABLE public.maintenancemessage (
    active boolean DEFAULT false,
    date_updated timestamp with time zone,
    id integer NOT NULL,
    user_updated uuid
);



--
-- Name: maintenancemessage_id_seq; Type: SEQUENCE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE SEQUENCE public.maintenancemessage_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
--



--
-- Name: maintenancemessage_messagetemplates; Type: TABLE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE TABLE public.maintenancemessage_messagetemplates (
    id integer NOT NULL,
    maintenancemessage_id integer,
    messagetemplates_id integer,
    sort integer
);



--
-- Name: maintenancemessage_messagetemplates_id_seq; Type: SEQUENCE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE SEQUENCE public.maintenancemessage_messagetemplates_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
--



--
-- Name: materialized_views_meta; Type: TABLE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE TABLE public.materialized_views_meta (
    view_name text NOT NULL,
    last_refreshed timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);



--
-- Name: messagetemplates; Type: TABLE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE TABLE public.messagetemplates (
    date_created timestamp with time zone,
    date_updated timestamp with time zone,
    id integer NOT NULL,
    status character varying(255) DEFAULT 'draft'::character varying NOT NULL,
    type character varying(255) DEFAULT 'error'::character varying NOT NULL,
    user_created uuid,
    user_updated uuid
);



--
-- Name: messagetemplates_id_seq; Type: SEQUENCE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE SEQUENCE public.messagetemplates_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
--



--
-- Name: messagetemplates_translations; Type: TABLE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE TABLE public.messagetemplates_translations (
    details text,
    id integer NOT NULL,
    languages_code character varying(255) DEFAULT NULL::character varying,
    message character varying(255) DEFAULT NULL::character varying NOT NULL,
    messagetemplates_id integer
);



--
-- Name: messagetemplates_translations_id_seq; Type: SEQUENCE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE SEQUENCE public.messagetemplates_translations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
--



--
-- Name: pages; Type: TABLE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE TABLE public.pages (
    id integer NOT NULL,
    status character varying(255) DEFAULT 'draft'::character varying NOT NULL,
    sort integer,
    user_created uuid,
    date_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    user_updated uuid,
    date_updated timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    code character varying(255) DEFAULT NULL::character varying,
    collection character varying(255) DEFAULT NULL::character varying,
    episode_id integer,
    season_id integer,
    show_id integer,
    type character varying(255) DEFAULT NULL::character varying
);



--
-- Name: pages_id_seq; Type: SEQUENCE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE SEQUENCE public.pages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
--



--
-- Name: pages_translations; Type: TABLE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE TABLE public.pages_translations (
    id integer NOT NULL,
    pages_id integer,
    languages_code character varying(255),
    title character varying(255),
    description character varying(255)
);



--
-- Name: pages_translations_id_seq; Type: SEQUENCE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE SEQUENCE public.pages_translations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
--



--
-- Name: seasons; Type: TABLE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE TABLE public.seasons (
    id integer NOT NULL,
    status character varying(255) DEFAULT 'draft'::character varying NOT NULL,
    user_created uuid,
    date_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    user_updated uuid,
    date_updated timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    available_from timestamp without time zone,
    available_to timestamp without time zone,
    show_id integer NOT NULL,
    agerating_code character varying(255) DEFAULT NULL::character varying,
    publish_date timestamp without time zone NOT NULL,
    image_file_id uuid,
    legacy_id integer,
    season_number integer NOT NULL,
    legacy_title_id integer,
    legacy_description_id integer
);



--
-- Name: seasons_id_seq; Type: SEQUENCE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE SEQUENCE public.seasons_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
--



--
-- Name: seasons_translations; Type: TABLE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE TABLE public.seasons_translations (
    id integer NOT NULL,
    seasons_id integer NOT NULL,
    languages_code character varying(255) DEFAULT NULL::character varying NOT NULL,
    title character varying(255) DEFAULT NULL::character varying,
    description text,
    legacy_title_id integer,
    legacy_description_id integer,
    is_primary boolean DEFAULT false NOT NULL
);



--
-- Name: seasons_translations_id_seq; Type: SEQUENCE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE SEQUENCE public.seasons_translations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
--



--
-- Name: seasons_usergroups; Type: TABLE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE TABLE public.seasons_usergroups (
    id integer NOT NULL,
    seasons_id integer NOT NULL,
    usergroups_code character varying(255) DEFAULT NULL::character varying NOT NULL
);



--
-- Name: seasons_usergroups_id_seq; Type: SEQUENCE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE SEQUENCE public.seasons_usergroups_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
--



--
-- Name: sections; Type: TABLE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE TABLE public.sections (
    id integer NOT NULL,
    status character varying(255) DEFAULT 'draft'::character varying NOT NULL,
    user_created uuid,
    date_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    user_updated uuid,
    date_updated timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    collection_id integer,
    page_id integer,
    sort integer,
    style character varying(255) DEFAULT NULL::character varying
);



--
-- Name: sections_id_seq; Type: SEQUENCE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE SEQUENCE public.sections_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
--



--
-- Name: sections_translations; Type: TABLE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE TABLE public.sections_translations (
    id integer NOT NULL,
    sections_id integer,
    languages_code character varying(255) DEFAULT NULL::character varying,
    title character varying(255) DEFAULT NULL::character varying,
    description character varying(255) DEFAULT NULL::character varying
);



--
-- Name: sections_translations_id_seq; Type: SEQUENCE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE SEQUENCE public.sections_translations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
--



--
-- Name: sections_usergroups; Type: TABLE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE TABLE public.sections_usergroups (
    id integer NOT NULL,
    sections_id integer NOT NULL,
    usergroups_code character varying(255) DEFAULT NULL::character varying NOT NULL
);



--
-- Name: sections_usergroups_id_seq; Type: SEQUENCE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE SEQUENCE public.sections_usergroups_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
--



--
-- Name: shows; Type: TABLE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE TABLE public.shows (
    id integer NOT NULL,
    status character varying(255) DEFAULT 'draft'::character varying NOT NULL,
    user_created uuid,
    date_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    user_updated uuid,
    date_updated timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    available_from timestamp without time zone,
    available_to timestamp without time zone,
    publish_date timestamp without time zone NOT NULL,
    type character varying(255) DEFAULT NULL::character varying NOT NULL,
    agerating_code character varying(255) DEFAULT NULL::character varying,
    image_file_id uuid,
    legacy_id integer,
    legacy_title_id integer,
    legacy_description_id integer
);



--
-- Name: shows_id_seq; Type: SEQUENCE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE SEQUENCE public.shows_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
--



--
-- Name: shows_translations; Type: TABLE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE TABLE public.shows_translations (
    id integer NOT NULL,
    shows_id integer NOT NULL,
    languages_code character varying(255) DEFAULT NULL::character varying NOT NULL,
    title character varying(255) DEFAULT NULL::character varying,
    description text,
    legacy_tags character varying(255) DEFAULT NULL::character varying,
    legacy_title_id bigint,
    legacy_description_id integer,
    legacy_tags_id integer,
    is_primary boolean DEFAULT false NOT NULL
);



--
-- Name: shows_translations_id_seq; Type: SEQUENCE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE SEQUENCE public.shows_translations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
--



--
-- Name: shows_usergroups; Type: TABLE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE TABLE public.shows_usergroups (
    id integer NOT NULL,
    shows_id integer NOT NULL,
    usergroups_code character varying(255) DEFAULT NULL::character varying NOT NULL
);



--
-- Name: shows_usergroups_id_seq; Type: SEQUENCE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE SEQUENCE public.shows_usergroups_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
--



--
-- Name: tags; Type: TABLE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE TABLE public.tags (
    id integer NOT NULL,
    user_created uuid,
    date_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    user_updated uuid,
    date_updated timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    code character varying(255) DEFAULT NULL::character varying,
    name character varying(255) DEFAULT NULL::character varying NOT NULL
);



--
-- Name: tags_id_seq; Type: SEQUENCE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE SEQUENCE public.tags_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
--



--
-- Name: tags_translations; Type: TABLE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE TABLE public.tags_translations (
    id integer NOT NULL,
    languages_code character varying(255) DEFAULT NULL::character varying,
    name character varying(255) DEFAULT NULL::character varying,
    tags_id integer
);



--
-- Name: tags_translations_id_seq; Type: SEQUENCE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE SEQUENCE public.tags_translations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
--



--
-- Name: usergroups; Type: TABLE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE TABLE public.usergroups (
    code character varying(255) DEFAULT NULL::character varying NOT NULL,
    sort integer,
    user_created uuid,
    date_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    user_updated uuid,
    date_updated timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    name character varying(255) DEFAULT NULL::character varying NOT NULL,
    emails text
);



--
-- Name: webconfig; Type: TABLE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE TABLE public.webconfig (
    date_updated timestamp with time zone NOT NULL,
    id integer NOT NULL,
    user_updated uuid NOT NULL
);



--
-- Name: webconfig_id_seq; Type: SEQUENCE; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE SEQUENCE public.webconfig_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
--



--
-- Name: ageratings_translations id; Type: DEFAULT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.ageratings_translations ALTER COLUMN id SET DEFAULT nextval('public.ageratings_translations_id_seq'::regclass);


--
-- Name: appconfig id; Type: DEFAULT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.appconfig ALTER COLUMN id SET DEFAULT nextval('public.appconfig_id_seq'::regclass);


--
-- Name: assetfiles id; Type: DEFAULT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.assetfiles ALTER COLUMN id SET DEFAULT nextval('public.assetfiles_id_seq'::regclass);


--
-- Name: assets id; Type: DEFAULT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.assets ALTER COLUMN id SET DEFAULT nextval('public.assets_id_seq'::regclass);


--
-- Name: assetstreams id; Type: DEFAULT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.assetstreams ALTER COLUMN id SET DEFAULT nextval('public.assetstreams_id_seq'::regclass);


--
-- Name: assetstreams_audio_languages id; Type: DEFAULT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.assetstreams_audio_languages ALTER COLUMN id SET DEFAULT nextval('public.assetstreams_audio_languages_id_seq'::regclass);


--
-- Name: assetstreams_subtitle_languages id; Type: DEFAULT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.assetstreams_subtitle_languages ALTER COLUMN id SET DEFAULT nextval('public.assetstreams_subtitle_languages_id_seq'::regclass);


--
-- Name: calendarentries id; Type: DEFAULT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.calendarentries ALTER COLUMN id SET DEFAULT nextval('public.calendarentries_id_seq'::regclass);


--
-- Name: calendarentries_translations id; Type: DEFAULT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.calendarentries_translations ALTER COLUMN id SET DEFAULT nextval('public.calendarentries_translations_id_seq'::regclass);


--
-- Name: calendarevent id; Type: DEFAULT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.calendarevent ALTER COLUMN id SET DEFAULT nextval('public.calendarevent_id_seq'::regclass);


--
-- Name: categories id; Type: DEFAULT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.categories ALTER COLUMN id SET DEFAULT nextval('public.categories_id_seq'::regclass);


--
-- Name: categories_translations id; Type: DEFAULT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.categories_translations ALTER COLUMN id SET DEFAULT nextval('public.categories_translations_id_seq'::regclass);


--
-- Name: collections id; Type: DEFAULT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.collections ALTER COLUMN id SET DEFAULT nextval('public.collections_id_seq'::regclass);


--
-- Name: collections_items id; Type: DEFAULT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.collections_items ALTER COLUMN id SET DEFAULT nextval('public.collections_items_id_seq'::regclass);


--
-- Name: directus_activity id; Type: DEFAULT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.directus_activity ALTER COLUMN id SET DEFAULT nextval('public.directus_activity_id_seq'::regclass);


--
-- Name: directus_fields id; Type: DEFAULT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.directus_fields ALTER COLUMN id SET DEFAULT nextval('public.directus_fields_id_seq'::regclass);


--
-- Name: directus_notifications id; Type: DEFAULT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.directus_notifications ALTER COLUMN id SET DEFAULT nextval('public.directus_notifications_id_seq'::regclass);


--
-- Name: directus_permissions id; Type: DEFAULT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.directus_permissions ALTER COLUMN id SET DEFAULT nextval('public.directus_permissions_id_seq'::regclass);


--
-- Name: directus_presets id; Type: DEFAULT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.directus_presets ALTER COLUMN id SET DEFAULT nextval('public.directus_presets_id_seq'::regclass);


--
-- Name: directus_relations id; Type: DEFAULT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.directus_relations ALTER COLUMN id SET DEFAULT nextval('public.directus_relations_id_seq'::regclass);


--
-- Name: directus_revisions id; Type: DEFAULT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.directus_revisions ALTER COLUMN id SET DEFAULT nextval('public.directus_revisions_id_seq'::regclass);


--
-- Name: directus_settings id; Type: DEFAULT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.directus_settings ALTER COLUMN id SET DEFAULT nextval('public.directus_settings_id_seq'::regclass);


--
-- Name: directus_webhooks id; Type: DEFAULT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.directus_webhooks ALTER COLUMN id SET DEFAULT nextval('public.directus_webhooks_id_seq'::regclass);


--
-- Name: episodes id; Type: DEFAULT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.episodes ALTER COLUMN id SET DEFAULT nextval('public.episodes_id_seq'::regclass);


--
-- Name: episodes_categories id; Type: DEFAULT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.episodes_categories ALTER COLUMN id SET DEFAULT nextval('public.episodes_categories_id_seq'::regclass);


--
-- Name: episodes_tags id; Type: DEFAULT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.episodes_tags ALTER COLUMN id SET DEFAULT nextval('public.episodes_tags_id_seq'::regclass);


--
-- Name: episodes_translations id; Type: DEFAULT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.episodes_translations ALTER COLUMN id SET DEFAULT nextval('public.episodes_translations_id_seq'::regclass);


--
-- Name: episodes_usergroups id; Type: DEFAULT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.episodes_usergroups ALTER COLUMN id SET DEFAULT nextval('public.episodes_usergroups_id_seq'::regclass);


--
-- Name: episodes_usergroups_download id; Type: DEFAULT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.episodes_usergroups_download ALTER COLUMN id SET DEFAULT nextval('public.episodes_usergroups_download_id_seq'::regclass);


--
-- Name: episodes_usergroups_earlyaccess id; Type: DEFAULT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.episodes_usergroups_earlyaccess ALTER COLUMN id SET DEFAULT nextval('public.episodes_usergroups_earlyaccess_id_seq'::regclass);


--
-- Name: events id; Type: DEFAULT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.events ALTER COLUMN id SET DEFAULT nextval('public.events_id_seq'::regclass);


--
-- Name: events_translations id; Type: DEFAULT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.events_translations ALTER COLUMN id SET DEFAULT nextval('public.events_translations_id_seq'::regclass);


--
-- Name: faq_categories id; Type: DEFAULT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.faq_categories ALTER COLUMN id SET DEFAULT nextval('public.faq_categories_id_seq'::regclass);


--
-- Name: faq_categories_translations id; Type: DEFAULT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.faq_categories_translations ALTER COLUMN id SET DEFAULT nextval('public.faq_categories_translations_id_seq'::regclass);


--
-- Name: faqs id; Type: DEFAULT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.faqs ALTER COLUMN id SET DEFAULT nextval('public.faqs_id_seq'::regclass);


--
-- Name: faqs_translations id; Type: DEFAULT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.faqs_translations ALTER COLUMN id SET DEFAULT nextval('public.faqs_translations_id_seq'::regclass);


--
-- Name: faqs_usergroups id; Type: DEFAULT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.faqs_usergroups ALTER COLUMN id SET DEFAULT nextval('public.faqs_usergroups_id_seq'::regclass);


--
-- Name: globalconfig id; Type: DEFAULT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.globalconfig ALTER COLUMN id SET DEFAULT nextval('public.globalconfig_id_seq'::regclass);


--
-- Name: lists id; Type: DEFAULT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.lists ALTER COLUMN id SET DEFAULT nextval('public.lists_id_seq'::regclass);


--
-- Name: lists_relations id; Type: DEFAULT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.lists_relations ALTER COLUMN id SET DEFAULT nextval('public.lists_relations_id_seq'::regclass);


--
-- Name: maintenancemessage id; Type: DEFAULT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.maintenancemessage ALTER COLUMN id SET DEFAULT nextval('public.maintenancemessage_id_seq'::regclass);


--
-- Name: maintenancemessage_messagetemplates id; Type: DEFAULT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.maintenancemessage_messagetemplates ALTER COLUMN id SET DEFAULT nextval('public.maintenancemessage_messagetemplates_id_seq'::regclass);


--
-- Name: messagetemplates id; Type: DEFAULT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.messagetemplates ALTER COLUMN id SET DEFAULT nextval('public.messagetemplates_id_seq'::regclass);


--
-- Name: messagetemplates_translations id; Type: DEFAULT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.messagetemplates_translations ALTER COLUMN id SET DEFAULT nextval('public.messagetemplates_translations_id_seq'::regclass);


--
-- Name: pages id; Type: DEFAULT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.pages ALTER COLUMN id SET DEFAULT nextval('public.pages_id_seq'::regclass);


--
-- Name: pages_translations id; Type: DEFAULT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.pages_translations ALTER COLUMN id SET DEFAULT nextval('public.pages_translations_id_seq'::regclass);


--
-- Name: seasons id; Type: DEFAULT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.seasons ALTER COLUMN id SET DEFAULT nextval('public.seasons_id_seq'::regclass);


--
-- Name: seasons_translations id; Type: DEFAULT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.seasons_translations ALTER COLUMN id SET DEFAULT nextval('public.seasons_translations_id_seq'::regclass);


--
-- Name: seasons_usergroups id; Type: DEFAULT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.seasons_usergroups ALTER COLUMN id SET DEFAULT nextval('public.seasons_usergroups_id_seq'::regclass);


--
-- Name: sections id; Type: DEFAULT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.sections ALTER COLUMN id SET DEFAULT nextval('public.sections_id_seq'::regclass);


--
-- Name: sections_translations id; Type: DEFAULT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.sections_translations ALTER COLUMN id SET DEFAULT nextval('public.sections_translations_id_seq'::regclass);


--
-- Name: sections_usergroups id; Type: DEFAULT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.sections_usergroups ALTER COLUMN id SET DEFAULT nextval('public.sections_usergroups_id_seq'::regclass);


--
-- Name: shows id; Type: DEFAULT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.shows ALTER COLUMN id SET DEFAULT nextval('public.shows_id_seq'::regclass);


--
-- Name: shows_translations id; Type: DEFAULT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.shows_translations ALTER COLUMN id SET DEFAULT nextval('public.shows_translations_id_seq'::regclass);


--
-- Name: shows_usergroups id; Type: DEFAULT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.shows_usergroups ALTER COLUMN id SET DEFAULT nextval('public.shows_usergroups_id_seq'::regclass);


--
-- Name: tags id; Type: DEFAULT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.tags ALTER COLUMN id SET DEFAULT nextval('public.tags_id_seq'::regclass);


--
-- Name: tags_translations id; Type: DEFAULT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.tags_translations ALTER COLUMN id SET DEFAULT nextval('public.tags_translations_id_seq'::regclass);


--
-- Name: webconfig id; Type: DEFAULT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.webconfig ALTER COLUMN id SET DEFAULT nextval('public.webconfig_id_seq'::regclass);


--
-- Name: ageratings ageratings_pkey; Type: CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.ageratings
    ADD CONSTRAINT ageratings_pkey PRIMARY KEY (code);


--
-- Name: ageratings_translations ageratings_translations_pkey; Type: CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.ageratings_translations
    ADD CONSTRAINT ageratings_translations_pkey PRIMARY KEY (id);


--
-- Name: appconfig appconfig_pkey; Type: CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.appconfig
    ADD CONSTRAINT appconfig_pkey PRIMARY KEY (id);


--
-- Name: assetfiles assetfiles_pkey; Type: CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.assetfiles
    ADD CONSTRAINT assetfiles_pkey PRIMARY KEY (id);


--
-- Name: assets assets_pkey; Type: CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.assets
    ADD CONSTRAINT assets_pkey PRIMARY KEY (id);


--
-- Name: assetstreams_audio_languages assetstreams_audio_languages_pkey; Type: CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.assetstreams_audio_languages
    ADD CONSTRAINT assetstreams_audio_languages_pkey PRIMARY KEY (id);


--
-- Name: assetstreams assetstreams_pkey; Type: CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.assetstreams
    ADD CONSTRAINT assetstreams_pkey PRIMARY KEY (id);


--
-- Name: assetstreams_subtitle_languages assetstreams_subtitle_languages_pkey; Type: CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.assetstreams_subtitle_languages
    ADD CONSTRAINT assetstreams_subtitle_languages_pkey PRIMARY KEY (id);


--
-- Name: calendarentries calendarentries_pkey; Type: CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.calendarentries
    ADD CONSTRAINT calendarentries_pkey PRIMARY KEY (id);


--
-- Name: calendarentries_translations calendarentries_translations_pkey; Type: CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.calendarentries_translations
    ADD CONSTRAINT calendarentries_translations_pkey PRIMARY KEY (id);


--
-- Name: calendarevent calendarevent_pkey; Type: CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.calendarevent
    ADD CONSTRAINT calendarevent_pkey PRIMARY KEY (id);


--
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: categories_translations categories_translations_pkey; Type: CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.categories_translations
    ADD CONSTRAINT categories_translations_pkey PRIMARY KEY (id);


--
-- Name: collections_items collections_items_pkey; Type: CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.collections_items
    ADD CONSTRAINT collections_items_pkey PRIMARY KEY (id);


--
-- Name: collections collections_pkey; Type: CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.collections
    ADD CONSTRAINT collections_pkey PRIMARY KEY (id);


--
-- Name: directus_activity directus_activity_pkey; Type: CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.directus_activity
    ADD CONSTRAINT directus_activity_pkey PRIMARY KEY (id);


--
-- Name: directus_collections directus_collections_pkey; Type: CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.directus_collections
    ADD CONSTRAINT directus_collections_pkey PRIMARY KEY (collection);


--
-- Name: directus_dashboards directus_dashboards_pkey; Type: CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.directus_dashboards
    ADD CONSTRAINT directus_dashboards_pkey PRIMARY KEY (id);


--
-- Name: directus_fields directus_fields_pkey; Type: CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.directus_fields
    ADD CONSTRAINT directus_fields_pkey PRIMARY KEY (id);


--
-- Name: directus_files directus_files_pkey; Type: CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.directus_files
    ADD CONSTRAINT directus_files_pkey PRIMARY KEY (id);


--
-- Name: directus_flows directus_flows_operation_unique; Type: CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.directus_flows
    ADD CONSTRAINT directus_flows_operation_unique UNIQUE (operation);


--
-- Name: directus_flows directus_flows_pkey; Type: CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.directus_flows
    ADD CONSTRAINT directus_flows_pkey PRIMARY KEY (id);


--
-- Name: directus_folders directus_folders_pkey; Type: CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.directus_folders
    ADD CONSTRAINT directus_folders_pkey PRIMARY KEY (id);


--
-- Name: directus_migrations directus_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.directus_migrations
    ADD CONSTRAINT directus_migrations_pkey PRIMARY KEY (version);


--
-- Name: directus_notifications directus_notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.directus_notifications
    ADD CONSTRAINT directus_notifications_pkey PRIMARY KEY (id);


--
-- Name: directus_operations directus_operations_pkey; Type: CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.directus_operations
    ADD CONSTRAINT directus_operations_pkey PRIMARY KEY (id);


--
-- Name: directus_operations directus_operations_reject_unique; Type: CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.directus_operations
    ADD CONSTRAINT directus_operations_reject_unique UNIQUE (reject);


--
-- Name: directus_operations directus_operations_resolve_unique; Type: CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.directus_operations
    ADD CONSTRAINT directus_operations_resolve_unique UNIQUE (resolve);


--
-- Name: directus_panels directus_panels_pkey; Type: CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.directus_panels
    ADD CONSTRAINT directus_panels_pkey PRIMARY KEY (id);


--
-- Name: directus_permissions directus_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.directus_permissions
    ADD CONSTRAINT directus_permissions_pkey PRIMARY KEY (id);


--
-- Name: directus_presets directus_presets_pkey; Type: CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.directus_presets
    ADD CONSTRAINT directus_presets_pkey PRIMARY KEY (id);


--
-- Name: directus_relations directus_relations_pkey; Type: CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.directus_relations
    ADD CONSTRAINT directus_relations_pkey PRIMARY KEY (id);


--
-- Name: directus_revisions directus_revisions_pkey; Type: CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.directus_revisions
    ADD CONSTRAINT directus_revisions_pkey PRIMARY KEY (id);


--
-- Name: directus_roles directus_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.directus_roles
    ADD CONSTRAINT directus_roles_pkey PRIMARY KEY (id);


--
-- Name: directus_sessions directus_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.directus_sessions
    ADD CONSTRAINT directus_sessions_pkey PRIMARY KEY (token);


--
-- Name: directus_settings directus_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.directus_settings
    ADD CONSTRAINT directus_settings_pkey PRIMARY KEY (id);


--
-- Name: directus_shares directus_shares_pkey; Type: CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.directus_shares
    ADD CONSTRAINT directus_shares_pkey PRIMARY KEY (id);


--
-- Name: directus_users directus_users_email_unique; Type: CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.directus_users
    ADD CONSTRAINT directus_users_email_unique UNIQUE (email);


--
-- Name: directus_users directus_users_external_identifier_unique; Type: CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.directus_users
    ADD CONSTRAINT directus_users_external_identifier_unique UNIQUE (external_identifier);


--
-- Name: directus_users directus_users_pkey; Type: CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.directus_users
    ADD CONSTRAINT directus_users_pkey PRIMARY KEY (id);


--
-- Name: directus_users directus_users_token_unique; Type: CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.directus_users
    ADD CONSTRAINT directus_users_token_unique UNIQUE (token);


--
-- Name: directus_webhooks directus_webhooks_pkey; Type: CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.directus_webhooks
    ADD CONSTRAINT directus_webhooks_pkey PRIMARY KEY (id);


--
-- Name: episodes_categories episodes_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.episodes_categories
    ADD CONSTRAINT episodes_categories_pkey PRIMARY KEY (id);


--
-- Name: episodes episodes_legacy_id_unique; Type: CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.episodes
    ADD CONSTRAINT episodes_legacy_id_unique UNIQUE (legacy_id);


--
-- Name: episodes episodes_legacy_program_id_unique; Type: CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.episodes
    ADD CONSTRAINT episodes_legacy_program_id_unique UNIQUE (legacy_program_id);


--
-- Name: episodes episodes_pkey; Type: CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.episodes
    ADD CONSTRAINT episodes_pkey PRIMARY KEY (id);


--
-- Name: episodes_tags episodes_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.episodes_tags
    ADD CONSTRAINT episodes_tags_pkey PRIMARY KEY (id);


--
-- Name: episodes_translations episodes_translations_pkey; Type: CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.episodes_translations
    ADD CONSTRAINT episodes_translations_pkey PRIMARY KEY (id);


--
-- Name: episodes_usergroups_download episodes_usergroups_download_pkey; Type: CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.episodes_usergroups_download
    ADD CONSTRAINT episodes_usergroups_download_pkey PRIMARY KEY (id);


--
-- Name: episodes_usergroups_earlyaccess episodes_usergroups_earlyaccess_pkey; Type: CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.episodes_usergroups_earlyaccess
    ADD CONSTRAINT episodes_usergroups_earlyaccess_pkey PRIMARY KEY (id);


--
-- Name: episodes_usergroups episodes_usergroups_pkey; Type: CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.episodes_usergroups
    ADD CONSTRAINT episodes_usergroups_pkey PRIMARY KEY (id);


--
-- Name: events events_pkey; Type: CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);


--
-- Name: events_translations events_translations_pkey; Type: CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.events_translations
    ADD CONSTRAINT events_translations_pkey PRIMARY KEY (id);


--
-- Name: faq_categories faq_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.faq_categories
    ADD CONSTRAINT faq_categories_pkey PRIMARY KEY (id);


--
-- Name: faq_categories_translations faq_categories_translations_pkey; Type: CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.faq_categories_translations
    ADD CONSTRAINT faq_categories_translations_pkey PRIMARY KEY (id);


--
-- Name: faqs faqs_pkey; Type: CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.faqs
    ADD CONSTRAINT faqs_pkey PRIMARY KEY (id);


--
-- Name: faqs_translations faqs_translations_pkey; Type: CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.faqs_translations
    ADD CONSTRAINT faqs_translations_pkey PRIMARY KEY (id);


--
-- Name: faqs_usergroups faqs_usergroups_pkey; Type: CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.faqs_usergroups
    ADD CONSTRAINT faqs_usergroups_pkey PRIMARY KEY (id);


--
-- Name: globalconfig globalconfig_pkey; Type: CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.globalconfig
    ADD CONSTRAINT globalconfig_pkey PRIMARY KEY (id);


--
-- Name: languages languages_pkey; Type: CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.languages
    ADD CONSTRAINT languages_pkey PRIMARY KEY (code);


--
-- Name: lists lists_pkey; Type: CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.lists
    ADD CONSTRAINT lists_pkey PRIMARY KEY (id);


--
-- Name: lists_relations lists_relations_pkey; Type: CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.lists_relations
    ADD CONSTRAINT lists_relations_pkey PRIMARY KEY (id);


--
-- Name: maintenancemessage_messagetemplates maintenancemessage_messagetemplates_pkey; Type: CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.maintenancemessage_messagetemplates
    ADD CONSTRAINT maintenancemessage_messagetemplates_pkey PRIMARY KEY (id);


--
-- Name: maintenancemessage maintenancemessage_pkey; Type: CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.maintenancemessage
    ADD CONSTRAINT maintenancemessage_pkey PRIMARY KEY (id);


--


--
-- Name: messagetemplates messagetemplates_pkey; Type: CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.messagetemplates
    ADD CONSTRAINT messagetemplates_pkey PRIMARY KEY (id);


--
-- Name: messagetemplates_translations messagetemplates_translations_pkey; Type: CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.messagetemplates_translations
    ADD CONSTRAINT messagetemplates_translations_pkey PRIMARY KEY (id);


--
-- Name: pages pages_code_unique; Type: CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.pages
    ADD CONSTRAINT pages_code_unique UNIQUE (code);


--
-- Name: pages pages_collection_unique; Type: CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.pages
    ADD CONSTRAINT pages_collection_unique UNIQUE (collection);


--
-- Name: pages pages_pkey; Type: CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.pages
    ADD CONSTRAINT pages_pkey PRIMARY KEY (id);


--
-- Name: pages_translations pages_translations_pkey; Type: CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.pages_translations
    ADD CONSTRAINT pages_translations_pkey PRIMARY KEY (id);


--
-- Name: seasons seasons_pkey; Type: CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.seasons
    ADD CONSTRAINT seasons_pkey PRIMARY KEY (id);


--
-- Name: seasons_translations seasons_translations_pkey; Type: CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.seasons_translations
    ADD CONSTRAINT seasons_translations_pkey PRIMARY KEY (id);


--
-- Name: seasons_usergroups seasons_usergroups_pkey; Type: CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.seasons_usergroups
    ADD CONSTRAINT seasons_usergroups_pkey PRIMARY KEY (id);


--
-- Name: sections sections_pkey; Type: CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.sections
    ADD CONSTRAINT sections_pkey PRIMARY KEY (id);


--
-- Name: sections_translations sections_translations_pkey; Type: CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.sections_translations
    ADD CONSTRAINT sections_translations_pkey PRIMARY KEY (id);


--
-- Name: sections_usergroups sections_usergroups_pkey; Type: CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.sections_usergroups
    ADD CONSTRAINT sections_usergroups_pkey PRIMARY KEY (id);


--
-- Name: shows shows_pkey; Type: CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.shows
    ADD CONSTRAINT shows_pkey PRIMARY KEY (id);


--
-- Name: shows_translations shows_translations_pkey; Type: CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.shows_translations
    ADD CONSTRAINT shows_translations_pkey PRIMARY KEY (id);


--
-- Name: shows_usergroups shows_usergroups_pkey; Type: CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.shows_usergroups
    ADD CONSTRAINT shows_usergroups_pkey PRIMARY KEY (id);


--
-- Name: tags tags_pkey; Type: CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- Name: tags_translations tags_translations_pkey; Type: CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.tags_translations
    ADD CONSTRAINT tags_translations_pkey PRIMARY KEY (id);


--
-- Name: usergroups usergroups_pkey; Type: CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.usergroups
    ADD CONSTRAINT usergroups_pkey PRIMARY KEY (code);


--
-- Name: webconfig webconfig_pkey; Type: CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.webconfig
    ADD CONSTRAINT webconfig_pkey PRIMARY KEY (id);


--
-- Name: tags lowercasenametagtrigger; Type: TRIGGER; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

CREATE TRIGGER lowercasenametagtrigger BEFORE INSERT OR UPDATE ON public.tags FOR EACH ROW EXECUTE FUNCTION public.nametolowercase();


--
-- Name: ageratings_translations ageratings_translations_ageratings_code_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.ageratings_translations
    ADD CONSTRAINT ageratings_translations_ageratings_code_foreign FOREIGN KEY (ageratings_code) REFERENCES public.ageratings(code);


--
-- Name: ageratings_translations ageratings_translations_languages_code_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.ageratings_translations
    ADD CONSTRAINT ageratings_translations_languages_code_foreign FOREIGN KEY (languages_code) REFERENCES public.languages(code);


--
-- Name: appconfig appconfig_user_updated_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.appconfig
    ADD CONSTRAINT appconfig_user_updated_foreign FOREIGN KEY (user_updated) REFERENCES public.directus_users(id);


--
-- Name: assetfiles assetfiles_asset_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.assetfiles
    ADD CONSTRAINT assetfiles_asset_id_foreign FOREIGN KEY (asset_id) REFERENCES public.assets(id) ON DELETE CASCADE;


--
-- Name: assetfiles assetfiles_audio_language_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.assetfiles
    ADD CONSTRAINT assetfiles_audio_language_id_foreign FOREIGN KEY (audio_language_id) REFERENCES public.languages(code) ON DELETE SET NULL;


--
-- Name: assetfiles assetfiles_subtitle_language_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.assetfiles
    ADD CONSTRAINT assetfiles_subtitle_language_id_foreign FOREIGN KEY (subtitle_language_id) REFERENCES public.languages(code) ON DELETE SET NULL;


--
-- Name: assetfiles assetfiles_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.assetfiles
    ADD CONSTRAINT assetfiles_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id);


--
-- Name: assetfiles assetfiles_user_updated_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.assetfiles
    ADD CONSTRAINT assetfiles_user_updated_foreign FOREIGN KEY (user_updated) REFERENCES public.directus_users(id);


--
-- Name: assets assets_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.assets
    ADD CONSTRAINT assets_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id);


--
-- Name: assets assets_user_updated_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.assets
    ADD CONSTRAINT assets_user_updated_foreign FOREIGN KEY (user_updated) REFERENCES public.directus_users(id);


--
-- Name: assetstreams assetstreams_asset_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.assetstreams
    ADD CONSTRAINT assetstreams_asset_id_foreign FOREIGN KEY (asset_id) REFERENCES public.assets(id) ON DELETE CASCADE;


--
-- Name: assetstreams_audio_languages assetstreams_audio_languages_assetstreams_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.assetstreams_audio_languages
    ADD CONSTRAINT assetstreams_audio_languages_assetstreams_id_foreign FOREIGN KEY (assetstreams_id) REFERENCES public.assetstreams(id) ON DELETE CASCADE;


--
-- Name: assetstreams_audio_languages assetstreams_audio_languages_languages_code_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.assetstreams_audio_languages
    ADD CONSTRAINT assetstreams_audio_languages_languages_code_foreign FOREIGN KEY (languages_code) REFERENCES public.languages(code);


--
-- Name: assetstreams_subtitle_languages assetstreams_subtitle_languages_assetstreams_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.assetstreams_subtitle_languages
    ADD CONSTRAINT assetstreams_subtitle_languages_assetstreams_id_foreign FOREIGN KEY (assetstreams_id) REFERENCES public.assetstreams(id) ON DELETE CASCADE;


--
-- Name: assetstreams_subtitle_languages assetstreams_subtitle_languages_languages_code_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.assetstreams_subtitle_languages
    ADD CONSTRAINT assetstreams_subtitle_languages_languages_code_foreign FOREIGN KEY (languages_code) REFERENCES public.languages(code);


--
-- Name: assetstreams assetstreams_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.assetstreams
    ADD CONSTRAINT assetstreams_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id);


--
-- Name: assetstreams assetstreams_user_updated_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.assetstreams
    ADD CONSTRAINT assetstreams_user_updated_foreign FOREIGN KEY (user_updated) REFERENCES public.directus_users(id);


--
-- Name: calendarentries calendarentries_episode_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.calendarentries
    ADD CONSTRAINT calendarentries_episode_id_foreign FOREIGN KEY (episode_id) REFERENCES public.episodes(id) ON DELETE SET NULL;


--
-- Name: calendarentries calendarentries_event_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.calendarentries
    ADD CONSTRAINT calendarentries_event_id_foreign FOREIGN KEY (event_id) REFERENCES public.events(id) ON DELETE SET NULL;


--
-- Name: calendarentries calendarentries_image_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.calendarentries
    ADD CONSTRAINT calendarentries_image_foreign FOREIGN KEY (image) REFERENCES public.directus_files(id) ON DELETE SET NULL;


--
-- Name: calendarentries calendarentries_season_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.calendarentries
    ADD CONSTRAINT calendarentries_season_id_foreign FOREIGN KEY (season_id) REFERENCES public.seasons(id) ON DELETE SET NULL;


--
-- Name: calendarentries calendarentries_show_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.calendarentries
    ADD CONSTRAINT calendarentries_show_id_foreign FOREIGN KEY (show_id) REFERENCES public.shows(id) ON DELETE SET NULL;


--
-- Name: calendarentries_translations calendarentries_translations_calendarentries_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.calendarentries_translations
    ADD CONSTRAINT calendarentries_translations_calendarentries_id_foreign FOREIGN KEY (calendarentries_id) REFERENCES public.calendarentries(id) ON DELETE CASCADE;


--
-- Name: calendarentries_translations calendarentries_translations_languages_code_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.calendarentries_translations
    ADD CONSTRAINT calendarentries_translations_languages_code_foreign FOREIGN KEY (languages_code) REFERENCES public.languages(code) ON DELETE CASCADE;


--
-- Name: calendarentries calendarentries_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.calendarentries
    ADD CONSTRAINT calendarentries_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id);


--
-- Name: calendarentries calendarentries_user_updated_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.calendarentries
    ADD CONSTRAINT calendarentries_user_updated_foreign FOREIGN KEY (user_updated) REFERENCES public.directus_users(id);


--
-- Name: calendarevent calendarevent_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.calendarevent
    ADD CONSTRAINT calendarevent_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id);


--
-- Name: calendarevent calendarevent_user_updated_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.calendarevent
    ADD CONSTRAINT calendarevent_user_updated_foreign FOREIGN KEY (user_updated) REFERENCES public.directus_users(id);


--
-- Name: categories categories_parent_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_parent_id_foreign FOREIGN KEY (parent_id) REFERENCES public.categories(id);


--
-- Name: categories_translations categories_translations_categories_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.categories_translations
    ADD CONSTRAINT categories_translations_categories_id_foreign FOREIGN KEY (categories_id) REFERENCES public.categories(id);


--
-- Name: categories_translations categories_translations_languages_code_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.categories_translations
    ADD CONSTRAINT categories_translations_languages_code_foreign FOREIGN KEY (languages_code) REFERENCES public.languages(code);


--
-- Name: categories categories_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id);


--
-- Name: categories categories_user_updated_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_user_updated_foreign FOREIGN KEY (user_updated) REFERENCES public.directus_users(id);


--
-- Name: collections_items collections_items_collection_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.collections_items
    ADD CONSTRAINT collections_items_collection_id_foreign FOREIGN KEY (collection_id) REFERENCES public.collections(id) ON DELETE CASCADE;


--
-- Name: collections_items collections_items_episode_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.collections_items
    ADD CONSTRAINT collections_items_episode_id_foreign FOREIGN KEY (episode_id) REFERENCES public.episodes(id) ON DELETE SET NULL;


--
-- Name: collections_items collections_items_page_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.collections_items
    ADD CONSTRAINT collections_items_page_id_foreign FOREIGN KEY (page_id) REFERENCES public.pages(id) ON DELETE SET NULL;


--
-- Name: collections_items collections_items_season_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.collections_items
    ADD CONSTRAINT collections_items_season_id_foreign FOREIGN KEY (season_id) REFERENCES public.seasons(id) ON DELETE SET NULL;


--
-- Name: collections_items collections_items_show_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.collections_items
    ADD CONSTRAINT collections_items_show_id_foreign FOREIGN KEY (show_id) REFERENCES public.shows(id) ON DELETE SET NULL;


--
-- Name: collections_items collections_items_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.collections_items
    ADD CONSTRAINT collections_items_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id);


--
-- Name: collections_items collections_items_user_updated_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.collections_items
    ADD CONSTRAINT collections_items_user_updated_foreign FOREIGN KEY (user_updated) REFERENCES public.directus_users(id);


--
-- Name: collections collections_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.collections
    ADD CONSTRAINT collections_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id);


--
-- Name: collections collections_user_updated_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.collections
    ADD CONSTRAINT collections_user_updated_foreign FOREIGN KEY (user_updated) REFERENCES public.directus_users(id);


--
-- Name: directus_collections directus_collections_group_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.directus_collections
    ADD CONSTRAINT directus_collections_group_foreign FOREIGN KEY ("group") REFERENCES public.directus_collections(collection);


--
-- Name: directus_dashboards directus_dashboards_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.directus_dashboards
    ADD CONSTRAINT directus_dashboards_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id) ON DELETE SET NULL;


--
-- Name: directus_files directus_files_folder_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.directus_files
    ADD CONSTRAINT directus_files_folder_foreign FOREIGN KEY (folder) REFERENCES public.directus_folders(id) ON DELETE SET NULL;


--
-- Name: directus_files directus_files_modified_by_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.directus_files
    ADD CONSTRAINT directus_files_modified_by_foreign FOREIGN KEY (modified_by) REFERENCES public.directus_users(id);


--
-- Name: directus_files directus_files_uploaded_by_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.directus_files
    ADD CONSTRAINT directus_files_uploaded_by_foreign FOREIGN KEY (uploaded_by) REFERENCES public.directus_users(id);


--
-- Name: directus_flows directus_flows_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.directus_flows
    ADD CONSTRAINT directus_flows_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id) ON DELETE SET NULL;


--
-- Name: directus_folders directus_folders_parent_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.directus_folders
    ADD CONSTRAINT directus_folders_parent_foreign FOREIGN KEY (parent) REFERENCES public.directus_folders(id);


--
-- Name: directus_notifications directus_notifications_recipient_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.directus_notifications
    ADD CONSTRAINT directus_notifications_recipient_foreign FOREIGN KEY (recipient) REFERENCES public.directus_users(id) ON DELETE CASCADE;


--
-- Name: directus_notifications directus_notifications_sender_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.directus_notifications
    ADD CONSTRAINT directus_notifications_sender_foreign FOREIGN KEY (sender) REFERENCES public.directus_users(id);


--
-- Name: directus_operations directus_operations_flow_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.directus_operations
    ADD CONSTRAINT directus_operations_flow_foreign FOREIGN KEY (flow) REFERENCES public.directus_flows(id) ON DELETE CASCADE;


--
-- Name: directus_operations directus_operations_reject_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.directus_operations
    ADD CONSTRAINT directus_operations_reject_foreign FOREIGN KEY (reject) REFERENCES public.directus_operations(id);


--
-- Name: directus_operations directus_operations_resolve_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.directus_operations
    ADD CONSTRAINT directus_operations_resolve_foreign FOREIGN KEY (resolve) REFERENCES public.directus_operations(id);


--
-- Name: directus_operations directus_operations_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.directus_operations
    ADD CONSTRAINT directus_operations_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id) ON DELETE SET NULL;


--
-- Name: directus_panels directus_panels_dashboard_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.directus_panels
    ADD CONSTRAINT directus_panels_dashboard_foreign FOREIGN KEY (dashboard) REFERENCES public.directus_dashboards(id) ON DELETE CASCADE;


--
-- Name: directus_panels directus_panels_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.directus_panels
    ADD CONSTRAINT directus_panels_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id) ON DELETE SET NULL;


--
-- Name: directus_permissions directus_permissions_role_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.directus_permissions
    ADD CONSTRAINT directus_permissions_role_foreign FOREIGN KEY (role) REFERENCES public.directus_roles(id) ON DELETE CASCADE;


--
-- Name: directus_presets directus_presets_role_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.directus_presets
    ADD CONSTRAINT directus_presets_role_foreign FOREIGN KEY (role) REFERENCES public.directus_roles(id) ON DELETE CASCADE;


--
-- Name: directus_presets directus_presets_user_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.directus_presets
    ADD CONSTRAINT directus_presets_user_foreign FOREIGN KEY ("user") REFERENCES public.directus_users(id) ON DELETE CASCADE;


--
-- Name: directus_revisions directus_revisions_activity_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.directus_revisions
    ADD CONSTRAINT directus_revisions_activity_foreign FOREIGN KEY (activity) REFERENCES public.directus_activity(id) ON DELETE CASCADE;


--
-- Name: directus_revisions directus_revisions_parent_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.directus_revisions
    ADD CONSTRAINT directus_revisions_parent_foreign FOREIGN KEY (parent) REFERENCES public.directus_revisions(id);


--
-- Name: directus_sessions directus_sessions_share_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.directus_sessions
    ADD CONSTRAINT directus_sessions_share_foreign FOREIGN KEY (share) REFERENCES public.directus_shares(id) ON DELETE CASCADE;


--
-- Name: directus_sessions directus_sessions_user_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.directus_sessions
    ADD CONSTRAINT directus_sessions_user_foreign FOREIGN KEY ("user") REFERENCES public.directus_users(id) ON DELETE CASCADE;


--
-- Name: directus_settings directus_settings_project_logo_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.directus_settings
    ADD CONSTRAINT directus_settings_project_logo_foreign FOREIGN KEY (project_logo) REFERENCES public.directus_files(id);


--
-- Name: directus_settings directus_settings_public_background_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.directus_settings
    ADD CONSTRAINT directus_settings_public_background_foreign FOREIGN KEY (public_background) REFERENCES public.directus_files(id);


--
-- Name: directus_settings directus_settings_public_foreground_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.directus_settings
    ADD CONSTRAINT directus_settings_public_foreground_foreign FOREIGN KEY (public_foreground) REFERENCES public.directus_files(id);


--
-- Name: directus_settings directus_settings_storage_default_folder_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.directus_settings
    ADD CONSTRAINT directus_settings_storage_default_folder_foreign FOREIGN KEY (storage_default_folder) REFERENCES public.directus_folders(id) ON DELETE SET NULL;


--
-- Name: directus_shares directus_shares_collection_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.directus_shares
    ADD CONSTRAINT directus_shares_collection_foreign FOREIGN KEY (collection) REFERENCES public.directus_collections(collection) ON DELETE CASCADE;


--
-- Name: directus_shares directus_shares_role_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.directus_shares
    ADD CONSTRAINT directus_shares_role_foreign FOREIGN KEY (role) REFERENCES public.directus_roles(id) ON DELETE CASCADE;


--
-- Name: directus_shares directus_shares_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.directus_shares
    ADD CONSTRAINT directus_shares_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id) ON DELETE SET NULL;


--
-- Name: directus_users directus_users_role_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.directus_users
    ADD CONSTRAINT directus_users_role_foreign FOREIGN KEY (role) REFERENCES public.directus_roles(id) ON DELETE SET NULL;


--
-- Name: episodes episodes_agerating_code_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.episodes
    ADD CONSTRAINT episodes_agerating_code_foreign FOREIGN KEY (agerating_code) REFERENCES public.ageratings(code) ON DELETE SET NULL;


--
-- Name: episodes episodes_asset_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.episodes
    ADD CONSTRAINT episodes_asset_id_foreign FOREIGN KEY (asset_id) REFERENCES public.assets(id) ON DELETE SET NULL;


--
-- Name: episodes_categories episodes_categories_categories_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.episodes_categories
    ADD CONSTRAINT episodes_categories_categories_id_foreign FOREIGN KEY (categories_id) REFERENCES public.categories(id) ON DELETE CASCADE;


--
-- Name: episodes_categories episodes_categories_episodes_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.episodes_categories
    ADD CONSTRAINT episodes_categories_episodes_id_foreign FOREIGN KEY (episodes_id) REFERENCES public.episodes(id) ON DELETE CASCADE;


--
-- Name: episodes episodes_image_file_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.episodes
    ADD CONSTRAINT episodes_image_file_id_foreign FOREIGN KEY (image_file_id) REFERENCES public.directus_files(id) ON DELETE SET NULL;


--
-- Name: episodes episodes_season_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.episodes
    ADD CONSTRAINT episodes_season_id_foreign FOREIGN KEY (season_id) REFERENCES public.seasons(id) ON DELETE CASCADE;


--
-- Name: episodes_tags episodes_tags_episodes_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.episodes_tags
    ADD CONSTRAINT episodes_tags_episodes_id_foreign FOREIGN KEY (episodes_id) REFERENCES public.episodes(id) ON DELETE CASCADE;


--
-- Name: episodes_tags episodes_tags_tags_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.episodes_tags
    ADD CONSTRAINT episodes_tags_tags_id_foreign FOREIGN KEY (tags_id) REFERENCES public.tags(id) ON DELETE CASCADE;


--
-- Name: episodes_translations episodes_translations_episodes_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.episodes_translations
    ADD CONSTRAINT episodes_translations_episodes_id_foreign FOREIGN KEY (episodes_id) REFERENCES public.episodes(id) ON DELETE CASCADE;


--
-- Name: episodes_translations episodes_translations_languages_code_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.episodes_translations
    ADD CONSTRAINT episodes_translations_languages_code_foreign FOREIGN KEY (languages_code) REFERENCES public.languages(code) ON DELETE CASCADE;


--
-- Name: episodes episodes_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.episodes
    ADD CONSTRAINT episodes_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id);


--
-- Name: episodes episodes_user_updated_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.episodes
    ADD CONSTRAINT episodes_user_updated_foreign FOREIGN KEY (user_updated) REFERENCES public.directus_users(id);


--
-- Name: episodes_usergroups_download episodes_usergroups_download_episodes_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.episodes_usergroups_download
    ADD CONSTRAINT episodes_usergroups_download_episodes_id_foreign FOREIGN KEY (episodes_id) REFERENCES public.episodes(id) ON DELETE CASCADE;


--
-- Name: episodes_usergroups_download episodes_usergroups_download_usergroups_code_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.episodes_usergroups_download
    ADD CONSTRAINT episodes_usergroups_download_usergroups_code_foreign FOREIGN KEY (usergroups_code) REFERENCES public.usergroups(code) ON DELETE CASCADE;


--
-- Name: episodes_usergroups_earlyaccess episodes_usergroups_earlyaccess_episodes_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.episodes_usergroups_earlyaccess
    ADD CONSTRAINT episodes_usergroups_earlyaccess_episodes_id_foreign FOREIGN KEY (episodes_id) REFERENCES public.episodes(id) ON DELETE CASCADE;


--
-- Name: episodes_usergroups_earlyaccess episodes_usergroups_earlyaccess_usergroups_code_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.episodes_usergroups_earlyaccess
    ADD CONSTRAINT episodes_usergroups_earlyaccess_usergroups_code_foreign FOREIGN KEY (usergroups_code) REFERENCES public.usergroups(code) ON DELETE CASCADE;


--
-- Name: episodes_usergroups episodes_usergroups_episodes_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.episodes_usergroups
    ADD CONSTRAINT episodes_usergroups_episodes_id_foreign FOREIGN KEY (episodes_id) REFERENCES public.episodes(id) ON DELETE CASCADE;


--
-- Name: episodes_usergroups episodes_usergroups_usergroups_code_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.episodes_usergroups
    ADD CONSTRAINT episodes_usergroups_usergroups_code_foreign FOREIGN KEY (usergroups_code) REFERENCES public.usergroups(code) ON DELETE CASCADE;


--
-- Name: events_translations events_translations_events_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.events_translations
    ADD CONSTRAINT events_translations_events_id_foreign FOREIGN KEY (events_id) REFERENCES public.events(id) ON DELETE SET NULL;


--
-- Name: events_translations events_translations_languages_code_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.events_translations
    ADD CONSTRAINT events_translations_languages_code_foreign FOREIGN KEY (languages_code) REFERENCES public.languages(code) ON DELETE SET NULL;


--
-- Name: events events_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id);


--
-- Name: events events_user_updated_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_user_updated_foreign FOREIGN KEY (user_updated) REFERENCES public.directus_users(id);


--
-- Name: faq_categories_translations faq_categories_translations_faq_categories_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.faq_categories_translations
    ADD CONSTRAINT faq_categories_translations_faq_categories_id_foreign FOREIGN KEY (faq_categories_id) REFERENCES public.faq_categories(id) ON DELETE CASCADE;


--
-- Name: faq_categories_translations faq_categories_translations_languages_code_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.faq_categories_translations
    ADD CONSTRAINT faq_categories_translations_languages_code_foreign FOREIGN KEY (languages_code) REFERENCES public.languages(code) ON DELETE CASCADE;


--
-- Name: faqs faqs_category_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.faqs
    ADD CONSTRAINT faqs_category_foreign FOREIGN KEY (category) REFERENCES public.faq_categories(id);


--
-- Name: faqs_translations faqs_translations_faqs_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.faqs_translations
    ADD CONSTRAINT faqs_translations_faqs_id_foreign FOREIGN KEY (faqs_id) REFERENCES public.faqs(id) ON DELETE CASCADE;


--
-- Name: faqs_translations faqs_translations_languages_code_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.faqs_translations
    ADD CONSTRAINT faqs_translations_languages_code_foreign FOREIGN KEY (languages_code) REFERENCES public.languages(code) ON DELETE CASCADE;


--
-- Name: faqs faqs_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.faqs
    ADD CONSTRAINT faqs_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id);


--
-- Name: faqs faqs_user_updated_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.faqs
    ADD CONSTRAINT faqs_user_updated_foreign FOREIGN KEY (user_updated) REFERENCES public.directus_users(id);


--
-- Name: faqs_usergroups faqs_usergroups_faqs_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.faqs_usergroups
    ADD CONSTRAINT faqs_usergroups_faqs_id_foreign FOREIGN KEY (faqs_id) REFERENCES public.faqs(id);


--
-- Name: faqs_usergroups faqs_usergroups_usergroups_code_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.faqs_usergroups
    ADD CONSTRAINT faqs_usergroups_usergroups_code_foreign FOREIGN KEY (usergroups_code) REFERENCES public.usergroups(code);


--
-- Name: globalconfig globalconfig_user_updated_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.globalconfig
    ADD CONSTRAINT globalconfig_user_updated_foreign FOREIGN KEY (user_updated) REFERENCES public.directus_users(id);


--
-- Name: lists_relations lists_relations_lists_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.lists_relations
    ADD CONSTRAINT lists_relations_lists_id_foreign FOREIGN KEY (lists_id) REFERENCES public.lists(id) ON DELETE CASCADE;


--
-- Name: lists lists_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.lists
    ADD CONSTRAINT lists_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id);


--
-- Name: lists lists_user_updated_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.lists
    ADD CONSTRAINT lists_user_updated_foreign FOREIGN KEY (user_updated) REFERENCES public.directus_users(id);


--
-- Name: maintenancemessage_messagetemplates maintenancemessage_messagetemplates_mainte__6b993ed9_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.maintenancemessage_messagetemplates
    ADD CONSTRAINT maintenancemessage_messagetemplates_mainte__6b993ed9_foreign FOREIGN KEY (maintenancemessage_id) REFERENCES public.maintenancemessage(id) ON DELETE SET NULL;


--
-- Name: maintenancemessage_messagetemplates maintenancemessage_messagetemplates_messag__488cfa1b_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.maintenancemessage_messagetemplates
    ADD CONSTRAINT maintenancemessage_messagetemplates_messag__488cfa1b_foreign FOREIGN KEY (messagetemplates_id) REFERENCES public.messagetemplates(id) ON DELETE SET NULL;


--
-- Name: maintenancemessage maintenancemessage_user_updated_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.maintenancemessage
    ADD CONSTRAINT maintenancemessage_user_updated_foreign FOREIGN KEY (user_updated) REFERENCES public.directus_users(id);


--
-- Name: messagetemplates_translations messagetemplates_translations_languages_code_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.messagetemplates_translations
    ADD CONSTRAINT messagetemplates_translations_languages_code_foreign FOREIGN KEY (languages_code) REFERENCES public.languages(code) ON DELETE SET NULL;


--
-- Name: messagetemplates_translations messagetemplates_translations_messagetemplates_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.messagetemplates_translations
    ADD CONSTRAINT messagetemplates_translations_messagetemplates_id_foreign FOREIGN KEY (messagetemplates_id) REFERENCES public.messagetemplates(id) ON DELETE SET NULL;


--
-- Name: messagetemplates messagetemplates_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.messagetemplates
    ADD CONSTRAINT messagetemplates_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id);


--
-- Name: messagetemplates messagetemplates_user_updated_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.messagetemplates
    ADD CONSTRAINT messagetemplates_user_updated_foreign FOREIGN KEY (user_updated) REFERENCES public.directus_users(id);


--
-- Name: pages pages_episode_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.pages
    ADD CONSTRAINT pages_episode_id_foreign FOREIGN KEY (episode_id) REFERENCES public.episodes(id) ON DELETE SET NULL;


--
-- Name: pages pages_season_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.pages
    ADD CONSTRAINT pages_season_id_foreign FOREIGN KEY (season_id) REFERENCES public.seasons(id) ON DELETE SET NULL;


--
-- Name: pages pages_show_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.pages
    ADD CONSTRAINT pages_show_id_foreign FOREIGN KEY (show_id) REFERENCES public.shows(id) ON DELETE SET NULL;


--
-- Name: pages_translations pages_translations_languages_code_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.pages_translations
    ADD CONSTRAINT pages_translations_languages_code_foreign FOREIGN KEY (languages_code) REFERENCES public.languages(code) ON DELETE SET NULL;


--
-- Name: pages_translations pages_translations_pages_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.pages_translations
    ADD CONSTRAINT pages_translations_pages_id_foreign FOREIGN KEY (pages_id) REFERENCES public.pages(id) ON DELETE SET NULL;


--
-- Name: pages pages_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.pages
    ADD CONSTRAINT pages_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id);


--
-- Name: pages pages_user_updated_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.pages
    ADD CONSTRAINT pages_user_updated_foreign FOREIGN KEY (user_updated) REFERENCES public.directus_users(id);


--
-- Name: seasons seasons_agerating_code_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.seasons
    ADD CONSTRAINT seasons_agerating_code_foreign FOREIGN KEY (agerating_code) REFERENCES public.ageratings(code) ON DELETE SET NULL;


--
-- Name: seasons seasons_image_file_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.seasons
    ADD CONSTRAINT seasons_image_file_id_foreign FOREIGN KEY (image_file_id) REFERENCES public.directus_files(id) ON DELETE SET NULL;


--
-- Name: seasons seasons_show_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.seasons
    ADD CONSTRAINT seasons_show_id_foreign FOREIGN KEY (show_id) REFERENCES public.shows(id) ON DELETE CASCADE;


--
-- Name: seasons_translations seasons_translations_languages_code_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.seasons_translations
    ADD CONSTRAINT seasons_translations_languages_code_foreign FOREIGN KEY (languages_code) REFERENCES public.languages(code) ON DELETE CASCADE;


--
-- Name: seasons_translations seasons_translations_seasons_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.seasons_translations
    ADD CONSTRAINT seasons_translations_seasons_id_foreign FOREIGN KEY (seasons_id) REFERENCES public.seasons(id) ON DELETE CASCADE;


--
-- Name: seasons seasons_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.seasons
    ADD CONSTRAINT seasons_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id);


--
-- Name: seasons seasons_user_updated_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.seasons
    ADD CONSTRAINT seasons_user_updated_foreign FOREIGN KEY (user_updated) REFERENCES public.directus_users(id);


--
-- Name: seasons_usergroups seasons_usergroups_seasons_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.seasons_usergroups
    ADD CONSTRAINT seasons_usergroups_seasons_id_foreign FOREIGN KEY (seasons_id) REFERENCES public.seasons(id);


--
-- Name: seasons_usergroups seasons_usergroups_usergroups_code_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.seasons_usergroups
    ADD CONSTRAINT seasons_usergroups_usergroups_code_foreign FOREIGN KEY (usergroups_code) REFERENCES public.usergroups(code);


--
-- Name: sections sections_collection_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.sections
    ADD CONSTRAINT sections_collection_id_foreign FOREIGN KEY (collection_id) REFERENCES public.collections(id) ON DELETE SET NULL;


--
-- Name: sections sections_page_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.sections
    ADD CONSTRAINT sections_page_id_foreign FOREIGN KEY (page_id) REFERENCES public.pages(id) ON DELETE CASCADE;


--
-- Name: sections_translations sections_translations_languages_code_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.sections_translations
    ADD CONSTRAINT sections_translations_languages_code_foreign FOREIGN KEY (languages_code) REFERENCES public.languages(code) ON DELETE SET NULL;


--
-- Name: sections_translations sections_translations_sections_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.sections_translations
    ADD CONSTRAINT sections_translations_sections_id_foreign FOREIGN KEY (sections_id) REFERENCES public.sections(id) ON DELETE SET NULL;


--
-- Name: sections sections_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.sections
    ADD CONSTRAINT sections_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id);


--
-- Name: sections sections_user_updated_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.sections
    ADD CONSTRAINT sections_user_updated_foreign FOREIGN KEY (user_updated) REFERENCES public.directus_users(id);


--
-- Name: sections_usergroups sections_usergroups_sections_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.sections_usergroups
    ADD CONSTRAINT sections_usergroups_sections_id_foreign FOREIGN KEY (sections_id) REFERENCES public.sections(id) ON DELETE CASCADE;


--
-- Name: sections_usergroups sections_usergroups_usergroups_code_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.sections_usergroups
    ADD CONSTRAINT sections_usergroups_usergroups_code_foreign FOREIGN KEY (usergroups_code) REFERENCES public.usergroups(code) ON DELETE CASCADE;


--
-- Name: shows shows_agerating_code_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.shows
    ADD CONSTRAINT shows_agerating_code_foreign FOREIGN KEY (agerating_code) REFERENCES public.ageratings(code) ON DELETE SET NULL;


--
-- Name: shows shows_image_file_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.shows
    ADD CONSTRAINT shows_image_file_id_foreign FOREIGN KEY (image_file_id) REFERENCES public.directus_files(id) ON DELETE SET NULL;


--
-- Name: shows_translations shows_translations_languages_code_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.shows_translations
    ADD CONSTRAINT shows_translations_languages_code_foreign FOREIGN KEY (languages_code) REFERENCES public.languages(code) ON DELETE CASCADE;


--
-- Name: shows_translations shows_translations_shows_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.shows_translations
    ADD CONSTRAINT shows_translations_shows_id_foreign FOREIGN KEY (shows_id) REFERENCES public.shows(id) ON DELETE CASCADE;


--
-- Name: shows shows_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.shows
    ADD CONSTRAINT shows_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id);


--
-- Name: shows shows_user_updated_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.shows
    ADD CONSTRAINT shows_user_updated_foreign FOREIGN KEY (user_updated) REFERENCES public.directus_users(id);


--
-- Name: shows_usergroups shows_usergroups_shows_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.shows_usergroups
    ADD CONSTRAINT shows_usergroups_shows_id_foreign FOREIGN KEY (shows_id) REFERENCES public.shows(id);


--
-- Name: shows_usergroups shows_usergroups_usergroups_code_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.shows_usergroups
    ADD CONSTRAINT shows_usergroups_usergroups_code_foreign FOREIGN KEY (usergroups_code) REFERENCES public.usergroups(code);


--
-- Name: tags_translations tags_translations_languages_code_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.tags_translations
    ADD CONSTRAINT tags_translations_languages_code_foreign FOREIGN KEY (languages_code) REFERENCES public.languages(code) ON DELETE SET NULL;


--
-- Name: tags_translations tags_translations_tags_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.tags_translations
    ADD CONSTRAINT tags_translations_tags_id_foreign FOREIGN KEY (tags_id) REFERENCES public.tags(id) ON DELETE SET NULL;


--
-- Name: tags tags_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tags_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id);


--
-- Name: tags tags_user_updated_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tags_user_updated_foreign FOREIGN KEY (user_updated) REFERENCES public.directus_users(id);


--
-- Name: usergroups usergroups_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.usergroups
    ADD CONSTRAINT usergroups_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id);


--
-- Name: usergroups usergroups_user_updated_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.usergroups
    ADD CONSTRAINT usergroups_user_updated_foreign FOREIGN KEY (user_updated) REFERENCES public.directus_users(id);


--
-- Name: webconfig webconfig_user_updated_foreign; Type: FK CONSTRAINT; Schema: public; Owner: directus@btv-platform-dev-2.iam
--

ALTER TABLE ONLY public.webconfig
    ADD CONSTRAINT webconfig_user_updated_foreign FOREIGN KEY (user_updated) REFERENCES public.directus_users(id);


--- BEGIN CREATE SEQUENCE "public"."goose_db_version_id_seq" ---


CREATE SEQUENCE IF NOT EXISTS "public"."goose_db_version_id_seq"
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE;

ALTER SEQUENCE "public"."goose_db_version_id_seq" OWNER TO btv;
GRANT SELECT ON SEQUENCE "public"."goose_db_version_id_seq" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT USAGE ON SEQUENCE "public"."goose_db_version_id_seq" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON SEQUENCE "public"."goose_db_version_id_seq" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON SEQUENCE "public"."goose_db_version_id_seq"  IS NULL;

--- END CREATE SEQUENCE "public"."goose_db_version_id_seq" ---

--- BEGIN CREATE SEQUENCE "public"."calendarevent_id_seq" ---

--- BEGIN CREATE TABLE "public"."goose_db_version" ---

CREATE TABLE IF NOT EXISTS "public"."goose_db_version" (
	"id" int4 NOT NULL DEFAULT nextval('goose_db_version_id_seq'::regclass) ,
	"version_id" int8 NOT NULL  ,
	"is_applied" bool NOT NULL  ,
	"tstamp" timestamp NULL DEFAULT now() ,
	CONSTRAINT "goose_db_version_pkey" PRIMARY KEY (id)
);

ALTER TABLE IF EXISTS "public"."goose_db_version" OWNER TO btv;

GRANT SELECT ON TABLE "public"."goose_db_version" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT INSERT ON TABLE "public"."goose_db_version" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT UPDATE ON TABLE "public"."goose_db_version" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT DELETE ON TABLE "public"."goose_db_version" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRUNCATE ON TABLE "public"."goose_db_version" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT REFERENCES ON TABLE "public"."goose_db_version" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!
GRANT TRIGGER ON TABLE "public"."goose_db_version" TO btv; --WARN: Grant\Revoke privileges to a role can occure in a sql error during execution if role is missing to the target database!

COMMENT ON COLUMN "public"."goose_db_version"."id"  IS NULL;


COMMENT ON COLUMN "public"."goose_db_version"."version_id"  IS NULL;


COMMENT ON COLUMN "public"."goose_db_version"."is_applied"  IS NULL;


COMMENT ON COLUMN "public"."goose_db_version"."tstamp"  IS NULL;

COMMENT ON CONSTRAINT "goose_db_version_pkey" ON "public"."goose_db_version" IS NULL;

COMMENT ON TABLE "public"."goose_db_version"  IS NULL;

--- END CREATE TABLE "public"."goose_db_version" ---
