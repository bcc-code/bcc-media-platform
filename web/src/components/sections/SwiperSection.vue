<template>
    <div>
        <h1 class="text-xl">{{ section.title }}</h1>
        <Swiper
            :slides-per-view="1"
            :space-between="10"
            :slides-per-group="1"
            :modules="modules"
            :breakpoints="breakpoints"
            navigation
        >
            <SwiperSlide v-for="item in section.items.items">
                <SectionItem
                    class="cursor-pointer transition hover:-translate-y-1"
                    :item="item"
                    @click="click(item)"
                ></SectionItem>
            </SwiperSlide>
        </Swiper>
    </div>
</template>
<script lang="ts" setup>
import { Swiper, SwiperSlide } from "swiper/vue"
import { Section, SectionItem as TSectionItem } from "./types"
import SectionItem from "./SectionItem.vue"
import { Navigation } from "swiper"

defineProps<{
    section: Section
    click: (item: TSectionItem) => any
}>()

const modules = [Navigation]

const breakpoints = {
    // when window width is >= 320px
    320: {
        slidesPerView: 2,
        spaceBetween: 10,
        slidesPerGroup: 2,
    },
    // when window width is >= 480px
    480: {
        slidesPerView: 3,
        spaceBetween: 15,
        slidesPerGroup: 3,
    },
    // when window width is >= 640px
    640: {
        slidesPerView: 4,
        spaceBetween: 20,
        slidesPerGroup: 4,
    },
    1200: {
        slidesPerView: 8,
        spaceBetween: 20,
        slidesPerGroup: 8,
    }
}
</script>
