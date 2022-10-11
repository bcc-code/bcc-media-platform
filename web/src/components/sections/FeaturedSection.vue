<template>
    <section>
        <SectionTitle v-if="item.title">{{item.title}}</SectionTitle>
        <Swiper
            :breakpoints="options"
            :modules="modules"
            :navigation="true"
        >
            <SwiperSlide
                v-for="i in item.items.items"
                class="relative h-full aspect-[4/3]"
            >
                <img 
                    v-if="i.image"
                    :src="i.image + '?h=1080'"
                    class="rounded rounded-xl h-full object-cover"
                />
                <div class="absolute rounded rounded-xl z-10 top-0 bg-gradient-to-t from-black via-transparent to-transparent h-full w-full opacity-100">
                    
                </div>
                <div class="absolute z-20 bottom-0 p-4 w-full text-center">
                    <h1 class="text-2xl font-bold mx-auto">
                        {{ i.title }}
                    </h1>
                    <p class="opacity-80">What does it mean!?</p>
                </div>
            </SwiperSlide>
        </Swiper>
    </section>
</template>
<script lang="ts" setup>
import { Section } from "./types"

import { Navigation, Pagination, SwiperOptions } from "swiper"

import "swiper/css";

import "swiper/css/pagination";
import "swiper/css/navigation";

import { Swiper, SwiperSlide } from "swiper/vue"
import { computed } from "vue";
import SectionTitle from "./SectionTitle.vue";

const props = defineProps<{
    item: Section & { __typename: "FeaturedSection" }
}>()

const modules = [ Navigation, Pagination]

const options = computed(() => {
    switch (props.item.size) {
        case "small":
            return {
                400: {
                    slidesPerView: 2,
                    spaceBetween: 4,
                },
                1280: {
                    slidesPerView: 3,
                    spaceBetween: 4,
                },
                1920: {
                    slidesPerView: 4,
                    spaceBetween: 4,
                }
            } as {
                [key: number]: SwiperOptions
            }
        case "medium":
            return {
                400: {
                    slidesPerView: 1,
                    spaceBetween: 4,
                },
                1280: {
                    slidesPerView: 1.5,
                    spaceBetween: 4,
                },
                1920: {
                    slidesPerView: 2,
                    spaceBetween: 4,
                }
            } as {
                [key: number]: SwiperOptions
            }
    }
})
</script>
