<template>
    <div>
        <media-controller>
            <video slot="media" :src="videoSrc">
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

const props = defineProps<{
    factory: () => Promise<string>
}>()

const videoSrc = ref("")
const error = ref(null as string | null)
const loading = ref(false)

const load = async () => {
    error.value = null
    loading.value = true
    try {
        videoSrc.value = await props.factory();
    } catch {
        error.value = "Couldn't retrieve from API"
    }
    loading.value = false
}
</script>