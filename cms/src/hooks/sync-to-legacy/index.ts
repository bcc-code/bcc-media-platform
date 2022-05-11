import { defineHook } from '@directus/extensions-sdk';
import { ItemsService } from 'directus';
import episodes from '../../btv'
import knex, { Knex } from 'knex'
import { CategoryEntity, CategoryEpisodeEntity, CategoryProgramEntity, CategorySeriesEntity, EpisodeEntity, LanguageEntity, LocalizedStringEntity, ProgramEntity, SeasonEntity, SeriesEntity } from '@/Database';
import { createLocalizable, getStatusFromNew, isObjectUseless, objectPatch, sleep, upsertLS } from './utils';
import { oldKnex } from './oldKnex';
import { createEpisodeTranslation, createSeasonTranslation, createShowTranslation } from './filters/translations';
import { createShow, updateShow } from './filters/shows';


export default defineHook(({ filter, action }, {services,database}) => {    

	action('items.update', (m, c) => updateShow(database, m, c))
	filter('items.create', createShow)
    
	filter('items.create', createShowTranslation);
	filter('items.create', createSeasonTranslation);
	filter('items.create', createEpisodeTranslation);

	action('items.update', async (m,c) =>  {
        await sleep(2000)
		console.log('Item updated!');
		console.log(m);
        if (m.collection != "episodes") {
            return
        }
        // get legacy id
		const itemsService = new ItemsService<episodes.components["schemas"]["ItemsEpisodes"]>("episodes", {
			knex: database as any,
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
            Published: e.publish_date as unknown as Date,
            AvailableTo: e.available_to as unknown as Date,
            AvailableFrom: e.available_from as unknown as Date,
            Status: getStatusFromNew(e.status)
        }
        if (e.type === "episode") {
            patch.SeasonId = season.legacy_id
            patch.EpisodeNo = e.episode_number

            if (e.download_usergroups.some(ug => (ug as any).usergroups_code.code === "fktb-download" || (ug as any).usergroups_code.code === "fktb-early-access")) {
                patch.AllowSpecialAccessFKTB = true
            }
            if (e.earlyaccess_usergroups.some(ug => (ug as any).usergroups_code.code === "kids-early-access")) {
                patch.AllowSpecialAccess = true
            }
        }

        if (image != null) {
            patch.Image = "https://brunstadtv.imgix.net/"+image.filename_disk
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
            await upsertLS(oldKnex, t.legacy_description_id, oldLang, t.description ?? "")
            await upsertLS(oldKnex, t.legacy_extra_description_id, oldLang, t.extra_description)
            console.log("done updating norwegian")
        }

        console.log("patch", patch)
        if (!isObjectUseless(patch)) {
            if (e.type === "episode") {
                let a = await oldKnex<EpisodeEntity>("episode").where("id", e.legacy_id).update(patch).returning("*")
                console.log(a)
            } else if (e.type === "standalone") {
                let a = await oldKnex<ProgramEntity>("program").where("id", e.legacy_program_id).update(patch).returning("*")
                console.log(a)
            }
        }
	});
    
	filter('items.create', async (m, c) => {
        if (m.collection != "episodes") {
            return
        }
		console.log('episode created!');
		console.log(m);
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
            Published: e.publish_date as unknown as Date,
            AvailableTo: e.available_to as unknown as Date,
            AvailableFrom: e.available_from as unknown as Date,
            Status: getStatusFromNew(e.status),
            LastUpdate: e.date_created as unknown as Date
        }
        if (e.type === "episode") {
            patch.SeasonId = season.legacy_id
            patch.EpisodeNo = e.episode_number

            if (e.download_usergroups.some(ug => (ug as any).usergroups_code.code === "fktb-download" || (ug as any).usergroups_code.code === "fktb-early-access")) {
                patch.AllowSpecialAccessFKTB = true
            }
            if (e.earlyaccess_usergroups.some(ug => (ug as any).usergroups_code.code === "kids-early-access")) {
                patch.AllowSpecialAccess = true
            }
        }

        if (image != null) {
            patch.Image = "https://brunstadtv.imgix.net/"+image.filename_disk
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
        
        if (e.type === "episode") {
            let legacyEpisode = await oldKnex<EpisodeEntity>("episode").insert(patch).returning("*")
            console.log(legacyEpisode)
            await c.database("episodes").update({legacy_id: legacyEpisode[0].Id}).where("id", e.id)
        } else if (e.type === "standalone") {
            let legacyProgram = await oldKnex<EpisodeEntity>("program").insert(patch).returning("*")
            console.log(legacyProgram)
            await c.database("episodes").update({legacy_program_id: legacyProgram[0].Id}).where("id", e.id)
        }

        console.log("insert", patch)
	});

    // Create seasons
	filter('items.create', async (p, m, c) => {
        if (m.collection != "seasons") {
            return
        }
		console.log('Season created!');
		console.log(p, m);

        p = p as episodes.components["schemas"]["ItemsSeasons"]
        let show = (await database("shows").select("*").where("id", p.show_id))[0];
        
        console.log("directus", p)

        // update it in original        
        let patch: Partial<any> = {
            SeriesId: show.legacy_id,
            SeasonNo: p.season_number,
            Published: p.publish_date as unknown as Date,
            AvailableTo: p.available_to as unknown as Date,
            AvailableFrom: p.available_from as unknown as Date,
            Status: getStatusFromNew(p.status),
            LastUpdate: p.date_created as unknown as Date ?? new Date()
        }
        patch.TitleId = await createLocalizable(oldKnex)
        patch.DescriptionId = await createLocalizable(oldKnex)
        patch.LongDescriptionId = await createLocalizable(oldKnex)
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
        
        let legacySeason = await oldKnex<SeasonEntity>("season").insert(patch).returning("*")
        console.log(legacySeason, "legacySeason")
        //await c.database("seasons").update({legacy_id: legacySeason[0].Id}).where("id", p.id)
        p.legacy_id = legacySeason[0].Id
        console.log("insert", patch)
        return p
	});

    // Update season
	action('items.update', async (m,c) =>  {
        await sleep(2000)
		console.log('Item updated!');
		console.log(m);
        if (m.collection != "seasons") {
            return
        }
        // get legacy id
		const itemsService = new ItemsService<episodes.components["schemas"]["ItemsSeasons"]>("seasons", {
			knex: database as any,
			schema: c.schema,
		});
        let e = await itemsService.readOne(Number(m.keys[0]), { fields: ['*.*.*'] })
        let show = e.show_id as episodes.components["schemas"]["ItemsShows"]
        let image = e.image_file_id as episodes.components["schemas"]["Files"]
        console.log("directus", e)

        // update it in original 
        let patch: Partial<SeasonEntity> = {
            SeasonNo: e.season_number,
            SeriesId: show.legacy_id,
            LastUpdate: new Date(),
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
            t = t as episodes.components["schemas"]["ItemsSeasonsTranslations"]
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
            let a = await oldKnex<SeasonEntity>("season").where("id", e.legacy_id).update(patch).returning("*")
            console.log("updated legacy season: ", a)
        }
	});

	action('items.create', async (m, c) => {
        await sleep(2000)
		console.log('Item created!');
		console.log(m);
        if (m.collection != "lists") {
            return
        }
        // get legacy id
		const itemService = new ItemsService<episodes.components["schemas"]["ItemsLists"]>("lists", {
			knex: database as any,
			schema: c.schema,
		});
        let e = await itemService.readOne(Number(m.key), { fields: ['*.*.*'] })
        console.log("directus", e)

        // update it in original        
        let patch: Partial<CategoryEntity> = {
            LastUpdate: e.date_created as unknown as Date
        }
        let languages = await oldKnex<LanguageEntity>("language").select("*")
        let oldLang = languages.find(l => l.CultureCode == "no")
        patch.NameId = await createLocalizable(oldKnex)
        await upsertLS(oldKnex, patch.NameId, oldLang, e.name)
        
        let legacyCategory = await oldKnex<CategoryEntity>("category").insert(patch).returning("*")
        console.log("legacyCategory", legacyCategory)
        await database("lists").update({legacy_category_id: legacyCategory[0].Id}).where("id", e.id)

        console.log("insert", patch)
	});


	action('items.create', async (m, c) => {
        await sleep(2000)
        if (m.collection != "lists_relations") {
            return
        }
		console.log('List relation created!');
		console.log(m);
        let {payload} = m;
        let {lists_id, collection, item} = payload

        // get legacy ids
        let list = (await database("lists").select("*").where("id", lists_id))[0];

        if (collection === "episodes") {
                let episode = (await database("episodes").select("*").where("id", item.id))[0];

                if (episode.type === "episode") {
                    let patch: Partial<CategoryEpisodeEntity> = {
                        CategoryId: list.legacy_category_id,
                        EpisodeId: episode.legacy_id
                    }
                    
                    let legacyRelation = await oldKnex("CategoryEpisode").insert(patch).returning("*")
                    console.log("legacy list relation", legacyRelation)
                } else if (episode.type === "standalone") {
                    let patch: Partial<CategoryProgramEntity> = {
                        CategoryId: list.legacy_category_id,
                        ProgramId: episode.legacy_program_id
                    }
                    
                    let legacyRelation = await oldKnex("CategoryProgram").insert(patch).returning("*")
                    console.log("legacy list relation", legacyRelation)
                } else { throw new Error("invalid episode type") }
        } else if (collection === "shows") {
            let show = (await database("shows").select("*").where("id", item.id))[0];
            let patch: Partial<CategorySeriesEntity> = {
                CategoryId: list.legacy_category_id,
                SeriesId: show.legacy_id
            }
            
            let legacyRelation = await oldKnex("CategorySeries").insert(patch).returning("*")
            console.log("legacy list relation", legacyRelation)
        } else {
            console.error("unknown collection '" + collection + "'")
            return;
        }
	});

	filter('items.delete', async (p, m, c) => {
		console.log("items.delete", m);
        if (m.collection !== "shows") {
            return
        }
		console.log('show being deleted, deleting it in legacy...');

        // get legacy ids
        let shows_id = p[0]
        let show = (await database("shows").select("*").where("id", shows_id))[0];
        console.log(show)
      
        let result = await oldKnex("series").where("id", show.legacy_id).delete()
        console.log("legacy show delete result:", result)
	});

	filter('items.delete', async (p, m, c) => {
		console.log("items.delete", m);
        if (m.collection !== "seasons") {
            return
        }
		console.log('Season being deleted, deleting it in legacy...');

        // get legacy ids
        let seasons_id = p[0]
        let season = (await database("seasons").select("*").where("id", seasons_id))[0];
        console.log(season)
      
        let result = await oldKnex("Season").where("id", season.legacy_id).delete()
        console.log("legacy season delete result:", result)
	});

	filter('items.delete', async (p, m, c) => {
		console.log("items.delete", m);
        if (m.collection != "lists_relations") {
            return
        }
		console.log('List relation deleted!');

        // get legacy ids
        let list_relation = (await database("lists_relations").select("*").where("id", p[0]))[0];
        let {collection, item, lists_id} = list_relation
        let list = (await database("lists").select("*").where("id", lists_id))[0];
        console.log(list_relation)
        console.log(list)

        if (collection === "episodes") {
                let episode = (await database("episodes").select("*").where("id", item))[0];

                if (episode.type === "episode") {
                    let result = await oldKnex("CategoryEpisode").where("categoryid", list.legacy_category_id).andWhere("episodeid", episode.legacy_id).delete()
                    console.log("legacy list relation delete result", result)
                } else if (episode.type === "standalone") {
                    let result = await oldKnex("CategoryProgram").where("categoryid", list.legacy_category_id).andWhere("ProgramId", episode.legacy_program_id).delete()
                    console.log("legacy list relation delete result", result)
                }
        } else if (collection === "shows") {
            let show = (await database("shows").select("*").where("id", item))[0];
            let result = await oldKnex("CategorySeries").where("categoryid", list.legacy_category_id).andWhere("seriesid", show.legacy_id).delete()
            console.log("legacy list relation delete result", result)
        } else {
            console.error("unknown collection '" + collection + "'")
            return;
        }
	});


	filter('items.delete', async (p, m, c) => {
		console.log("items.delete", m);
        if (m.collection !== "lists") {
            return
        }
		console.log('List being deleted, deleting it in legacy...');

        // get legacy ids
        let lists_id = p[0]
        let list = (await database("lists").select("*").where("id", lists_id))[0];
        console.log(list)
        
        let result = await oldKnex("Category").where("id", list.legacy_category_id).delete()
        console.log("legacy category delete result:", result)
	});



	filter('items.delete', async (p, m, c) => {
		console.log("items.delete", m);
        if (m.collection !== "episodes") {
            return
        }
		console.log('Episode being deleted, deleting it in legacy...');

        // get legacy ids
        let episodes_id = p[0]
        let episode = (await database("episodes").select("*").where("id", episodes_id))[0];
        console.log(episode)
      
        // should be cascade deleted instead

        if (episode.type === "episode") {
            let result = await oldKnex("Episode").where("id", episode.legacy_id).delete()
            console.log("legacy episode delete result:", result)
        } else if (episode.type === "standalone") {
            let result = await oldKnex("Program").where("id", episode.legacy_program_id).delete()
            console.log("legacy program delete result:", result)
        }
	});

});

