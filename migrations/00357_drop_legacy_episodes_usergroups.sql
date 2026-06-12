-- +goose Up

-- Drop the dead legacy episode usergroup junction tables. Episode access is resolved
-- via the `episode_roles` view, which reads mediaitems_usergroups* (joined on
-- episodes.mediaitem_id). These tables have no query/Go/admin-web references and their
-- data has been frozen since the mediaitem migration.

DROP TABLE IF EXISTS "public"."episodes_usergroups";

DROP TABLE IF EXISTS "public"."episodes_usergroups_download";

DROP TABLE IF EXISTS "public"."episodes_usergroups_earlyaccess";

-- Remove Directus metadata: the junction-collection fields, the dangling episode-side
-- legacy m2m fields, the relations, and the collections themselves.

DELETE FROM "public"."directus_fields"
WHERE collection IN ('episodes_usergroups', 'episodes_usergroups_download', 'episodes_usergroups_earlyaccess')
   OR (collection = 'episodes' AND field IN ('usergroups', 'download_usergroups', 'earlyaccess_usergroups'));

DELETE FROM "public"."directus_relations"
WHERE many_collection IN ('episodes_usergroups', 'episodes_usergroups_download', 'episodes_usergroups_earlyaccess');

DELETE FROM "public"."directus_collections"
WHERE collection IN ('episodes_usergroups', 'episodes_usergroups_download', 'episodes_usergroups_earlyaccess');

-- +goose Down

-- Recreate the three tables (structure only; the legacy data is not restored).

CREATE SEQUENCE IF NOT EXISTS "public"."episodes_usergroups_id_seq";
CREATE SEQUENCE IF NOT EXISTS "public"."episodes_usergroups_download_id_seq";
CREATE SEQUENCE IF NOT EXISTS "public"."episodes_usergroups_earlyaccess_id_seq";

CREATE TABLE IF NOT EXISTS "public"."episodes_usergroups" (
    "id" int4 NOT NULL DEFAULT nextval('episodes_usergroups_id_seq'::regclass),
    "episodes_id" int4 NOT NULL,
    "type" varchar(255) NULL,
    "usergroups_code" varchar(255) NOT NULL,
    "date_created" timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "date_updated" timestamptz NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "episodes_usergroups_pkey" PRIMARY KEY (id),
    CONSTRAINT "episodes_usergroups_episodes_id_foreign" FOREIGN KEY (episodes_id) REFERENCES episodes(id) ON DELETE CASCADE,
    CONSTRAINT "episodes_usergroups_usergroups_code_foreign" FOREIGN KEY (usergroups_code) REFERENCES usergroups(code) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS "public"."episodes_usergroups_download" (
    "id" int4 NOT NULL DEFAULT nextval('episodes_usergroups_download_id_seq'::regclass),
    "episodes_id" int4 NOT NULL,
    "usergroups_code" varchar(255) NOT NULL,
    "date_created" timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "date_updated" timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "episodes_usergroups_download_pkey" PRIMARY KEY (id),
    CONSTRAINT "episodes_usergroups_download_episodes_id_foreign" FOREIGN KEY (episodes_id) REFERENCES episodes(id) ON DELETE CASCADE,
    CONSTRAINT "episodes_usergroups_download_usergroups_code_foreign" FOREIGN KEY (usergroups_code) REFERENCES usergroups(code) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS "public"."episodes_usergroups_earlyaccess" (
    "id" int4 NOT NULL DEFAULT nextval('episodes_usergroups_earlyaccess_id_seq'::regclass),
    "episodes_id" int4 NOT NULL,
    "usergroups_code" varchar(255) NOT NULL,
    "date_created" timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "date_updated" timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "episodes_usergroups_earlyaccess_pkey" PRIMARY KEY (id),
    CONSTRAINT "episodes_usergroups_earlyaccess_episodes_id_foreign" FOREIGN KEY (episodes_id) REFERENCES episodes(id) ON DELETE CASCADE,
    CONSTRAINT "episodes_usergroups_earlyaccess_usergroups_code_foreign" FOREIGN KEY (usergroups_code) REFERENCES usergroups(code) ON DELETE CASCADE
);

GRANT SELECT ON TABLE "public"."episodes_usergroups", "public"."episodes_usergroups_download", "public"."episodes_usergroups_earlyaccess" TO api, background_worker, onsite_backup, staging_sync;
GRANT SELECT, INSERT, UPDATE, DELETE, REFERENCES, TRIGGER ON TABLE "public"."episodes_usergroups", "public"."episodes_usergroups_download", "public"."episodes_usergroups_earlyaccess" TO directus;
GRANT SELECT, INSERT, UPDATE, DELETE, REFERENCES, TRIGGER, TRUNCATE ON TABLE "public"."episodes_usergroups", "public"."episodes_usergroups_download", "public"."episodes_usergroups_earlyaccess" TO manager;

-- Restore Directus metadata (exact rows captured from prod).

INSERT INTO "public"."directus_collections" (collection,icon,note,display_template,hidden,singleton,translations,archive_field,archive_app_filter,archive_value,unarchive_value,sort_field,accountability,color,item_duplication_fields,sort,"group",collapse,preview_url,versioning) VALUES
 ('episodes_usergroups','import_export',NULL,NULL,true,false,NULL,NULL,true,NULL,NULL,NULL,'all',NULL,NULL,1,'usergroups_relations','open',NULL,false),
 ('episodes_usergroups_download','import_export',NULL,NULL,true,false,NULL,NULL,true,NULL,NULL,NULL,'all',NULL,NULL,3,'episodes','open',NULL,false),
 ('episodes_usergroups_earlyaccess','import_export',NULL,NULL,true,false,NULL,NULL,true,NULL,NULL,NULL,'all',NULL,NULL,4,'episodes','open',NULL,false);

INSERT INTO "public"."directus_relations" (id,many_collection,many_field,one_collection,one_field,one_collection_field,one_allowed_collections,junction_field,sort_field,one_deselect_action) VALUES
 (50,'episodes_usergroups','episodes_id','episodes','usergroups',NULL,NULL,'usergroups_code',NULL,'delete'),
 (51,'episodes_usergroups','usergroups_code','usergroups',NULL,NULL,NULL,'episodes_id',NULL,'nullify'),
 (52,'episodes_usergroups_download','episodes_id','episodes','download_usergroups',NULL,NULL,'usergroups_code',NULL,'delete'),
 (53,'episodes_usergroups_download','usergroups_code','usergroups',NULL,NULL,NULL,'episodes_id',NULL,'nullify'),
 (54,'episodes_usergroups_earlyaccess','episodes_id','episodes','earlyaccess_usergroups',NULL,NULL,'usergroups_code',NULL,'delete'),
 (55,'episodes_usergroups_earlyaccess','usergroups_code','usergroups',NULL,NULL,NULL,'episodes_id',NULL,'delete');

INSERT INTO "public"."directus_fields" (id,collection,field,special,interface,options,display,display_options,readonly,hidden,sort,width,translations,note,conditions,required,"group",validation,validation_message) VALUES (126,'episodes','download_usergroups','m2m','list-m2m','{"enableCreate":false,"template":"{{usergroups_code.name}}"}','related-values','{ "template": "{{usergroups_code.name}}" }',false,false,6,'half',NULL,NULL,NULL,false,'availability',NULL,NULL);
INSERT INTO "public"."directus_fields" (id,collection,field,special,interface,options,display,display_options,readonly,hidden,sort,width,translations,note,conditions,required,"group",validation,validation_message) VALUES (127,'episodes','earlyaccess_usergroups','m2m','list-m2m','{ "enableCreate": false, "template": "{{usergroups_code.name}}" }','related-values','{ "template": "{{usergroups_code.name}}" }',false,false,4,'half',NULL,NULL,NULL,false,'availability',NULL,NULL);
INSERT INTO "public"."directus_fields" (id,collection,field,special,interface,options,display,display_options,readonly,hidden,sort,width,translations,note,conditions,required,"group",validation,validation_message) VALUES (149,'episodes','usergroups','m2m','list-m2m','{ "enableCreate": false, "template": "{{usergroups_code.name}}" }','related-values','{ "template": "{{usergroups_code.name}}" }',false,true,5,'half',NULL,NULL,NULL,false,'availability',NULL,NULL);
INSERT INTO "public"."directus_fields" (id,collection,field,special,interface,options,display,display_options,readonly,hidden,sort,width,translations,note,conditions,required,"group",validation,validation_message) VALUES (163,'episodes_usergroups','episodes_id',NULL,NULL,NULL,NULL,NULL,false,true,NULL,'full',NULL,NULL,NULL,false,NULL,NULL,NULL);
INSERT INTO "public"."directus_fields" (id,collection,field,special,interface,options,display,display_options,readonly,hidden,sort,width,translations,note,conditions,required,"group",validation,validation_message) VALUES (164,'episodes_usergroups','id',NULL,NULL,NULL,NULL,NULL,false,true,NULL,'full',NULL,NULL,NULL,false,NULL,NULL,NULL);
INSERT INTO "public"."directus_fields" (id,collection,field,special,interface,options,display,display_options,readonly,hidden,sort,width,translations,note,conditions,required,"group",validation,validation_message) VALUES (165,'episodes_usergroups','type',NULL,'select-radio','{"choices":[{"text":"Availability","value":"availability"},{"text":"Early Access","value":"early-access"}]}',NULL,NULL,false,false,NULL,'full',NULL,NULL,NULL,false,NULL,NULL,NULL);
INSERT INTO "public"."directus_fields" (id,collection,field,special,interface,options,display,display_options,readonly,hidden,sort,width,translations,note,conditions,required,"group",validation,validation_message) VALUES (166,'episodes_usergroups','usergroups_code',NULL,NULL,NULL,NULL,NULL,false,true,NULL,'full',NULL,NULL,NULL,false,NULL,NULL,NULL);
INSERT INTO "public"."directus_fields" (id,collection,field,special,interface,options,display,display_options,readonly,hidden,sort,width,translations,note,conditions,required,"group",validation,validation_message) VALUES (330,'episodes_usergroups','date_created','date-created',NULL,NULL,NULL,NULL,false,true,NULL,'full',NULL,NULL,NULL,false,NULL,NULL,NULL);
INSERT INTO "public"."directus_fields" (id,collection,field,special,interface,options,display,display_options,readonly,hidden,sort,width,translations,note,conditions,required,"group",validation,validation_message) VALUES (331,'episodes_usergroups','date_updated','date-created,date-updated',NULL,NULL,NULL,NULL,false,false,NULL,'full',NULL,NULL,NULL,false,NULL,NULL,NULL);
INSERT INTO "public"."directus_fields" (id,collection,field,special,interface,options,display,display_options,readonly,hidden,sort,width,translations,note,conditions,required,"group",validation,validation_message) VALUES (167,'episodes_usergroups_download','episodes_id',NULL,NULL,NULL,NULL,NULL,false,true,NULL,'full',NULL,NULL,NULL,false,NULL,NULL,NULL);
INSERT INTO "public"."directus_fields" (id,collection,field,special,interface,options,display,display_options,readonly,hidden,sort,width,translations,note,conditions,required,"group",validation,validation_message) VALUES (168,'episodes_usergroups_download','id',NULL,NULL,NULL,NULL,NULL,false,true,NULL,'full',NULL,NULL,NULL,false,NULL,NULL,NULL);
INSERT INTO "public"."directus_fields" (id,collection,field,special,interface,options,display,display_options,readonly,hidden,sort,width,translations,note,conditions,required,"group",validation,validation_message) VALUES (169,'episodes_usergroups_download','usergroups_code',NULL,NULL,NULL,NULL,NULL,false,true,NULL,'full',NULL,NULL,NULL,false,NULL,NULL,NULL);
INSERT INTO "public"."directus_fields" (id,collection,field,special,interface,options,display,display_options,readonly,hidden,sort,width,translations,note,conditions,required,"group",validation,validation_message) VALUES (332,'episodes_usergroups_download','date_created','date-created',NULL,NULL,NULL,NULL,false,true,NULL,'full',NULL,NULL,NULL,false,NULL,NULL,NULL);
INSERT INTO "public"."directus_fields" (id,collection,field,special,interface,options,display,display_options,readonly,hidden,sort,width,translations,note,conditions,required,"group",validation,validation_message) VALUES (333,'episodes_usergroups_download','date_updated','date-created,date-updated',NULL,NULL,NULL,NULL,false,true,NULL,'full',NULL,NULL,NULL,false,NULL,NULL,NULL);
INSERT INTO "public"."directus_fields" (id,collection,field,special,interface,options,display,display_options,readonly,hidden,sort,width,translations,note,conditions,required,"group",validation,validation_message) VALUES (170,'episodes_usergroups_earlyaccess','episodes_id',NULL,NULL,NULL,NULL,NULL,false,true,NULL,'full',NULL,NULL,NULL,false,NULL,NULL,NULL);
INSERT INTO "public"."directus_fields" (id,collection,field,special,interface,options,display,display_options,readonly,hidden,sort,width,translations,note,conditions,required,"group",validation,validation_message) VALUES (171,'episodes_usergroups_earlyaccess','id',NULL,NULL,NULL,NULL,NULL,false,true,NULL,'full',NULL,NULL,NULL,false,NULL,NULL,NULL);
INSERT INTO "public"."directus_fields" (id,collection,field,special,interface,options,display,display_options,readonly,hidden,sort,width,translations,note,conditions,required,"group",validation,validation_message) VALUES (172,'episodes_usergroups_earlyaccess','usergroups_code',NULL,NULL,NULL,NULL,NULL,false,true,NULL,'full',NULL,NULL,NULL,false,NULL,NULL,NULL);
INSERT INTO "public"."directus_fields" (id,collection,field,special,interface,options,display,display_options,readonly,hidden,sort,width,translations,note,conditions,required,"group",validation,validation_message) VALUES (334,'episodes_usergroups_earlyaccess','date_created','date-created',NULL,NULL,NULL,NULL,false,true,NULL,'full',NULL,NULL,NULL,false,NULL,NULL,NULL);
INSERT INTO "public"."directus_fields" (id,collection,field,special,interface,options,display,display_options,readonly,hidden,sort,width,translations,note,conditions,required,"group",validation,validation_message) VALUES (335,'episodes_usergroups_earlyaccess','date_updated','date-created,date-updated',NULL,NULL,NULL,NULL,false,true,NULL,'full',NULL,NULL,NULL,false,NULL,NULL,NULL);
