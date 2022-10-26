<template>
    <section>
        <SectionTitle v-if="item.title">{{ item.title }}</SectionTitle>
        <Swiper :breakpoints="breakpoints(item.size)" :modules="modules">
            <SwiperSlide
                v-for="i in item.items.items"
                class="relative"
                @click="goToSectionItem(i)"
            >
                <NewPill class="absolute top-0 right-0" :item="i"></NewPill>
                <div class="flex flex-col cursor-pointer mx-2 mt-2">
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

import { Swiper, SwiperSlide } from "swiper/vue"
import { computed } from "vue"
import SectionTitle from "./SectionTitle.vue"
import breakpoints from "./breakpoints"
import { useI18n } from "vue-i18n"
import { goToSectionItem } from "@/utils/items"
import NewPill from "./NewPill.vue"
import SectionItemTitle from "./SectionItemTitle.vue"

const { t } = useI18n()

const props = defineProps<{
    item: Section & { __typename: "DefaultSection" }
}>()

const modules = [Navigation, Pagination]

const imageSize = computed(() => {
    return {
        small: {
            height: 225,
            width: 400,
        },
        medium: {
            height: 225,
            width: 400,
        },
    }[props.item.size]
})
</script>
