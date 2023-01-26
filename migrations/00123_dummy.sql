-- +goose Up
/**********************************************************/
/*** SCRIPT AUTHOR: Matjaz Debelak (matjaz@debelak.org) ***/
/***    CREATED ON: 2023-01-13T15:19:43.529Z            ***/
/**********************************************************/

CREATE SCHEMA stats;

create table stats.members_data
(
    id     integer not null
        constraint members_data_pk
            primary key,
    age    integer not null,
    org_id integer not null
);

alter table stats.members_data
    owner to builder;

GRANT ALL PRIVILEGES ON stats.members_data TO api;

alter table stats.members_data
    rename column age to age_group;

alter table stats.members_data
    alter column age_group type text using age_group::text;


--- END ALTER TABLE "users"."taskanswers" ---
-- +goose Down
/**********************************************************/
/*** SCRIPT AUTHOR: Matjaz Debelak (matjaz@debelak.org) ***/
/***    CREATED ON: 2023-01-13T15:19:45.039Z            ***/
/**********************************************************/

DROP TABLE IF EXISTS stats.members_data
