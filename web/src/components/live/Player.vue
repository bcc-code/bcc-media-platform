<template>
    <div id="live-video-player"></div>
</template>
<script lang="ts" setup>
import Auth from "@/services/auth";
import { createPlayer } from "bccm-video-player"
import { onUnmounted } from "vue";

const result = await fetch("https://livestreamfunctions.brunstad.tv/api/urls/live", {
    method: "GET",
    cache: "no-cache",
    headers: {
        "Authorization": `Bearer ${await Auth.getToken()}`,
    }});

const json = await result.json();

console.log(json);

// const player = await createPlayer("live-video-player", {src: {
//     src: await (fetch("https://livestreamfunctions.brunstad.tv/api/urls/live", {method: "GET", headers: {
//         "Authorization": `Bearer ${await Auth.getToken()}`,
//     }})).then(r => r.json()).then(r => r.url)
// }})

// onUnmounted(() => player.dispose())
</script>