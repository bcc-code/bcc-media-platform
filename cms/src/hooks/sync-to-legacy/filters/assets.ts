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
    
    
    // get legacy id
    p = p as episodes.components["schemas"]["ItemsAssets"]
    //let image = e.image_file_id as episodes.components["schemas"]["Files"]
    

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

    
    let legacyAsset = await oldKnex<VideoEntity>("video").insert(patch).returning("*")
    
    p.legacy_id = legacyAsset[0].Id
    
    return p
    //await c.database("assets").update({legacy_id: legacyAsset[0].Id}).where("id", e.id)

};

export async function updateAsset (p, m, c) {
    if (m.collection != "assets") {
        return
    }
    
    // get legacy id
    const itemsService = new ItemsService<episodes.components["schemas"]["ItemsAssets"]>("assets", {
        knex: c.database as any,
        schema: c.schema,
    });
    let assetBeforeUpdate = await itemsService.readOne(Number(m.keys[0]), { fields: ['*.*.*'] })
    
    
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

    
    if (!isObjectUseless(patch)) {
        let a = await oldKnex<VideoEntity>("video").where("id", assetBeforeUpdate.legacy_id).update(patch).returning("*")
        
    }
};

export async function deleteAsset(p, m, c) {
    
    if (m.collection !== "assets") {
        return
    }
    

    // get legacy ids
    let assets_id = p[0]
    let asset = (await c.database("assets").select("*").where("id", assets_id))[0];
    
  
    let result = await oldKnex("video").where("id", asset.legacy_id).delete()
    
};