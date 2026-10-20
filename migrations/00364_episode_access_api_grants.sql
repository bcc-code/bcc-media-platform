-- +goose Up
-- The admin API grants and revokes episode access, creating missing auto groups (e.g. <app>-public).
GRANT INSERT, DELETE ON public.mediaitems_usergroups TO api;
GRANT INSERT, DELETE ON public.mediaitems_usergroups_download TO api;
GRANT INSERT, DELETE ON public.mediaitems_usergroups_earlyaccess TO api;
GRANT USAGE ON SEQUENCE public.mediaitems_usergroups_id_seq TO api;
GRANT USAGE ON SEQUENCE public.mediaitems_usergroups_download_id_seq TO api;
GRANT USAGE ON SEQUENCE public.mediaitems_usergroups_earlyaccess_id_seq TO api;
GRANT INSERT ON public.usergroups TO api;

-- +goose Down
REVOKE INSERT, DELETE ON public.mediaitems_usergroups FROM api;
REVOKE INSERT, DELETE ON public.mediaitems_usergroups_download FROM api;
REVOKE INSERT, DELETE ON public.mediaitems_usergroups_earlyaccess FROM api;
REVOKE USAGE ON SEQUENCE public.mediaitems_usergroups_id_seq FROM api;
REVOKE USAGE ON SEQUENCE public.mediaitems_usergroups_download_id_seq FROM api;
REVOKE USAGE ON SEQUENCE public.mediaitems_usergroups_earlyaccess_id_seq FROM api;
REVOKE INSERT ON public.usergroups FROM api;
