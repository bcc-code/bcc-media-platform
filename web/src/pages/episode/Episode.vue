<template>
    <div class="px-2 lg:px-20">
        <EpisodeDisplay
            :auto-play="autoPlay"
            :initial-episode-id="episodeId"
            :context="context"
            @episode="setEpisode"
        />
    </div>
</template>
<script lang="ts" setup>
import EpisodeDisplay from "@/components/episodes/EpisodeDisplay.vue"
import { GetEpisodeQuery } from "@/graph/generated"
import { computed, ref } from "vue"
import { useRouter } from "vue-router"
import { setTitle } from "@/utils/title"
import { analytics } from "@/services/analytics"
import { usePage } from "@/utils/page"

const props = defineProps<{
    episodeId: string
    collection?: string
    playlistId?: string
}>()

const router = useRouter()

const autoPlay = ref(false)

const context = computed(() => ({
    collectionId: props.collection,
    playlistId: props.playlistId,
}))

const setEpisode = (episode: GetEpisodeQuery["episode"]) => {
    autoPlay.value = true
    router.push({
        params: { episodeId: episode.id },
        query: router.currentRoute.value.query,
    })

    setTitle(episode.title)

    const { setCurrent } = usePage()
    setCurrent("episode")
    analytics.page({
        id: "episode",
        title: document.title,
        meta: {
            episodeId: episode.id,
        },
    })
}
</script>
