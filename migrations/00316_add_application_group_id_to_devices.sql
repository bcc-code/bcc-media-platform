-- +goose Up

alter table users.devices add application_group_id uuid;

UPDATE users.devices dev SET application_group_id = (SELECT applicationgroup_id FROM users.profiles pr WHERE pr.id = dev.profile_id);

ALTER table users.devices ALTER COLUMN application_group_id SET NOT NULL;

-- +goose Down

alter table users.devices drop column application_group_id;
