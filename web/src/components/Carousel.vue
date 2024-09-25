<script lang="ts" setup generic="TSliderItem extends { id: string }">
import { SectionSize } from '@/graph/generated'
import TSwiper from 'swiper'
import { Navigation, Pagination } from 'swiper/modules'
import type { SwiperOptions } from 'swiper/types'
import { Swiper, SwiperSlide } from 'swiper/vue'
import { computed, ref } from 'vue'
import Breakpoints from './sections/item/breakpoints'

const swiperEl = ref(null as HTMLDivElement | null)

const next = ref(null)
const prev = ref(null)

const showNav = ref(false)

const props = withDefaults(
    defineProps<{
        items: TSliderItem[]
        size?: SectionSize
        breakpoints?: {
            [width: number]: SwiperOptions
        }
        isLoadingMore?: boolean
    }>(),
    {
        size: SectionSize.Medium,
    }
)

const emit = defineEmits<{
    (e: 'loadMore'): void
}>()

const effectiveBreakpoints = computed(() => {
    return props.breakpoints ?? Breakpoints(props.size)
})

const modules = [Navigation, Pagination]

const onswipe = (swiper: TSwiper) => {
    swiper.on('progress', () => {
        const bp =
            swiper.currentBreakpoint == 'max'
                ? Object.values(effectiveBreakpoints.value)[0]
                : effectiveBreakpoints.value[swiper.currentBreakpoint]
        if (!bp) {
            if (swiper.progress > 0.5) {
                emit('loadMore')
            }
        }
        // Check when the slide should be updated with new items.
        const pg =
            1 - (((bp.slidesPerView as any) ?? 1) + 1) / props.items.length
        if (swiper.progress > pg) {
            emit('loadMore')
        }
    })
}
</script>

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
                v-for="(item, index) in items"
                :key="item.id"
                class="relative"
            >
                <slot :item="item" :index="index" />
                <div
                    v-if="index === items.length - 1 && isLoadingMore"
                    class="absolute right-0 top-0 h-full flex bg-gradient-to-l from-background to-transparent w-40"
                />
            </SwiperSlide>
            <SwiperSlide v-if="$slots.end" class="relative">
                <slot name="end" />
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
