<template>
    <section>
        <SectionTitle v-if="item.title">{{ item.title }}</SectionTitle>
        <Swiper
            :slides-per-view="4"
            :breakpoints="breakpoints(item.size)"
            :modules="modules"
        >
            <SwiperSlide
                v-for="i in item.items.items"
                class="relative"
                @click="goToSectionItem(i)"
            >
                <NewPill class="absolute top-0 right-0" :item="i"></NewPill>
                <div
                    class="flex flex-col rounded rounded-md mt-1 cursor-pointer"
                >
                    <div
                        class="relative w-full aspect-[9/16] mb-1 rounded-md overflow-hidden"
                    >
                        <img
                            :src="
                                i.image +
                                `?h=${imageSize.height}&w=${imageSize.width}&fit=crop&crop=faces`
                            "
                            loading="lazy"
                        />
                        <ProgressBar
                            class="absolute bottom-0 w-full"
                            v-if="i.item?.__typename === 'Episode'"
                            :item="i.item"
                        />
                    </div>
                    <SectionItemTitle :i="i"></SectionItemTitle>
                </div>
            </SwiperSlide>
        </Swiper>
    </section>
</template>
<script lang="ts" setup>
import { Section } from "./types"

import { Navigation, Pagination } from "swiper"

import { Swiper, SwiperSlide } from "swiper/vue"
import SectionTitle from "./SectionTitle.vue"
import breakpoints from "./breakpoints"
import { goToSectionItem } from "@/utils/items"
import NewPill from "./NewPill.vue"
import { computed } from "vue"
import SectionItemTitle from "./SectionItemTitle.vue"
import ProgressBar from "../episodes/ProgressBar.vue"

const props = defineProps<{
    item: Section & { __typename: "PosterSection" }
}>()

const modules = [Navigation, Pagination]

const imageSize = computed(() => {
    return {
        small: {
            height: 800,
            width: 450,
        },
        medium: {
            height: 800,
            width: 450,
        },
    }[props.item.size]
})
</script>
