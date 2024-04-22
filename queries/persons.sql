
-- name: getPersons :many
SELECT *
FROM persons
WHERE id = ANY (@ids::uuid[]);

-- name: GetPersonIDsByNames :many
SELECT p.id, p.name
FROM persons p
WHERE name = ANY (@names::varchar[]);

-- name: InsertPerson :exec
INSERT INTO "public"."persons" (id, name)
VALUES (@id, @name);

-- name: InsertTimedMetadataPerson :exec
INSERT INTO "public"."timedmetadata_persons" (timedmetadata_id, persons_id)
VALUES (@timedmetadata_id::uuid, @persons_id::uuid);
