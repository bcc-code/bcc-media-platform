<template>
    <section>
        <SectionTitle v-if="item.title">{{ item.title }}</SectionTitle>
        <Swiper :breakpoints="breakpoints(item.size)" :modules="modules" :lazy="true">
            <SwiperSlide v-for="i in item.items.items" class="relative">
                <NewPill class="absolute top-0 right-0" :item="i"></NewPill>
                <div
                    class="flex flex-col cursor-pointer mt-2"
                    @click="goToSectionItem(i)"
                >
                    <div
                        class="relative mb-1 rounded-md top-0 w-full object-cover aspect-video overflow-hidden"
                    >
                        <Image :src="i.image" loading="lazy" size-source="width" :ratio="9/16" />
                        <ProgressBar
                            class="absolute bottom-0 w-full"
                            v-if="i.item?.__typename === 'Episode'"
                            :item="i.item"
                        />
                    </div>
                    <SectionItemTitle :for="i.id" :i="i"></SectionItemTitle>
                </div>
            </SwiperSlide>
        </Swiper>
    </section>
</template>
<script lang="ts" setup>
import { Section } from "./types"

import { Navigation, Pagination, Lazy } from "swiper"

import { Swiper, SwiperSlide } from "swiper/vue"
import SectionTitle from "./SectionTitle.vue"
import breakpoints from "./breakpoints"
import { goToSectionItem } from "@/utils/items"
import NewPill from "./NewPill.vue"
import SectionItemTitle from "./SectionItemTitle.vue"
import ProgressBar from "../episodes/ProgressBar.vue"
import Image from "../Image.vue"

const props = defineProps<{
    item: Section & { __typename: "DefaultSection" }
}>()

const modules = [Navigation, Pagination, Lazy]
</script>
