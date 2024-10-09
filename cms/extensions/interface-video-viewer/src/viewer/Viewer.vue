<template>
    <div>
        <div>
            <Player v-if="asset" :asset="asset"></Player>
        </div>
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
        console.log(asset.value)
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