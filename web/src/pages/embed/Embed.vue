<template>
    <router-view v-slot="{ Component }">
        <transition name="slide-fade" mode="out-in">
            <component :key="$route.name" :is="Component" />
        </transition>
    </router-view>
</template>
<script lang="ts" setup>
import router from "@/router"

if (!!router.currentRoute.value.query["bg"]) {
    document.body.style.setProperty("--tw-bg-opacity", "1")
}
</script>

<style>
.bg-background {
    --tw-bg-opacity: 0;
}
</style>
