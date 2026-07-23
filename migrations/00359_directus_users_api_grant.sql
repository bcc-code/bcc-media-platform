-- +goose Up
-- The API authorizes admin requests by loading the Directus user and checking
-- its status; the login response also includes name/avatar and the role name
-- (embedded in the admin access tokens the API mints itself).
-- Column-level grant: directus_users also holds password/tfa_secret,
-- which the api role must not be able to read.
GRANT SELECT (id, email, first_name, last_name, role, status, avatar)
    ON public.directus_users TO api;
GRANT SELECT (id, name) ON public.directus_roles TO api;

-- +goose Down
REVOKE SELECT (id, email, first_name, last_name, role, status, avatar)
    ON public.directus_users FROM api;
REVOKE SELECT (id, name) ON public.directus_roles FROM api;
