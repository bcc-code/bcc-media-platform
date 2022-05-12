import { oldKnex } from "../oldKnex";
import { createLocalizable, getStatusFromNew, isObjectUseless, upsertLS } from "../utils";
import episodes from '../../../btv';
import { LanguageEntity, SeriesEntity } from "@/Database";
import { ItemsService } from "directus";


export async function updateShow (p, m, c) {
    if (m.collection != "shows") {
        return
    }
    console.log('Show updating!');
    // get legacy id
    const itemsService = new ItemsService<episodes.components["schemas"]["ItemsShows"]>("shows", {
        knex: c.database as any,
        schema: c.schema,
    });
    let showBeforeUpdate = await itemsService.readOne(Number(m.keys[0]), { fields: ['*.*.*'] })
    console.log("update", p)

    // update it in original 
    
    let patch: Partial<SeriesEntity> = {
        Published: p.publish_date as unknown as Date,
        AvailableTo: p.available_to as unknown as Date,
        AvailableFrom: p.available_from as unknown as Date,
        LastUpdate: new Date()
    }
    if (p.type) {
        patch.IsCategory = p.type === "event" ? 1 : 0
    }
    if (p.status) {
        patch.Status = getStatusFromNew(p.status)
    }

    if (p.image_file_id) {
        let image = (await c.database("directus_files").select("*").where("id", p.image_file_id))[0];
        patch.Image = "https://brunstadtv.imgix.net/"+image.filename_disk
    } if (p.image_file_id === null) {
        patch.Image = null
    }

    console.log("patch", patch)
    if (!isObjectUseless(patch)) {
        let a = await oldKnex<SeriesEntity>("series").where("id", showBeforeUpdate.legacy_id).update(patch).returning("*")
        console.log("updated legacy series: ", a)
    }
};

export async function createShow(p, m, c) {
    if (m.collection != "shows") {
        return
    }
    console.log('Show created!');
    console.log(p,m,c);
    // get legacy id
    p = p as episodes.components["schemas"]["ItemsShows"]
    //let image = e.image_file_id as episodes.components["schemas"]["Files"]
    console.log("directus", p)

    // update it in original        
    let patch: Partial<SeriesEntity> = {
        IsCategory: p.type === "event" ? 1 : 0,
        Published: p.publish_date as unknown as Date,
        AvailableTo: p.available_to as unknown as Date,
        AvailableFrom: p.available_from as unknown as Date,
        Status: getStatusFromNew(p.status),
        LastUpdate: p.date_created as unknown as Date  ?? new Date()
    }
    patch.TitleId = await createLocalizable(oldKnex)
    patch.DescriptionId = await createLocalizable(oldKnex)
    p.legacy_title_id = patch.TitleId
    p.legacy_description_id = patch.DescriptionId

    /* if (image != null) {
        patch.Image = "https://brunstadtv.imgix.net/"+image.filename_disk
    } */

    if (p.status == "published") {
        patch.Status = 1
    } else {
        patch.Status = 0
    }
    
    console.log("inserting series", patch)
    let legacyShow = await oldKnex<SeriesEntity>("series").insert(patch).returning("*")
    console.log("legacyShow", legacyShow)
    p.legacy_id = legacyShow[0].Id
    console.log("p", p)
    return p
    //await c.database("shows").update({legacy_id: legacyShow[0].Id}).where("id", e.id)

};

export async function deleteShow(p, m, c) {
    console.log("items.delete", m);
    if (m.collection !== "shows") {
        return
    }
    console.log('show being deleted, deleting it in legacy...');

    // get legacy ids
    let shows_id = p[0]
    let show = (await c.database("shows").select("*").where("id", shows_id))[0];
    console.log(show)
  
    let result = await oldKnex("series").where("id", show.legacy_id).delete()
    console.log("legacy show delete result:", result)
};