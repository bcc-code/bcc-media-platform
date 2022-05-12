import { oldKnex } from "../oldKnex";
import { createLocalizable, getStatusFromNew, isObjectUseless, upsertLS } from "../utils";
import episodes from '../../../btv';
import { EpisodeEntity, LanguageEntity, SeriesEntity, SystemDataEntity } from "@/Database";
import { ItemsService } from "directus";

enum Visibility {
    MembersOnly = 1,
    PublicOnly = 2,
    Both = 3
}

export async function createEpisodesUsergroup(p, m, c) {
    if (m.collection != "episodes_usergroups") {
        return
    }
    console.log('creating a episodes_usergroups relation');
    console.log(p,m,c);
    
    let episode = (await c.database("episodes").select("*").where("id", p.episodes_id))[0];
    let ep_ug_rows = (await c.database("episodes_usergroups").select("*").where("episodes_id", p.episodes_id));
    let ug_codes: string[] = ep_ug_rows.map(ep_ug => ep_ug.usergroups_code)
    ug_codes.push(p.usergroups_code.code)
    console.log("episode", episode)
    console.log("ug_codes", ug_codes)

    let patch: Partial<EpisodeEntity> = {
    }

    if (ug_codes.some(ug => ug === "public") && ug_codes.some(ug => ug === "bcc-members")) {
        patch.Visibility = Visibility.Both
    } else if (ug_codes.some(ug => ug === "public")) {
        patch.Visibility = Visibility.PublicOnly
    } else {
        patch.Visibility = Visibility.MembersOnly
    }
    
    if (episode.type === "episode") {
        let legacyEpisode = await oldKnex<EpisodeEntity>("episode").update(patch).where("id", episode.legacy_id).returning("*")
        console.log("legacyEpisode", legacyEpisode)
    } else if (episode.type === "standalone") {
        let legacyProgram = await oldKnex<EpisodeEntity>("program").update(patch).where("id", episode.legacy_program_id).returning("*")
        console.log("legacyProgram", legacyProgram)
    }

    console.log("update", patch)
}

export async function deleteEpisodesUsergroup(p, m, c) {
    if (m.collection != "episodes_usergroups") {
        return
    }
    console.log('deleting a episodes_usergroups relation');
    console.log(p,m,c);

    let ug = (await c.database("episodes_usergroups").select("*").where("id", p[0]))[0];
    console.log(ug)
    let episode = (await c.database("episodes").select("*").where("id", ug.episodes_id))[0];
    let ep_ug_rows = (await c.database("episodes_usergroups").select("*").where("episodes_id", ug.episodes_id));
    console.log("ep_ug_rows", ep_ug_rows)
    let ug_codes: string[] = ep_ug_rows.map(ep_ug => ep_ug.usergroups_code)
    const index = ug_codes.indexOf(ug.usergroups_code);
    if (index > -1) {
        ug_codes.splice(index, 1); // 2nd parameter means remove one item only
    }
    console.log("episode", episode)
    console.log("ug_codes", ug_codes)

    let patch: Partial<EpisodeEntity> = {}

    if (ug_codes.some(ug => ug === "public") && ug_codes.some(ug => ug === "bcc-members")) {
        patch.Visibility = Visibility.Both
    } else if (ug_codes.some(ug => ug === "public")) {
        patch.Visibility = Visibility.PublicOnly
    } else {
        patch.Visibility = Visibility.MembersOnly
    }
    
    if (episode.type === "episode") {
        let legacyEpisode = await oldKnex<EpisodeEntity>("episode").update(patch).where("id", episode.legacy_id).returning("*")
        console.log("legacyEpisode", legacyEpisode)
    } else if (episode.type === "standalone") {
        let legacyProgram = await oldKnex<EpisodeEntity>("program").update(patch).where("id", episode.legacy_program_id).returning("*")
        console.log("legacyProgram", legacyProgram)
    }

    console.log("update", patch)
}



export async function createEpisodesUsergroupEarlyAccess(p, m, c) {
    if (m.collection != "episodes_usergroups_earlyaccess") {
        return
    }
    console.log('creating a episodes_usergroups_earlyaccess relation');
    console.log(p,m,c);
    
    let episode = (await c.database("episodes").select("*").where("id", p.episodes_id))[0];
    let ep_ug_rows = (await c.database("episodes_usergroups_earlyaccess").select("*").where("episodes_id", p.episodes_id));
    let ug_codes: string[] = ep_ug_rows.map(ep_ug => ep_ug.usergroups_code)
    ug_codes.push(p.usergroups_code.code)
    console.log("episode", episode)
    console.log("ug_codes", ug_codes)

    let patch: Partial<EpisodeEntity> = {
    }

    patch.AllowSpecialAccessFKTB = ug_codes.some(ug => ug === "fktb-download" || ug === "fktb-early-access")
    patch.AllowSpecialAccess = ug_codes.some(ug => ug === "kids-early-access")
    
    if (episode.type === "episode") {
        let legacyEpisode = await oldKnex<EpisodeEntity>("episode").update(patch).where("id", episode.legacy_id).returning("*")
        console.log("legacyEpisode", legacyEpisode)
    } else if (episode.type === "standalone") {
        let legacyProgram = await oldKnex<EpisodeEntity>("program").update(patch).where("id", episode.legacy_program_id).returning("*")
        console.log("legacyProgram", legacyProgram)
    }

    console.log("update", patch)
}

export async function deleteEpisodesUsergroupEarlyAccess(p, m, c) {
    if (m.collection != "episodes_usergroups_earlyaccess") {
        return
    }
    console.log('deleting a episodes_usergroups_earlyaccess relation');
    console.log(p,m,c);

    // Get this ug
    let ug = (await c.database("episodes_usergroups_earlyaccess").select("*").where("id", p[0]))[0];
    console.log(ug)
    let episode = (await c.database("episodes").select("*").where("id", ug.episodes_id))[0];

    // Get all the ugs
    let ep_ug_rows = (await c.database("episodes_usergroups_earlyaccess").select("*").where("episodes_id", ug.episodes_id));
    console.log("ep_ug_rows", ep_ug_rows)
    let ug_codes: string[] = ep_ug_rows.map(ep_ug => ep_ug.usergroups_code)

    const index = ug_codes.indexOf(ug.usergroups_code);
    if (index > -1) {
        ug_codes.splice(index, 1); // 2nd parameter means remove one item only
    }

    console.log("episode", episode)
    console.log("ug_codes", ug_codes)

    let patch: Partial<EpisodeEntity> = {}

    patch.AllowSpecialAccessFKTB = ug_codes.some(ug => ug === "fktb-download" || ug === "fktb-early-access")
    patch.AllowSpecialAccess = ug_codes.some(ug => ug === "kids-early-access")
    
    if (episode.type === "episode") {
        let legacyEpisode = await oldKnex<EpisodeEntity>("episode").update(patch).where("id", episode.legacy_id).returning("*")
        console.log("legacyEpisode", legacyEpisode)
    } else if (episode.type === "standalone") {
        let legacyProgram = await oldKnex<EpisodeEntity>("program").update(patch).where("id", episode.legacy_program_id).returning("*")
        console.log("legacyProgram", legacyProgram)
    }

    console.log("update", patch)
}

export async function updateUsergroup(p, m, c) {
    if (m.collection != "usergroups") {
        return
    }
    console.log("updating usergroup")
    console.log(p,m,c)

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
        .update({ Value: p.emails.split('\n').join(',') })
        .where("Key", sdKey)
    }
};