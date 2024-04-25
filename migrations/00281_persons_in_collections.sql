-- +goose Up
/***************************************************************/
/*** SCRIPT AUTHOR: Andreas Gangsø (andreasgangso@gmail.com) ***/
/***    CREATED ON: 2024-04-25T08:06:42.351Z                 ***/
/***************************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "options" = '{"choices":[{"text":"Default","value":"default"},{"text":"Avatars","value":"avatars"},{"text":"Featured","value":"featured"},{"text":"Grid","value":"grid"},{"text":"Posters","value":"posters"},{"text":"Poster Grid","value":"poster_grid"},{"text":"List","value":"list"},{"text":"Icons","value":"icons"},{"text":"Icon Grid","value":"icon_grid"},{"text":"Labels","value":"labels"},{"text":"Cards","value":"cards"},{"text":"Card List","value":"card_list"}]}' WHERE "id" = 405;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

UPDATE "public"."directus_relations" SET "one_allowed_collections" = 'episodes,links,pages,seasons,shows,studytopics,games,playlists,shorts,persons' WHERE "id" = 214;

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
-- +goose Down
/***************************************************************/
/*** SCRIPT AUTHOR: Andreas Gangsø (andreasgangso@gmail.com) ***/
/***    CREATED ON: 2024-04-25T08:06:44.820Z                 ***/
/***************************************************************/

--- BEGIN SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

UPDATE "public"."directus_fields" SET "options" = '{"choices":[{"text":"Default","value":"default"},{"text":"Featured","value":"featured"},{"text":"Grid","value":"grid"},{"text":"Posters","value":"posters"},{"text":"Poster Grid","value":"poster_grid"},{"text":"List","value":"list"},{"text":"Icons","value":"icons"},{"text":"Icon Grid","value":"icon_grid"},{"text":"Labels","value":"labels"},{"text":"Cards","value":"cards"},{"text":"Card List","value":"card_list"}]}' WHERE "id" = 405;

--- END SYNCHRONIZE TABLE "public"."directus_fields" RECORDS ---

--- BEGIN SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---

UPDATE "public"."directus_relations" SET "one_allowed_collections" = 'episodes,links,pages,seasons,shows,studytopics,games,playlists,shorts' WHERE "id" = 214;

--- END SYNCHRONIZE TABLE "public"."directus_relations" RECORDS ---
