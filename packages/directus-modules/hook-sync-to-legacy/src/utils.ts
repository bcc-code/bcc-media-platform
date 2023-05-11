import {LanguageEntity, LocalizedStringEntity} from './Database'
// @ts-ignore
import type {Knex} from 'knex'

export function getStatusFromOld(status: number): string {
    switch (status) {
        case 0:
            return "draft"
        case 1:
            return "published"
        default:
            return "draft"
    }
}

export function getStatusFromNew(status: string): number {
    switch (status) {
        case "published":
            return 1
        default:
            return 0
    }
}

export async function upsertLS(oldKnex: Knex<any, unknown[]>, parentId: number, lang: LanguageEntity, value: string) {
    if (value == undefined) {
        value = ""
    }

    let c = await oldKnex<LocalizedStringEntity>("LocalizedString")
        .innerJoin("Language", "LocalizedString.LanguageId", "Language.Id")
        .where("ParentId", parentId)
        .andWhere("Language.CultureCode", lang.CultureCode)
        .update({
            Value: value
        }).returning("*")
    if (c.length === 0 && value != null) {
        console.log({
            ParentId: parentId,
            LanguageId: lang.Id,
            Value: value
        })
        let inserted = await oldKnex<LocalizedStringEntity>("LocalizedString")
            .insert({
                ParentId: parentId,
                LanguageId: lang.Id,
                Value: value
            }).returning("*")

    }
}

export async function getEpisodeUsergroups(c: any, table: string, episodeId: number): Promise<string[]> {
    let ep_ug_rows = (await c.database(table).select("*").where("episodes_id", episodeId));
    if (!ep_ug_rows) {
        return [];
    }
    return ep_ug_rows.map(ep_ug => ep_ug.usergroups_code)
}

/*

export async function ensureLocalizablesExist(oldKnex: knex.Knex<any, unknown[]>, table: string, e: any, fields: {[oldColumn: string]: string}): Promise<{[idColumn: string]: number}> {
    let ids = {}
    for (let key in fields) {
        if (e[key] == null) { // if entity doesnt have a localizablestring for this column
            ids[fields[key]] = await createLocalizable(oldKnex, table, e, fields[key]) // Create one
        }
    }
    return ids
} */

export async function createLocalizable(oldKnex: Knex<any, unknown[]>): Promise<number> {
    let result = await oldKnex<LocalizedStringEntity>("LocalizableString").insert({}).returning<[{ Id: number }]>("Id")
    return result[0].Id
}

export function objectPatch(e: any, fields: { [field: string]: any }) {
    return {
        ...e,
        ...fields
    }
}

export function sleep(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
}

export function isObjectUseless(patch: object) {
    for (let k in patch) {
        if (patch[k] != undefined) {
            return false
        }
    }
    return true
}


export enum Visibility {
    MembersOnly = 1,
    PublicOnly = 2,
    Both = 3
}

export function shouldDraft(ug_codes: string[]) {
    return !ug_codes.some(ug => ["bcc-members", "public", "kids-early-access"].includes(ug))
}

export function ugCodesToVisibility(ug_codes: string[]) {
    if (ug_codes.some(ug => ug === "public") && ug_codes.some(ug => ug === "bcc-members")) {
        return Visibility.Both
    } else if (ug_codes.some(ug => ug === "public")) {
        return Visibility.PublicOnly
    } else {
        return Visibility.MembersOnly
    }
}

export function ShouldAllowSpecialAccess(ug_codes: string[]) {
    return ug_codes.some(ug => ug === "kids-early-access")
}

export function ShouldAllowFKTBSpecialAccess(ug_codes: string[]) {
    return ug_codes.some(ug => ug === "fktb-download" || ug === "fktb-early-access")
}
