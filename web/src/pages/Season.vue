<template>
    <div v-if="season" class="max-w-screen-xl mx-auto">
        <img v-if="img" :src="img" />
        <h1 class="text-primary">{{ season.show.title }}</h1>
        <h1 class="text-xl">{{ season.number }} {{ season.title }}</h1>
        <p>{{ season.description }}</p>
        <div class="flex flex-col mt-10 bg-black p-4 rounded rounded-xl gap-4">
            <EpisodeCard
                v-for="episode in season.episodes.items"
                :item="episode"
            ></EpisodeCard>
        </div>
    </div>
    <div v-if="fetching">Loading...</div>
</template>
<script lang="ts" setup>
import { useGetSeasonQuery } from "@/graph/generated"
import { computed } from "vue"
import { useRoute } from "vue-router"
import EpisodeCard from "@/components/EpisodeCard.vue"
import { randomImageUrl } from "@/utils/randomImage"

const route = useRoute()

const showId = route.params.seasonId as string

const { data, fetching } = useGetSeasonQuery({
    variables: {
        id: showId,
    },
})

const img = computed(() => {
    return season.value?.imageUrl ?? randomImageUrl()
})

const season = computed(() => {
    return data.value?.season ?? null
})
</script>
