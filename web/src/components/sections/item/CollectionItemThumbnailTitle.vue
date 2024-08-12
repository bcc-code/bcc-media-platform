<script lang="ts" setup>
import EpisodeTitle from "@/components/episodes/EpisodeTitle.vue"
import SeasonTitle from "@/components/seasons/SeasonTitle.vue"
import ShowTitle from "@/components/shows/ShowTitle.vue"
import type { CollectionItemThumbnailFragment } from "@/graph/generated"

defineProps<{
    item: CollectionItemThumbnailFragment
    title: string
    secondaryTitles?: boolean
}>()
</script>

<template>
    <EpisodeTitle
        v-if="item.__typename === 'Episode'"
        :title="title"
        :secondary-titles="secondaryTitles ?? true"
        :episode="item"
        class="mt-1"
    />
    <SeasonTitle
        v-else-if="item.__typename === 'Season'"
        class="mt-1"
        :season="item"
        :title="title"
    />
    <ShowTitle
        v-else-if="item.__typename === 'Show'"
        class="mt-1"
        :show="item"
        :title="title"
    />
    <p v-else class="text-style-body-2 line-clamp-2">
        {{ title }}
    </p>
</template>
