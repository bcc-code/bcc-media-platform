<template>
    <div v-if="!err" id="live-video-player"></div>
    <div v-if="err" class="w-full h-full text-center text-xl">{{ err }}</div>
</template>
<script lang="ts" setup>
import Auth from "@/services/auth"
import { createPlayer, Player } from "bccm-video-player"
import "bccm-video-player/css"
import { onUnmounted, ref } from "vue"

const err = ref(null as string | null)

let player: Player | null = null

;(async () => {
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
    const body = await res.json()
    const url = body.url

    player = await createPlayer("live-video-player", {
        src: {
            src: url,
        },
    })

})()

onUnmounted(() => player?.dispose())
</script>
