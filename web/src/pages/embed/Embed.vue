<template>
    <div class="h-screen">
        <router-view v-slot="{ Component }">
            <transition name="slide-fade" mode="out-in">
                <component :key="$route.name" :is="Component" />
            </transition>
        </router-view>
    </div>
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
/* Hide scrollbar for Chrome, Safari and Opera */
.embed-hide-scrollbar::-webkit-scrollbar {
    display: none;
}

/* Hide scrollbar for IE, Edge and Firefox */
.embed-hide-scrollbar {
    -ms-overflow-style: none; /* IE and Edge */
    scrollbar-width: none; /* Firefox */
}
</style>
