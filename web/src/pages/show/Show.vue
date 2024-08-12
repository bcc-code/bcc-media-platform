<script lang="ts" setup>
import ShowSeason from "@/components/shows/ShowSeason.vue"
import { useGetShowQuery } from "@/graph/generated"

const props = defineProps<{
    showId: string
}>()

const { data } = useGetShowQuery({
    variables: { id: props.showId },
})
</script>

<template>
    <div v-if="data" class="px-2 lg:px-20">
        <div class="my-8">
            <h1 class="text-style-headline-1 mb-2">
                {{ data.show.title }}
            </h1>
            <p class="text-style-body-2 text-label-3">
                {{ data.show.description }}
            </p>
        </div>

        <ShowSeason
            v-for="season in data.show.seasons.items"
            :key="season.id"
            :season="season"
            class="mb-6"
        />
    </div>
</template>
