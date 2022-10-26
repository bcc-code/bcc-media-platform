<template>
    <section>
        <SectionTitle v-if="item.title">{{ item.title }}</SectionTitle>
        <Swiper :breakpoints="options" :modules="modules" :navigation="true">
            <SwiperSlide
                v-for="i in item.items.items"
                class="h-full aspect-[4/3] md:aspect-video"
                @click="goToSectionItem(i)"
            >
                <div class="relative h-full">
                    <img
                        v-if="i.image"
                        :src="i.image + '?h=1080'"
                        class="rounded rounded-xl h-full object-cover"
                    />
                    <div
                        class="absolute bottom-0 w-full text-center bg-gradient-to-t from-background to-transparent p- pt-8"
                    >
                        <h1 class="text-2xl font-bold">
                            {{ i.title }}
                        </h1>
                        <p
                            v-if="i.description"
                            class="opacity-80 truncate px-8"
                        >
                            {{ i.description }}
                        </p>
                    </div>
                </div>
                <div class="text-center mt-2">
                    <button
                        class="bg-slate-800 px-4 py-1 rounded-full font-bold text-lg flex mx-auto"
                    >
                        <Play></Play><span class="ml-1">Watch now</span>
                    </button>
                </div>
            </SwiperSlide>
        </Swiper>
    </section>
</template>
<script lang="ts" setup>
import { Section } from "./types"

import { Navigation, Pagination, SwiperOptions } from "swiper"

import { Swiper, SwiperSlide } from "swiper/vue"
import { computed } from "vue"
import SectionTitle from "./SectionTitle.vue"
import Play from "../icons/Play.vue"
import { goToSectionItem } from "@/utils/items"

const props = defineProps<{
    item: Section & { __typename: "FeaturedSection" }
}>()

const modules = [Navigation, Pagination]

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
                },
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
                },
            } as {
                [key: number]: SwiperOptions
            }
    }
})
</script>
