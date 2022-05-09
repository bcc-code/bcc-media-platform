import { defineHook } from '@directus/extensions-sdk';
import { ItemsService } from 'directus';
import episodes from '../../btv'
import knex from 'knex'
import { EpisodeEntity } from '@/Database';
import { getStatusFromNew } from './utils';

var oldKnex = knex({
    client: 'mssql',
    connection: {
        "host": process.env.OLDDB_HOST,
        "port": Number(process.env.OLDDB_PORT),
        "user": process.env.OLDDB_USER,
        "password": process.env.OLDDB_PASSWORD,
        "database" : process.env.OLDDB_DATABASE
    }
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
	filter('items.update', async (p,m,c) =>  {
        let input = p as Partial<episodes.components["schemas"]["ItemsEpisodes"]>
        if(m.collection != "episodes") {
            return
        }
		console.log('Updating Item!');
		console.log(p);
		console.log(m);
        // get legacy id
		const itemsService = new ItemsService<episodes.components["schemas"]["ItemsEpisodes"]>("episodes", {
			knex: c.database as any,
			schema: c.schema,
		});
        let e = await itemsService.readOne(Number(m.keys[0]))

        // update it in original 
        let patch: Partial<EpisodeEntity> = {
            EpisodeNo: input.episode_number,
            Published: input.publish_date as unknown as Date,
            AvailableTo: input.available_to as unknown as Date,
            AvailableFrom: input.available_from as unknown as Date,
            Status: getStatusFromNew(input.status)
        }
        
        if (!isObjectUseless(patch)) {
            let a = await oldKnex<EpisodeEntity>("episode").where("id", e.legacy_id).update(patch).returning("*")
            console.log(a)
        }
	});

	action('items.create', () => {
		console.log('Item created!');
	});
});
