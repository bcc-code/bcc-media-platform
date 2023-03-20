<template>
    <div
        class="w-full h-full point-events-none flex flex-col justify-center items-center relative"
        style="padding-bottom: env(safe-area-inset-bottom)"
        :ref="(el) => (targetScrollEl = el as any)"
    >
        <div class="py-8 px-12 text-left">
            <p class="mt-3 text-xl" data-swiper-parallax-y="-200">
                <span class="bg-[#FEECD0] bg-opacity-75">
                    Salige er de som hungrer og tørster efter rettferdighet; for
                    de skal mettes.
                </span>
            </p>
            <p class="mt-3 text-xl" data-swiper-parallax-y="-200">
                <span class="bg-[#FEECD0] bg-opacity-75"> Matteus 5:6 </span>
            </p>
        </div>
        <div class="h-24">&nbsp;</div>
        <!-- <div
                class="absolute right-[-25vw] top-[120px] -z-50"
                style="width: 70vw"
            >
                <SotmShapeLong
                    color="#B16B35"
                    style="transform: rotate(-30deg)"
                >
                </SotmShapeLong>
            </div>
            <div
                class="absolute right-[-40vw] top-[0] -z-10"
                style="width: 70vw"
            >
                <SotmShapeLong
                    color="#536C5B"
                    style="transform: rotate(-30deg)"
                >
                </SotmShapeLong>
            </div> -->
        <div
            class="absolute left-[-25%] bottom-[80px] -z-50"
            data-swiper-parallax-y="-50"
            style="width: 60%"
        >
            <SotmShapeLong color="#B16B35" style="transform: rotate(-222deg)">
            </SotmShapeLong>
        </div>
        <div
            class="absolute left-[-35%] bottom-[-20px] -z-10"
            data-swiper-parallax-y="-100"
            style="width: 58%"
        >
            <SotmShapeLong color="#536C5B" style="transform: rotate(-222deg)">
            </SotmShapeLong>
        </div>
    </div>
</template>

<script lang="ts" setup>
import { ref } from "vue"
import SotmShapeLong from "./SotmShapeLong.vue"
import Parallax from "./Parallax.vue"

const targetScrollEl = ref<Element | null>(null)

const animate = (ratio: number) => (diff: number) => {
    console.log(`animate ${diff} ${window.innerHeight}`)
    let y = -diff * ratio
    if (diff < 0) {
        y = -diff * (ratio * 10)
    }
    return `transform: translate(0, ${y}px);`
}
</script>
