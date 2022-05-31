import { oldKnex } from "../oldKnex";
import { createLocalizable, getStatusFromNew, isObjectUseless, upsertLS } from "../utils";
import episodes from '../../../btv';
import { LanguageEntity, SeriesEntity } from "@/Database";
import { ItemsService } from "directus";


export async function updateSection (p, m, c) {
    if (m.collection != "sections") {
        return
    }
    
    // get legacy id
    const itemsService = new ItemsService<episodes.components["schemas"]["ItemsSections"]>("sections", {
        knex: c.database as any,
        schema: c.schema,
    });
    let sectionBeforeUpdate = await itemsService.readOne(Number(m.keys[0]), { fields: ['*.*.*'] })
    

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
        let image = (await c.database("directus_files").select("*").where("Id", p.image_file_id))[0];
        patch.Image = "https://brunstadtv.imgix.net/"+image.filename_disk
    } if (p.image_file_id === null) {
        patch.Image = null
    }

    
    if (!isObjectUseless(patch)) {
        let a = await oldKnex<SeriesEntity>("Slider").where("Id", sectionBeforeUpdate.legacy_id).update(patch).returning("*")
        
    }
};

export async function createSection(p, m, c) {
    if (m.collection != "sections") {
        return
    }
    
    
    // get legacy id
    p = p as episodes.components["schemas"]["ItemsSections"]
    //let image = e.image_file_id as episodes.components["schemas"]["Files"]
    

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
    
    
    let legacySection = await oldKnex<SeriesEntity>("Slider").insert(patch).returning("*")
    
    p.legacy_id = legacySection[0].Id
    
    return p
    //await c.database("sections").update({legacy_id: legacySection[0].Id}).where("Id", e.id)

};

export async function deleteSection(p, m, c) {
    
    if (p.length > 1) {
        throw new Error("Syncing bulk-deletes hasn't been implemented. Contact Andreas if that's slowing you down much.")
    }
    if (m.collection !== "sections") {
        return
    }
    

    // get legacy ids
    let sections_id = p[0]
    let section = (await c.database("sections").select("*").where("Id", sections_id))[0];
    
  
    let result = await oldKnex("Slider").where("Id", section.legacy_id).delete()
    
};