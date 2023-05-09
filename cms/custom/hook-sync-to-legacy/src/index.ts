import {
    createEpisodeTranslation,
    createSeasonTranslation,
    createShowTranslation,
    updateEpisodeTranslation,
    updateSeasonTranslation,
    updateShowTranslation
} from './filters/translations';
import {createShow, deleteShow, updateShow} from './filters/shows';
import {createEpisode, deleteEpisode, updateEpisodes} from './filters/episodes';
import {createSeason, deleteSeason, updateSeason} from './filters/seasons';
import {
    createEpisodesUsergroup,
    createEpisodesUsergroupEarlyAccess,
    deleteEpisodesUsergroup,
    deleteEpisodesUsergroupEarlyAccess,
    updateUsergroup
} from './filters/usergroups';
import {createList, deleteList, updateList} from './filters/lists';
import {createListRelation, deleteListRelation} from './filters/lists_relations';
import {createAsset, deleteAsset, updateAsset} from './filters/assets';
import {createAssetstream, deleteAssetstream, updateAssetstream} from './filters/assetstreams';
import {createEpisodeTag, deleteEpisodeTag, updateTag} from './filters/tags';

export default (({filter}) => {
    if (process.env.LEGACY_SYNC === "off") {
        return
    }

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
    filter('items.create', createAsset);
    filter('items.create', createAssetstream);
    filter('items.create', createEpisodeTag);

    filter('items.update', (p: any, m: any, c: any) => {
        if (m.keys.length > 1 && m.collection != "episodes") {
            throw new Error("Syncing bulk-updates hasn't been implemented. Contact Andreas if that's slowing you down much.")
        }
        switch (m.collection) {
            case "shows":
                return updateShow(p, m, c);
            case "seasons":
                return updateSeason(p, m, c);
            case "episodes":
                return updateEpisodes(p, m, c);
            case "lists":
                return updateList(p, m, c);
            case "shows_translations":
                return updateShowTranslation(p, m, c);
            case "seasons_translations":
                return updateSeasonTranslation(p, m, c);
            case "episodes_translations":
                return updateEpisodeTranslation(p, m, c);
            case "usergroups":
                return updateUsergroup(p, m, c);
            case "assets":
                return updateAsset(p, m, c);
            case "assetstreams":
                return updateAssetstream(p, m, c);
            case "tags":
                return updateTag(p, m, c);
        }
    });

    filter('items.delete', (p: any[], m, c) => {
        if (p.length > 1) {
            throw new Error("Syncing bulk-deletes hasn't been implemented. Contact Andreas if that's slowing you down much.")
        }
        switch (m.collection) {
            case "episodes_usergroups":
                return deleteEpisodesUsergroup(p, m, c);
            case "episodes_usergroups_earlyaccess":
                return deleteEpisodesUsergroupEarlyAccess(p, m, c);
            case "episodes":
                return deleteEpisode(p, m, c);
            case "seasons":
                return deleteSeason(p, m, c);
            case "shows":
                return deleteShow(p, m, c);
            case "lists":
                return deleteList(p, m, c);
            case "lists_relations":
                return deleteListRelation(p, m, c);
            case "assets":
                return deleteAsset(p, m, c);
            case "assetstreams":
                return deleteAssetstream(p, m, c);
            case "episodes_tags":
                return deleteEpisodeTag(p, m, c);
        }
    })
})
