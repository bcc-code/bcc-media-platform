<script lang="ts" setup>
import { onMounted, onUnmounted, onUpdated, ref } from 'vue'
import { Options, Player } from 'bccm-video-player'
import playerFactory from '@/services/player'
import {
    EpisodeContext,
    useGetMeQuery,
    useUpdateEpisodeProgressMutation,
    StreamFragment,
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
import { ProcessWatchedCommandEvent } from '@bcc-code/bmm-sdk-fetch'

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

const onSpaceBar = (event: KeyboardEvent) => {
    if (event.type === 'keydown') {
        if (event.key === ' ') {
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
            },
            onProgress(currentTime, duration, player) {
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
                )[0].localizedName,
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

let playedOverHalfCounter = 0
function onVideoProgress(
    currentTime: number,
    duration: number,
    player: Player
) {
    const videoProgressPercent = currentTime / duration
    if (videoProgressPercent >= 0.5 && playedOverHalfCounter < 20) {
        playedOverHalfCounter++
    }
    if (
        (videoProgressPercent >= 0.5 && playedOverHalfCounter === 10) ||
        (videoProgressPercent === 1 && playedOverHalfCounter > 10)
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
    }
}

onUpdated(load)

onMounted(() => {
    load()
    window.addEventListener('keydown', onSpaceBar)
})

onUnmounted(async () => {
    await checkProgress(true)
    player.value?.dispose()
    window.removeEventListener('keydown', onSpaceBar)
})

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
