<template>
    <video id="video-player"></video>
</template>
<script lang="ts" setup>
import Hls from "hls.js"
import Dash from "dashjs"
import { onMounted, watch } from "vue";

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
    switch (props.asset.type) {
        case "hls_cmaf":
        case "hls_ts":
            if (Hls.isSupported()) {
                const hls = new Hls()
                hls.loadSource(props.asset.url)
                hls.attachMedia(video)
                // Autoplay on load
                hls.on(Hls.Events.MANIFEST_LOADED, () => {
                    video.play()
                })
            }
        case "dash":
            if (Dash.supportsMediaSource()) {
                const player = Dash.MediaPlayer().create();
                player.initialize(video, props.asset.url, true)
            }
    }
}

onMounted(load)
watch(() => props.asset, load)
</script>