import {oldKnex} from "../oldKnex";
import {createLocalizable, getStatusFromNew, isObjectUseless} from "../utils";
import {SeasonEntity} from "../Database";

export async function createSeason(p, m, c) {
    if (m.collection != "seasons") {
        return
    }


    let show = (await c.database("shows").select("*").where("id", p.show_id))[0];


    // update it in original
    let patch: Partial<any> = {
        SeriesId: show.legacy_id,
        SeasonNo: p.season_number,
        Published: p.publish_date as unknown as Date,
        AvailableTo: p.available_to as unknown as Date,
        AvailableFrom: p.available_from as unknown as Date,
        Status: getStatusFromNew(p.status),
        LastUpdate: p.date_created as unknown as Date ?? new Date(),
        AgeRatingCode: p.agerating_code
    }
    patch.TitleId = await createLocalizable(oldKnex)
    patch.DescriptionId = await createLocalizable(oldKnex)
    p.legacy_title_id = patch.TitleId
    p.legacy_description_id = patch.DescriptionId
    /*
        if (image != null) {
            patch.Image = "https://brunstadtv.imgix.net/"+image.filename_disk
        } */

    if (p.status == "published") {
        patch.Status = 1
    } else {
        patch.Status = 0
    }

    let legacySeason = await oldKnex<SeasonEntity>("Season").insert(patch).returning("*")

    //await c.database("seasons").update({legacy_id: legacySeason[0].Id}).where("id", p.id)
    p.legacy_id = legacySeason[0].Id

    return p
}


export async function updateSeason(p, m, c) {
    // get legacy id
    let seasonBeforeupdate = (await c.database("seasons").select("*").where("id", Number(m.keys[0])))[0];


    // update it in original
    let patch: Partial<SeasonEntity> = {
        SeasonNo: p.season_number,
        LastUpdate: new Date(),
        Published: p.publish_date as unknown as Date,
        AvailableTo: p.available_to as unknown as Date,
        AvailableFrom: p.available_from as unknown as Date,
        AgeRatingCode: p.agerating_code,
    }
    if (p.status) {
        patch.Status = getStatusFromNew(p.status)
    }
    if (p.show_id) {
        let new_show = (await c.database("shows").select("*").where("id", p.show_id))[0];
        patch.SeriesId = new_show.legacy_id
    } else if (p.show_id === null) {
        patch.SeriesId = null
    }

    if (p.image_file_id) {
        let image = (await c.database("directus_files").select("*").where("id", p.image_file_id))[0];
        patch.Image = "https://brunstadtv.imgix.net/" + image.filename_disk
    }
    if (p.image_file_id === null) {
        patch.Image = null
    }


    if (!isObjectUseless(patch)) {
        let a = await oldKnex<SeasonEntity>("Season").where("Id", seasonBeforeupdate.legacy_id).update(patch).returning("*")

    }
};


export async function deleteSeason(p, m, c) {

    if (p.length > 1) {
        throw new Error("Syncing bulk-deletes hasn't been implemented. Contact Andreas if that's slowing you down much.")
    }
    if (m.collection !== "seasons") {
        return
    }


    // get legacy ids
    let seasons_id = p[0]
    let season = (await c.database("seasons").select("*").where("id", seasons_id))[0];


    let result = await oldKnex("Season").where("Id", season.legacy_id).delete()

};
