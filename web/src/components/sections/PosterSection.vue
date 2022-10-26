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
                <div class="flex flex-col aspect-[9/16] rounded rounded-md mx-2 mt-1">
                    <img
                        :src="i.image + `?h=${imageSize.height}&w=${imageSize.width}&fit=crop&crop=faces`"
                        class="rounded-md top-0 h-full w-full object-cover mb-1"
                    />
                    <SectionItemTitle :i="i"></SectionItemTitle>
                </div>
            </SwiperSlide>
        </Swiper>
    </section>
</template>
<script lang="ts" setup>
import { Section } from "./types"

import { Navigation, Pagination } from "swiper"
import { useI18n } from "vue-i18n"

import { Swiper, SwiperSlide } from "swiper/vue"
import SectionTitle from "./SectionTitle.vue"
import breakpoints from "./breakpoints"
import { goToSectionItem } from "@/utils/items"
import NewPill from "./NewPill.vue"
import { computed } from "vue"
import SectionItemTitle from "./SectionItemTitle.vue"

const { t } = useI18n()

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
