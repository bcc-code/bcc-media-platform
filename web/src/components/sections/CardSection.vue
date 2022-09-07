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
                <CardSectionItem
                    class="cursor-pointer transition hover:-translate-y-1 mt-1"
                    :item="item"
                    @click="click(item)"
                ></CardSectionItem>
            </SwiperSlide>
        </Swiper>
    </div>
</template>
<script lang="ts" setup>
import { Swiper, SwiperSlide } from "swiper/vue"
import { Section, SectionItem as TSectionItem } from "./types"
import { Navigation } from "swiper"
import CardSectionItem from "./CardSectionItem.vue";

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
        slidesPerView: 2,
        spaceBetween: 15,
        slidesPerGroup: 2,
    },
    // when window width is >= 640px
    640: {
        slidesPerView: 3,
        spaceBetween: 20,
        slidesPerGroup: 3,
    },
    1200: {
        slidesPerView: 6,
        spaceBetween: 20,
        slidesPerGroup: 6,
    }
}
</script>
