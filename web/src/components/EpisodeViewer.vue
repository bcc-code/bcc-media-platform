<template>
    <div id="video-player"></div>
</template>
<script lang="ts" setup>
import { addError } from "@/utils/error"
import { onMounted, onUnmounted, onUpdated, ref } from "vue"
import { Player } from "bccm-video-player"
import playerFactory from "@/services/player"
import { useUpdateEpisodeProgressMutation } from "@/graph/generated"
import { useAuth0 } from "@auth0/auth0-vue"
import { setProgress } from "@/utils/episodes"

const { isAuthenticated } = useAuth0()

const props = defineProps<{
    episode: {
        id: string
        duration: number
        progress?: number | null
    }
    autoPlay?: boolean
}>()

const player = ref(null as Player | null)

const current = ref(null as string | null)

const { executeMutation } = useUpdateEpisodeProgressMutation()

const updateEpisodeProgress = async (episode: {
    id: string
    progress: number
    duration: number
}) => {
    await executeMutation({
        episodeId: episode.id,
        progress: episode.progress,
        duration: episode.duration,
    })
}

const load = async () => {
    const episodeId = props.episode.id
    if (current.value !== episodeId) {
        current.value = episodeId
        player.value?.dispose()
        player.value = await playerFactory.create("video-player", {
            episodeId: episodeId,
            overrides: {
                videojs: {
                    autoplay: props.autoPlay,
                },
            },
        })
        let lastProgress = props.episode.progress
        player.value.currentTime(lastProgress)
        if (isAuthenticated.value) {
            player.value.on("timeupdate", async () => {
                const progress = Math.floor(player.value.currentTime())
                if (
                    lastProgress === null ||
                    lastProgress === undefined ||
                    (progress != lastProgress && progress % 15 === 0) ||
                    lastProgress - progress < -15 ||
                    progress - lastProgress < -15
                ) {
                    lastProgress = progress
                    await updateEpisodeProgress({
                        id: episodeId,
                        duration: props.episode.duration,
                        progress: progress,
                    })
                    setProgress(episodeId, progress)
                }
            })
        }
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
