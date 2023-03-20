<template>
    <div
        class="point-events-none h-full snap-start relative flex flex-col"
        :ref="(el) => (targetScrollEl = el as any)"
    >
        <div
            class="absolute bottom-0 text-left"
            style="padding-bottom: env(safe-area-inset-bottom)"
        >
            <div class="" style="width: 100%" data-swiper-parallax-y="0">
                <div class="relative" style="z-index: -300">
                    <img
                        src="https://static.bcc.media/images/pc23/camp_moment_v2.jpg"
                        class="select-none"
                        style="min-width: 100%"
                    />
                    <div
                        class="absolute left-0 top-0 bg-gradient-to-b from-white h-full opacity-75"
                        style="width: 100%"
                    ></div>
                </div>
            </div>
            <p class="px-16 mb-16 mt-4 text-xl" data-swiper-parallax-y="-100">
                <span class="bg-[#FEECD0] bg-opacity-0"
                    >Når du er på camp, ikke vær som fariseerne som var stolte
                    og ikke mottagelige for det som Jesus ville si til
                    dem,</span
                >
            </p>
        </div>
    </div>
</template>

<script lang="ts" setup>
import { ref } from "vue"
import SotmShapeLong from "./SotmShapeLong.vue"
import Parallax from "./Parallax.vue"

const targetScrollEl = ref<Element | null>(null)

const animate = (ratio: number) => (diff: number) => {
    console.log(diff)
    return `transform: translate(0, ${-diff * ratio}px);`
}
</script>

<style scoped>
.gradient-overlay {
    background: linear-gradient(
        rgba(255, 255, 255, 0.4),
        rgba(255, 255, 255, 0)
    );
    height: 100%;
}
</style>
