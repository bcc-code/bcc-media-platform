<template>
    <div class="px-2 lg:px-20">
        <EpisodeDisplay
            :auto-play="autoPlay"
            :episode-id="episodeId"
            :context="context"
            @update:episode-id="setEpisode"
        ></EpisodeDisplay>
    </div>
</template>
<script lang="ts" setup>
import EpisodeDisplay from "@/components/episodes/EpisodeDisplay.vue"
import { computed, ref } from "vue"
import { useRouter } from "vue-router"

const props = defineProps<{
    episodeId: string
    collection?: string
}>()

const router = useRouter()

const autoPlay = ref(false)

const context = computed(() => ({
    collectionId: props.collection,
}))

const setEpisode = (id: string) => {
    autoPlay.value = true
    router.push({
        params: { episodeId: id },
        query: router.currentRoute.value.query,
    })
}
</script>
