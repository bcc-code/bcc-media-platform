<template>
    <div id="video-player"></div>
</template>
<script lang="ts" setup>
// import Hls from "hls.js"
// import Dash from "dashjs"
import { onMounted, watch } from "vue";
import { createPlayer } from "bccm-video-player"

const props = defineProps<{
    asset: {
        url: string;
        type: string;
    }
}>()

const load = () => {
    const video = document.getElementById("video-player") as HTMLVideoElement;
    if (!video) {
        return
    }

    createPlayer(video.id, {
        src: {
            src: props.asset.url
        }
    })
}

onMounted(load)
watch(() => props.asset, load)
</script>