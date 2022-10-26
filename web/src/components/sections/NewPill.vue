<template>
    <div class="bg-red rounded rounded-xl text-sm px-2 py-0.5" v-if="newString">{{newString}}</div>
</template>
<script lang="ts" setup>
import { computed } from 'vue';
import { useI18n } from 'vue-i18n';
import { Section } from './types';

const props = defineProps<{
    item: (Section & {__typename: "DefaultSection" | "PosterSection" | "FeaturedSection"})["items"]["items"][0]
}>()

const {t} = useI18n()

const NEW_DAYS_THRESHOLD = 7

const newString = computed(() => {
    const date = new Date();
    date.setDate(date.getDate() - NEW_DAYS_THRESHOLD)
    switch (props.item.item?.__typename) {
        case "Episode":
            return new Date(props.item.item.publishDate).getTime() > date.getTime() ? t("common.new") : ""
        case "Season":
            return new Date(props.item.item.episodes.items[0].publishDate).getTime() > date.getTime() ? t("common.newEpisodes") : ""
        case "Show":
            const episode = props.item.item.seasons.items[0]?.episodes.items[0]
            if (!episode) break
            return new Date(episode.publishDate).getTime() > date.getTime() ? t("common.newEpisodes") : ""
    }
})
</script>