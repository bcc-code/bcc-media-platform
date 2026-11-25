-- +goose Up
UPDATE users.admin_permissions
SET scope = jsonb_set(scope #- '{search,group}', '{search,groups}',
                      CASE WHEN coalesce(scope #>> '{search,group}', '') = '' THEN 'null'::jsonb
                           ELSE jsonb_build_array(scope #>> '{search,group}') END)
WHERE scope -> 'search' ? 'group';

UPDATE users.admin_permissions
SET scope = scope #- '{search,groups}'
WHERE scope #> '{search,groups}' = 'null'::jsonb;

-- +goose Down
UPDATE users.admin_permissions
SET scope = jsonb_set(scope #- '{search,groups}', '{search,group}', scope #> '{search,groups,0}')
WHERE jsonb_array_length(coalesce(scope #> '{search,groups}', '[]')) > 0;

UPDATE users.admin_permissions
SET scope = scope #- '{search,groups}'
WHERE scope -> 'search' ? 'groups';
