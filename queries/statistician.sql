-- name: GetAllMemberIDs :many
SELECT user_id FROM users.profiles GROUP BY user_id;

-- name: InsertMember :exec
INSERT INTO stats.members_data (id, age_group, org_id) VALUES (@id, @age_group, @org);
