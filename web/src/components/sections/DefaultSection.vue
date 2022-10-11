<template>
    <section>
        <SectionTitle v-if="item.title">{{item.title}}</SectionTitle>
        <Swiper 
            :slides-per-view="4"
            :breakpoints="options"
            :modules="modules"
        >
            <SwiperSlide
                v-for="i in item.items.items"
                class="flex flex-col h-full aspect-video rounded rounded-md"
            >
                <div class="rounded-md top-0 h-full w-full bg-cover bg-no-repeat" :style="{
                    'background-image': `url(${i.image}?h=400)`
                }">
                    
                </div>
                <div class="">
                    <h3 class="text-xs text-primary w-full">Show title<span class="ml-1 text-gray">10.0.0</span></h3>
                    <h1 :class="style.title">
                        {{ i.title }}
                    </h1>
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
    item: Section & { __typename: "DefaultSection" }
}>()

const modules = [ Navigation, Pagination]

const style = computed(() => {
    return {
        small: {
            title: "text-md lg:text-lg"
        },
        medium: {
            title: "text-sm lg:text-lg"
        }
    }[props.item.size]
})

const options = computed(() => {
    switch (props.item.size) {
        case "small":
            return {
                0: {
                    slidesPerView: 3.5,
                    spaceBetween: 4,
                },
                1280: {
                    slidesPerView: 6,
                    spaceBetween: 4,
                },
                1920: {
                    slidesPerView: 9,
                    spaceBetween: 4,
                }
            } as {
                [key: number]: SwiperOptions
            }
        case "medium":
            return {
                0: {
                    slidesPerView: 2.5,
                    spaceBetween: 4,
                },
                1280: {
                    slidesPerView: 4,
                    spaceBetween: 4,
                },
                1920: {
                    slidesPerView: 6,
                    spaceBetween: 4,
                }
            } as {
                [key: number]: SwiperOptions
            }
    }
})
</script>
