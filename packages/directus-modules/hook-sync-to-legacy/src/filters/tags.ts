import {oldKnex} from "../oldKnex";
import {upsertLS} from "../utils";
import type {Knex} from "knex";

export async function createEpisodeTag(p, m, c) {
    if (m.collection != "episodes_tags") {
        return
    }

    console.log("createEpisodeTag", p)

    let db = c.database as Knex<any>

    let episode = (await db("episodes").select("*").where("id", p.episodes_id))[0];
    let tag_ids = (await db("episodes_tags").select("tags_id").where("episodes_id", p.episodes_id)).map(t => t.tags_id);
    tag_ids.push(p.tags_id.id)

    let tags = (await db("tags").select("name").whereIn("id", tag_ids)).map(t => t.name)

    let result = await upsertLS(oldKnex, episode.legacy_tags_id, {
        CultureCode: "no",
        Id: 1,
        Name: "Norsk"
    }, tags.join(","))
}

export async function deleteEpisodeTag(p, m, c) {
    if (p.length > 1) {
        throw new Error("Syncing bulk-deletes hasn't been implemented. Contact Andreas if that's slowing you down much.")
    }
    if (m.collection != "episodes_tags") {
        return
    }

    let db = c.database as Knex<any>
    let tagToDelete = (await db("episodes_tags").select("*").where("id", p[0]))[0];
    let episode = (await db("episodes").select("*").where("id", tagToDelete.episodes_id))[0];
    let tag_ids = (await db("episodes_tags").select("tags_id").where("episodes_id", tagToDelete.episodes_id)).map(t => t.tags_id);


    const index = tag_ids.indexOf(tagToDelete.tags_id);
    if (index > -1) {
        tag_ids.splice(index, 1); // 2nd parameter means remove one item only
    }

    let tags = (await db("tags").select("name").whereIn("id", tag_ids)).map(t => t.name)

    let result = await upsertLS(oldKnex, episode.legacy_tags_id, {
        CultureCode: "no",
        Id: 1,
        Name: "Norsk"
    }, tags.join(","))

}


export async function updateTag(p, m, c) {
    if (!p.name) {
        // We only care about name updates
        return
    }

    let db = c.database as Knex<any>
    let episodeTags = (await db("episodes_tags").select("*").where("tags_id", m.keys[0]));
    let episodes = (await db("episodes").select("*").whereIn("id", episodeTags.map(et => et.episodes_id)));


    for (var episode of episodes) {
        let tag_ids = (await db("episodes_tags").select("tags_id").where("episodes_id", episode.id)).map(t => t.tags_id);


        // Remove it here because we push the new version later
        const index = tag_ids.indexOf(Number(m.keys[0]));


        if (index > -1) {
            tag_ids.splice(index, 1);
        }

        let tags = (await db("tags").select("name").whereIn("id", tag_ids)).map(t => t.name)
        tags.push(p.name)

        let result = await upsertLS(oldKnex, episode.legacy_tags_id, {
            CultureCode: "no",
            Id: 1,
            Name: "Norsk"
        }, tags.join(","))


    }
}
