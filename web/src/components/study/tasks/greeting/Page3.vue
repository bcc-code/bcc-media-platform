<template>
    <div
        class="point-events-none h-screen snap-start relative flex flex-col"
        :ref="(el) => (targetScrollEl = el as any)"
    >
        <template v-if="targetScrollEl != null">
            <div class="mt-24 px-16 text-left">
                <Parallax
                    :parentScrollEl="parentScrollEl"
                    :targetScrollEl="targetScrollEl!"
                    :scrollHandler="animate(-0.7)"
                >
                    <p class="mt-3 text-2xl">
                        <span class="bg-[#FEECD0] bg-opacity-0"
                            >Du har gjennom de siste ukene fått lys om hvordan
                            du kan bygge ditt liv på fjell og har fått et
                            tydelig bilde av hva som kreves av deg for å være en
                            sann disippel.</span
                        >
                    </p>
                </Parallax>
            </div>
            <div
                class="relative left-0 top-[-100px] -z-50"
                style="width: 100vw"
            >
                <Parallax
                    :parentScrollEl="parentScrollEl"
                    :targetScrollEl="targetScrollEl!"
                    :scrollHandler="animateBg(0.7)"
                    class="transition-opacity duration-300"
                >
                    <div class="relative">
                        <img
                            src="https://static.bcc.media/images/pc23/camp_moment.jpg"
                            class="select-none"
                            style="min-width: 100%"
                        />
                        <div
                            class="absolute left-0 top-0 bg-gradient-to-b from-white h-full opacity-75"
                            style="width: 100vw"
                        ></div>
                    </div>
                </Parallax>
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
    return `transform: translate(0, ${-diff * ratio}px);`
}

const animateBg = (ratio: number) => (diff: number) => {
    console.log(`animateBg ${diff} ${window.innerHeight}`)
    let y = -diff * ratio
    let style = `transform: translate(0, ${y}px);`
    if (diff > 1000) {
        style += `opacity: 0`
    } else {
        style += `opacity: 1`
    }
    return style
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
