<script setup lang="ts">
import { PrimaryMediaType, type GetEpisodeQuery } from '@/graph/generated'
import Hls from 'hls.js'
import { onMounted, ref, useTemplateRef, onBeforeUnmount } from 'vue'

const props = defineProps<{
    episode: GetEpisodeQuery['episode']
}>()

const player = useTemplateRef('player')

const hls = ref<Hls>()

onMounted(() => {
    if (!Hls.isSupported()) return

    hls.value = new Hls()
    const src = props.episode.streams.find(
        (s) => s.primaryMediaType === PrimaryMediaType.Audio
    )?.url

    if (src && player.value) {
        hls.value.loadSource(src)
        hls.value.attachMedia(player.value)
        hls.value.on(Hls.Events.MANIFEST_PARSED, () => {
            player.value?.play()
        })
    }
})

onBeforeUnmount(() => {
    if (hls.value) {
        hls.value.destroy()
    }
})
</script>

<template>
    <div class="flex w-full">
        <audio ref="player" controls class="flex-1"></audio>
    </div>
</template>
