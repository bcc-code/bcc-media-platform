<template>
    <div class="px-2 lg:px-20">
        <EpisodeDisplay
            :auto-play="autoPlay"
            :initial-episode-id="episodeId"
            :context="context"
            @episode="setEpisode"
        ></EpisodeDisplay>
    </div>
</template>
<script lang="ts" setup>
import EpisodeDisplay from "@/components/episodes/EpisodeDisplay.vue"
import { GetEpisodeQuery } from "@/graph/generated";
import { computed, ref } from "vue"
import { useRouter } from "vue-router"
import { setTitle } from "@/utils/title"
import { analytics } from "@/services/analytics";

const props = defineProps<{
    episodeId: string
    collection?: string
}>()

const router = useRouter()

const autoPlay = ref(false)

const context = computed(() => ({
    collectionId: props.collection,
}))

const setEpisode = (episode: GetEpisodeQuery["episode"]) => {
    autoPlay.value = true
    router.push({
        params: { episodeId: episode.id },
        query: router.currentRoute.value.query,
    })
    
    setTitle(episode.title)

    analytics.page({
        id: "episode",
        title: document.title,
        meta: {
            episodeId: episode.id
        }
    })
}
</script>
