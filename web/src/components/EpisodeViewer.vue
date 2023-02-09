<template>
    <div
        class="transition bg-slate-800"
        :class="[loaded ? 'opacity-100' : 'opacity-0']"
        id="video-player"
    ></div>
</template>
<script lang="ts" setup>
import { addError } from "@/utils/error"
import { onMounted, onUnmounted, onUpdated, ref } from "vue"
import { Player } from "bccm-video-player"
import playerFactory from "@/services/player"
import {
    EpisodeContext,
    useGetMeQuery,
    useUpdateEpisodeProgressMutation,
} from "@/graph/generated"
import { useAuth0 } from "@auth0/auth0-vue"
import { setProgress } from "@/utils/episodes"
import { current as currentLanguage } from "@/services/language"

const { isAuthenticated } = useAuth0()

const lanTo3letter: {
    [key: string]: string
} = {
    no: "nor",
    en: "eng",
    nl: "nld",
    de: "deu",
    fr: "fra",
    es: "spa",
    fi: "fin",
    ru: "rus",
    pt: "por",
    ro: "ron",
    tr: "tur",
    pl: "pol",
    hu: "hun",
    it: "ita",
    da: "dan",
}

const { data, executeQuery } = useGetMeQuery()

const props = defineProps<{
    context: EpisodeContext
    episode: {
        id: string
        title: string
        duration: number
        progress?: number | null
        season?: {
            title: string
            show: {
                title: string
            }
        } | null
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
        context: props.context,
    })
}

let lastProgress = props.episode.progress
const loaded = ref(false)

const onSpaceBar = (event: KeyboardEvent) => {
    if (event.type === "keydown") {
        if (event.key === " ") {
            event.preventDefault()

            if (!player.value) return

            if (player.value.paused()) {
                player.value.play()
            } else {
                player.value.pause()
            }
        }
    }
}

const load = async () => {
    const episodeId = props.episode.id
    if (current.value !== episodeId) {
        loaded.value = false
        current.value = episodeId
        if (!data.value) {
            await executeQuery()
        }

        player.value?.dispose()
        player.value = await playerFactory.create("video-player", {
            episodeId: episodeId,
            overrides: {
                languagePreferenceDefaults: {
                    audio: lanTo3letter[currentLanguage.value.code],
                    subtitles: lanTo3letter[currentLanguage.value.code],
                },
                videojs: {
                    autoplay: props.autoPlay,
                },
                npaw: {
                    enabled: true,
                    accountCode: import.meta.env.VITE_NPAW_ACCOUNT_CODE,
                    tracking: {
                        isLive: false,
                        userId: data.value?.me.analytics.anonymousId,
                        metadata: {
                            contentId: episodeId,
                            title: props.episode.title,
                            episodeTitle: props.episode.title,
                            seasonTitle: props.episode.season?.title,
                            showTitle: props.episode.season?.show.title,
                        },
                    },
                },
            },
        })

        // create a event when player is created 
        const vodPlayer = new CustomEvent("vodPlayer", {
            detail: player.value,
            bubbles: false,
            cancelable: true,
            composed: false,
        });
        window.dispatchEvent(vodPlayer)
        
        lastProgress = props.episode.progress
        player.value.currentTime(lastProgress)

        // player.value.on("play", analytics.track("playback_started", ))
        // player.value.on("ended", analytics.track("playback_ended", undefined))
        // player.value.on("pause", analytics.track("playback_paused", undefined))
        // player.value.on("error", analytics.track("playback_interrupted", undefined))
        if (isAuthenticated.value) {
            player.value.on("timeupdate", checkProgress)
        }
        if (player.value === null) {
            addError("No available VOD for this episode")
        }
        loaded.value = true
    }
}

const checkProgress = async (force?: boolean) => {
    if (!player.value) {
        return
    }
    const episodeId = props.episode.id
    const progress = Math.floor(player.value.currentTime())
    if (
        force === true ||
        (progress &&
            (lastProgress === null ||
                lastProgress === undefined ||
                (progress != lastProgress && progress % 15 === 0) ||
                lastProgress - progress < -15 ||
                progress - lastProgress < -15))
    ) {
        lastProgress = progress
        await updateEpisodeProgress({
            id: episodeId,
            duration: props.episode.duration,
            progress: progress,
        })
        setProgress(episodeId, progress)
    }
}

onUpdated(load)

onMounted(() => {
    load()
    window.addEventListener("keydown", onSpaceBar)
})

onUnmounted(async () => {
    await checkProgress(true)
    player.value?.dispose()
    window.removeEventListener("keydown", onSpaceBar)
})
</script>
