<template>
    <div>
        <EpisodeViewer :episode-id="(route.params.episodeId as string)"></EpisodeViewer>
        <div class="flex">
            <img class="rounded rounded-lg" :src="query.data.value?.episode?.image" />
            <div>
                <h3 class="text-sm text-secondary">{{query.data.value?.episode?.season?.show.title}}</h3>
                <h1 class="text-xl">{{ title }}</h1>
            </div>
        </div>
    </div>
</template>
<script lang="ts" setup>
import { useGetEpisodeQuery } from "@/graph/generated"
import { addError } from "@/utils/error"
import { ref } from "vue"
import { useRoute } from "vue-router"
import EpisodeViewer from "@/components/EpisodeViewer.vue";

const route = useRoute()

const query = useGetEpisodeQuery({
    variables: {
        episodeId: route.params.episodeId as string,
    },
})

const title = ref("")

query.then((r) => {
    if (query.error.value) {
        addError(query.error.value.message)
        return
    }
    const episode = r.data.value?.episode
    if (episode) {
        title.value = episode.title
    }
})
</script>
