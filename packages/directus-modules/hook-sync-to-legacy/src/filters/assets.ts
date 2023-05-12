import {oldKnex} from "../oldKnex";
import {isObjectUseless} from "../utils";
import * as episodes from '../btv';
import {VideoEntity} from "../Database";

enum EncodingVersion {
    AMS = 0,
    BTV = 1
}

export async function createAsset(p, m, c) {
    if (m.collection != "assets") {
        return
    }

    // get legacy id
    p = p as episodes.components["schemas"]["ItemsAssets"]
    //let image = e.image_file_id as episodes.components["schema"]["Files"]


    // update it in original
    let patch: Partial<VideoEntity> = {
        EncodingStatus: 2,
        Filename: p.name,
        LastUpdate: p.date_created as unknown as Date ?? new Date(),
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


    let legacyAsset = await oldKnex<VideoEntity>("Video").insert(patch).returning("*")

    p.legacy_id = legacyAsset[0].Id

    return p

};

export async function updateAsset(p, m, c) {
    if (m.collection != "assets") {
        return
    }

    // get legacy id
    let assetBeforeUpdate = (await c.database("assets").select("*").where("id", Number(m.keys[0])))[0]

    let patch: Partial<VideoEntity> = {
        EncodingStatus: 2,
        Filename: p.name,
        LastUpdate: p.date_created as unknown as Date ?? new Date()
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
        let a = await oldKnex<VideoEntity>("Video").where("Id", assetBeforeUpdate.legacy_id).update(patch).returning("*")

    }
};

export async function deleteAsset(p, m, c) {
    if (p.length > 1) {
        throw new Error("Syncing bulk-deletes hasn't been implemented. Contact Andreas if that's slowing you down much.")
    }

    if (m.collection !== "assets") {
        return
    }


    // get legacy ids
    let assets_id = p[0]
    let asset = (await c.database("assets").select("*").where("id", assets_id))[0];


    let result = await oldKnex("Video").where("Id", asset.legacy_id).delete()

};
