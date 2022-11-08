<template>
    <div class="flex flex-col">
        <div class="flex">
            <h3
                class="text-sm truncate text-primary"
                v-if="episode.season?.show"
            >
                {{ episode.season.show.title }}
            </h3>
            <p class="text-sm text-gray ml-auto" v-if="episode.productionDate">
                {{ new Date(episode.productionDate).toLocaleDateString() }}
            </p>
            <p class="text-sm text-gray ml-auto" v-else-if="episode.season">
                S{{ episode.season.number }}:E{{ episode.number }}
            </p>
        </div>
        <h1 class="text-md lg:text-lg line-clamp-2">{{ episode.title }}</h1>
    </div>
</template>
<script lang="ts" setup>
defineProps<{
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
