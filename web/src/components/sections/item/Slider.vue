<template>
    <div
        class="relative"
        @mouseenter="showNav = true"
        @mouseleave="showNav = false"
    >
        <Swiper
            ref="swiperEl"
            style="overflow: visible"
            :breakpoints="effectiveBreakpoints"
            :modules="modules"
            :lazy="true"
            :navigation="{
                enabled: true,
                prevEl: prev,
                nextEl: next,
            }"
            @swiper="onswipe"
        >
            <SwiperSlide v-for="i in item.items.items" class="relative">
                <slot :item="i"></slot>
            </SwiperSlide>
        </Swiper>
        <div
            class="absolute top-0 z-10 w-full h-full pointer-events-none justify-between hidden lg:flex transition"
            :class="[showNav ? 'opacity-100' : 'opacity-0']"
        >
            <div class="w-1/3 h-full flex">
                <div
                    ref="prev"
                    class="pointer-events-auto my-auto ml-2 rounded-full bg-background opacity-80 cursor-pointer hover:opacity-100 transition"
                >
                    <img
                        src="/icons/utility/Medium/ChevronRight/Tint.svg"
                        class="h-16 w-16 rotate-180 stroke-white"
                    />
                </div>
            </div>
            <div class="ml-auto w-1/3 h-full flex">
                <div
                    ref="next"
                    class="pointer-events-auto my-auto ml-auto mr-2 rounded-full bg-background opacity-80 cursor-pointer hover:opacity-100 transition"
                >
                    <img
                        src="/icons/utility/Medium/ChevronRight/Tint.svg"
                        class="h-16 w-16 stroke-white"
                    />
                </div>
            </div>
        </div>
    </div>
</template>
<script lang="ts" setup>
import { Section } from "../types"
import TSwiper, { Navigation, Pagination, Lazy, SwiperOptions } from "swiper"
import { Swiper, SwiperSlide } from "swiper/vue"
import breakpoints from "./breakpoints"
import { computed, onMounted, ref } from "vue"

const swiperEl = ref(null as HTMLDivElement | null)

const next = ref(null)
const prev = ref(null)

const showNav = ref(false)

const props = defineProps<{
    item: Section & {
        __typename: "DefaultSection" | "PosterSection" | "FeaturedSection"
    }
    breakpoints?: {
        [width: number]: SwiperOptions
    }
}>()

const emit = defineEmits<{
    (e: "loadMore"): void
}>()

const effectiveBreakpoints = computed(() => {
    return props.breakpoints ?? breakpoints(props.item.size)
})

const modules = [Navigation, Pagination, Lazy]

const onswipe = (swiper: TSwiper) => {
    swiper.on("progress", () => {
        if (swiper.progress > 0.9) {
            emit("loadMore")
        }
    })
}
</script>
