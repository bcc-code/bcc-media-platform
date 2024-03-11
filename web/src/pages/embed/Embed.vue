<template>
    <div class="h-screen embedded-pag">
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
import { useGetMeQuery } from "@/graph/generated"
import { analytics } from "@/services/analytics"

const initializing = ref(true)

if (!!router.currentRoute.value.query["bg"]) {
    document.body.style.setProperty("--tw-bg-opacity", "1")
}

const analyticsQuery = useGetMeQuery({
    pause: true,
})

onMounted(async () => {
    console.time("embedInit")
    const flutterLocale = await webViewMain?.getLocale()
    if (flutterLocale) {
        settings.locale = flutterLocale
    }
    await init()

    await analytics.initialize(async () => {
        let analyticsId: string | null = null
        const result = await analyticsQuery.executeQuery()
        if (result.data.value?.me.analytics.anonymousId) {
            analyticsId = result.data.value.me.analytics.anonymousId
        }
        return analyticsId
    })

    console.timeEnd("embedInit")
    initializing.value = false
})
</script>

<style>
.bg-background {
    --tw-bg-opacity: 0;
}
</style>
