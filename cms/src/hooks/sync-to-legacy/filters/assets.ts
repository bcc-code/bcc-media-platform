import { oldKnex } from "../oldKnex";
import { createLocalizable, getStatusFromNew, isObjectUseless, upsertLS } from "../utils";
import episodes from '../../../btv';
import { LanguageEntity, VideoEntity } from "@/Database";
import { ItemsService } from "directus";

enum EncodingVersion {
    AMS = 0,
    BTV = 1
}/* 

function GetEncodingVersion(str): EncodingVersion {
} */

export async function createAsset(p, m, c) {
    if (m.collection != "assets") {
        return
    }
    console.log('Asset created!');
    console.log(p,m,c);
    // get legacy id
    p = p as episodes.components["schemas"]["ItemsAssets"]
    //let image = e.image_file_id as episodes.components["schemas"]["Files"]
    console.log("directus", p)

    // update it in original        
    let patch: Partial<VideoEntity> = {
        EncodingStatus: 2,
        Filename: p.name,
        LastUpdate: p.date_created as unknown as Date  ?? new Date(),
        IsEncrypted: false,
    }
    if (p.duration) {
        var date = new Date(null);
        date.setSeconds(p.duration);
        patch.Length = date.toISOString().substr(11, 8);
    }

    if (p.encoding_version === "btv") {
        patch.EncodingVersion = EncodingVersion.BTV
    } else {
        patch.EncodingVersion = EncodingVersion.AMS
    }

    console.log("inserting video", patch)
    let legacyAsset = await oldKnex<VideoEntity>("video").insert(patch).returning("*")
    console.log("legacyAsset", legacyAsset)
    p.legacy_id = legacyAsset[0].Id
    console.log("p", p)
    return p
    //await c.database("assets").update({legacy_id: legacyAsset[0].Id}).where("id", e.id)

};

export async function updateAsset (p, m, c) {
    if (m.collection != "assets") {
        return
    }
    console.log('Asset updating!');
    // get legacy id
    const itemsService = new ItemsService<episodes.components["schemas"]["ItemsAssets"]>("assets", {
        knex: c.database as any,
        schema: c.schema,
    });
    let assetBeforeUpdate = await itemsService.readOne(Number(m.keys[0]), { fields: ['*.*.*'] })
    console.log("update", p)
    
    let patch: Partial<VideoEntity> = {
        EncodingStatus: 2,
        Filename: p.name,
        LastUpdate: p.date_created as unknown as Date  ?? new Date()
    }
    
    if (p.duration) {
        var date = new Date(null);
        date.setSeconds(p.duration);
        patch.Length = date.toISOString().substr(11, 8);
    }

    if (p.encoding_version === "btv") {
        patch.EncodingVersion = EncodingVersion.BTV
    } else {
        patch.EncodingVersion = EncodingVersion.AMS
    }

    console.log("patch", patch)
    if (!isObjectUseless(patch)) {
        let a = await oldKnex<VideoEntity>("video").where("id", assetBeforeUpdate.legacy_id).update(patch).returning("*")
        console.log("updated legacy video: ", a)
    }
};

export async function deleteAsset(p, m, c) {
    console.log("items.delete", m);
    if (m.collection !== "assets") {
        return
    }
    console.log('asset being deleted, deleting it in legacy...');

    // get legacy ids
    let assets_id = p[0]
    let asset = (await c.database("assets").select("*").where("id", assets_id))[0];
    console.log(asset)
  
    let result = await oldKnex("video").where("id", asset.legacy_id).delete()
    console.log("legacy asset delete result:", result)
};