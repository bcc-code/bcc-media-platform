<template>
    <Swiper :breakpoints="breakpoints" :slides-per-view="1" :space-between="20">
        <SwiperSlide v-for="item in items">
            <HeaderSectionItem
                @click="click(item)"
                class="cursor-pointer"
                :item="item"
            ></HeaderSectionItem>
        </SwiperSlide>
    </Swiper>
</template>
<script lang="ts" setup>
import { Swiper, SwiperSlide } from "swiper/vue"
import { SectionItem } from "./types"
import HeaderSectionItem from "./HeaderSectionItem.vue"
import { SwiperOptions } from "swiper";

defineProps<{
    items: SectionItem[]
    click: (item: SectionItem) => any
}>()

const breakpoints: SwiperOptions["breakpoints"] = {
    720: {
        slidesPerView: 1.5,
    },
    1200: {
        slidesPerView: 2,
        slidesPerGroup: 2,
    }
}
</script>
