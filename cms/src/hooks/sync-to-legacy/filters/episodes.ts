import { oldKnex } from "../oldKnex";
import { createLocalizable, getStatusFromNew, isObjectUseless, upsertLS } from "../utils";
import episodes from '../../../btv';
import { EpisodeEntity, LanguageEntity, SeriesEntity } from "@/Database";
import { ItemsService } from "directus";

export async function createEpisode(p, m, c) {
    if (m.collection != "episodes") {
        return
    }
    console.log('episode created!');
    console.log(m);
    // get legacy id
    let asset: any
    if (p.asset_id) {
        asset = (await c.database("assets").select("*").where("id", p.asset_id))[0];
    }
    //let image = e.image_file_id as episodes.components["schemas"]["Files"]
    console.log("directus", p)

    // update it in original 
    let patch: Partial<EpisodeEntity> = {
        VideoId: asset?.legacy_id ?? 1041, // TODO: remove this temp id
        Published: p.publish_date as unknown as Date,
        AvailableTo: p.available_to as unknown as Date,
        AvailableFrom: p.available_from as unknown as Date,
        Status: getStatusFromNew(p.status),
        LastUpdate: p.date_created as unknown as Date ?? new Date(),
        Visibility: 1,
        AllowSpecialAccess: false,
        AllowSpecialAccessFKTB: false,
    }
    patch.TitleId = await createLocalizable(oldKnex)
    patch.DescriptionId = await createLocalizable(oldKnex)
    patch.LongDescriptionId = await createLocalizable(oldKnex)
    p.legacy_title_id = patch.TitleId
    p.legacy_description_id = patch.DescriptionId
    p.legacy_extra_description_id = patch.LongDescriptionId
/* 
    if (image != null) {
        patch.Image = "https://brunstadtv.imgix.net/"+image.filename_disk
    } */
/* 
    if (e.usergroups.some(ug => (ug as any).usergroups_code.code === "public") && e.usergroups.some(ug => (ug as any).usergroups_code.code === "bcc-members")) {
        patch.Visibility = 3
    } else if (e.usergroups.some(ug => (ug as any).usergroups_code.code === "public")) {
        patch.Visibility = 2
    } else {
        patch.Visibility = 1
    } */

    if (p.status == "published") {
        patch.Status = 1
    } else {
        patch.Status = 0
    }
    
    if (p.type === "episode" || p.season_id) {
        let season = (await c.database("seasons").select("*").where("id", p.season_id))[0];
        patch.SeasonId = season.legacy_id
        patch.EpisodeNo = p.episode_number
        let legacyEpisode = await oldKnex<EpisodeEntity>("episode").insert(patch).returning("*")
        p.legacy_id = legacyEpisode[0].Id
        console.log(legacyEpisode)
    } else if (p.type === "standalone") {
        let legacyProgram = await oldKnex<EpisodeEntity>("program").insert(patch).returning("*")
        console.log(legacyProgram)
        p.legacy_program_id = legacyProgram[0].Id
    }

    console.log("insert", patch)
}