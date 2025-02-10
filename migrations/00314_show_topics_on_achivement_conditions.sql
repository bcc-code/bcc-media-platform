-- +goose Up
UPDATE "public"."directus_fields" SET "conditions" = '[{"name":"show if topic and action is completed items","rule":{"_and":[{"_or":[{"_and":[{"collection":{"_eq":"lessons"}},{"action":{"_eq":"completed"}}]},{"_and":[{"collection":{"_eq":"topics"}},{"action":{"_eq":"completed_items"}}]}]}]},"hidden":false,"options":{"layout":"list","enableCreate":true,"enableSelect":true,"limit":15,"junctionFieldLocation":"bottom","allowDuplicates":false,"enableSearchFilter":false,"enableLink":false}}]' WHERE "id" = 1127;

-- +goose Down

UPDATE "public"."directus_fields" SET "conditions" = '[{"name":"show if topic and action is completed items","rule":{"_and":[{"_and":[{"collection":{"_eq":"topics"}},{"action":{"_eq":"completed_items"}}]}]},"hidden":false,"options":{"layout":"list","enableCreate":true,"enableSelect":true,"limit":15,"junctionFieldLocation":"bottom","allowDuplicates":false,"enableSearchFilter":false,"enableLink":false}}]' WHERE "id" = 1127;

