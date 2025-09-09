<script lang="ts" setup>
import { onMounted, onUnmounted, onUpdated, ref } from 'vue'
import type { Options, Player } from 'bccm-video-player'
import playerFactory from '@/services/player'
import {
    type EpisodeContext,
    useGetMeQuery,
    useUpdateEpisodeProgressMutation,
    type StreamFragment,
    StreamType,
} from '@/graph/generated'
import { useAuth0 } from '@auth0/auth0-vue'
import { setProgress } from '@/utils/episodes'
import { current as currentLanguage } from '@/services/language'
import { getSessionId } from 'rudder-sdk-js'
import { analytics } from '@/services/analytics'
import { useRoute } from 'vue-router'
import { createVjsMenuButton, type MenuItem } from '@/components/videojs/Menu'
import { languages } from '@/services/language'
import { currentApp } from '@/services/app'
import { languageTo3letter } from '@/utils/languages'
import { generateUUID } from '@/utils/uuid'
import { BMM } from '@/services/bmm'
import { getOperatingSystem } from '@/utils/userAgent'
import type { ProcessWatchedCommandEvent } from '@bcc-code/bmm-sdk-fetch'
import { useEventListener } from '@vueuse/core'

const { isAuthenticated } = useAuth0()

const route = useRoute()

const { data, executeQuery } = useGetMeQuery({ variables: {} })

const props = defineProps<{
    context: EpisodeContext
    episode: {
        id: string
        uuid: string
        title: string
        originalTitle: string
        duration: number
        progress?: number | null
        season?: {
            id: string
            title: string
            show: {
                id: string
                title: string
            }
        } | null
        streams: StreamFragment[]
    }
    autoPlay?: boolean
}>()

const emit = defineEmits<{
    (e: 'next'): void
}>()

const player = ref<Player | null>(null)

const current = ref<string | null>(null)

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

const load = async () => {
    const episodeId = props.episode.uuid
    const referenceId = generateUUID()
    if (current.value !== episodeId) {
        loaded.value = false
        current.value = episodeId
        if (!data.value) {
            await executeQuery()
        }

        const options: Partial<Options> = {
            languagePreferenceDefaults: {
                audio: languageTo3letter(currentLanguage.value.code),
                subtitles: languageTo3letter(currentLanguage.value.code),
            },
            videojs: {
                autoplay: props.autoPlay,
                playbackRates: [0.75, 1, 1.5, 1.75, 2],
                aspectRatio: '16:9',
            },
            onProgress(currentTime: number, duration: number, player: any) {
                onVideoProgress(currentTime, duration, player)
            },
            npaw: {
                enabled: !!import.meta.env.VITE_NPAW_ACCOUNT_CODE,
                accountCode: import.meta.env.VITE_NPAW_ACCOUNT_CODE,
                appName: currentApp.value,
                tracking: {
                    isLive: false,
                    userId: data.value?.me.analytics.anonymousId,
                    sessionId: getSessionId()?.toString() ?? undefined,
                    ageGroup: analytics.getUser()?.ageGroup,
                    metadata: {
                        contentId: props.episode.id,
                        title: props.episode.originalTitle,
                        seasonTitle: props.episode.season?.title,
                        seasonId: props.episode.season?.id,
                        showTitle: props.episode.season?.show.title,
                        showId: props.episode.season?.show.id,
                        overrides: {
                            'content.language': languageTo3letter(
                                currentLanguage.value.code
                            ),
                            'content.subtitles': languageTo3letter(
                                currentLanguage.value.code
                            ),
                            'content.transactionCode': referenceId,
                        },
                    },
                },
            },
        }

        player.value?.dispose()
        player.value = await playerFactory.value.create('video-player', {
            episodeId: episodeId,
            videoLanguage: route.query.videoLang as string | undefined,
            overrides: options,
        })

        if (player.value == null) {
            return
        }
        setupVideoLanguageMenu(player.value as Player)

        // create a event when player is created
        const vodPlayer = new CustomEvent('vodPlayer', {
            detail: player.value,
            bubbles: false,
            cancelable: true,
            composed: false,
        })
        window.dispatchEvent(vodPlayer)

        lastProgress = props.episode.progress
        const queryTime = parseInt(route.query.t as string, 10)
        const seekTo = queryTime ?? lastProgress
        if (seekTo && !isNaN(seekTo)) {
            player.value.currentTime(seekTo)
        }

        if (isAuthenticated.value) {
            player.value.on('timeupdate', checkProgress)
        }
        player.value.on('ended', () => {
            emit('next')
        })
        player.value.on('play', () => {
            analytics.track('video_played', {
                videoId: props.episode.id,
                referenceId: referenceId,
                data: {
                    // Whatever data we want to send
                },
            })
        })
        loaded.value = true
    }
}

const setupVideoLanguageMenu = (player: Player) => {
    const videoLanguages = props.episode.streams
        .filter((s) => s.type === StreamType.HlsCmaf)
        .map((s) => {
            if (s.videoLanguage === null) {
                return {
                    label: 'Original',
                    value: null,
                    selected: route.query.videoLang == null,
                }
            }
            return {
                label: languages.value.filter(
                    (l) => l.code === s.videoLanguage
                )[0]?.localizedName,
                value: s.videoLanguage,
                selected: route.query.videoLang === s.videoLanguage,
            } as MenuItem
        })

    function setVideoLanguage(lang: string | undefined) {
        let url = `?t=${player.currentTime()}`
        if (lang) {
            url += `&videoLang=${lang}`
        }
        window.location.href = url
    }

    createVjsMenuButton(player, {
        items: videoLanguages,
        icon: 'vjs-icon-subtitles',
        title: 'Video Language',
        id: 'videolanguage',
        placement: 10,
        onClick: (i) => setVideoLanguage(i.value),
    })
}

const checkProgress = async (force?: boolean) => {
    if (!player.value) {
        return
    }
    const episodeId = props.episode.id
    const progress = Math.floor(player.value.currentTime() ?? 0)
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

// This is a very naive v1.0 of the BMM streak tracking.
// With this implementation, we have basically no way of preventing the
// user from skipping forward to the end, and therefore getting the streak point.
let hasSentHalfwayWatchedEvent = false
function onVideoProgress(
    currentTime: number,
    duration: number,
    player: Player
) {
    const videoProgressPercent = currentTime / duration
    if (
        (videoProgressPercent >= 0.5 && !hasSentHalfwayWatchedEvent) ||
        videoProgressPercent === 1
    ) {
        const event: ProcessWatchedCommandEvent = {
            episodeId: props.episode.id,
            os: getOperatingSystem(),
            language: currentLanguage.value.code,
            lastPosition: Math.floor(currentTime * 1000),
            timestampStart: new Date(),
            adjustedPlaybackSpeed: player.playbackRate(),
            playbackOrigin: 'bccm-web',
        }

        new BMM().postStatisticsWatched(event)
        hasSentHalfwayWatchedEvent = true
    }
}

onUpdated(load)

onMounted(() => {
    load()
})

onUnmounted(async () => {
    await checkProgress(true)
    player.value?.dispose()
})

const doTogglePlay = () => {
    if (!player.value) return
    if (player.value.paused()) {
        player.value.play()
    } else {
        player.value.pause()
    }
}
const doPlayerSkip = (seconds: number) => {
    const currentTime = player.value?.currentTime()
    if (!player.value || !currentTime) return
    player.value.currentTime(currentTime + seconds)
}
const onKeyDown = (event: KeyboardEvent) => {
    if (!player.value) return
    if (event.type === 'keydown') {
        switch (event.key) {
            case ' ':
            case 'k':
                event.preventDefault()
                doTogglePlay()
                break
            case 'ArrowLeft':
                event.preventDefault()
                doPlayerSkip(-5)
                break
            case 'ArrowRight':
                event.preventDefault()
                doPlayerSkip(5)
                break
            case 'j':
                event.preventDefault()
                doPlayerSkip(-10)
                break
            case 'l':
                event.preventDefault()
                doPlayerSkip(10)
                break
        }
    }
}
useEventListener('keydown', onKeyDown)

defineExpose({
    player,
})
</script>

<template>
    <div
        id="video-player"
        class="transition bg-slate-800"
        :class="[loaded ? 'opacity-100' : 'opacity-0']"
    ></div>
</template>

<style>
#video-player img {
    object-fit: cover;
}
</style>
