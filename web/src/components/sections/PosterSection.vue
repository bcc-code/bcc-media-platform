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
                class="flex flex-col h-full aspect-[9/16] rounded rounded-md"
                @click="goToSectionItem(i)"
            >
                <img
                    class="rounded-md top-0 h-full w-full object-cover border-2 border-slate-800"
                    :src="i.image + '?w=1080'"
                />
                <div class="mt-1" v-if="i.item?.__typename === 'Episode'">
                    <h3 class="text-sm text-primary w-full" v-if="i.item.season">
                        {{ i.item.season?.show.title
                        }}<span class="ml-1 text-gray"
                            >S{{ i.item.season?.number }}:E{{
                                i.item.episodeNumber
                            }}</span
                        >
                    </h3>
                    <SectionTitle>{{i.title}}</SectionTitle>
                </div>
                <div class="mt-1" v-if="i.item?.__typename === 'Show'">
                    <SectionTitle>{{i.title}}</SectionTitle>
                    <p class="text-gray">
                        {{ t("section.item.season", i.item.seasonCount) }} -
                        {{ t("section.item.episode", i.item.episodeCount) }}
                    </p>
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
import { computed } from "vue"
import SectionTitle from "./SectionTitle.vue"
import breakpoints from "./breakpoints"
import { goToSectionItem } from "@/utils/items"

const { t } = useI18n()

const props = defineProps<{
    item: Section & { __typename: "PosterSection" }
}>()

const modules = [Navigation, Pagination]
</script>
