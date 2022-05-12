import { oldKnex } from "../oldKnex";
import { createLocalizable, getStatusFromNew, isObjectUseless, upsertLS } from "../utils";
import episodes from '../../../btv';
import { LanguageEntity, CategoryEntity, SeriesEntity } from "@/Database";
import { ItemsService } from "directus";

export async function createList(p, m, c) {
    console.log('Item created!');
    console.log(p,m,c);
    if (m.collection != "lists") {
        return
    }
    let patch: Partial<CategoryEntity> = {
        LastUpdate: p.date_created as unknown as Date ?? new Date()
    }
    let languages = await oldKnex<LanguageEntity>("language").select("*")
    let oldLang = languages.find(l => l.CultureCode == "no")
    patch.NameId = await createLocalizable(oldKnex)
    await upsertLS(oldKnex, patch.NameId, oldLang, p.name)
    
    let legacyCategory = await oldKnex<CategoryEntity>("category").insert(patch).returning("*")
    console.log("legacyCategory", legacyCategory)
    p.legacy_category_id = legacyCategory[0].Id
    p.legacy_name_id = patch.NameId

    console.log("insert", patch)
}


export async function updateList(p, m, c) {
    if (m.collection != "lists") {
        return
    }
    console.log("updating list")
    console.log(p,m,c)
    let languages = await oldKnex<LanguageEntity>("language").select("*")
    let oldLang = languages.find(l => l.CultureCode == "no")
    let list = (await c.database("lists").select("*").where("id", m.keys[0]))[0];
    if (p.name) {
        await upsertLS(oldKnex, list.legacy_name_id, oldLang, p.name)
    }
};


export async function deleteList(p, m, c) {
    console.log("items.delete", m);
    if (m.collection !== "lists") {
        return
    }
    console.log('List being deleted, deleting it in legacy...');

    // get legacy ids
    let list = (await c.database("lists").select("*").where("id", p[0]))[0];
    console.log(list)
    
    let result = await oldKnex("Category").where("id", list.legacy_category_id).delete()
    console.log("legacy category delete result:", result)
};