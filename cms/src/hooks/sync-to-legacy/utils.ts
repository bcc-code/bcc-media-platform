
import { LanguageEntity, LocalizedStringEntity } from '@/Database'
import episodes from '../../btv'
import * as knex from 'knex'
import { ItemsService } from 'directus'
export function getStatusFromOld(status: number): string {
    switch (status) {
        case 0: return "draft"
        case 1: return "published"
        default: "draft"
    }
}

export function getStatusFromNew(status: string): number {
    switch (status) {
        case "published": return 1
        default: return 0
    }
}

export async function upsertLS(oldKnex: knex.Knex<any, unknown[]>, parentId: number, lang: LanguageEntity, value: string) {
    if (value == undefined) {
        value = ""
    }
    
    let c = await oldKnex<LocalizedStringEntity>("localizedstring")
    .innerJoin("language", "localizedstring.languageid", "language.id")
    .where("ParentId", parentId)
    .andWhere("language.culturecode", lang.CultureCode)
    .update({
        Value: value
    }).returning("*")
    if (c.length === 0 && value != null) {
        console.log({
            ParentId: parentId,
            LanguageId: lang.Id,
            Value: value
        })
        let inserted = await oldKnex<LocalizedStringEntity>("localizedstring")
        .insert({
            ParentId: parentId,
            LanguageId: lang.Id,
            Value: value
        }).returning("*")
        
    }
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

export async function createLocalizable(oldKnex: knex.Knex<any, unknown[]>): Promise<number> {
    let result = await oldKnex<LocalizedStringEntity>("localizablestring").insert({}).returning<[{id: number}]>("id")
    return result[0].id
}

export function objectPatch(e: any, fields: {[field: string]: any}) {
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
        if( patch[k] != undefined) {
            return false
        }
    }
    return true
} 