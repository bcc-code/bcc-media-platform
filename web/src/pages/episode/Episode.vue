<template>
    <EpisodeDisplay
        class="px-2 lg:px-4"
        :auto-play="autoPlay"
        :episode-id="episodeId"
        :context="context"
        @update:episode-id="setEpisode"
    ></EpisodeDisplay>
</template>
<script lang="ts" setup>
import EpisodeDisplay from "@/components/episodes/EpisodeDisplay.vue"
import { ref, watch } from "vue"
import { useRouter } from "vue-router"

defineProps<{
    episodeId: string
}>()

const router = useRouter()

const autoPlay = ref(false)

const getCollectionQueryParam = () =>
    router.currentRoute.value.query.collection
        ? { collectionId: router.currentRoute.value.query.collection as string }
        : undefined

const context = ref(getCollectionQueryParam())

watch(
    () => router.currentRoute.value.query,
    () => {
        context.value = getCollectionQueryParam()
    }
)

const setEpisode = (id: string) => {
    autoPlay.value = true
    router.push({ params: { episodeId: id } })
}
</script>
