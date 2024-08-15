<script lang="ts" setup>
import { CollectionItemThumbnailFragment } from "@/graph/generated"

defineProps<{
    title: string
    season: CollectionItemThumbnailFragment & {
        __typename: "Season"
    }
}>()
</script>
<template>
    <div>
        <p class="text-sm text-primary w-full line-clamp-1">
            {{ season.show.title }}
        </p>
        <p class="text-sm md:text-md lg:text-lg line-clamp-2">
            {{ title }}
        </p>
    </div>
</template>
