import {oldKnex} from "../oldKnex";
import {upsertLS} from "../utils";
import * as episodes from '../btv';
import {LanguageEntity} from "../Database";

export async function createShowTranslation(p: episodes.components["schemas"]["ItemsShowsTranslations"], m, c) {
    if (m.collection != "shows_translations") {
        return
    }
    let show = (await c.database("shows").select("*").where("id", (p.shows_id as number)))[0];
    let languages = await oldKnex<LanguageEntity>("Language").select("*")
    const languageCode = typeof p.languages_code == "string" ? p.languages_code : p.languages_code.code
    if (!languageCode) {
        return
    }

    let oldLang = languages.find(l => l.CultureCode == languageCode)
    await upsertLS(oldKnex, show.legacy_title_id, oldLang, p.title)
    await upsertLS(oldKnex, show.legacy_description_id, oldLang, p.description)

    return p
}

export async function createSeasonTranslation(p: episodes.components["schemas"]["ItemsSeasonsTranslations"], m, c) {
    if (m.collection != "seasons_translations") {
        return
    }
    let season = (await c.database("seasons").select("*").where("id", (p.seasons_id as number)))[0];
    let languages = await oldKnex<LanguageEntity>("Language").select("*")
    const languageCode = typeof p.languages_code == "string" ? p.languages_code : p.languages_code.code
    if (!languageCode) {
        return
    }

    let oldLang = languages.find(l => l.CultureCode == languageCode)
    await upsertLS(oldKnex, season.legacy_title_id, oldLang, p.title)
    await upsertLS(oldKnex, season.legacy_description_id, oldLang, p.description)

    return p
}

export async function createEpisodeTranslation(p: episodes.components["schemas"]["ItemsEpisodesTranslations"], m, c) {
    if (m.collection != "episodes_translations") {
        return
    }
    let episode = (await c.database("episodes").select("*").where("id", (p.episodes_id as number)))[0];
    let languages = await oldKnex<LanguageEntity>("Language").select("*")
    const languageCode = typeof p.languages_code == "string" ? p.languages_code : p.languages_code.code
    if (!languageCode) {
        return
    }
    if (!episode) {
        const err = new Error("Episode not found: " + JSON.stringify(p))
        console.error(err)
        throw new Error("Episode not found")
    }

    let oldLang = languages.find(l => l.CultureCode == languageCode)
    await upsertLS(oldKnex, episode.legacy_title_id, oldLang, p.title)
    await upsertLS(oldKnex, episode.legacy_description_id, oldLang, p.description)
    if (episode.legacy_extra_description_id) {
        await upsertLS(oldKnex, episode.legacy_extra_description_id, oldLang, p.extra_description)
    }

    return p
}

// Updates

export async function updateShowTranslation(p: episodes.components["schemas"]["ItemsShowsTranslations"], m, c) {
    if (m.collection != "shows_translations") {
        return
    }

    let translation = (await c.database("shows_translations").select("*").where("id", (m.keys[0] as number)))[0];
    let show = (await c.database("shows").select("*").where("id", (translation.shows_id as number)))[0];

    let languages = await oldKnex<LanguageEntity>("Language").select("*")
    const languageCode = translation.languages_code
    if (!languageCode) {
        return
    }

    let oldLang = languages.find(l => l.CultureCode == languageCode)
    if (p.hasOwnProperty('title')) {
        await upsertLS(oldKnex, show.legacy_title_id, oldLang, p.title)
    }
    if (p.hasOwnProperty('description')) {
        await upsertLS(oldKnex, show.legacy_description_id, oldLang, p.description)
    }

    return p
}

export async function updateSeasonTranslation(p: episodes.components["schemas"]["ItemsSeasonsTranslations"], m, c) {
    if (m.collection != "seasons_translations") {
        return
    }

    let translation = (await c.database("seasons_translations").select("*").where("id", (m.keys[0] as number)))[0];
    let season = (await c.database("seasons").select("*").where("id", (translation.seasons_id as number)))[0];

    let languages = await oldKnex<LanguageEntity>("Language").select("*")
    const languageCode = translation.languages_code
    if (!languageCode) {
        return
    }

    let oldLang = languages.find(l => l.CultureCode == languageCode)
    if (p.hasOwnProperty('title')) {
        await upsertLS(oldKnex, season.legacy_title_id, oldLang, p.title)
    }
    if (p.hasOwnProperty('description')) {
        await upsertLS(oldKnex, season.legacy_description_id, oldLang, p.description)
    }

    return p
}

export async function updateEpisodeTranslation(p: episodes.components["schemas"]["ItemsEpisodesTranslations"], m, c) {
    if (m.collection != "episodes_translations") {
        return
    }

    let translation = (await c.database("episodes_translations").select("*").where("id", (m.keys[0] as number)))[0];
    let episode = (await c.database("episodes").select("*").where("id", (translation.episodes_id as number)))[0];

    let languages = await oldKnex<LanguageEntity>("Language").select("*")
    const languageCode = translation.languages_code
    if (!languageCode) {
        return
    }

    let oldLang = languages.find(l => l.CultureCode == languageCode)
    if (p.hasOwnProperty('title')) {
        await upsertLS(oldKnex, episode.legacy_title_id, oldLang, p.title)
    }
    if (p.hasOwnProperty('description')) {
        await upsertLS(oldKnex, episode.legacy_description_id, oldLang, p.description)
    }
    if (p.hasOwnProperty('extra_description') && episode.legacy_extra_description_id) {
        await upsertLS(oldKnex, episode.legacy_extra_description_id, oldLang, p.extra_description)
    }

    return p
}
