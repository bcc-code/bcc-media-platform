-- +goose Up
-- The API authorizes admin requests by loading the Directus user, checking
-- its status and deriving admin_access from the Directus policies (via
-- directus_access, including the role ancestor chain); the login response
-- also includes name/avatar and the role name (embedded in the admin access
-- tokens the API mints itself).
-- Column-level grants: directus_users also holds password/tfa_secret and
-- directus_policies holds ip_access, which the api role must not read.
GRANT SELECT (id, email, first_name, last_name, role, status, avatar)
    ON public.directus_users TO api;
GRANT SELECT (id, name, parent) ON public.directus_roles TO api;
GRANT SELECT ("user", role, policy) ON public.directus_access TO api;
GRANT SELECT (id, admin_access) ON public.directus_policies TO api;

-- +goose Down
REVOKE SELECT (id, email, first_name, last_name, role, status, avatar)
    ON public.directus_users FROM api;
REVOKE SELECT (id, name, parent) ON public.directus_roles FROM api;
REVOKE SELECT ("user", role, policy) ON public.directus_access FROM api;
REVOKE SELECT (id, admin_access) ON public.directus_policies FROM api;
