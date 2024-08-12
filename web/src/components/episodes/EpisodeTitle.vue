<template>
    <div class="flex flex-col">
        <div class="flex">
            <p
                class="text-style-caption-1 truncate text-primary mr-1"
                v-if="episode.season?.show && secondaryTitles"
            >
                {{ episode.season.show.title }}
            </p>
        </div>
        <p class="text-style-body-2 line-clamp-2">
            {{ title }}
        </p>
    </div>
</template>

<script lang="ts" setup>
import { CollectionItemThumbnailFragment } from "@/graph/generated"

defineProps<{
    title: string
    episode: CollectionItemThumbnailFragment & {
        __typename: "Episode"
    }
    secondaryTitles: boolean
}>()
</script>
