-- Create the default directus admin user
INSERT INTO public.directus_users (id, first_name, last_name, email, password, location, title, description, tags,
                                   avatar, language, theme_light, tfa_secret, status, role, token, last_access, last_page,
                                   provider, external_identifier, auth_data, email_notifications)
VALUES ('45ac012b-185d-4c93-8a16-6ba7d51d261c', 'Admin', 'User', 'admin@brunstad.tv',
        '$argon2id$v=19$m=4096,t=3,p=1$5R/76zRWiBA6yxuHuVjLnw$XV40T3YN4qXi4YSt02MQXasmLZHRxE1PMX2w1CgKGXE', NULL, NULL,
        NULL, NULL, NULL, NULL, 'auto', NULL, 'active', 'aeeb3066-3a3d-48d2-b922-8ea359d1fc16', NULL,
        '2022-09-02 12:48:10.531+00', '/settings/data-model/shows', 'default', NULL, NULL, true);

