import { oldKnex } from "../oldKnex";
import { createLocalizable, getStatusFromNew, isObjectUseless, upsertLS } from "../utils";
import episodes from '../../../btv';
import { LanguageEntity, SeasonEntity, SeriesEntity } from "@/Database";
import { ItemsService } from "directus";

export async function createSeason(p, m, c) {
    if (m.collection != "seasons") {
        return
    }
    console.log('Season created!');
    console.log(p, m);

    p = p as episodes.components["schemas"]["ItemsSeasons"]
    let show = (await c.database("shows").select("*").where("id", p.show_id))[0];
    
    console.log("directus", p)

    // update it in original        
    let patch: Partial<any> = {
        SeriesId: show.legacy_id,
        SeasonNo: p.season_number,
        Published: p.publish_date as unknown as Date,
        AvailableTo: p.available_to as unknown as Date,
        AvailableFrom: p.available_from as unknown as Date,
        Status: getStatusFromNew(p.status),
        LastUpdate: p.date_created as unknown as Date ?? new Date()
    }
    patch.TitleId = await createLocalizable(oldKnex)
    patch.DescriptionId = await createLocalizable(oldKnex)
    p.legacy_title_id = patch.TitleId
    p.legacy_description_id = patch.DescriptionId
/* 
    if (image != null) {
        patch.Image = "https://brunstadtv.imgix.net/"+image.filename_disk
    } */

    if (p.status == "published") {
        patch.Status = 1
    } else {
        patch.Status = 0
    }
    
    let legacySeason = await oldKnex<SeasonEntity>("season").insert(patch).returning("*")
    console.log(legacySeason, "legacySeason")
    //await c.database("seasons").update({legacy_id: legacySeason[0].Id}).where("id", p.id)
    p.legacy_id = legacySeason[0].Id
    console.log("insert", patch)
    return p
}