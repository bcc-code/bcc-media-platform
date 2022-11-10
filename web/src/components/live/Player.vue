<template>
    <div v-if="!err" id="live-video-player"></div>
    <div v-if="err" class="w-full h-full text-center text-xl">{{ err }}</div>
</template>
<script lang="ts" setup>
import Auth from "@/services/auth"
import { createPlayer, Player } from "bccm-video-player"
import "bccm-video-player/css"
import { onMounted, onUnmounted, ref } from "vue"
import { useRoute } from "vue-router";

const err = ref(null as string | null)

let player: Player | null = null

const route = useRoute()

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

    const body = await res.json()
    const url = body.url

    player = await createPlayer("live-video-player", {
        src: {
            src: url,
        },
        autoplay: true,
        videojs: {
            autoplay: true,
        },
    })
})

onUnmounted(() => player?.dispose())
</script>
