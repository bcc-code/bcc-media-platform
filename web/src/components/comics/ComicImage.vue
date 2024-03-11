<script setup lang="ts">
import { computed, ref } from "vue"
import Loader from "../Loader.vue"
import { useTimestamp } from "@vueuse/core"

defineProps<{
    url: string
}>()

function imageUrl(image: string) {
    return `${image}?w=${window.innerWidth}px&fm=jpg&auto=format`
}

const loaded = ref(false)
const time = useTimestamp({ interval: 100 })
const started = time.value
const loadingForALongTime = computed(() => {
    return !loaded && time.value - started > 1000
})

function onLoad() {
    loaded.value = true
}
</script>

<template>
    <div class="w-full relative">
        <img
            :src="imageUrl(url)"
            alt="Comic page"
            :onload="onLoad"
            class="mx-auto transition-opacity duration-[4s] ease-out-expo min-h-screen"
            :class="{ 'opacity-100': loaded, 'opacity-0': !loaded }"
        />
        <div
            class="absolute top-0 left-0 flex items-center justify-center bg-background-1 w-full h-screen ease-out-expo transition-opacity duration-500"
            :class="{
                'opacity-0': loaded,
                'opacity-100': !loaded,
            }"
        >
            <Loader variant="spinner" />
        </div>
    </div>
</template>
