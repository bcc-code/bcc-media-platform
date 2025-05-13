-- +goose Up
alter table users.devices
alter column profile_id
drop not null;

alter table users.devices
drop constraint devices_pk;

alter table users.devices add constraint devices_pk primary key (token);

-- +goose Down
--
alter table users.devices
alter column profile_id
set
    not null;

alter table users.devices
drop constraint devices_pk;

alter table users.devices add constraint devices_pk primary key (token, profile_id);
