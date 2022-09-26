<template>
    <div>
        <div>
            <Player v-if="asset" :asset="asset"></Player>
        </div>
        <!-- <media-controller class="video-controller" v-if="asset">
            
            <media-control-bar>
                <media-play-button></media-play-button>
                <media-mute-button></media-mute-button>
                <media-volume-range></media-volume-range>
                <media-time-range></media-time-range>
                <media-captions-button></media-captions-button>
                <media-pip-button></media-pip-button>
                <media-fullscreen-button></media-fullscreen-button>
            </media-control-bar>
        </media-controller> -->
        <div>
            <v-button @click="load" :loading="loading">Load</v-button>
            <div v-if="error">
                <p style="color: red">{{error}}</p>
            </div>
        </div>
    </div>
</template>
<script lang="ts" setup>
import { ref } from "vue"
import Player from "../player/Player.vue";

const props = defineProps<{
    factory: () => Promise<{
        type: string;
        url: string;
    }>
}>()

const asset = ref(null as {type: string, url: string} | null)

const error = ref(null as string | null)
const loading = ref(false)

const load = async () => {
    asset.value = null
    error.value = null
    loading.value = true
    try {
        asset.value = await props.factory();
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