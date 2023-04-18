<template>
    <div v-if="!err" id="live-video-player"></div>
    <div v-if="err" class="w-full h-full text-center text-xl">{{ err }}</div>
</template>
<script lang="ts" setup>
import { useGetMeQuery } from "@/graph/generated"
import Auth from "@/services/auth"
import { languageTo3letter } from "@/utils/languages"
import { createPlayer, Player } from "bccm-video-player"
import "bccm-video-player/css"
import { onMounted, onUnmounted, ref } from "vue"
import { useRoute } from "vue-router"
import { current as currentLanguage } from "@/services/language"
import { getSessionId } from "rudder-sdk-js"

const err = ref(null as string | null)

let player: Player | null = null

const route = useRoute()

const { data, executeQuery } = useGetMeQuery()

const onSpaceBar = (event: KeyboardEvent) => {
    if (event.type === "keydown") {
        if (event.key === " ") {
            event.preventDefault()

            if (!player) return

            if (player.paused()) {
                player.play()
            } else {
                player.pause()
            }
        }
    }
}

onMounted(async () => {
    const fullPath = route.fullPath

    const res = await fetch(
        "https://livestreamfunctions.brunstad.tv/api/urls/live",
        {
            method: "GET",
            headers: {
                Authorization: `Bearer ${await Auth.getToken()}`,
            },
        }
    ).catch(() => {
        err.value = "Failed to open livestream"
    })
    if (!res) {
        return
    }
    if (fullPath != route.fullPath) {
        console.log("Route has changed, canceling create player")
        return
    }

    if (!data.value) {
        await executeQuery()
    }

    const body = await res.json()
    const url = body.url

    player = await createPlayer("live-video-player", {
        src: {
            src: url,
        },
        languagePreferenceDefaults: {
            audio: languageTo3letter(currentLanguage.value.code),
            subtitles: languageTo3letter(currentLanguage.value.code),
        },
        autoplay: true,
        videojs: {
            autoplay: true,
        },
        npaw: {
            enabled: !!import.meta.env.VITE_NPAW_ACCOUNT_CODE,
            accountCode: import.meta.env.VITE_NPAW_ACCOUNT_CODE,
            tracking: {
                isLive: true,
                userId: data.value?.me.analytics.anonymousId ?? "anonymous",
                sessionId: getSessionId()?.toString() ?? undefined,
                metadata: {},
            },
        },
    })

    window.addEventListener("keydown", onSpaceBar)
})

onUnmounted(() => {
    player?.dispose()
    window.removeEventListener("keydown", onSpaceBar)
})
</script>
