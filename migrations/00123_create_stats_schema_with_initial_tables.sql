-- +goose Up
/**********************************************************/
/*** SCRIPT AUTHOR: Matjaz Debelak (matjaz@debelak.org) ***/
/**********************************************************/

CREATE SCHEMA stats;
ALTER schema stats OWNER TO builder;

create table stats.members_data
(
    id     integer not null
        constraint members_data_pk
            primary key,
    age_group    text not null,
    org_id integer not null
);

alter table stats.members_data
    owner to builder;

create table stats.org_counts
(
    org_id integer not null
        constraint org_counts_pk
            primary key,
    count_persons integer not null,
    age_group text not null
);

alter table stats.org_counts
    owner to builder;


alter table stats.org_counts
    drop constraint org_counts_pk;

alter table stats.org_counts
    add constraint org_counts_pk
        primary key (org_id, age_group);

create table stats.orgs
(
    id   integer not null
        constraint orgs_pk
            primary key,
    name text    not null,
    type text    not null
);

alter table stats.org_counts
    add constraint org_counts_orgs_null_fk
        foreign key (org_id) references stats.orgs (id)
            on update cascade on delete restrict;

GRANT ALL PRIVILEGES ON stats.orgs TO api;
GRANT ALL PRIVILEGES ON stats.org_counts TO api;
GRANT ALL PRIVILEGES ON stats.members_data TO api;

-- +goose Down

DROP TABLE IF EXISTS stats.members_data;
DROP TABLE IF EXISTS stats.org_counts;
DROP TABLE IF EXISTS stats.orgs;
