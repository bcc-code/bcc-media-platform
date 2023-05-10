import {oldKnex} from "../oldKnex";
import {
    createLocalizable,
    getEpisodeUsergroups,
    getStatusFromNew,
    isObjectUseless,
    ShouldAllowFKTBSpecialAccess,
    ShouldAllowSpecialAccess,
    shouldDraft,
    ugCodesToVisibility
} from "../utils";
import {EpisodeEntity, ProgramEntity} from "../Database";

export async function createEpisode(p, m, c) {
    if (m.collection != "episodes") {
        return
    }
    return await createOneEpisode(p, c);
}


async function createOneEpisode(p, c) {
    // get legacy id
    let asset: any
    if (p.asset_id) {
        asset = (await c.database("assets").select("*").where("id", p.asset_id))[0];
    }

    let image = null
    if (p.image_file_id != null) {
        image = (await c.database("directus_files").select("*").where("id", p.image_file_id))[0];
    }

    let availableFrom = null
    for (const date of [p.publish_date, p.available_from]) {
        if (!availableFrom || (date && new Date(date).getTime() > new Date(availableFrom ?? 0).getTime())) {
            availableFrom = date
        }
    }

    // update it in original
    let patch: Partial<EpisodeEntity> = {
        VideoId: asset?.legacy_id ?? 3022, // 3022 is placeholder. videoId isnt nullable in the legacy system, but it is in the new one
        Published: p.publish_date as unknown as Date ?? new Date(),
        AvailableTo: p.available_to as unknown as Date,
        AvailableFrom: availableFrom as unknown as Date,
        Status: getStatusFromNew(p.status),
        LastUpdate: p.date_created as unknown as Date ?? new Date(),
        Visibility: 1,
        AllowSpecialAccess: false,
        AllowSpecialAccessFKTB: false,
    }

    if (p.id) {
        let visibilityCodes = await getEpisodeUsergroups(c, "episodes_usergroups", p.id);
        patch.Visibility = ugCodesToVisibility(visibilityCodes);
        if (shouldDraft(visibilityCodes)) {
            patch.Status = 0
        }

        let earlyaccess_ugs = await getEpisodeUsergroups(c, "episodes_usergroups_earlyaccess", p.id);
        patch.AllowSpecialAccess = ShouldAllowSpecialAccess(earlyaccess_ugs);
        patch.AllowSpecialAccess = ShouldAllowFKTBSpecialAccess(earlyaccess_ugs);
    }

    if (p.legacy_title_id == null) {
        patch.TitleId = await createLocalizable(oldKnex)
        p.legacy_title_id = patch.TitleId
    } else {
        patch.TitleId = p.legacy_title_id
    }

    if (p.legacy_description_id == null) {
        patch.DescriptionId = await createLocalizable(oldKnex)
        p.legacy_description_id = patch.DescriptionId
    } else {
        patch.DescriptionId = p.legacy_description_id
    }

    if (p.legacy_extra_description_id == null) {
        patch.LongDescriptionId = await createLocalizable(oldKnex)
        p.legacy_extra_description_id = patch.LongDescriptionId
    } else {
        patch.LongDescriptionId = p.legacy_extra_description_id
    }

    if (p.legacy_tags_id == null) {
        patch.SearchId = await createLocalizable(oldKnex)
        p.legacy_tags_id = patch.SearchId
    } else {
        patch.SearchId = p.legacy_tags_id
    }

    if (image != null) {
        patch.Image = "https://brunstadtv.imgix.net/" + image.filename_disk
    }

    // if (p.status == "published") {
    //     patch.Status = 1
    // } else {
    //     patch.Status = 0
    // }

    if (p.type === "episode" || p.season_id) {
        let season = (await c.database("seasons").select("*").where("id", p.season_id))[0];
        patch.SeasonId = season.legacy_id;

        patch.EpisodeNo = p.episode_number ?? 0;
        let legacyEpisode = await oldKnex<EpisodeEntity>("Episode").insert(patch).returning("*");
        p.legacy_id = legacyEpisode[0].Id;
    } else if (p.type === "standalone") {
        let programPatch = patch as Partial<ProgramEntity>;
        programPatch.AgeRatingCode = p.agerating_code;
        let legacyProgram = await oldKnex<EpisodeEntity>("Program").insert(programPatch).returning("*");
        p.legacy_program_id = legacyProgram[0].Id;
    }
    return p;
}


export async function updateEpisodes(p, m, c) {
    for (var key of m.keys) {
        await updateOneEpisode(p, key, c);
    }
};

async function updateOneEpisode(p, episodeKey, c) {

    // get legacy id
    let epBeforeUpdate = (await c.database("episodes").select("*").where("id", episodeKey))[0];

    if (!epBeforeUpdate.legacy_id && !epBeforeUpdate.legacy_program_id) {
        // Something weird happened
        let result = await createOneEpisode(epBeforeUpdate, c);
        if (result.legacy_id || result.legacy_program_id) {
            // Successful
            console.log("Successfully fixed " + episodeKey + " in legacy.");
        } else {
            console.error("Failed to create " + episodeKey);
        }
        p.legacy_id = result.legacy_id;
        p.legacy_program_id = result.legacy_program_id;
        p.legacy_title_id = result.legacy_title_id;
        p.legacy_description_id = result.legacy_description_id;
        p.legacy_extra_description_id = result.legacy_extra_description_id;
        p.legacy_tags_id = result.legacy_tags_id;
        console.log("proceeding with update");
        return p;
    }

    p.publish_date ??= epBeforeUpdate.publish_date;
    p.available_from ??= epBeforeUpdate.available_from;

    let availableFrom = null
    for (const date of [p.publish_date, p.available_from]) {
        if (!availableFrom || (date && new Date(date).getTime() > new Date(availableFrom ?? 0).getTime())) {
            availableFrom = date
        }
    }

    // update it in original
    let patch: Partial<EpisodeEntity> = {
        Published: p.publish_date as unknown as Date,
        AvailableTo: p.available_to as unknown as Date,
        AvailableFrom: availableFrom as unknown as Date,
        LastUpdate: new Date()
    }

    if (!epBeforeUpdate.legacy_tags_id) {
        patch.SearchId = await createLocalizable(oldKnex)
        p.legacy_tags_id = patch.SearchId
    }

    if (p.asset_id) {
        let asset = (await c.database("assets").select("*").where("id", p.asset_id))[0];
        patch.VideoId = asset.legacy_id
    } else if (p.asset_id === null) {
        patch.VideoId = null
    }

    if (p.image_file_id) {
        let image = (await c.database("directus_files").select("*").where("id", p.image_file_id))[0];
        patch.Image = "https://brunstadtv.imgix.net/" + image.filename_disk
    }
    if (p.image_file_id === null) {
        patch.Image = null
    }

    if (p.status || p.status === 0) {
        let visibilityCodes = await getEpisodeUsergroups(c, "episodes_usergroups", episodeKey);
        if (shouldDraft(visibilityCodes)) {
            patch.Status = 0
        } else {
            patch.Status = getStatusFromNew(p.status)
        }
    }

    if (epBeforeUpdate.type === "episode") {
        if (p.season_id) {
            let season = (await c.database("seasons").select("*").where("id", p.season_id))[0];
            patch.SeasonId = season.legacy_id
        }

        patch.EpisodeNo = p.episode_number === null ? 0 : p.episode_number
    }


    if (!isObjectUseless(patch)) {
        if (epBeforeUpdate.type === "episode") {
            let a = await oldKnex<EpisodeEntity>("Episode").where("Id", epBeforeUpdate.legacy_id).update(patch).returning("*")

        } else if (epBeforeUpdate.type === "standalone") {
            let programPatch = patch as Partial<ProgramEntity>;
            programPatch.AgeRatingCode = p.agerating_code;
            let a = await oldKnex<ProgramEntity>("Program").where("Id", epBeforeUpdate.legacy_program_id).update(programPatch).returning("*")
        }
    }
}

export async function deleteEpisode(p, m, c) {
    if (p.length > 1) {
        throw new Error("Syncing bulk-deletes hasn't been implemented. Contact Andreas if that's slowing you down much.")
    }

    if (m.collection !== "episodes") {
        return
    }


    // get legacy ids
    let episodes_id = p[0]
    let episode = (await c.database("episodes").select("*").where("id", episodes_id))[0];

    if (episode.type === "episode") {
        let result = await oldKnex("Episode").where("Id", episode.legacy_id).delete()

    } else if (episode.type === "standalone") {
        let result = await oldKnex("Program").where("Id", episode.legacy_program_id).delete()

    }
}
