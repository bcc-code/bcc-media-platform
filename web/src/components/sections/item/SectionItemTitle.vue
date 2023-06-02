<template>
    <EpisodeTitle
        v-if="i.item?.__typename === 'Episode'"
        class="mt-1"
        :secondary-titles="secondaryTitles ?? true"
        :episode="{
            ...i.item,
            title: i.title,
            number: i.item.episodeNumber,
        }"
    ></EpisodeTitle>
    <SeasonTitle
        v-else-if="i.item?.__typename === 'Season'"
        class="mt-1"
        :season="{ ...i.item, title: i.title }"
    >
    </SeasonTitle>
    <ShowTitle
        v-else-if="i.item?.__typename === 'Show'"
        class="mt-1"
        :show="{
            title: i.title,
            episodeCount: i.item.episodeCount,
            seasonCount: i.item.seasonCount,
        }"
    >
    </ShowTitle>
    <div v-else>
        <h1 class="text-sm md:text-md lg:text-lg line-clamp-2">
            {{ i.title }}
        </h1>
    </div>
</template>
<script lang="ts" setup>
import EpisodeTitle from "../../episodes/EpisodeTitle.vue"
import SeasonTitle from "../../seasons/SeasonTitle.vue"
import ShowTitle from "../../shows/ShowTitle.vue"
import { Section } from "../types"

defineProps<{
    secondaryTitles?: boolean
    i: (Section & {
        __typename:
            | "DefaultSection"
            | "DefaultGridSection"
            | "PosterSection"
            | "PosterGridSection"
    })["items"]["items"][0]
}>()
</script>
