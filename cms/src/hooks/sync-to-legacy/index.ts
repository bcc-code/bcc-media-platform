import { defineHook } from '@directus/extensions-sdk';
import { ItemsService } from 'directus';
import episodes from '../../btv'
import knex, { Knex } from 'knex'
import { CategoryEntity, CategoryEpisodeEntity, CategoryProgramEntity, CategorySeriesEntity, EpisodeEntity, LanguageEntity, LocalizedStringEntity, ProgramEntity, SeasonEntity, SeriesEntity } from '@/Database';
import { createLocalizable, getStatusFromNew, isObjectUseless, objectPatch, sleep, upsertLS } from './utils';
import { oldKnex } from './oldKnex';
import { createEpisodeTranslation, createSeasonTranslation, createShowTranslation, updateEpisodeTranslation, updateSeasonTranslation, updateShowTranslation } from './filters/translations';
import { createShow, deleteShow, updateShow } from './filters/shows';
import { createEpisode, deleteEpisode, updateEpisode } from './filters/episodes';
import { createSeason, deleteSeason, updateSeason } from './filters/seasons';
import { createEpisodesUsergroup, deleteEpisodesUsergroup, deleteEpisodesUsergroupEarlyAccess, createEpisodesUsergroupEarlyAccess } from './filters/usergroups';
import { createList, deleteList, updateList } from './filters/lists';
import { createListRelation, deleteListRelation } from './filters/lists_relations';


export default defineHook(({ filter, action }, {services,database}) => {    

	filter('items.create', createShow)
	filter('items.create', createSeason)
	filter('items.create', createEpisode)
	filter('items.create', createList)
	filter('items.create', createShowTranslation);
	filter('items.create', createSeasonTranslation);
	filter('items.create', createEpisodeTranslation);
	filter('items.create', createEpisodesUsergroup);
	filter('items.create', createEpisodesUsergroupEarlyAccess);
	filter('items.create', createListRelation);

	filter('items.update', updateShow)
	filter('items.update', updateSeason)
	filter('items.update', updateEpisode)
	filter('items.update', updateList)
	filter('items.update', updateShowTranslation)
	filter('items.update', updateSeasonTranslation)
	filter('items.update', updateEpisodeTranslation)

	filter('items.delete', deleteEpisodesUsergroup);
	filter('items.delete', deleteEpisodesUsergroupEarlyAccess);
	filter('items.delete', deleteEpisode);
	filter('items.delete', deleteSeason);
	filter('items.delete', deleteShow);
	filter('items.delete', deleteList);
	filter('items.delete', deleteListRelation);

});

