<script lang="ts" setup>
import type { CollectionItemThumbnailFragment } from '@/graph/generated'

defineProps<{
    title: string
    episode: CollectionItemThumbnailFragment & {
        __typename: 'Episode'
    }
    secondaryTitles: boolean
}>()
</script>

<template>
    <div class="flex flex-col">
        <div class="flex">
            <p
                v-if="episode.season?.show && secondaryTitles"
                class="text-style-caption-1 truncate text-primary mr-1"
            >
                {{ episode.season.show.title }}
            </p>
        </div>
        <p class="text-style-body-2 line-clamp-2">
            {{ title }}
        </p>
    </div>
</template>
