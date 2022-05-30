import { oldKnex } from "../oldKnex";
import { createLocalizable, getStatusFromNew, isObjectUseless, upsertLS } from "../utils";
import episodes from '../../../btv';
import { LanguageEntity, VideoUrlEntity } from "@/Database";
import { ItemsService } from "directus";


export async function createAssetstream(p, m, c) {
    if (m.collection != "assetstreams") {
        return
    }
    
    

    let asset = (await c.database("assets").select("*").where("id", p.asset_id))[0];

    // update it in original        
    let patch: Partial<VideoUrlEntity> = {
        VideoUrl: p.url,
        VideoId: asset.legacy_id,
        IsVideoClip: false,
    }
    if (p.type === "hls-cmaf") {
        patch.EncodingType = "application/vnd.apple.mpegurl"
    } else if (p.type === "hls-ts") {
        patch.EncodingType = "application/vnd.apple.mpegurl"
    } else if (p.type === "dash") {
        patch.EncodingType = "application/dash+xml"
    }

    
    let legacyAssetstream = await oldKnex<VideoUrlEntity>("videourl").insert(patch).returning("*")
    
    p.legacy_id = legacyAssetstream[0].Id
    
    return p
    //await c.database("assetstreams").update({legacy_id: legacyAssetstream[0].Id}).where("id", e.id)

};

export async function updateAssetstream (p, m, c) {
    if (m.collection != "assetstreams") {
        return
    }
    
    // get legacy id
    const itemsService = new ItemsService<episodes.components["schemas"]["ItemsAssetstreams"]>("assetstreams", {
        knex: c.database as any,
        schema: c.schema,
    });
    let assetstreamBeforeUpdate = await itemsService.readOne(Number(m.keys[0]), { fields: ['*.*.*'] }) as any
    let asset = (await c.database("assets").select("*").where("id", p.asset_id))[0];
    
    
    let patch: Partial<VideoUrlEntity> = {
        VideoUrl: p.url,
        VideoId: asset.legacy_id,
        IsVideoClip: false,
    }
    
    if (p.type === "hls-cmaf") {
        patch.EncodingType = "application/vnd.apple.mpegurl"
    } else if (p.type === "hls-ts") {
        patch.EncodingType = "application/vnd.apple.mpegurl"
    } else if (p.type === "dash") {
        patch.EncodingType = "application/dash+xml"
    }

    
    if (!isObjectUseless(patch)) {
        let a = await oldKnex<VideoUrlEntity>("videourl").where("id", assetstreamBeforeUpdate.legacy_id).update(patch).returning("*")
        
    }
};

export async function deleteAssetstream(p, m, c) {
    if (p.length > 1) {
        throw new Error("Syncing bulk-deletes hasn't been implemented. Contact Andreas if that's slowing you down much.")
    }
    
    if (m.collection !== "assetstreams") {
        return
    }
    

    // get legacy ids
    let assetstreams_id = p[0]
    let assetstream = (await c.database("assetstreams").select("*").where("id", assetstreams_id))[0];
    
  
    let result = await oldKnex("videourl").where("id", assetstream.legacy_id).delete()
    
};