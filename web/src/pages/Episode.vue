<template>
    <div v-if="episode">
        <EpisodeViewer :episode-id="(route.params.episodeId as string)"></EpisodeViewer>
        <div class="flex">
            <img v-if="episode.imageUrl" class="rounded rounded-lg" :src="episode.imageUrl" />
            <div>
                <h3 class="text-sm text-secondary">{{episode.season?.show.title}}</h3>
                <h1 class="text-xl">{{ episode.title }}</h1>
            </div>
        </div>
    </div>
</template>
<script lang="ts" setup>
import { useGetEpisodeQuery } from "@/graph/generated"
import { addError } from "@/utils/error"
import { computed, ref } from "vue"
import { useRoute } from "vue-router"
import EpisodeViewer from "@/components/EpisodeViewer.vue";

const route = useRoute()

const query = useGetEpisodeQuery({
    variables: {
        episodeId: route.params.episodeId as string,
    },
})

const episode = computed(() => {
    return query.data.value?.episode ?? null
})

query.then((r) => {
    if (query.error.value) {
        addError(query.error.value.message)
        return
    }
})
</script>
