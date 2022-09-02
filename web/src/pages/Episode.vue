<template>
    <div>
        <h1 class="text-xl">{{ title }}</h1>
        <div id="video-player"></div>
    </div>
</template>
<script lang="ts" setup>
import { useGetEpisodeQuery } from "@/graph/generated"
import { addError } from "@/utils/error"
import { onMounted, ref } from "vue"
import { useRoute } from "vue-router"
import { create } from "btv-video-player"

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

onMounted(() => {
    create("video-player", {
        episodeID: route.params.episodeId as string
    })
})
</script>
