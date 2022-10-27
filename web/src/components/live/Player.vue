<template>
    <div id="live-video-player"></div>
</template>
<script lang="ts" setup>
import Auth from "@/services/auth"
import { createPlayer } from "bccm-video-player"
import "bccm-video-player/css"
import { onUnmounted } from "vue"

;(async () => {
    const player = await createPlayer("live-video-player", {
        src: {
            src: await fetch(
                "https://livestreamfunctions.brunstad.tv/api/urls/live",
                {
                    method: "GET",
                    headers: {
                        Authorization: `Bearer ${await Auth.getToken()}`,
                    },
                }
            )
                .then((r) => r.json())
                .then((r) => r.url),
        },
    })

    onUnmounted(() => player.dispose())
})()
</script>
