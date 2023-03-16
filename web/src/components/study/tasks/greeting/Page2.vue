<template>
    <div
        class="w-full h-screen point-events-none flex items-center relative"
        :ref="(el) => (targetScrollEl = el as any)"
    >
        <template v-if="targetScrollEl != null">
            <div class="py-8 px-16 text-left">
                <p class="mt-3 text-2xl" data-swiper-parallax-y="-2000">
                    <span class="bg-[#FEECD0] bg-opacity-75"
                        >Du kan glede deg til noen innholdsrike dager full av
                        samfunn, oppbyggelse og trivsel. Denne campen er
                        høydepunktet og selve avslutningen for prosjektet om
                        Bergprekenen som du også har vært med på.</span
                    >
                </p>
            </div>
            <div
                class="absolute right-[-25vw] top-[120px] -z-50"
                style="width: 70vw"
            >
                <SotmShapeLong
                    color="#B16B35"
                    style="transform: rotate(-30deg)"
                >
                </SotmShapeLong>
            </div>
            <div class="absolute right-[-40vw] top-[0]" style="width: 70vw">
                <SotmShapeLong
                    color="#536C5B"
                    style="transform: rotate(-30deg)"
                >
                </SotmShapeLong>
            </div>
            <div
                class="absolute left-[-25vw] bottom-[120px] -z-50"
                style="width: 70vw"
            >
                <SotmShapeLong
                    color="#B16B35"
                    style="transform: rotate(-210deg)"
                >
                </SotmShapeLong>
            </div>
            <div class="absolute left-[-40vw] bottom-[0]" style="width: 70vw">
                <SotmShapeLong
                    color="#536C5B"
                    style="transform: rotate(-210deg)"
                >
                </SotmShapeLong>
            </div>
        </template>
    </div>
</template>

<script lang="ts" setup>
import { ref } from "vue"
import SotmShapeLong from "./SotmShapeLong.vue"
import Parallax from "./Parallax.vue"

const props = defineProps<{ parentScrollEl: Element }>()

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
