import {oldKnex} from "../oldKnex";
import {EpisodeEntity, ProgramEntity, SystemDataEntity} from "../Database";
import {getEpisodeUsergroups, shouldDraft, ugCodesToVisibility} from "../utils";

export async function createEpisodesUsergroup(p, m, c) {
    if (m.collection != "episodes_usergroups") {
        return
    }

    let episode = (await c.database("episodes").select("*").where("id", p.episodes_id))[0];
    let ug_codes = await getEpisodeUsergroups(c, "episodes_usergroups", p.episodes_id)
    ug_codes.push(p.usergroups_code.code)

    let patch: Partial<EpisodeEntity> = {}

    patch.Visibility = ugCodesToVisibility(ug_codes);

    if (shouldDraft(ug_codes)) {
        patch.Status = 0;
    }

    if (episode.type === "episode") {
        let legacyEpisode = await oldKnex<EpisodeEntity>("Episode").update(patch).where("Id", episode.legacy_id).returning("*")
    } else if (episode.type === "standalone") {
        let legacyProgram = await oldKnex<EpisodeEntity>("Program").update(patch).where("Id", episode.legacy_program_id).returning("*")
    }

}

export async function deleteEpisodesUsergroup(p, m, c) {
    if (p.length > 1) {
        throw new Error("Syncing bulk-deletes hasn't been implemented. Contact Andreas if that's slowing you down much.")
    }
    if (m.collection != "episodes_usergroups") {
        return
    }

    let ug = (await c.database("episodes_usergroups").select("*").where("id", p[0]))[0];

    let episode = (await c.database("episodes").select("*").where("id", ug.episodes_id))[0];
    let ug_codes = await getEpisodeUsergroups(c, "episodes_usergroups", ug.episodes_id)

    const index = ug_codes.indexOf(ug.usergroups_code);
    if (index > -1) {
        ug_codes.splice(index, 1); // 2nd parameter means remove one item only
    }

    let patch: Partial<EpisodeEntity> = {}

    patch.Visibility = ugCodesToVisibility(ug_codes);

    if (episode.type === "episode") {
        await oldKnex<EpisodeEntity>("Episode").update(patch).where("Id", episode.legacy_id).returning("*")

    } else if (episode.type === "standalone") {
        await oldKnex<ProgramEntity>("Program").update(patch).where("Id", episode.legacy_program_id).returning("*")

    }
}


export async function createEpisodesUsergroupEarlyAccess(p, m, c) {
    if (m.collection != "episodes_usergroups_earlyaccess") {
        return
    }

    let episode = (await c.database("episodes").select("*").where("id", p.episodes_id))[0];
    let ug_codes = await getEpisodeUsergroups(c, "episodes_usergroups_earlyaccess", p.episodes_id)
    ug_codes.push(p.usergroups_code.code)

    let patch: Partial<EpisodeEntity> = {}

    patch.AllowSpecialAccessFKTB = ug_codes.some(ug => ug === "fktb-download" || ug === "fktb-early-access")
    patch.AllowSpecialAccess = ug_codes.some(ug => ug === "kids-early-access")

    if (episode.type === "episode") {
        let legacyEpisode = await oldKnex<EpisodeEntity>("Episode").update(patch).where("Id", episode.legacy_id).returning("*")

    } else if (episode.type === "standalone") {
        let legacyProgram = await oldKnex<EpisodeEntity>("Program").update(patch).where("Id", episode.legacy_program_id).returning("*")

    }
}

export async function deleteEpisodesUsergroupEarlyAccess(p, m, c) {
    if (m.collection != "episodes_usergroups_earlyaccess") {
        return
    }

    // Get this ug
    let ug = (await c.database("episodes_usergroups_earlyaccess").select("*").where("id", p[0]))[0];
    let episode = (await c.database("episodes").select("*").where("id", ug.episodes_id))[0];
    // Get all the ugs
    let ug_codes = await getEpisodeUsergroups(c, "episodes_usergroups_earlyaccess", p.episodes_id)

    const index = ug_codes.indexOf(ug.usergroups_code);
    if (index > -1) {
        ug_codes.splice(index, 1); // 2nd parameter means remove one item only
    }

    let patch: Partial<EpisodeEntity> = {}

    patch.AllowSpecialAccessFKTB = ug_codes.some(ug => ug === "fktb-download" || ug === "fktb-early-access")
    patch.AllowSpecialAccess = ug_codes.some(ug => ug === "kids-early-access")

    if (episode.type === "episode") {
        let legacyEpisode = await oldKnex<EpisodeEntity>("Episode").update(patch).where("Id", episode.legacy_id).returning("*")
    } else if (episode.type === "standalone") {
        let legacyProgram = await oldKnex<EpisodeEntity>("Program").update(patch).where("Id", episode.legacy_program_id).returning("*")
    }
}

export async function updateUsergroup(p, m, c) {
    let ug_code = m.keys[0]

    if (!p.emails) {
        return
    }

    let sdKey = undefined
    if (ug_code === "fktb-download") {
        sdKey = "SpecialAccessFKTBDownloadMembers"
    } else if (ug_code === "fktb-early-access") {
        sdKey = "SpecialAccessFKTBMembers"
    } else if (ug_code === "kids-early-access") {
        sdKey = "SpecialAccessMembers"
    }
    if (sdKey) {
        await oldKnex<SystemDataEntity>("SystemData")
            .update({Value: p.emails.split('\n').join(',')})
            .where("Key", sdKey)
    }
};
