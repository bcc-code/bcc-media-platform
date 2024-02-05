<template>
    <div class="flex flex-col">
        <div class="flex">
            <h3
                class="text-style-caption-1 truncate text-primary mr-1"
                v-if="episode.season?.show && secondaryTitles"
            >
                {{ episode.season.show.title }}
            </h3>
        </div>
        <h1 class="text-style-body-2 line-clamp-2">
            {{ episode.title }}
        </h1>
    </div>
</template>
<script lang="ts" setup>
defineProps<{
    secondaryTitles: boolean
    episode: {
        title: string
        number?: number | null
        productionDate?: string | null
        season?: {
            number: number
            show: {
                type: string
                title: string
            }
        } | null
    }
}>()
</script>
