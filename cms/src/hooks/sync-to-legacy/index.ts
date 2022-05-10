import { defineHook } from '@directus/extensions-sdk';
import { ItemsService } from 'directus';
import episodes from '../../btv'
import knex from 'knex'
import { EpisodeEntity, LanguageEntity, LocalizedStringEntity, SeriesEntity } from '@/Database';
import { createLocalizable, getStatusFromNew, objectPatch, upsertLS } from './utils';

var oldKnex = knex({
    client: 'mssql',
    connection: {
        "host": process.env.OLDDB_HOST,
        "port": Number(process.env.OLDDB_PORT),
        "user": process.env.OLDDB_USER,
        "password": process.env.OLDDB_PASSWORD,
        "database" : process.env.OLDDB_DATABASE,
        "options": {
            "encrypt": process.env.OLDDB_ENCRYPT === "true"
        }
    },
});

function isObjectUseless(patch: object) {
    for (let k in patch) {
        if( patch[k] != undefined) {
            return false
        }
    }
    return true
} 

export default defineHook(({ filter, action }, {services}) => {    
	action('items.update', async (m,c) =>  {
		console.log('Item updated!');
		console.log(m);
        if (m.collection != "episodes") {
            return
        }
        // get legacy id
		const itemsService = new ItemsService<episodes.components["schemas"]["ItemsEpisodes"]>("episodes", {
			knex: c.database as any,
			schema: c.schema,
		});
        let e = await itemsService.readOne(Number(m.keys[0]), { fields: ['*.*.*'] })
        let season = e.season_id as episodes.components["schemas"]["ItemsSeasons"]
        let asset = e.asset_id as episodes.components["schemas"]["ItemsAssets"]
        let image = e.image_file_id as episodes.components["schemas"]["Files"]
        console.log("directus", e)

        // update it in original 
        let patch: Partial<EpisodeEntity> = {
            VideoId: asset?.legacy_id ?? 1041, // TODO: remove this temp id
            SeasonId: season.legacy_id,
            EpisodeNo: e.episode_number,
            Published: e.publish_date as unknown as Date,
            AvailableTo: e.available_to as unknown as Date,
            AvailableFrom: e.available_from as unknown as Date,
            Status: getStatusFromNew(e.status)
        }

        if (image != null) {
            patch.Image = "https://brunstadtv.imgix.net/"+image.filename_disk
        }

        if (e.download_usergroups.some(ug => (ug as any).usergroups_code.code === "fktb-download" || (ug as any).usergroups_code.code === "fktb-early-access")) {
            patch.AllowSpecialAccessFKTB = true
        }
        if (e.earlyaccess_usergroups.some(ug => (ug as any).usergroups_code.code === "kids-early-access")) {
            patch.AllowSpecialAccess = true
        }

        if (e.usergroups.some(ug => (ug as any).usergroups_code.code === "public") && e.usergroups.some(ug => (ug as any).usergroups_code.code === "bcc-members")) {
            patch.Visibility = 3
        } else if (e.usergroups.some(ug => (ug as any).usergroups_code.code === "public")) {
            patch.Visibility = 2
        } else {
            patch.Visibility = 1
        }

        if (e.status == "published") {
            patch.Status = 1
        } else {
            patch.Status = 0
        }

        let languages = await oldKnex<LanguageEntity>("language").select("*")
        
        for (let t of e.translations) {
            t = t as episodes.components["schemas"]["ItemsEpisodesTranslations"]
            let lang = (t.languages_code as episodes.components["schemas"]["ItemsLanguages"])    
            if (lang.code != "no") {
                // We want original to be source of truth for translations for now
                continue
            }
            console.log("updating norwegian")
            let oldLang = languages.find(l => l.CultureCode == lang.code)
            await upsertLS(oldKnex, t.legacy_title_id, oldLang, t.title)
            await upsertLS(oldKnex, t.legacy_description_id, oldLang, t.description)
            await upsertLS(oldKnex, t.legacy_extra_description_id, oldLang, t.extra_description)
            console.log("done updating norwegian")
        }

        console.log("patch", patch)
        if (!isObjectUseless(patch)) {
            let a = await oldKnex<EpisodeEntity>("episode").where("id", e.legacy_id).update(patch).returning("*")
            console.log(a)
        }
	});

	action('items.create', async (m, c) => {
		console.log('Item created!');
		console.log(m);
        if (m.collection != "episodes") {
            return
        }
        // get legacy id
		const episodesService = new ItemsService<episodes.components["schemas"]["ItemsEpisodes"]>("episodes", {
			knex: c.database as any,
			schema: c.schema,
		});
        const episodeTranslationsService = new ItemsService<episodes.components["schemas"]["ItemsEpisodesTranslations"]>("episodes_translations", {
			knex: c.database as any,
			schema: c.schema,
		});
        let e = await episodesService.readOne(Number(m.key), { fields: ['*.*.*'] })
        let season = e.season_id as episodes.components["schemas"]["ItemsSeasons"]
        let asset = e.asset_id as episodes.components["schemas"]["ItemsAssets"]
        let image = e.image_file_id as episodes.components["schemas"]["Files"]
        console.log("directus", e)

        // update it in original 
        let patch: Partial<EpisodeEntity> = {
            VideoId: asset?.legacy_id ?? 1041, // TODO: remove this temp id
            SeasonId: season.legacy_id,
            EpisodeNo: e.episode_number,
            Published: e.publish_date as unknown as Date,
            AvailableTo: e.available_to as unknown as Date,
            AvailableFrom: e.available_from as unknown as Date,
            Status: getStatusFromNew(e.status),
            LastUpdate: e.date_created as unknown as Date
        }

        if (image != null) {
            patch.Image = "https://brunstadtv.imgix.net/"+image.filename_disk
        }

        if (e.download_usergroups.some(ug => (ug as any).usergroups_code.code === "fktb-download" || (ug as any).usergroups_code.code === "fktb-early-access")) {
            patch.AllowSpecialAccessFKTB = true
        }
        if (e.earlyaccess_usergroups.some(ug => (ug as any).usergroups_code.code === "kids-early-access")) {
            patch.AllowSpecialAccess = true
        }

        if (e.usergroups.some(ug => (ug as any).usergroups_code.code === "public") && e.usergroups.some(ug => (ug as any).usergroups_code.code === "bcc-members")) {
            patch.Visibility = 3
        } else if (e.usergroups.some(ug => (ug as any).usergroups_code.code === "public")) {
            patch.Visibility = 2
        } else {
            patch.Visibility = 1
        }

        if (e.status == "published") {
            patch.Status = 1
        } else {
            patch.Status = 0
        }

        let languages = await oldKnex<LanguageEntity>("language").select("*")
        
        for (let t of e.translations) {
            t = t as episodes.components["schemas"]["ItemsEpisodesTranslations"]
            let lang = (t.languages_code as episodes.components["schemas"]["ItemsLanguages"])    
            if (lang.code != "no") {
                // We want original to be source of truth for translations for now
                continue
            }
            console.log("adding norwegian")
            console.log("t:", t)
            let oldLang = languages.find(l => l.CultureCode == lang.code)
            patch.TitleId = await createLocalizable(oldKnex)
            patch.DescriptionId = await createLocalizable(oldKnex)
            patch.LongDescriptionId = await createLocalizable(oldKnex)
            console.log(patch)
            //let ids = await ensureLocalizablesExist(oldKnex, 'episode', patch, {'title': 'legacy_title_id', 'description': 'legacy_description_id', 'long_description': 'legacy_extra_description_id'})
            
            t = {
                ...t,
                legacy_title_id: patch.TitleId,
                legacy_description_id: patch.DescriptionId,
                legacy_extra_description_id: patch.LongDescriptionId
            }
            await episodeTranslationsService.updateOne(t.id, t)
            await upsertLS(oldKnex, t.legacy_title_id, oldLang, t.title)
            await upsertLS(oldKnex, t.legacy_description_id, oldLang, t.description)
            await upsertLS(oldKnex, t.legacy_extra_description_id, oldLang, t.extra_description)
            console.log("done adding norwegian")
        }
        
        let legacyEpisode = await oldKnex<EpisodeEntity>("episode").insert(patch).returning("*")
        console.log(legacyEpisode)
        await c.database("episodes").update({legacy_id: legacyEpisode[0].Id}).where("id", e.id)

        console.log("insert", patch)
	});

	action('items.update', async (m,c) =>  {
		console.log('Item updated!');
		console.log(m);
        if (m.collection != "shows") {
            return
        }
        // get legacy id
		const itemsService = new ItemsService<episodes.components["schemas"]["ItemsShows"]>("shows", {
			knex: c.database as any,
			schema: c.schema,
		});
        let e = await itemsService.readOne(Number(m.keys[0]), { fields: ['*.*.*'] })
        let image = e.image_file_id as episodes.components["schemas"]["Files"]
        console.log("directus", e)

        // update it in original 
        let patch: Partial<SeriesEntity> = {
            Published: e.publish_date as unknown as Date,
            AvailableTo: e.available_to as unknown as Date,
            AvailableFrom: e.available_from as unknown as Date,
            Status: getStatusFromNew(e.status)
        }

        if (image != null) {
            patch.Image = "https://brunstadtv.imgix.net/"+image.filename_disk
        }

        if (e.status == "published") {
            patch.Status = 1
        } else {
            patch.Status = 0
        }

        let languages = await oldKnex<LanguageEntity>("language").select("*")
        
        for (let t of e.translations) {
            t = t as episodes.components["schemas"]["ItemsShowsTranslations"]
            let lang = (t.languages_code as episodes.components["schemas"]["ItemsLanguages"])    
            if (lang.code != "no") {
                // We want original to be source of truth for translations for now
                continue
            }
            console.log("updating norwegian")
            let oldLang = languages.find(l => l.CultureCode == lang.code)
            await upsertLS(oldKnex, t.legacy_title_id, oldLang, t.title)
            await upsertLS(oldKnex, t.legacy_description_id, oldLang, t.description)
            console.log("done updating norwegian")
        }

        console.log("patch", patch)
        if (!isObjectUseless(patch)) {
            let a = await oldKnex<SeriesEntity>("series").where("id", e.legacy_id).update(patch).returning("*")
            console.log("updated legacy series: ", a)
        }
	});

	action('items.create', async (m, c) => {
		console.log('Item created!');
		console.log(m);
        if (m.collection != "shows") {
            return
        }
        // get legacy id
		const showsService = new ItemsService<episodes.components["schemas"]["ItemsShows"]>("shows", {
			knex: c.database as any,
			schema: c.schema,
		});
        const showTranslationsService = new ItemsService<episodes.components["schemas"]["ItemsShowsTranslations"]>("shows_translations", {
			knex: c.database as any,
			schema: c.schema,
		});
        let e = await showsService.readOne(Number(m.key), { fields: ['*.*.*'] })
        let image = e.image_file_id as episodes.components["schemas"]["Files"]
        console.log("directus", e)

        // update it in original        
        let patch: Partial<SeriesEntity> = {
            IsCategory: e.type === "event" ? 1 : 0,
            Published: e.publish_date as unknown as Date,
            AvailableTo: e.available_to as unknown as Date,
            AvailableFrom: e.available_from as unknown as Date,
            Status: getStatusFromNew(e.status),
            LastUpdate: e.date_created as unknown as Date
        }

        if (image != null) {
            patch.Image = "https://brunstadtv.imgix.net/"+image.filename_disk
        }

        if (e.status == "published") {
            patch.Status = 1
        } else {
            patch.Status = 0
        }

        let languages = await oldKnex<LanguageEntity>("language").select("*")
        
        for (let t of e.translations) {
            t = t as episodes.components["schemas"]["ItemsShowsTranslations"]
            let lang = (t.languages_code as episodes.components["schemas"]["ItemsLanguages"])    
            if (lang.code != "no") {
                // We want original to be source of truth for translations for now
                continue
            }
            console.log("adding norwegian")
            console.log("t:", t)
            let oldLang = languages.find(l => l.CultureCode == lang.code)
            patch.TitleId = await createLocalizable(oldKnex)
            patch.DescriptionId = await createLocalizable(oldKnex)
            console.log(patch)
            //let ids = await ensureLocalizablesExist(oldKnex, 'episode', patch, {'title': 'legacy_title_id', 'description': 'legacy_description_id', 'long_description': 'legacy_extra_description_id'})
            
            t = {
                ...t,
                legacy_title_id: patch.TitleId,
                legacy_description_id: patch.DescriptionId,
            }
            await showTranslationsService.updateOne(t.id, t)
            await upsertLS(oldKnex, t.legacy_title_id, oldLang, t.title)
            await upsertLS(oldKnex, t.legacy_description_id, oldLang, t.description)
            console.log("done adding norwegian")
        }
        
        let legacyShow = await oldKnex<SeriesEntity>("series").insert(patch).returning("*")
        console.log(legacyShow, "legacyShow")
        await c.database("shows").update({legacy_id: legacyShow[0].Id}).where("id", e.id)

        console.log("insert", patch)
	});
});
