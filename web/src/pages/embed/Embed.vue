<template>
    <div class="h-screen embedded-page">
        <div
            v-if="initializing"
            class="flex h-full items-center justify-center"
        >
            <div class="m-auto"><Loader variant="spinner"></Loader></div>
        </div>
        <router-view v-else v-slot="{ Component }">
            <transition name="slide-fade" mode="out-in">
                <component :key="$route.name" :is="Component" />
            </transition>
        </router-view>
    </div>
</template>
<script lang="ts" setup>
import router from "@/router"
import settings from "@/services/settings"
import { webViewMain } from "@/services/webviews/mainHandler"
import { onMounted, ref } from "vue"
import { init } from "@/services/language"
import Loader from "@/components/Loader.vue"

const initializing = ref(true)

if (!!router.currentRoute.value.query["bg"]) {
    document.body.style.setProperty("--tw-bg-opacity", "1")
}
onMounted(async () => {
    const flutterLocale = await webViewMain?.getLocale()
    console.time("embedInitLocale")
    if (flutterLocale) {
        settings.locale = flutterLocale
    }
    await init()
    console.timeEnd("embedInitLocale")
    initializing.value = false
})
</script>

<style>
.bg-background {
    --tw-bg-opacity: 0;
}
</style>
@/services/webviews/mainHandler
