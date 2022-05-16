import { oldKnex } from "../oldKnex";
import { createLocalizable, getStatusFromNew, isObjectUseless, upsertLS } from "../utils";
import episodes from '../../../btv';
import { EpisodeEntity, LanguageEntity, ProgramEntity, SeriesEntity } from "@/Database";
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
    let image = null
    if (p.image_file_id != null) {
        image = (await c.database("directus_files").select("*").where("id", p.image_file_id))[0];
    }
    console.log("directus", p)

    // update it in original 
    let patch: Partial<EpisodeEntity> = {
        VideoId: asset?.legacy_id ?? 3022, // 3022 is placeholder. videoId isnt nullable in the legacy system, but it is in the new one
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
    
    if (image != null) {
        patch.Image = "https://brunstadtv.imgix.net/"+image.filename_disk
    } 

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

export async function updateEpisode(p, m, c) {
    console.log('Item updated!');
    console.log(m);
    if (m.collection != "episodes") {
        return
    }
    // get legacy id
    let epBeforeUpdate = (await c.database("episodes").select("*").where("id", m.keys[0]))[0];

    // update it in original 
    let patch: Partial<EpisodeEntity> = {
        Published: p.publish_date as unknown as Date,
        AvailableTo: p.available_to as unknown as Date,
        AvailableFrom: p.available_from as unknown as Date,
        LastUpdate: new Date()
    }
    if (p.asset_id) {
        let asset = (await c.database("assets").select("*").where("id", p.asset_id))[0];
        patch.VideoId = asset.legacy_id
    } else if (p.asset_id === null) {
        patch.VideoId = null
    }
    
    if (p.image_file_id) {
        let image = (await c.database("directus_files").select("*").where("id", p.image_file_id))[0];
        patch.Image = "https://brunstadtv.imgix.net/"+image.filename_disk
    } if (p.image_file_id === null) {
        patch.Image = null
    }

    if (p.status) {
        patch.Status = getStatusFromNew(p.status)
    }

    if (epBeforeUpdate.type === "episode") {
        if (p.season_id) {
            let season = (await c.database("seasons").select("*").where("id", p.season_id))[0];
            patch.SeasonId = season.legacy_id
        }
        patch.EpisodeNo = p.episode_number
    }

    console.log("patch", patch)
    if (!isObjectUseless(patch)) {
        if (epBeforeUpdate.type === "episode") {
            let a = await oldKnex<EpisodeEntity>("episode").where("id", epBeforeUpdate.legacy_id).update(patch).returning("*")
            console.log(a)
        } else if (epBeforeUpdate.type === "standalone") {
            let a = await oldKnex<ProgramEntity>("program").where("id", epBeforeUpdate.legacy_program_id).update(patch).returning("*")
            console.log(a)
        }
    }
};

export async function deleteEpisode(p, m, c) {
    console.log("items.delete", m);
    if (m.collection !== "episodes") {
        return
    }
    console.log('Episode being deleted, deleting it in legacy...');

    // get legacy ids
    let episodes_id = p[0]
    let episode = (await c.database("episodes").select("*").where("id", episodes_id))[0];
    console.log(episode)
    
    // should be cascade deleted instead
    if (episode.type === "episode") {
        let result = await oldKnex("Episode").where("id", episode.legacy_id).delete()
        console.log("legacy episode delete result:", result)
    } else if (episode.type === "standalone") {
        let result = await oldKnex("Program").where("id", episode.legacy_program_id).delete()
        console.log("legacy program delete result:", result)
    }
}