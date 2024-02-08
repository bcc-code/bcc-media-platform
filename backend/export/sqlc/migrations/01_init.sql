-- +goose Up

CREATE TABLE shows (
    id INTEGER NOT NULL PRIMARY KEY,
    type TEXT NOT NULL,
    legacy_id INTEGER,
    title TEXT NOT NULL,
    description TEXT NOT NULL,
    images TEXT NOT NULL, -- JSON
    default_episode INTEGER
);

CREATE TABLE seasons (
	id INTEGER NOT NULL PRIMARY KEY,
	legacy_id INTEGER,
	tag_ids TEXT NOT NULL DEFAULT '{}',
	number INTEGER NOT NULL,
	age_rating TEXT NOT NULL,
	title TEXT NOT NULL,
	description TEXT NOT NULL,
	show_id INTEGER NOT NULL,
	images TEXT NOT NULL -- JSON
);

CREATE TABLE episodes (
	id INTEGER NOT NULL PRIMARY KEY,
	legacy_id INTEGER,
	legacy_program_id INTEGER,
	age_rating TEXT NOT NULL,
	title TEXT NOT NULL,
	description TEXT NOT NULL,
	extra_description TEXT NOT NULL,
	images TEXT NOT NULL, -- JSON
	production_date TEXT,
	season_id INTEGER,
	duration INTEGER NOT NULL,
	number INTEGER NOT NULL
);

CREATE TABLE applications (
	id INTEGER NOT NULL PRIMARY KEY,
	code TEXT NOT NULL,
	client_version TEXT NOT NULL,
	default_page_id INTEGER
);

CREATE TABLE pages (
	id INTEGER NOT NULL PRIMARY KEY,
	code TEXT NOT NULL,
	title TEXT NOT NULL,
	description TEXT NOT NULL,
	images TEXT NOT NULL,
	section_ids TEXT NOT NULL
);

CREATE TABLE sections (
	id INTEGER NOT NULL PRIMARY KEY,
	sort INTEGER NOT NULL,
	page_id INTEGER NOT NULL,
	type TEXT NOT NULL,
	show_title BOOLEAN NOT NULL,
	title TEXT NOT NULL,
	description TEXT NOT NULL,
	style TEXT NOT NULL,
	size TEXT NOT NULL,
	collection_id INTEGER
);

CREATE TABLE collections (
	id INTEGER NOT NULL PRIMARY KEY,
	name TEXT NOT NULL,
	collection_items TEXT NOT NULL
);

CREATE TABLE streams (
	id INTEGER NOT NULL PRIMARY KEY,
	episode_id INTEGER NOT NULL,
	url TEXT NOT NULL,
	audio_languages TEXT NOT NULL,
	subtitle_languages TEXT NOT NULL,
	type TEXT NOT NULL,
    video_language TEXT
);
