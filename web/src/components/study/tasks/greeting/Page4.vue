<template>
    <div
        class="point-events-none mt-24 h-screen snap-start relative flex flex-col"
        :ref="(el) => (targetScrollEl = el as any)"
    >
        <template v-if="targetScrollEl != null">
            <div class="mt-24 px-16 text-left absolute bottom-[15%]">
                <Parallax
                    :parentScrollEl="parentScrollEl"
                    :targetScrollEl="targetScrollEl!"
                    :scrollHandler="animate(-0.7)"
                >
                    <p class="mt-3 text-2xl">
                        <span class="bg-[#FEECD0] bg-opacity-0"
                            >Når du er på camp, ikke vær som fariseerne som var
                            stolte og ikke mottagelige for det som Jesus ville
                            si til dem,</span
                        >
                    </p>
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
