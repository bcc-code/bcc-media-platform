<template>
    <div class="relative">
        <Swiper
            :breakpoints="effectiveBreakpoints"
            :modules="modules"
            :lazy="true"
            :navigation="{
                enabled: true,
                prevEl: prev,
                nextEl: next,
            }"
        >
            <SwiperSlide v-for="i in item.items.items" class="relative">
                <slot :item="i"></slot>
            </SwiperSlide>
        </Swiper>
        <div
            class="absolute top-0 flex z-10 w-full h-full pointer-events-none justify-between"
        >
            <div
                ref="prev"
                class="pointer-events-auto my-auto ml-2 rounded-full bg-background opacity-80 cursor-pointer hover:opacity-100"
            >
                <img
                    src="/icons/utility/Medium/ChevronRight/Tint.svg"
                    class="h-16 w-16 rotate-180 stroke-white"
                />
            </div>
            <div
                ref="next"
                class="pointer-events-auto my-auto mr-2 rounded-full bg-background opacity-80 cursor-pointer hover:opacity-100"
            >
                <img
                    src="/icons/utility/Medium/ChevronRight/Tint.svg"
                    class="h-16 w-16 stroke-white"
                />
            </div>
        </div>
    </div>
</template>
<script lang="ts" setup>
import { Section } from "./types"
import { Navigation, Pagination, Lazy, SwiperOptions } from "swiper"
import { Swiper, SwiperSlide } from "swiper/vue"
import breakpoints from "./breakpoints"
import { computed, ref } from "vue"

const next = ref(null)
const prev = ref(null)

const props = defineProps<{
    item: Section & {
        __typename: "DefaultSection" | "PosterSection" | "FeaturedSection"
    }
    breakpoints?: {
        [width: number]: SwiperOptions
    }
}>()

const effectiveBreakpoints = computed(() => {
    return props.breakpoints ?? breakpoints(props.item.size)
})

const modules = [Navigation, Pagination, Lazy]
</script>
