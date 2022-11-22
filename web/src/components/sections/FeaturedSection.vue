<template>
    <section>
        <SectionTitle v-if="item.title">{{ item.title }}</SectionTitle>
        <Slider :item="item" v-slot="{ item: i }" :breakpoints="options">
            <div
                class="relative h-full cursor-pointer aspect-video overflow-hidden"
                @click="goToSectionItem(i, item.metadata?.collectionId)"
            >
                <Image
                    :src="i.image"
                    size-source="width"
                    :ratio="9 / 16"
                    class="rounded rounded-xl h-full object-cover"
                />
                <div
                    class="absolute bottom-0 w-full text-center bg-gradient-to-t from-background to-transparent pt-8"
                >
                    <h1 class="text-2xl font-bold">
                        {{ i.title }}
                    </h1>
                    <p
                        v-if="(i as any).description"
                        class="opacity-80 line-clamp-2 px-8 lg:px-16"
                    >
                        {{ (i as any).description }}
                    </p>
                </div>
            </div>
            <div class="text-center mt-2">
                <button
                    class="bg-slate-800 px-4 py-1 rounded-full font-bold text-lg flex mx-auto hover:scale-105"
                    @click="goToSectionItem(i)"
                >
                    <div class="flex" v-if="['Episode', 'Show', 'Season'].includes(i.item.__typename)">
                        <Play></Play><span class="ml-1">Watch now</span>
                    </div>
                    <div class="flex" v-else>
                        <Play></Play><span class="ml-1">Explore</span>
                    </div>
                </button>
            </div>
        </Slider>
    </section>
</template>
<script lang="ts" setup>
import { Section } from "./types"

import { computed } from "vue"
import SectionTitle from "./SectionTitle.vue"
import Play from "../icons/Play.vue"
import Image from "../Image.vue"
import Slider from "./Slider.vue"
import { goToSectionItem } from "@/utils/items"

const props = defineProps<{
    item: Section & { __typename: "FeaturedSection" }
}>()

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
            }
    }
})
</script>
