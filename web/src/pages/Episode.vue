<template>
    <section class="max-w-screen-2xl mx-auto p-10 rounded rounded-2xl" v-if="episode">
        <EpisodeViewer
            class="drop-shadow-xl"
            :episode-id="(route.params.episodeId as string)"
        ></EpisodeViewer>
        <div class="flex mt-5">
            <img
                v-if="episode.imageUrl"
                class="rounded rounded-lg"
                :src="episode.imageUrl"
            />
            <div>
                <h3 class="text-sm text-primary">
                    {{ episode.season?.show.title }}
                </h3>
                <h1 class="text-xl">{{ episode.title }}</h1>
            </div>
        </div>
        <div v-if="error" class="text-red">{{error.message}}</div>
    </section>
</template>
<script lang="ts" setup>
import { useGetEpisodeQuery } from "@/graph/generated"
import { computed } from "vue"
import { useRoute } from "vue-router"
import EpisodeViewer from "@/components/EpisodeViewer.vue"

const route = useRoute()

const {data, error } = useGetEpisodeQuery({
    variables: {
        episodeId: route.params.episodeId as string,
    },
})

const episode = computed(() => {
    return data.value?.episode ?? null
})
</script>
