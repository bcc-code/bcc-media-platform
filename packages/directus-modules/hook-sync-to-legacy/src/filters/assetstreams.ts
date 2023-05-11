import {oldKnex} from "../oldKnex";
import {isObjectUseless} from "../utils";
import * as episodes from '../btv';
import {VideoUrlEntity} from "../Database";

export async function createAssetstream(p, m, c) {
    if (m.collection != "assetstreams") {
        return
    }

    let asset = (await c.database("assets").select("*").where("id", p.asset_id))[0];

    console.log("createAssetstream")
    console.log("legacy_id", asset.legacy_id)

    // update it in original
    let patch: Partial<VideoUrlEntity> = {
        VideoUrl: p.url,
        VideoId: asset.legacy_id,
        IsVideoClip: false,
    }
    if (p.type === "hls_cmaf" && p.service.indexOf('mediapackage') !== -1) {
        // Hacky solution for mediapackge to work.
        // The app accepts application/vnd.apple.mpegurl
        // or application/vnd.applev3.mpegurl.
        // It proxies the vnd.apple.mpegurl ones through proxy.brunstad.tv
        // But not the vnd.applev3.mpegurl ones.
        patch.EncodingType = "application/vnd.applev3.mpegurl"
    } else if (p.type === "hls_ts") {
        patch.EncodingType = "application/vnd.apple.mpegurl"
    } else if (p.type === "dash") {
        patch.EncodingType = "application/dash+xml"
    }


    let legacyAssetstream = await oldKnex<VideoUrlEntity>("VideoUrl").insert(patch).returning("*")

    p.legacy_id = legacyAssetstream[0].Id

    return p
    //await c.database("assetstreams").update({legacy_id: legacyAssetstream[0].Id}).where("id", e.id)

};

export async function updateAssetstream(p, m, c) {
    if (m.collection != "assetstreams") {
        return
    }

    // get legacy id
    let assetstreamBeforeUpdate = (await c.database("assetstreams").select("*").where("id", Number(p.keys[0])))[0]
    let asset = (await c.database("assets").select("*").where("id", p.asset_id))[0];


    let patch: Partial<VideoUrlEntity> = {
        VideoUrl: p.url,
        VideoId: asset.legacy_id,
        IsVideoClip: false,
    }
    let service = p.service;
    if (!service) {
        service = assetstreamBeforeUpdate.service;
    }

    if (p.type === "hls_cmaf" && p.service.indexOf('mediapackage') !== -1) {
        // Hacky solution for mediapackge to work.
        // The app accepts application/vnd.apple.mpegurl
        // or application/vnd.applev3.mpegurl.
        // It proxies the vnd.apple.mpegurl ones through proxy.brunstad.tv
        // But not the vnd.applev3.mpegurl ones.
        patch.EncodingType = "application/vnd.applev3.mpegurl"
    } else if (p.type === "hls_ts") {
        patch.EncodingType = "application/vnd.apple.mpegurl"
    } else if (p.type === "dash") {
        patch.EncodingType = "application/dash+xml"
    }


    if (!isObjectUseless(patch)) {
        let a = await oldKnex<VideoUrlEntity>("VideoUrl").where("Id", assetstreamBeforeUpdate.legacy_id).update(patch).returning("*")

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


    let result = await oldKnex("VideoUrl").where("Id", assetstream.legacy_id).delete()

};
