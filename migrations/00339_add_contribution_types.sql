-- +goose Up
/**********************************************************/
/*** SCRIPT AUTHOR: Matjaz Debelak (matjaz@debelak.org) ***/
/***    CREATED ON: 2026-05-11T00:00:00.000Z            ***/
/**********************************************************/

UPDATE "public"."directus_fields" SET "options" = '{"choices":[{"text":"Speaker","value":"speaker"},{"text":"Lyricist","value":"lyricist"},{"text":"Arranger","value":"arranger"},{"text":"Singer","value":"singer"},{"text":"Composer","value":"composer"},{"text":"Soloist","value":"soloist"},{"text":"Performer","value":"performer"},{"text":"Translator","value":"translator"},{"text":"Director","value":"director"},{"text":"Producer","value":"producer"},{"text":"Script Writer","value":"scriptwriter"},{"text":"Actor","value":"actor"},{"text":"Voice Actor","value":"voiceactor"}],"icon":"category"}' WHERE "id" = 3023;

-- +goose Down
/**********************************************************/
/*** SCRIPT AUTHOR: Matjaz Debelak (matjaz@debelak.org) ***/
/***    CREATED ON: 2026-05-11T00:00:00.000Z            ***/
/**********************************************************/

UPDATE "public"."directus_fields" SET "options" = '{"choices":[{"text":"Speaker","value":"speaker"},{"text":"Lyricist","value":"lyricist"},{"text":"Arranger","value":"arranger"},{"text":"Singer","value":"singer"}],"icon":"category"}' WHERE "id" = 3023;
