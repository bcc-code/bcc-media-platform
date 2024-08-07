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
            <SwiperSlide
                v-for="(i, index) in section.items.items"
                class="relative"
            >
                <slot :item="i" :index="index"></slot>
                <div
                    class="absolute right-0 top-0 h-full flex bg-gradient-to-l from-background to-transparent w-40"
                    v-if="
                        index === section.items.items.length - 1 &&
                        section.items.total >
                            section.items.offset + section.items.first
                    "
                ></div>
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
import TSwiper from "swiper"
import type { SwiperOptions } from "swiper/types"
import { Navigation, Pagination } from "swiper/modules"
import { Swiper, SwiperSlide } from "swiper/vue"
import breakpoints from "./breakpoints"
import { computed, ref } from "vue"
import { SectionSize } from "@/graph/generated"

const swiperEl = ref(null as HTMLDivElement | null)

const next = ref(null)
const prev = ref(null)

const showNav = ref(false)

const props = defineProps<{
    section: Section & {
        __typename:
            | "DefaultSection"
            | "PosterSection"
            | "FeaturedSection"
            | "ListSection"
    }
    breakpoints?: {
        [width: number]: SwiperOptions
    }
}>()

const emit = defineEmits<{
    (e: "loadMore"): void
}>()

const size = computed<SectionSize>(() => {
    return "size" in props.section ? props.section.size : SectionSize.Medium
})

const effectiveBreakpoints = computed(() => {
    return props.breakpoints ?? breakpoints(size.value)
})

const modules = [Navigation, Pagination]

const onswipe = (swiper: TSwiper) => {
    swiper.on("progress", () => {
        const bp =
            swiper.currentBreakpoint == "max"
                ? Object.values(effectiveBreakpoints.value)[0]
                : effectiveBreakpoints.value[swiper.currentBreakpoint]
        if (!bp) {
            if (swiper.progress > 0.5) {
                emit("loadMore")
            }
        }
        // Check when the slide should be updated with new items.
        const pg =
            1 -
            (((bp.slidesPerView as any) ?? 1) + 1) /
                props.section.items.items.length
        if (swiper.progress > pg) {
            emit("loadMore")
        }
    })
}
</script>
