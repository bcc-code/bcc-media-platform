<script lang="ts" setup>
import Carousel from "@/components/Carousel.vue"
import { SectionSize } from "@/graph/generated"
import type { SwiperOptions } from "swiper/types"
import { computed } from "vue"
import { Section } from "../types"

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

const size = computed(() =>
    "size" in props.section ? props.section.size : SectionSize.Medium
)

const isNotLastPage = computed(() => {
    return (
        props.section.items.total >
        props.section.items.offset + props.section.items.first
    )
})
</script>

<template>
    <Carousel
        :items="section.items.items"
        :offset="section.items.offset"
        :is-loading-more="isNotLastPage"
        :size="size"
        :breakpoints="props.breakpoints"
        @load-more="emit('loadMore')"
        v-slot="{ item, index }"
    >
        <slot :item="item" :index="index" />
    </Carousel>
</template>
