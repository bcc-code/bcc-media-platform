<template>
    <div>
        <h1 class="text-xl">{{ title }}</h1>
        <div id="video-player"></div>
    </div>
</template>
<script lang="ts" setup>
import { useGetEpisodeQuery } from "@/graph/generated"
import { addError } from "@/utils/error"
import { onMounted, onUnmounted, onUpdated, ref } from "vue"
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

const player = ref(null as any)

const current = ref(null as string | null)

const load = async () => {
    const episodeId = route.params.episodeId as string;
    if (current.value !== episodeId) {
        player.value = await create("video-player", {
            episodeID: route.params.episodeId as string
        })
    }
}

onUpdated(load)

onMounted(load)

onUnmounted(() => {
    player.value?.dispose()
})
</script>
