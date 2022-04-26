--
-- PostgreSQL database dump
--

-- Dumped from database version 14.2 (Debian 14.2-1.pgdg110+1)
-- Dumped by pg_dump version 14.2

-- Started on 2022-04-25 18:12:41 CEST

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

SET default_table_access_method = heap;

--
-- TOC entry 237 (class 1259 OID 16876)
-- Name: ageratings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ageratings (
    code character varying(255) DEFAULT NULL::character varying NOT NULL,
    sort integer,
    date_created timestamp with time zone,
    date_updated timestamp with time zone,
    title character varying(255) DEFAULT NULL::character varying
);


--
-- TOC entry 239 (class 1259 OID 16886)
-- Name: ageratings_translations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ageratings_translations (
    id integer NOT NULL,
    ageratings_code character varying(255) DEFAULT NULL::character varying,
    languages_code character varying(255) DEFAULT NULL::character varying,
    title character varying(255) DEFAULT NULL::character varying
);


--
-- TOC entry 238 (class 1259 OID 16885)
-- Name: ageratings_translations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ageratings_translations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3812 (class 0 OID 0)
-- Dependencies: 238
-- Name: ageratings_translations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ageratings_translations_id_seq OWNED BY public.ageratings_translations.id;


--
-- TOC entry 241 (class 1259 OID 16898)
-- Name: assetfiles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.assetfiles (
    id integer NOT NULL,
    user_created uuid,
    date_created timestamp with time zone,
    user_updated uuid,
    date_updated timestamp with time zone,
    filename character varying(255) DEFAULT NULL::character varying,
    type character varying(255) DEFAULT NULL::character varying,
    storage character varying(255) DEFAULT NULL::character varying,
    asset_id integer
);


--
-- TOC entry 240 (class 1259 OID 16897)
-- Name: assetfiles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.assetfiles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3813 (class 0 OID 0)
-- Dependencies: 240
-- Name: assetfiles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.assetfiles_id_seq OWNED BY public.assetfiles.id;


--
-- TOC entry 243 (class 1259 OID 16910)
-- Name: assets; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.assets (
    id integer NOT NULL,
    user_created uuid,
    date_created timestamp with time zone,
    user_updated uuid,
    date_updated timestamp with time zone,
    name character varying(255) DEFAULT NULL::character varying
);


--
-- TOC entry 242 (class 1259 OID 16909)
-- Name: assets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.assets_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3814 (class 0 OID 0)
-- Dependencies: 242
-- Name: assets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.assets_id_seq OWNED BY public.assets.id;


--
-- TOC entry 245 (class 1259 OID 16918)
-- Name: calendarevent; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.calendarevent (
    id integer NOT NULL,
    status character varying(255) DEFAULT 'draft'::character varying NOT NULL,
    user_created uuid,
    date_created timestamp with time zone,
    user_updated uuid,
    date_updated timestamp with time zone,
    start timestamp without time zone NOT NULL,
    "end" timestamp without time zone,
    title character varying(255) DEFAULT NULL::character varying
);


--
-- TOC entry 244 (class 1259 OID 16917)
-- Name: calendarevent_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.calendarevent_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3815 (class 0 OID 0)
-- Dependencies: 244
-- Name: calendarevent_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.calendarevent_id_seq OWNED BY public.calendarevent.id;


--
-- TOC entry 247 (class 1259 OID 16929)
-- Name: categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.categories (
    id integer NOT NULL,
    sort integer,
    user_created uuid,
    date_created timestamp with time zone,
    user_updated uuid,
    date_updated timestamp with time zone,
    appear_in_search boolean DEFAULT false,
    title character varying(255) DEFAULT NULL::character varying,
    parent_id integer
);


--
-- TOC entry 249 (class 1259 OID 16938)
-- Name: categories_episodes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.categories_episodes (
    id integer NOT NULL,
    categories_id integer,
    episodes_id integer
);


--
-- TOC entry 248 (class 1259 OID 16937)
-- Name: categories_episodes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.categories_episodes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3816 (class 0 OID 0)
-- Dependencies: 248
-- Name: categories_episodes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.categories_episodes_id_seq OWNED BY public.categories_episodes.id;


--
-- TOC entry 246 (class 1259 OID 16928)
-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.categories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3817 (class 0 OID 0)
-- Dependencies: 246
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.categories_id_seq OWNED BY public.categories.id;


--
-- TOC entry 251 (class 1259 OID 16945)
-- Name: collections; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.collections (
    id integer NOT NULL,
    sort integer,
    user_created uuid,
    date_created timestamp with time zone,
    user_updated uuid,
    date_updated timestamp with time zone,
    title character varying(255) DEFAULT NULL::character varying,
    content character varying(255) DEFAULT 'everything'::character varying,
    legacy_order_by character varying(255) DEFAULT NULL::character varying,
    show_episodes_in_slider boolean DEFAULT true,
    show_id integer,
    category_id integer
);


--
-- TOC entry 250 (class 1259 OID 16944)
-- Name: collections_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.collections_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3818 (class 0 OID 0)
-- Dependencies: 250
-- Name: collections_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.collections_id_seq OWNED BY public.collections.id;


--
-- TOC entry 215 (class 1259 OID 16447)
-- Name: directus_activity; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.directus_activity (
    id integer NOT NULL,
    action character varying(45) NOT NULL,
    "user" uuid,
    "timestamp" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    ip character varying(50) NOT NULL,
    user_agent character varying(255),
    collection character varying(64) NOT NULL,
    item character varying(255) NOT NULL,
    comment text
);


--
-- TOC entry 214 (class 1259 OID 16446)
-- Name: directus_activity_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.directus_activity_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3819 (class 0 OID 0)
-- Dependencies: 214
-- Name: directus_activity_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.directus_activity_id_seq OWNED BY public.directus_activity.id;


--
-- TOC entry 209 (class 1259 OID 16385)
-- Name: directus_collections; Type: TABLE; Schema: public; Owner: -
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
-- TOC entry 232 (class 1259 OID 16762)
-- Name: directus_dashboards; Type: TABLE; Schema: public; Owner: -
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
-- TOC entry 213 (class 1259 OID 16424)
-- Name: directus_fields; Type: TABLE; Schema: public; Owner: -
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
-- TOC entry 212 (class 1259 OID 16423)
-- Name: directus_fields_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.directus_fields_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3820 (class 0 OID 0)
-- Dependencies: 212
-- Name: directus_fields_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.directus_fields_id_seq OWNED BY public.directus_fields.id;


--
-- TOC entry 217 (class 1259 OID 16471)
-- Name: directus_files; Type: TABLE; Schema: public; Owner: -
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
-- TOC entry 216 (class 1259 OID 16461)
-- Name: directus_folders; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.directus_folders (
    id uuid NOT NULL,
    name character varying(255) NOT NULL,
    parent uuid
);


--
-- TOC entry 231 (class 1259 OID 16635)
-- Name: directus_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.directus_migrations (
    version character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    "timestamp" timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- TOC entry 235 (class 1259 OID 16822)
-- Name: directus_notifications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.directus_notifications (
    id integer NOT NULL,
    "timestamp" timestamp with time zone NOT NULL,
    status character varying(255) DEFAULT 'inbox'::character varying,
    recipient uuid NOT NULL,
    sender uuid NOT NULL,
    subject character varying(255) NOT NULL,
    message text,
    collection character varying(64),
    item character varying(255)
);


--
-- TOC entry 234 (class 1259 OID 16821)
-- Name: directus_notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.directus_notifications_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3821 (class 0 OID 0)
-- Dependencies: 234
-- Name: directus_notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.directus_notifications_id_seq OWNED BY public.directus_notifications.id;


--
-- TOC entry 233 (class 1259 OID 16776)
-- Name: directus_panels; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.directus_panels (
    id uuid NOT NULL,
    dashboard uuid NOT NULL,
    name character varying(255),
    icon character varying(30) DEFAULT 'insert_chart'::character varying,
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
-- TOC entry 219 (class 1259 OID 16497)
-- Name: directus_permissions; Type: TABLE; Schema: public; Owner: -
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
-- TOC entry 218 (class 1259 OID 16496)
-- Name: directus_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.directus_permissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3822 (class 0 OID 0)
-- Dependencies: 218
-- Name: directus_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.directus_permissions_id_seq OWNED BY public.directus_permissions.id;


--
-- TOC entry 221 (class 1259 OID 16516)
-- Name: directus_presets; Type: TABLE; Schema: public; Owner: -
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
-- TOC entry 220 (class 1259 OID 16515)
-- Name: directus_presets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.directus_presets_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3823 (class 0 OID 0)
-- Dependencies: 220
-- Name: directus_presets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.directus_presets_id_seq OWNED BY public.directus_presets.id;


--
-- TOC entry 223 (class 1259 OID 16541)
-- Name: directus_relations; Type: TABLE; Schema: public; Owner: -
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
-- TOC entry 222 (class 1259 OID 16540)
-- Name: directus_relations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.directus_relations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3824 (class 0 OID 0)
-- Dependencies: 222
-- Name: directus_relations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.directus_relations_id_seq OWNED BY public.directus_relations.id;


--
-- TOC entry 225 (class 1259 OID 16560)
-- Name: directus_revisions; Type: TABLE; Schema: public; Owner: -
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
-- TOC entry 224 (class 1259 OID 16559)
-- Name: directus_revisions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.directus_revisions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3825 (class 0 OID 0)
-- Dependencies: 224
-- Name: directus_revisions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.directus_revisions_id_seq OWNED BY public.directus_revisions.id;


--
-- TOC entry 210 (class 1259 OID 16395)
-- Name: directus_roles; Type: TABLE; Schema: public; Owner: -
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
-- TOC entry 226 (class 1259 OID 16583)
-- Name: directus_sessions; Type: TABLE; Schema: public; Owner: -
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
-- TOC entry 228 (class 1259 OID 16596)
-- Name: directus_settings; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 227 (class 1259 OID 16595)
-- Name: directus_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.directus_settings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3826 (class 0 OID 0)
-- Dependencies: 227
-- Name: directus_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.directus_settings_id_seq OWNED BY public.directus_settings.id;


--
-- TOC entry 236 (class 1259 OID 16842)
-- Name: directus_shares; Type: TABLE; Schema: public; Owner: -
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
-- TOC entry 211 (class 1259 OID 16406)
-- Name: directus_users; Type: TABLE; Schema: public; Owner: -
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
-- TOC entry 230 (class 1259 OID 16624)
-- Name: directus_webhooks; Type: TABLE; Schema: public; Owner: -
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
-- TOC entry 229 (class 1259 OID 16623)
-- Name: directus_webhooks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.directus_webhooks_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3827 (class 0 OID 0)
-- Dependencies: 229
-- Name: directus_webhooks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.directus_webhooks_id_seq OWNED BY public.directus_webhooks.id;


--
-- TOC entry 253 (class 1259 OID 16958)
-- Name: episodes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.episodes (
    id integer NOT NULL,
    status character varying(255) DEFAULT 'draft'::character varying NOT NULL,
    user_created uuid,
    date_created timestamp with time zone,
    user_updated uuid,
    date_updated timestamp with time zone,
    available_from timestamp without time zone,
    available_to timestamp without time zone,
    agerating_code character varying(255) DEFAULT NULL::character varying,
    season_id integer,
    migration_data json,
    publish_date timestamp without time zone NOT NULL,
    type character varying(255) DEFAULT NULL::character varying NOT NULL,
    image_file_id uuid
);


--
-- TOC entry 252 (class 1259 OID 16957)
-- Name: episodes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.episodes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3828 (class 0 OID 0)
-- Dependencies: 252
-- Name: episodes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.episodes_id_seq OWNED BY public.episodes.id;


--
-- TOC entry 255 (class 1259 OID 16970)
-- Name: episodes_translations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.episodes_translations (
    id integer NOT NULL,
    episodes_id integer,
    languages_id character varying(255) DEFAULT NULL::character varying,
    title character varying(255) DEFAULT NULL::character varying,
    description character varying(255) DEFAULT NULL::character varying,
    is_primary boolean DEFAULT true
);


--
-- TOC entry 254 (class 1259 OID 16969)
-- Name: episodes_translations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.episodes_translations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3829 (class 0 OID 0)
-- Dependencies: 254
-- Name: episodes_translations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.episodes_translations_id_seq OWNED BY public.episodes_translations.id;


--
-- TOC entry 257 (class 1259 OID 16983)
-- Name: episodes_usergroups; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.episodes_usergroups (
    id integer NOT NULL,
    episodes_id integer,
    usergroups_code character varying(255) DEFAULT NULL::character varying
);


--
-- TOC entry 256 (class 1259 OID 16982)
-- Name: episodes_usergroups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.episodes_usergroups_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3830 (class 0 OID 0)
-- Dependencies: 256
-- Name: episodes_usergroups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.episodes_usergroups_id_seq OWNED BY public.episodes_usergroups.id;


--
-- TOC entry 259 (class 1259 OID 16991)
-- Name: featureds; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.featureds (
    id integer NOT NULL,
    status character varying(255) DEFAULT 'draft'::character varying NOT NULL,
    sort integer,
    user_created uuid,
    date_created timestamp with time zone,
    user_updated uuid,
    date_updated timestamp with time zone
);


--
-- TOC entry 258 (class 1259 OID 16990)
-- Name: featureds_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.featureds_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3831 (class 0 OID 0)
-- Dependencies: 258
-- Name: featureds_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.featureds_id_seq OWNED BY public.featureds.id;


--
-- TOC entry 260 (class 1259 OID 16998)
-- Name: languages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.languages (
    code character varying(255) DEFAULT NULL::character varying NOT NULL,
    name character varying(255) DEFAULT NULL::character varying,
    legacy_3_letter_code character varying(255) DEFAULT NULL::character varying,
    legacy_2_letter_code character varying(255) DEFAULT NULL::character varying
);


--
-- TOC entry 262 (class 1259 OID 17010)
-- Name: pages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pages (
    id integer NOT NULL,
    status character varying(255) DEFAULT 'draft'::character varying NOT NULL,
    sort integer,
    user_created uuid,
    date_created timestamp with time zone,
    user_updated uuid,
    date_updated timestamp with time zone,
    code character varying(255) DEFAULT NULL::character varying
);


--
-- TOC entry 261 (class 1259 OID 17009)
-- Name: pages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.pages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3832 (class 0 OID 0)
-- Dependencies: 261
-- Name: pages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.pages_id_seq OWNED BY public.pages.id;


--
-- TOC entry 264 (class 1259 OID 17021)
-- Name: seasons; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.seasons (
    id integer NOT NULL,
    status character varying(255) DEFAULT 'draft'::character varying NOT NULL,
    user_created uuid,
    date_created timestamp with time zone,
    user_updated uuid,
    date_updated timestamp with time zone,
    available_from timestamp without time zone,
    available_to timestamp without time zone,
    show_id integer NOT NULL,
    agerating_code character varying(255) DEFAULT NULL::character varying,
    publish_date timestamp without time zone NOT NULL,
    image_file_id uuid
);


--
-- TOC entry 263 (class 1259 OID 17020)
-- Name: seasons_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.seasons_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3833 (class 0 OID 0)
-- Dependencies: 263
-- Name: seasons_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.seasons_id_seq OWNED BY public.seasons.id;


--
-- TOC entry 266 (class 1259 OID 17032)
-- Name: seasons_translations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.seasons_translations (
    id integer NOT NULL,
    seasons_id integer,
    languages_code character varying(255) DEFAULT NULL::character varying,
    title character varying(255) DEFAULT NULL::character varying,
    description character varying(255) DEFAULT NULL::character varying,
    legacy_tags character varying(255) DEFAULT NULL::character varying
);


--
-- TOC entry 265 (class 1259 OID 17031)
-- Name: seasons_translations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.seasons_translations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3834 (class 0 OID 0)
-- Dependencies: 265
-- Name: seasons_translations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.seasons_translations_id_seq OWNED BY public.seasons_translations.id;


--
-- TOC entry 268 (class 1259 OID 17045)
-- Name: seasons_usergroups; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.seasons_usergroups (
    id integer NOT NULL,
    seasons_id integer,
    usergroups_code character varying(255) DEFAULT NULL::character varying
);


--
-- TOC entry 267 (class 1259 OID 17044)
-- Name: seasons_usergroups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.seasons_usergroups_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3835 (class 0 OID 0)
-- Dependencies: 267
-- Name: seasons_usergroups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.seasons_usergroups_id_seq OWNED BY public.seasons_usergroups.id;


--
-- TOC entry 270 (class 1259 OID 17053)
-- Name: sections; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sections (
    id integer NOT NULL,
    status character varying(255) DEFAULT 'draft'::character varying NOT NULL,
    user_created uuid,
    date_created timestamp with time zone,
    user_updated uuid,
    date_updated timestamp with time zone,
    page integer,
    title character varying(255) DEFAULT NULL::character varying NOT NULL
);


--
-- TOC entry 269 (class 1259 OID 17052)
-- Name: sections_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sections_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3836 (class 0 OID 0)
-- Dependencies: 269
-- Name: sections_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sections_id_seq OWNED BY public.sections.id;


--
-- TOC entry 272 (class 1259 OID 17064)
-- Name: sections_usergroups; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sections_usergroups (
    id integer NOT NULL,
    sections_id integer,
    usergroups_code character varying(255) DEFAULT NULL::character varying
);


--
-- TOC entry 271 (class 1259 OID 17063)
-- Name: sections_usergroups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sections_usergroups_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3837 (class 0 OID 0)
-- Dependencies: 271
-- Name: sections_usergroups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sections_usergroups_id_seq OWNED BY public.sections_usergroups.id;


--
-- TOC entry 274 (class 1259 OID 17072)
-- Name: shows; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.shows (
    id integer NOT NULL,
    status character varying(255) DEFAULT 'draft'::character varying NOT NULL,
    user_created uuid,
    date_created timestamp with time zone,
    user_updated uuid,
    date_updated timestamp with time zone,
    title character varying(255) DEFAULT NULL::character varying NOT NULL,
    description text,
    image uuid,
    available_from timestamp without time zone,
    available_to timestamp without time zone,
    migration_data json,
    publish_date timestamp without time zone NOT NULL,
    type character varying(255) DEFAULT NULL::character varying NOT NULL,
    agerating_code character varying(255) DEFAULT NULL::character varying,
    image_file_id uuid
);


--
-- TOC entry 273 (class 1259 OID 17071)
-- Name: shows_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.shows_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3838 (class 0 OID 0)
-- Dependencies: 273
-- Name: shows_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.shows_id_seq OWNED BY public.shows.id;


--
-- TOC entry 276 (class 1259 OID 17087)
-- Name: shows_usergroups; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.shows_usergroups (
    id integer NOT NULL,
    shows_id integer,
    usergroups_code character varying(255) DEFAULT NULL::character varying
);


--
-- TOC entry 275 (class 1259 OID 17086)
-- Name: shows_usergroups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.shows_usergroups_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3839 (class 0 OID 0)
-- Dependencies: 275
-- Name: shows_usergroups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.shows_usergroups_id_seq OWNED BY public.shows_usergroups.id;


--
-- TOC entry 278 (class 1259 OID 17095)
-- Name: tvguideentry; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tvguideentry (
    id integer NOT NULL,
    status character varying(255) DEFAULT 'published'::character varying,
    user_created uuid,
    date_created timestamp with time zone,
    user_updated uuid,
    date_updated timestamp with time zone,
    title character varying(255) DEFAULT NULL::character varying,
    description character varying(255) DEFAULT NULL::character varying,
    image uuid,
    event integer,
    start timestamp without time zone,
    "end" timestamp without time zone,
    use_image_from_link boolean DEFAULT true NOT NULL
);


--
-- TOC entry 277 (class 1259 OID 17094)
-- Name: tvguideentry_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tvguideentry_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3840 (class 0 OID 0)
-- Dependencies: 277
-- Name: tvguideentry_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tvguideentry_id_seq OWNED BY public.tvguideentry.id;


--
-- TOC entry 280 (class 1259 OID 17108)
-- Name: tvguideentry_link; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tvguideentry_link (
    id integer NOT NULL,
    tvguideentry_id integer,
    item character varying(255) DEFAULT NULL::character varying,
    collection character varying(255) DEFAULT NULL::character varying
);


--
-- TOC entry 279 (class 1259 OID 17107)
-- Name: tvguideentry_link_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tvguideentry_link_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3841 (class 0 OID 0)
-- Dependencies: 279
-- Name: tvguideentry_link_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tvguideentry_link_id_seq OWNED BY public.tvguideentry_link.id;


--
-- TOC entry 281 (class 1259 OID 17118)
-- Name: usergroups; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.usergroups (
    code character varying(255) DEFAULT NULL::character varying NOT NULL,
    sort integer,
    user_created uuid,
    date_created timestamp with time zone,
    user_updated uuid,
    date_updated timestamp with time zone,
    name character varying(255) DEFAULT NULL::character varying
);


--
-- TOC entry 3416 (class 2604 OID 16889)
-- Name: ageratings_translations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ageratings_translations ALTER COLUMN id SET DEFAULT nextval('public.ageratings_translations_id_seq'::regclass);


--
-- TOC entry 3420 (class 2604 OID 16901)
-- Name: assetfiles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assetfiles ALTER COLUMN id SET DEFAULT nextval('public.assetfiles_id_seq'::regclass);


--
-- TOC entry 3424 (class 2604 OID 16913)
-- Name: assets id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assets ALTER COLUMN id SET DEFAULT nextval('public.assets_id_seq'::regclass);


--
-- TOC entry 3426 (class 2604 OID 16921)
-- Name: calendarevent id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.calendarevent ALTER COLUMN id SET DEFAULT nextval('public.calendarevent_id_seq'::regclass);


--
-- TOC entry 3429 (class 2604 OID 16932)
-- Name: categories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categories ALTER COLUMN id SET DEFAULT nextval('public.categories_id_seq'::regclass);


--
-- TOC entry 3432 (class 2604 OID 16941)
-- Name: categories_episodes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categories_episodes ALTER COLUMN id SET DEFAULT nextval('public.categories_episodes_id_seq'::regclass);


--
-- TOC entry 3433 (class 2604 OID 16948)
-- Name: collections id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.collections ALTER COLUMN id SET DEFAULT nextval('public.collections_id_seq'::regclass);


--
-- TOC entry 3383 (class 2604 OID 16450)
-- Name: directus_activity id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.directus_activity ALTER COLUMN id SET DEFAULT nextval('public.directus_activity_id_seq'::regclass);


--
-- TOC entry 3378 (class 2604 OID 16427)
-- Name: directus_fields id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.directus_fields ALTER COLUMN id SET DEFAULT nextval('public.directus_fields_id_seq'::regclass);


--
-- TOC entry 3410 (class 2604 OID 16825)
-- Name: directus_notifications id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.directus_notifications ALTER COLUMN id SET DEFAULT nextval('public.directus_notifications_id_seq'::regclass);


--
-- TOC entry 3387 (class 2604 OID 16500)
-- Name: directus_permissions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.directus_permissions ALTER COLUMN id SET DEFAULT nextval('public.directus_permissions_id_seq'::regclass);


--
-- TOC entry 3388 (class 2604 OID 16519)
-- Name: directus_presets id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.directus_presets ALTER COLUMN id SET DEFAULT nextval('public.directus_presets_id_seq'::regclass);


--
-- TOC entry 3391 (class 2604 OID 16544)
-- Name: directus_relations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.directus_relations ALTER COLUMN id SET DEFAULT nextval('public.directus_relations_id_seq'::regclass);


--
-- TOC entry 3393 (class 2604 OID 16563)
-- Name: directus_revisions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.directus_revisions ALTER COLUMN id SET DEFAULT nextval('public.directus_revisions_id_seq'::regclass);


--
-- TOC entry 3394 (class 2604 OID 16599)
-- Name: directus_settings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.directus_settings ALTER COLUMN id SET DEFAULT nextval('public.directus_settings_id_seq'::regclass);


--
-- TOC entry 3400 (class 2604 OID 16627)
-- Name: directus_webhooks id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.directus_webhooks ALTER COLUMN id SET DEFAULT nextval('public.directus_webhooks_id_seq'::regclass);


--
-- TOC entry 3438 (class 2604 OID 16961)
-- Name: episodes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.episodes ALTER COLUMN id SET DEFAULT nextval('public.episodes_id_seq'::regclass);


--
-- TOC entry 3442 (class 2604 OID 16973)
-- Name: episodes_translations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.episodes_translations ALTER COLUMN id SET DEFAULT nextval('public.episodes_translations_id_seq'::regclass);


--
-- TOC entry 3447 (class 2604 OID 16986)
-- Name: episodes_usergroups id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.episodes_usergroups ALTER COLUMN id SET DEFAULT nextval('public.episodes_usergroups_id_seq'::regclass);


--
-- TOC entry 3449 (class 2604 OID 16994)
-- Name: featureds id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.featureds ALTER COLUMN id SET DEFAULT nextval('public.featureds_id_seq'::regclass);


--
-- TOC entry 3455 (class 2604 OID 17013)
-- Name: pages id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pages ALTER COLUMN id SET DEFAULT nextval('public.pages_id_seq'::regclass);


--
-- TOC entry 3458 (class 2604 OID 17024)
-- Name: seasons id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.seasons ALTER COLUMN id SET DEFAULT nextval('public.seasons_id_seq'::regclass);


--
-- TOC entry 3461 (class 2604 OID 17035)
-- Name: seasons_translations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.seasons_translations ALTER COLUMN id SET DEFAULT nextval('public.seasons_translations_id_seq'::regclass);


--
-- TOC entry 3466 (class 2604 OID 17048)
-- Name: seasons_usergroups id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.seasons_usergroups ALTER COLUMN id SET DEFAULT nextval('public.seasons_usergroups_id_seq'::regclass);


--
-- TOC entry 3468 (class 2604 OID 17056)
-- Name: sections id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sections ALTER COLUMN id SET DEFAULT nextval('public.sections_id_seq'::regclass);


--
-- TOC entry 3471 (class 2604 OID 17067)
-- Name: sections_usergroups id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sections_usergroups ALTER COLUMN id SET DEFAULT nextval('public.sections_usergroups_id_seq'::regclass);


--
-- TOC entry 3473 (class 2604 OID 17075)
-- Name: shows id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shows ALTER COLUMN id SET DEFAULT nextval('public.shows_id_seq'::regclass);


--
-- TOC entry 3478 (class 2604 OID 17090)
-- Name: shows_usergroups id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shows_usergroups ALTER COLUMN id SET DEFAULT nextval('public.shows_usergroups_id_seq'::regclass);


--
-- TOC entry 3480 (class 2604 OID 17098)
-- Name: tvguideentry id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tvguideentry ALTER COLUMN id SET DEFAULT nextval('public.tvguideentry_id_seq'::regclass);


--
-- TOC entry 3485 (class 2604 OID 17111)
-- Name: tvguideentry_link id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tvguideentry_link ALTER COLUMN id SET DEFAULT nextval('public.tvguideentry_link_id_seq'::regclass);


--
-- TOC entry 3535 (class 2606 OID 16884)
-- Name: ageratings ageratings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ageratings
    ADD CONSTRAINT ageratings_pkey PRIMARY KEY (code);


--
-- TOC entry 3537 (class 2606 OID 16896)
-- Name: ageratings_translations ageratings_translations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ageratings_translations
    ADD CONSTRAINT ageratings_translations_pkey PRIMARY KEY (id);


--
-- TOC entry 3539 (class 2606 OID 16908)
-- Name: assetfiles assetfiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assetfiles
    ADD CONSTRAINT assetfiles_pkey PRIMARY KEY (id);


--
-- TOC entry 3541 (class 2606 OID 16916)
-- Name: assets assets_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assets
    ADD CONSTRAINT assets_pkey PRIMARY KEY (id);


--
-- TOC entry 3543 (class 2606 OID 16927)
-- Name: calendarevent calendarevent_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.calendarevent
    ADD CONSTRAINT calendarevent_pkey PRIMARY KEY (id);


--
-- TOC entry 3547 (class 2606 OID 16943)
-- Name: categories_episodes categories_episodes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categories_episodes
    ADD CONSTRAINT categories_episodes_pkey PRIMARY KEY (id);


--
-- TOC entry 3545 (class 2606 OID 16936)
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- TOC entry 3549 (class 2606 OID 16956)
-- Name: collections collections_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.collections
    ADD CONSTRAINT collections_pkey PRIMARY KEY (id);


--
-- TOC entry 3505 (class 2606 OID 16455)
-- Name: directus_activity directus_activity_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.directus_activity
    ADD CONSTRAINT directus_activity_pkey PRIMARY KEY (id);


--
-- TOC entry 3491 (class 2606 OID 16394)
-- Name: directus_collections directus_collections_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.directus_collections
    ADD CONSTRAINT directus_collections_pkey PRIMARY KEY (collection);


--
-- TOC entry 3527 (class 2606 OID 16770)
-- Name: directus_dashboards directus_dashboards_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.directus_dashboards
    ADD CONSTRAINT directus_dashboards_pkey PRIMARY KEY (id);


--
-- TOC entry 3503 (class 2606 OID 16435)
-- Name: directus_fields directus_fields_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.directus_fields
    ADD CONSTRAINT directus_fields_pkey PRIMARY KEY (id);


--
-- TOC entry 3509 (class 2606 OID 16480)
-- Name: directus_files directus_files_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.directus_files
    ADD CONSTRAINT directus_files_pkey PRIMARY KEY (id);


--
-- TOC entry 3507 (class 2606 OID 16465)
-- Name: directus_folders directus_folders_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.directus_folders
    ADD CONSTRAINT directus_folders_pkey PRIMARY KEY (id);


--
-- TOC entry 3525 (class 2606 OID 16642)
-- Name: directus_migrations directus_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.directus_migrations
    ADD CONSTRAINT directus_migrations_pkey PRIMARY KEY (version);


--
-- TOC entry 3531 (class 2606 OID 16830)
-- Name: directus_notifications directus_notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.directus_notifications
    ADD CONSTRAINT directus_notifications_pkey PRIMARY KEY (id);


--
-- TOC entry 3529 (class 2606 OID 16785)
-- Name: directus_panels directus_panels_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.directus_panels
    ADD CONSTRAINT directus_panels_pkey PRIMARY KEY (id);


--
-- TOC entry 3511 (class 2606 OID 16504)
-- Name: directus_permissions directus_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.directus_permissions
    ADD CONSTRAINT directus_permissions_pkey PRIMARY KEY (id);


--
-- TOC entry 3513 (class 2606 OID 16524)
-- Name: directus_presets directus_presets_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.directus_presets
    ADD CONSTRAINT directus_presets_pkey PRIMARY KEY (id);


--
-- TOC entry 3515 (class 2606 OID 16548)
-- Name: directus_relations directus_relations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.directus_relations
    ADD CONSTRAINT directus_relations_pkey PRIMARY KEY (id);


--
-- TOC entry 3517 (class 2606 OID 16567)
-- Name: directus_revisions directus_revisions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.directus_revisions
    ADD CONSTRAINT directus_revisions_pkey PRIMARY KEY (id);


--
-- TOC entry 3493 (class 2606 OID 16405)
-- Name: directus_roles directus_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.directus_roles
    ADD CONSTRAINT directus_roles_pkey PRIMARY KEY (id);


--
-- TOC entry 3519 (class 2606 OID 16589)
-- Name: directus_sessions directus_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.directus_sessions
    ADD CONSTRAINT directus_sessions_pkey PRIMARY KEY (token);


--
-- TOC entry 3521 (class 2606 OID 16607)
-- Name: directus_settings directus_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.directus_settings
    ADD CONSTRAINT directus_settings_pkey PRIMARY KEY (id);


--
-- TOC entry 3533 (class 2606 OID 16850)
-- Name: directus_shares directus_shares_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.directus_shares
    ADD CONSTRAINT directus_shares_pkey PRIMARY KEY (id);


--
-- TOC entry 3495 (class 2606 OID 16812)
-- Name: directus_users directus_users_email_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.directus_users
    ADD CONSTRAINT directus_users_email_unique UNIQUE (email);


--
-- TOC entry 3497 (class 2606 OID 16810)
-- Name: directus_users directus_users_external_identifier_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.directus_users
    ADD CONSTRAINT directus_users_external_identifier_unique UNIQUE (external_identifier);


--
-- TOC entry 3499 (class 2606 OID 16415)
-- Name: directus_users directus_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.directus_users
    ADD CONSTRAINT directus_users_pkey PRIMARY KEY (id);


--
-- TOC entry 3501 (class 2606 OID 16820)
-- Name: directus_users directus_users_token_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.directus_users
    ADD CONSTRAINT directus_users_token_unique UNIQUE (token);


--
-- TOC entry 3523 (class 2606 OID 16634)
-- Name: directus_webhooks directus_webhooks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.directus_webhooks
    ADD CONSTRAINT directus_webhooks_pkey PRIMARY KEY (id);


--
-- TOC entry 3551 (class 2606 OID 16968)
-- Name: episodes episodes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.episodes
    ADD CONSTRAINT episodes_pkey PRIMARY KEY (id);


--
-- TOC entry 3553 (class 2606 OID 16981)
-- Name: episodes_translations episodes_translations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.episodes_translations
    ADD CONSTRAINT episodes_translations_pkey PRIMARY KEY (id);


--
-- TOC entry 3555 (class 2606 OID 16989)
-- Name: episodes_usergroups episodes_usergroups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.episodes_usergroups
    ADD CONSTRAINT episodes_usergroups_pkey PRIMARY KEY (id);


--
-- TOC entry 3557 (class 2606 OID 16997)
-- Name: featureds featureds_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.featureds
    ADD CONSTRAINT featureds_pkey PRIMARY KEY (id);


--
-- TOC entry 3559 (class 2606 OID 17008)
-- Name: languages languages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.languages
    ADD CONSTRAINT languages_pkey PRIMARY KEY (code);


--
-- TOC entry 3561 (class 2606 OID 17019)
-- Name: pages pages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pages
    ADD CONSTRAINT pages_pkey PRIMARY KEY (id);


--
-- TOC entry 3563 (class 2606 OID 17030)
-- Name: seasons seasons_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.seasons
    ADD CONSTRAINT seasons_pkey PRIMARY KEY (id);


--
-- TOC entry 3565 (class 2606 OID 17043)
-- Name: seasons_translations seasons_translations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.seasons_translations
    ADD CONSTRAINT seasons_translations_pkey PRIMARY KEY (id);


--
-- TOC entry 3567 (class 2606 OID 17051)
-- Name: seasons_usergroups seasons_usergroups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.seasons_usergroups
    ADD CONSTRAINT seasons_usergroups_pkey PRIMARY KEY (id);


--
-- TOC entry 3569 (class 2606 OID 17062)
-- Name: sections sections_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sections
    ADD CONSTRAINT sections_pkey PRIMARY KEY (id);


--
-- TOC entry 3571 (class 2606 OID 17070)
-- Name: sections_usergroups sections_usergroups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sections_usergroups
    ADD CONSTRAINT sections_usergroups_pkey PRIMARY KEY (id);


--
-- TOC entry 3573 (class 2606 OID 17083)
-- Name: shows shows_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shows
    ADD CONSTRAINT shows_pkey PRIMARY KEY (id);


--
-- TOC entry 3575 (class 2606 OID 17085)
-- Name: shows shows_publish_date_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shows
    ADD CONSTRAINT shows_publish_date_unique UNIQUE (publish_date);


--
-- TOC entry 3577 (class 2606 OID 17093)
-- Name: shows_usergroups shows_usergroups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shows_usergroups
    ADD CONSTRAINT shows_usergroups_pkey PRIMARY KEY (id);


--
-- TOC entry 3581 (class 2606 OID 17117)
-- Name: tvguideentry_link tvguideentry_link_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tvguideentry_link
    ADD CONSTRAINT tvguideentry_link_pkey PRIMARY KEY (id);


--
-- TOC entry 3579 (class 2606 OID 17106)
-- Name: tvguideentry tvguideentry_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tvguideentry
    ADD CONSTRAINT tvguideentry_pkey PRIMARY KEY (id);


--
-- TOC entry 3583 (class 2606 OID 17126)
-- Name: usergroups usergroups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.usergroups
    ADD CONSTRAINT usergroups_pkey PRIMARY KEY (code);


--
-- TOC entry 3610 (class 2606 OID 17132)
-- Name: ageratings_translations ageratings_translations_ageratings_code_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ageratings_translations
    ADD CONSTRAINT ageratings_translations_ageratings_code_foreign FOREIGN KEY (ageratings_code) REFERENCES public.ageratings(code) ON DELETE SET NULL;


--
-- TOC entry 3609 (class 2606 OID 17127)
-- Name: ageratings_translations ageratings_translations_languages_code_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ageratings_translations
    ADD CONSTRAINT ageratings_translations_languages_code_foreign FOREIGN KEY (languages_code) REFERENCES public.languages(code) ON DELETE SET NULL;


--
-- TOC entry 3611 (class 2606 OID 17137)
-- Name: assetfiles assetfiles_asset_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assetfiles
    ADD CONSTRAINT assetfiles_asset_id_foreign FOREIGN KEY (asset_id) REFERENCES public.assets(id);


--
-- TOC entry 3613 (class 2606 OID 17147)
-- Name: assetfiles assetfiles_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assetfiles
    ADD CONSTRAINT assetfiles_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id);


--
-- TOC entry 3612 (class 2606 OID 17142)
-- Name: assetfiles assetfiles_user_updated_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assetfiles
    ADD CONSTRAINT assetfiles_user_updated_foreign FOREIGN KEY (user_updated) REFERENCES public.directus_users(id);


--
-- TOC entry 3615 (class 2606 OID 17157)
-- Name: assets assets_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assets
    ADD CONSTRAINT assets_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id);


--
-- TOC entry 3614 (class 2606 OID 17152)
-- Name: assets assets_user_updated_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assets
    ADD CONSTRAINT assets_user_updated_foreign FOREIGN KEY (user_updated) REFERENCES public.directus_users(id);


--
-- TOC entry 3617 (class 2606 OID 17167)
-- Name: calendarevent calendarevent_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.calendarevent
    ADD CONSTRAINT calendarevent_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id);


--
-- TOC entry 3616 (class 2606 OID 17162)
-- Name: calendarevent calendarevent_user_updated_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.calendarevent
    ADD CONSTRAINT calendarevent_user_updated_foreign FOREIGN KEY (user_updated) REFERENCES public.directus_users(id);


--
-- TOC entry 3621 (class 2606 OID 17187)
-- Name: categories_episodes categories_episodes_categories_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categories_episodes
    ADD CONSTRAINT categories_episodes_categories_id_foreign FOREIGN KEY (categories_id) REFERENCES public.categories(id) ON DELETE SET NULL;


--
-- TOC entry 3622 (class 2606 OID 17192)
-- Name: categories_episodes categories_episodes_episodes_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categories_episodes
    ADD CONSTRAINT categories_episodes_episodes_id_foreign FOREIGN KEY (episodes_id) REFERENCES public.episodes(id) ON DELETE SET NULL;


--
-- TOC entry 3618 (class 2606 OID 17172)
-- Name: categories categories_parent_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_parent_id_foreign FOREIGN KEY (parent_id) REFERENCES public.categories(id);


--
-- TOC entry 3620 (class 2606 OID 17182)
-- Name: categories categories_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id);


--
-- TOC entry 3619 (class 2606 OID 17177)
-- Name: categories categories_user_updated_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_user_updated_foreign FOREIGN KEY (user_updated) REFERENCES public.directus_users(id);


--
-- TOC entry 3623 (class 2606 OID 17197)
-- Name: collections collections_category_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.collections
    ADD CONSTRAINT collections_category_id_foreign FOREIGN KEY (category_id) REFERENCES public.categories(id) ON DELETE SET NULL;


--
-- TOC entry 3624 (class 2606 OID 17202)
-- Name: collections collections_show_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.collections
    ADD CONSTRAINT collections_show_id_foreign FOREIGN KEY (show_id) REFERENCES public.shows(id) ON DELETE SET NULL;


--
-- TOC entry 3626 (class 2606 OID 17212)
-- Name: collections collections_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.collections
    ADD CONSTRAINT collections_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id);


--
-- TOC entry 3625 (class 2606 OID 17207)
-- Name: collections collections_user_updated_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.collections
    ADD CONSTRAINT collections_user_updated_foreign FOREIGN KEY (user_updated) REFERENCES public.directus_users(id);


--
-- TOC entry 3584 (class 2606 OID 16814)
-- Name: directus_collections directus_collections_group_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.directus_collections
    ADD CONSTRAINT directus_collections_group_foreign FOREIGN KEY ("group") REFERENCES public.directus_collections(collection);


--
-- TOC entry 3601 (class 2606 OID 16771)
-- Name: directus_dashboards directus_dashboards_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.directus_dashboards
    ADD CONSTRAINT directus_dashboards_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id) ON DELETE SET NULL;


--
-- TOC entry 3589 (class 2606 OID 16727)
-- Name: directus_files directus_files_folder_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.directus_files
    ADD CONSTRAINT directus_files_folder_foreign FOREIGN KEY (folder) REFERENCES public.directus_folders(id) ON DELETE SET NULL;


--
-- TOC entry 3588 (class 2606 OID 16658)
-- Name: directus_files directus_files_modified_by_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.directus_files
    ADD CONSTRAINT directus_files_modified_by_foreign FOREIGN KEY (modified_by) REFERENCES public.directus_users(id);


--
-- TOC entry 3587 (class 2606 OID 16653)
-- Name: directus_files directus_files_uploaded_by_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.directus_files
    ADD CONSTRAINT directus_files_uploaded_by_foreign FOREIGN KEY (uploaded_by) REFERENCES public.directus_users(id);


--
-- TOC entry 3586 (class 2606 OID 16663)
-- Name: directus_folders directus_folders_parent_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.directus_folders
    ADD CONSTRAINT directus_folders_parent_foreign FOREIGN KEY (parent) REFERENCES public.directus_folders(id);


--
-- TOC entry 3604 (class 2606 OID 16831)
-- Name: directus_notifications directus_notifications_recipient_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.directus_notifications
    ADD CONSTRAINT directus_notifications_recipient_foreign FOREIGN KEY (recipient) REFERENCES public.directus_users(id) ON DELETE CASCADE;


--
-- TOC entry 3605 (class 2606 OID 16836)
-- Name: directus_notifications directus_notifications_sender_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.directus_notifications
    ADD CONSTRAINT directus_notifications_sender_foreign FOREIGN KEY (sender) REFERENCES public.directus_users(id);


--
-- TOC entry 3602 (class 2606 OID 16786)
-- Name: directus_panels directus_panels_dashboard_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.directus_panels
    ADD CONSTRAINT directus_panels_dashboard_foreign FOREIGN KEY (dashboard) REFERENCES public.directus_dashboards(id) ON DELETE CASCADE;


--
-- TOC entry 3603 (class 2606 OID 16791)
-- Name: directus_panels directus_panels_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.directus_panels
    ADD CONSTRAINT directus_panels_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id) ON DELETE SET NULL;


--
-- TOC entry 3590 (class 2606 OID 16732)
-- Name: directus_permissions directus_permissions_role_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.directus_permissions
    ADD CONSTRAINT directus_permissions_role_foreign FOREIGN KEY (role) REFERENCES public.directus_roles(id) ON DELETE CASCADE;


--
-- TOC entry 3592 (class 2606 OID 16742)
-- Name: directus_presets directus_presets_role_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.directus_presets
    ADD CONSTRAINT directus_presets_role_foreign FOREIGN KEY (role) REFERENCES public.directus_roles(id) ON DELETE CASCADE;


--
-- TOC entry 3591 (class 2606 OID 16737)
-- Name: directus_presets directus_presets_user_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.directus_presets
    ADD CONSTRAINT directus_presets_user_foreign FOREIGN KEY ("user") REFERENCES public.directus_users(id) ON DELETE CASCADE;


--
-- TOC entry 3594 (class 2606 OID 16747)
-- Name: directus_revisions directus_revisions_activity_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.directus_revisions
    ADD CONSTRAINT directus_revisions_activity_foreign FOREIGN KEY (activity) REFERENCES public.directus_activity(id) ON DELETE CASCADE;


--
-- TOC entry 3593 (class 2606 OID 16688)
-- Name: directus_revisions directus_revisions_parent_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.directus_revisions
    ADD CONSTRAINT directus_revisions_parent_foreign FOREIGN KEY (parent) REFERENCES public.directus_revisions(id);


--
-- TOC entry 3596 (class 2606 OID 16866)
-- Name: directus_sessions directus_sessions_share_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.directus_sessions
    ADD CONSTRAINT directus_sessions_share_foreign FOREIGN KEY (share) REFERENCES public.directus_shares(id) ON DELETE CASCADE;


--
-- TOC entry 3595 (class 2606 OID 16752)
-- Name: directus_sessions directus_sessions_user_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.directus_sessions
    ADD CONSTRAINT directus_sessions_user_foreign FOREIGN KEY ("user") REFERENCES public.directus_users(id) ON DELETE CASCADE;


--
-- TOC entry 3597 (class 2606 OID 16698)
-- Name: directus_settings directus_settings_project_logo_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.directus_settings
    ADD CONSTRAINT directus_settings_project_logo_foreign FOREIGN KEY (project_logo) REFERENCES public.directus_files(id);


--
-- TOC entry 3599 (class 2606 OID 16708)
-- Name: directus_settings directus_settings_public_background_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.directus_settings
    ADD CONSTRAINT directus_settings_public_background_foreign FOREIGN KEY (public_background) REFERENCES public.directus_files(id);


--
-- TOC entry 3598 (class 2606 OID 16703)
-- Name: directus_settings directus_settings_public_foreground_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.directus_settings
    ADD CONSTRAINT directus_settings_public_foreground_foreign FOREIGN KEY (public_foreground) REFERENCES public.directus_files(id);


--
-- TOC entry 3600 (class 2606 OID 16802)
-- Name: directus_settings directus_settings_storage_default_folder_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.directus_settings
    ADD CONSTRAINT directus_settings_storage_default_folder_foreign FOREIGN KEY (storage_default_folder) REFERENCES public.directus_folders(id) ON DELETE SET NULL;


--
-- TOC entry 3606 (class 2606 OID 16851)
-- Name: directus_shares directus_shares_collection_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.directus_shares
    ADD CONSTRAINT directus_shares_collection_foreign FOREIGN KEY (collection) REFERENCES public.directus_collections(collection) ON DELETE CASCADE;


--
-- TOC entry 3607 (class 2606 OID 16856)
-- Name: directus_shares directus_shares_role_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.directus_shares
    ADD CONSTRAINT directus_shares_role_foreign FOREIGN KEY (role) REFERENCES public.directus_roles(id) ON DELETE CASCADE;


--
-- TOC entry 3608 (class 2606 OID 16861)
-- Name: directus_shares directus_shares_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.directus_shares
    ADD CONSTRAINT directus_shares_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id) ON DELETE SET NULL;


--
-- TOC entry 3585 (class 2606 OID 16757)
-- Name: directus_users directus_users_role_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.directus_users
    ADD CONSTRAINT directus_users_role_foreign FOREIGN KEY (role) REFERENCES public.directus_roles(id) ON DELETE SET NULL;


--
-- TOC entry 3629 (class 2606 OID 17227)
-- Name: episodes episodes_agerating_code_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.episodes
    ADD CONSTRAINT episodes_agerating_code_foreign FOREIGN KEY (agerating_code) REFERENCES public.ageratings(code) ON DELETE SET NULL;


--
-- TOC entry 3627 (class 2606 OID 17217)
-- Name: episodes episodes_image_file_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.episodes
    ADD CONSTRAINT episodes_image_file_id_foreign FOREIGN KEY (image_file_id) REFERENCES public.directus_files(id) ON DELETE SET NULL;


--
-- TOC entry 3628 (class 2606 OID 17222)
-- Name: episodes episodes_season_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.episodes
    ADD CONSTRAINT episodes_season_id_foreign FOREIGN KEY (season_id) REFERENCES public.seasons(id) ON DELETE SET NULL;


--
-- TOC entry 3632 (class 2606 OID 17242)
-- Name: episodes_translations episodes_translations_episodes_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.episodes_translations
    ADD CONSTRAINT episodes_translations_episodes_id_foreign FOREIGN KEY (episodes_id) REFERENCES public.episodes(id) ON DELETE CASCADE;


--
-- TOC entry 3633 (class 2606 OID 17247)
-- Name: episodes_translations episodes_translations_languages_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.episodes_translations
    ADD CONSTRAINT episodes_translations_languages_id_foreign FOREIGN KEY (languages_id) REFERENCES public.languages(code) ON DELETE SET NULL;


--
-- TOC entry 3631 (class 2606 OID 17237)
-- Name: episodes episodes_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.episodes
    ADD CONSTRAINT episodes_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id);


--
-- TOC entry 3630 (class 2606 OID 17232)
-- Name: episodes episodes_user_updated_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.episodes
    ADD CONSTRAINT episodes_user_updated_foreign FOREIGN KEY (user_updated) REFERENCES public.directus_users(id);


--
-- TOC entry 3634 (class 2606 OID 17252)
-- Name: episodes_usergroups episodes_usergroups_episodes_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.episodes_usergroups
    ADD CONSTRAINT episodes_usergroups_episodes_id_foreign FOREIGN KEY (episodes_id) REFERENCES public.episodes(id) ON DELETE SET NULL;


--
-- TOC entry 3635 (class 2606 OID 17257)
-- Name: episodes_usergroups episodes_usergroups_usergroups_code_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.episodes_usergroups
    ADD CONSTRAINT episodes_usergroups_usergroups_code_foreign FOREIGN KEY (usergroups_code) REFERENCES public.usergroups(code) ON DELETE SET NULL;


--
-- TOC entry 3637 (class 2606 OID 17267)
-- Name: featureds featureds_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.featureds
    ADD CONSTRAINT featureds_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id);


--
-- TOC entry 3636 (class 2606 OID 17262)
-- Name: featureds featureds_user_updated_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.featureds
    ADD CONSTRAINT featureds_user_updated_foreign FOREIGN KEY (user_updated) REFERENCES public.directus_users(id);


--
-- TOC entry 3639 (class 2606 OID 17277)
-- Name: pages pages_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pages
    ADD CONSTRAINT pages_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id);


--
-- TOC entry 3638 (class 2606 OID 17272)
-- Name: pages pages_user_updated_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pages
    ADD CONSTRAINT pages_user_updated_foreign FOREIGN KEY (user_updated) REFERENCES public.directus_users(id);


--
-- TOC entry 3642 (class 2606 OID 17292)
-- Name: seasons seasons_agerating_code_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.seasons
    ADD CONSTRAINT seasons_agerating_code_foreign FOREIGN KEY (agerating_code) REFERENCES public.ageratings(code) ON DELETE SET NULL;


--
-- TOC entry 3640 (class 2606 OID 17282)
-- Name: seasons seasons_image_file_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.seasons
    ADD CONSTRAINT seasons_image_file_id_foreign FOREIGN KEY (image_file_id) REFERENCES public.directus_files(id);


--
-- TOC entry 3641 (class 2606 OID 17287)
-- Name: seasons seasons_show_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.seasons
    ADD CONSTRAINT seasons_show_id_foreign FOREIGN KEY (show_id) REFERENCES public.shows(id);


--
-- TOC entry 3645 (class 2606 OID 17307)
-- Name: seasons_translations seasons_translations_languages_code_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.seasons_translations
    ADD CONSTRAINT seasons_translations_languages_code_foreign FOREIGN KEY (languages_code) REFERENCES public.languages(code) ON DELETE SET NULL;


--
-- TOC entry 3646 (class 2606 OID 17312)
-- Name: seasons_translations seasons_translations_seasons_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.seasons_translations
    ADD CONSTRAINT seasons_translations_seasons_id_foreign FOREIGN KEY (seasons_id) REFERENCES public.seasons(id) ON DELETE SET NULL;


--
-- TOC entry 3644 (class 2606 OID 17302)
-- Name: seasons seasons_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.seasons
    ADD CONSTRAINT seasons_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id);


--
-- TOC entry 3643 (class 2606 OID 17297)
-- Name: seasons seasons_user_updated_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.seasons
    ADD CONSTRAINT seasons_user_updated_foreign FOREIGN KEY (user_updated) REFERENCES public.directus_users(id);


--
-- TOC entry 3647 (class 2606 OID 17317)
-- Name: seasons_usergroups seasons_usergroups_seasons_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.seasons_usergroups
    ADD CONSTRAINT seasons_usergroups_seasons_id_foreign FOREIGN KEY (seasons_id) REFERENCES public.seasons(id) ON DELETE SET NULL;


--
-- TOC entry 3648 (class 2606 OID 17322)
-- Name: seasons_usergroups seasons_usergroups_usergroups_code_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.seasons_usergroups
    ADD CONSTRAINT seasons_usergroups_usergroups_code_foreign FOREIGN KEY (usergroups_code) REFERENCES public.usergroups(code) ON DELETE SET NULL;


--
-- TOC entry 3649 (class 2606 OID 17327)
-- Name: sections sections_page_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sections
    ADD CONSTRAINT sections_page_foreign FOREIGN KEY (page) REFERENCES public.pages(id) ON DELETE SET NULL;


--
-- TOC entry 3651 (class 2606 OID 17337)
-- Name: sections sections_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sections
    ADD CONSTRAINT sections_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id);


--
-- TOC entry 3650 (class 2606 OID 17332)
-- Name: sections sections_user_updated_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sections
    ADD CONSTRAINT sections_user_updated_foreign FOREIGN KEY (user_updated) REFERENCES public.directus_users(id);


--
-- TOC entry 3652 (class 2606 OID 17342)
-- Name: sections_usergroups sections_usergroups_sections_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sections_usergroups
    ADD CONSTRAINT sections_usergroups_sections_id_foreign FOREIGN KEY (sections_id) REFERENCES public.sections(id) ON DELETE SET NULL;


--
-- TOC entry 3653 (class 2606 OID 17347)
-- Name: sections_usergroups sections_usergroups_usergroups_code_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sections_usergroups
    ADD CONSTRAINT sections_usergroups_usergroups_code_foreign FOREIGN KEY (usergroups_code) REFERENCES public.usergroups(code) ON DELETE SET NULL;


--
-- TOC entry 3655 (class 2606 OID 17357)
-- Name: shows shows_agerating_code_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shows
    ADD CONSTRAINT shows_agerating_code_foreign FOREIGN KEY (agerating_code) REFERENCES public.ageratings(code) ON DELETE SET NULL;


--
-- TOC entry 3654 (class 2606 OID 17352)
-- Name: shows shows_image_file_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shows
    ADD CONSTRAINT shows_image_file_id_foreign FOREIGN KEY (image_file_id) REFERENCES public.directus_files(id) ON DELETE SET NULL;


--
-- TOC entry 3658 (class 2606 OID 17372)
-- Name: shows shows_image_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shows
    ADD CONSTRAINT shows_image_foreign FOREIGN KEY (image) REFERENCES public.directus_files(id) ON DELETE SET NULL;


--
-- TOC entry 3657 (class 2606 OID 17367)
-- Name: shows shows_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shows
    ADD CONSTRAINT shows_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id);


--
-- TOC entry 3656 (class 2606 OID 17362)
-- Name: shows shows_user_updated_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shows
    ADD CONSTRAINT shows_user_updated_foreign FOREIGN KEY (user_updated) REFERENCES public.directus_users(id);


--
-- TOC entry 3659 (class 2606 OID 17377)
-- Name: shows_usergroups shows_usergroups_shows_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shows_usergroups
    ADD CONSTRAINT shows_usergroups_shows_id_foreign FOREIGN KEY (shows_id) REFERENCES public.shows(id) ON DELETE SET NULL;


--
-- TOC entry 3660 (class 2606 OID 17382)
-- Name: shows_usergroups shows_usergroups_usergroups_code_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shows_usergroups
    ADD CONSTRAINT shows_usergroups_usergroups_code_foreign FOREIGN KEY (usergroups_code) REFERENCES public.usergroups(code) ON DELETE SET NULL;


--
-- TOC entry 3661 (class 2606 OID 17387)
-- Name: tvguideentry tvguideentry_event_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tvguideentry
    ADD CONSTRAINT tvguideentry_event_foreign FOREIGN KEY (event) REFERENCES public.calendarevent(id) ON DELETE SET NULL;


--
-- TOC entry 3662 (class 2606 OID 17392)
-- Name: tvguideentry tvguideentry_image_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tvguideentry
    ADD CONSTRAINT tvguideentry_image_foreign FOREIGN KEY (image) REFERENCES public.directus_files(id) ON DELETE SET NULL;


--
-- TOC entry 3665 (class 2606 OID 17407)
-- Name: tvguideentry_link tvguideentry_link_tvguideentry_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tvguideentry_link
    ADD CONSTRAINT tvguideentry_link_tvguideentry_id_foreign FOREIGN KEY (tvguideentry_id) REFERENCES public.tvguideentry(id) ON DELETE SET NULL;


--
-- TOC entry 3664 (class 2606 OID 17402)
-- Name: tvguideentry tvguideentry_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tvguideentry
    ADD CONSTRAINT tvguideentry_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id);


--
-- TOC entry 3663 (class 2606 OID 17397)
-- Name: tvguideentry tvguideentry_user_updated_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tvguideentry
    ADD CONSTRAINT tvguideentry_user_updated_foreign FOREIGN KEY (user_updated) REFERENCES public.directus_users(id);


--
-- TOC entry 3667 (class 2606 OID 17417)
-- Name: usergroups usergroups_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.usergroups
    ADD CONSTRAINT usergroups_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id);


--
-- TOC entry 3666 (class 2606 OID 17412)
-- Name: usergroups usergroups_user_updated_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.usergroups
    ADD CONSTRAINT usergroups_user_updated_foreign FOREIGN KEY (user_updated) REFERENCES public.directus_users(id);


-- Completed on 2022-04-25 18:12:42 CEST

--
-- PostgreSQL database dump complete
--

