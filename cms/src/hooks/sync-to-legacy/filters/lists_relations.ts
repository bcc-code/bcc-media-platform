import { oldKnex } from "../oldKnex";
import { createLocalizable, getStatusFromNew, isObjectUseless, upsertLS } from "../utils";
import episodes from '../../../btv';
import { LanguageEntity, CategoryEntity, SeriesEntity, CategoryEpisodeEntity, CategoryProgramEntity, CategorySeriesEntity } from "@/Database";
import { ItemsService } from "directus";

export async function createListRelation(p, m, c) {
    if (m.collection != "lists_relations") {
        return
    }
    console.log('List relation created!');
    console.log(p,m,c);
    let {lists_id, collection, item} = p

    // get legacy ids
    let list = (await c.database("lists").select("*").where("id", lists_id))[0];

    if (collection === "episodes") {
            let episode = (await c.database("episodes").select("*").where("id", item.id))[0];

            if (episode.type === "episode") {
                let patch: Partial<CategoryEpisodeEntity> = {
                    CategoryId: list.legacy_category_id,
                    EpisodeId: episode.legacy_id
                }
                
                let legacyRelation = await oldKnex("CategoryEpisode").insert(patch).returning("*")
                console.log("legacy list relation", legacyRelation)
            } else if (episode.type === "standalone") {
                let patch: Partial<CategoryProgramEntity> = {
                    CategoryId: list.legacy_category_id,
                    ProgramId: episode.legacy_program_id
                }
                
                let legacyRelation = await oldKnex("CategoryProgram").insert(patch).returning("*")
                console.log("legacy list relation", legacyRelation)
            } else { throw new Error("invalid episode type") }
    } else if (collection === "shows") {
        let show = (await c.database("shows").select("*").where("id", item.id))[0];
        let patch: Partial<CategorySeriesEntity> = {
            CategoryId: list.legacy_category_id,
            SeriesId: show.legacy_id
        }
        
        let legacyRelation = await oldKnex("CategorySeries").insert(patch).returning("*")
        console.log("legacy list relation", legacyRelation)
    } else {
        console.error("unknown collection '" + collection + "'")
        return;
    }
}


export async function updateListRelation(p, m, c) {
    if (m.collection != "lists_relations") {
        return
    }
};


export async function deleteListRelation(p, m, c) {
    console.log("items.delete", m);
    if (m.collection != "lists_relations") {
        return
    }
    console.log('List relation deleted!');

    // get legacy ids
    let list_relation = (await c.database("lists_relations").select("*").where("id", p[0]))[0];
    let {collection, item, lists_id} = list_relation
    let list = (await c.database("lists").select("*").where("id", lists_id))[0];
    console.log(list_relation)
    console.log(list)

    if (collection === "episodes") {
            let episode = (await c.database("episodes").select("*").where("id", item))[0];

            if (episode.type === "episode") {
                let result = await oldKnex("CategoryEpisode").where("categoryid", list.legacy_category_id).andWhere("episodeid", episode.legacy_id).delete()
                console.log("legacy list relation delete result", result)
            } else if (episode.type === "standalone") {
                let result = await oldKnex("CategoryProgram").where("categoryid", list.legacy_category_id).andWhere("ProgramId", episode.legacy_program_id).delete()
                console.log("legacy list relation delete result", result)
            }
    } else if (collection === "shows") {
        let show = (await c.database("shows").select("*").where("id", item))[0];
        let result = await oldKnex("CategorySeries").where("categoryid", list.legacy_category_id).andWhere("seriesid", show.legacy_id).delete()
        console.log("legacy list relation delete result", result)
    } else {
        console.error("unknown collection '" + collection + "'")
        return;
    }
};