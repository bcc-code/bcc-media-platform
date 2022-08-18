<template>
    <div>
        <media-controller class="video-controller">
            <video id="viewer-video" slot="media">
            </video>
            <media-control-bar>
                <media-play-button></media-play-button>
                <media-mute-button></media-mute-button>
                <media-volume-range></media-volume-range>
                <media-time-range></media-time-range>
                <media-pip-button></media-pip-button>
                <media-fullscreen-button></media-fullscreen-button>
            </media-control-bar>
        </media-controller>
        <div>
            <v-button @click="load" :loading="loading">Load</v-button>
            <div v-if="error">
                <p style="color: red">{{error}}</p>
            </div>
        </div>
    </div>
</template>
<script lang="ts" setup>
import { ref, computed } from "vue"
import Hls from "hls.js"

const props = defineProps<{
    factory: () => Promise<{
        type: string;
        url: string;
    }>
}>()

const videoSrc = ref("")
const error = ref(null as string | null)
const loading = ref(false)
const type = ref("")

const isHLS = computed(() => {
    return type.value.includes("hls")
})

const load = async () => {
    error.value = null
    loading.value = true
    try {
        const config = await props.factory();
        type.value = config.type;
        videoSrc.value = config.url;
        if (!isHLS.value) {
            return
        }
        const el = document.getElementById("viewer-video") as HTMLVideoElement
        if (!el) {
            return
        }
        
        if (el.canPlayType("application/vnd.apple.mpegurl")) {
            el.src = config.url;
            console.log("running")
        } else {
            const hls = new Hls();
            hls.loadSource(config.url)
            hls.attachMedia(el)
            hls.on(Hls.Events.MANIFEST_PARSED, () => {
                el.play();
            })
        }

    } catch {
        error.value = "Couldn't retrieve from API"
    } finally {
        loading.value = false
    }
}
</script>
<style scoped>
#viewer-video {
    width: 100%;
}

.video-controller {
    width: 100%;
}
</style>