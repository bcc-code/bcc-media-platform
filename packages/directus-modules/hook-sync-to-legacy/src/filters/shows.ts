import {oldKnex} from "../oldKnex";
import {createLocalizable, getStatusFromNew, isObjectUseless} from "../utils";
import * as episodes from '../btv';
import {SeriesEntity} from "../Database";

export async function updateShow(p, m, c) {
    // get legacy id
    let showBeforeUpdate = (await c.database("shows").select("*").where("id", Number(m.keys[0])))[0]

    // update it in original
    let patch: Partial<SeriesEntity> = {
        Published: p.publish_date as unknown as Date,
        AvailableTo: p.available_to as unknown as Date,
        AvailableFrom: p.available_from as unknown as Date,
        LastUpdate: new Date()
    }
    if (p.type) {
        patch.IsCategory = p.type === "event" ? 1 : 0
    }
    if (p.status) {
        patch.Status = getStatusFromNew(p.status)
    }

    if (p.image_file_id) {
        let image = (await c.database("directus_files").select("*").where("id", p.image_file_id))[0];
        patch.Image = "https://brunstadtv.imgix.net/" + image.filename_disk
    }
    if (p.image_file_id === null) {
        patch.Image = null
    }


    if (!isObjectUseless(patch)) {
        let a = await oldKnex<SeriesEntity>("Series").where("Id", showBeforeUpdate.legacy_id).update(patch).returning("*")
    }
};

export async function createShow(p, m, c) {
    if (m.collection != "shows") {
        return
    }


    // get legacy id
    p = p as episodes.components["schemas"]["ItemsShows"]
    //let image = e.image_file_id as episodes.components["schema"]["Files"]


    // update it in original
    let patch: Partial<SeriesEntity> = {
        IsCategory: p.type === "event" ? 1 : 0,
        Published: p.publish_date as unknown as Date,
        AvailableTo: p.available_to as unknown as Date,
        AvailableFrom: p.available_from as unknown as Date,
        ShowEpisodeTitles: 1,
        Status: getStatusFromNew(p.status),
        LastUpdate: p.date_created as unknown as Date ?? new Date()
    }
    patch.TitleId = await createLocalizable(oldKnex)
    patch.DescriptionId = await createLocalizable(oldKnex)
    p.legacy_title_id = patch.TitleId
    p.legacy_description_id = patch.DescriptionId

    /* if (image != null) {
        patch.Image = "https://brunstadtv.imgix.net/"+image.filename_disk
    } */

    if (p.status == "published") {
        patch.Status = 1
    } else {
        patch.Status = 0
    }


    let legacyShow = await oldKnex<SeriesEntity>("Series").insert(patch).returning("*")

    p.legacy_id = legacyShow[0].Id

    return p
    //await c.database("shows").update({legacy_id: legacyShow[0].Id}).where("id", e.id)

};

export async function deleteShow(p, m, c) {

    if (p.length > 1) {
        throw new Error("Syncing bulk-deletes hasn't been implemented. Contact Andreas if that's slowing you down much.")
    }
    if (m.collection !== "shows") {
        return
    }


    // get legacy ids
    let shows_id = p[0]
    let show = (await c.database("shows").select("*").where("id", shows_id))[0];


    let result = await oldKnex("Series").where("Id", show.legacy_id).delete()

};
