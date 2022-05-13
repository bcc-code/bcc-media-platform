import { oldKnex } from "../oldKnex";
import { createLocalizable, getStatusFromNew, isObjectUseless, upsertLS } from "../utils";
import episodes from '../../../btv';
import { LanguageEntity, CategoryEntity, SeriesEntity, CategoryEpisodeEntity, CategoryProgramEntity, CategorySeriesEntity, EpisodeEntity } from "@/Database";
import { ItemsService } from "directus";
import { Knex } from "knex";


export async function createEpisodeTag(p, m, c) {
    if (m.collection != "episodes_tags") {
        return
    }
    console.log('creating a episodes_tags relation');
    console.log(p,m,c);

    let db = c.database as Knex<any>
    
    let episode = (await db("episodes").select("*").where("id", p.episodes_id))[0];
    let tag_ids = (await db("episodes_tags").select("tags_id").where("episodes_id", p.episodes_id)).map(t => t.tags_id);
    tag_ids.push(p.tags_id.id)
    console.log("episode", episode)
    console.log("tag_ids", tag_ids)

    let tags = (await db("tags").select("name").whereIn("id", tag_ids)).map(t => t.name)
    console.log("tags", tags)
    let result = await upsertLS(oldKnex, episode.legacy_tags_id, {CultureCode: "no", Id: 1, Name: "Norsk"}, tags.join(","))

    console.log("updated tags: ", tags)
    console.log("result", result)
}

export async function deleteEpisodeTag(p, m, c) {
    if (m.collection != "episodes_tags") {
        return
    }
    console.log('deleting a episodes_tags relation');
    console.log(p,m,c);

    let db = c.database as Knex<any>
    let tagToDelete = (await db("episodes_tags").select("*").where("id", p[0]))[0];
    let episode = (await db("episodes").select("*").where("id", tagToDelete.episodes_id))[0];
    let tag_ids = (await db("episodes_tags").select("tags_id").where("episodes_id", tagToDelete.episodes_id)).map(t => t.tags_id);
    console.log("episode", episode)
    console.log("tag_ids", tag_ids)

    const index = tag_ids.indexOf(tagToDelete.tags_id);
    if (index > -1) {
        tag_ids.splice(index, 1); // 2nd parameter means remove one item only
    }

    let tags = (await db("tags").select("name").whereIn("id", tag_ids)).map(t => t.name)
    console.log("tags", tags)
    let result = await upsertLS(oldKnex, episode.legacy_tags_id, {CultureCode: "no", Id: 1, Name: "Norsk"}, tags.join(","))

    console.log("updated tags: ", tags)
    console.log("result", result)
}