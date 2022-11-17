<template>
    <div class="relative">
        <Swiper
            :breakpoints="effectiveBreakpoints"
            :modules="modules"
            :lazy="true"
            :navigation="true"
        >
            <SwiperSlide v-for="i in item.items.items" class="relative">
                <slot :item="i"></slot>
            </SwiperSlide>
        </Swiper>
    </div>
</template>
<script lang="ts" setup>
import { Section } from "./types"
import { Navigation, Pagination, Lazy, SwiperOptions } from "swiper"
import { Swiper, SwiperSlide } from "swiper/vue"
import breakpoints from "./breakpoints"
import { computed } from "vue"

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
