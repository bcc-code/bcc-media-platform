<template>
    <EpisodeDisplay :auto-play="autoPlay" :episode-id="episodeId" @update:episode-id="setEpisode"></EpisodeDisplay>
</template>
<script lang="ts" setup>
import EpisodeDisplay from '@/components/episodes/EpisodeDisplay.vue';
import { ref } from 'vue';
import { useRouter } from 'vue-router';

defineProps<{
    episodeId: string
}>()

const router = useRouter()

const autoPlay = ref(false)

const setEpisode = (id: string) => {
    autoPlay.value = true
    router.push({params: {episodeId: id}})
}
</script>
