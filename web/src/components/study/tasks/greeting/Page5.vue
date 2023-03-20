<template>
    <div
        class="point-events-none h-full snap-start relative flex flex-col"
        :ref="(el) => (targetScrollEl = el as any)"
    >
        <div
            class="text-left w-full"
            style="padding-bottom: env(safe-area-inset-bottom)"
        >
            <div
                class="mt-16 w-full lg:w-1/2 mx-auto"
                data-swiper-parallax-y="0"
            >
                <div class="relative">
                    <video
                        autoplay
                        loop
                        muted
                        playsinline
                        src="https://static.bcc.media/images/pc23/sotm-clip-v7.mp4"
                        class="select-none"
                        style="
                            min-width: 150%;
                            margin-left: 30%;
                            transform: translateX(-30%);
                        "
                    ></video>
                    <div
                        class="w-full absolute left-0 bottom-0 bg-gradient-to-t from-white h-1/2 opacity-50 z-50"
                        style="-webkit-transform: translateZ(1px)"
                    ></div>
                </div>
            </div>
            <p class="px-8 mb-16 mt-8 text-xl" data-swiper-parallax-y="-150">
                <span class="bg-[#FEECD0] bg-opacity-0"
                    >men vær fattig i ånden for å kunne eie himlenes rike og få
                    et evig liv med ham.<br /><br />
                    Da vil trangen til å bli mer og mer mesteren lik bli oppfylt
                    i livet ditt.</span
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
