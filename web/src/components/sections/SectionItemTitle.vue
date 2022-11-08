<template>
    <div v-if="i.item?.__typename === 'Episode'" class="mt-1">
        <EpisodeTitle
            :episode="{
                ...i.item,
                title: i.title,
                number: i.item.episodeNumber,
            }"
        ></EpisodeTitle>
    </div>
    <div v-else-if="i.item?.__typename === 'Season'" class="mt-1">
        <h3 class="text-sm text-primary w-full line-clamp-1">
            {{ i.item.show.title
            }}<span class="ml-1 text-gray">S{{ i.item.seasonNumber }}</span>
        </h3>
        <h1 class="text-lg lg:text-xl line-clamp-2">{{ i.title }}</h1>
    </div>
    <div v-else-if="i.item?.__typename === 'Show'" class="mt-1">
        <h1 class="text-lg lg:text-xl line-clamp-2">{{ i.title }}</h1>
        <p class="text-gray line-clamp-1">
            {{ t("section.item.season", i.item.seasonCount) }} -
            {{ t("section.item.episode", i.item.episodeCount) }}
        </p>
    </div>
</template>
<script lang="ts" setup>
import { useI18n } from "vue-i18n"
import EpisodeTitle from "../episodes/EpisodeTitle.vue"
import { Section } from "./types"

const { t } = useI18n()

defineProps<{
    i: (Section & {
        __typename:
            | "DefaultSection"
            | "DefaultGridSection"
            | "PosterSection"
            | "PosterGridSection"
    })["items"]["items"][0]
}>()
</script>
