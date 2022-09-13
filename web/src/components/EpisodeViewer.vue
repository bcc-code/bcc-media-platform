<template>
    <div id="video-player"></div>
</template>
<script lang="ts" setup>
import { addError } from "@/utils/error"
import { onMounted, onUnmounted, onUpdated, ref } from "vue"
import { Player } from "bccm-video-player"
import playerFactory from "@/services/player";

const props = defineProps<{
    episodeId: string
}>()

const player = ref(null as Player | null)

const current = ref(null as string | null)

const load = async () => {
    const episodeId = props.episodeId
    if (current.value !== episodeId) {
        current.value = episodeId
        player.value = await playerFactory.create("video-player", {
            episodeId: episodeId,
        })
        if (player.value === null) {
            addError("No available VOD for this episode")
        }
    }
}

onUpdated(load)
onMounted(load)

onUnmounted(() => {
    player.value?.dispose()
})
</script>
