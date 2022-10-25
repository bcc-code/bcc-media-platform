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
                        :src="i.image + '?h=400'"
                        class="rounded-md top-0 h-full w-full object-cover mb-1"
                    />
                    <div v-if="i.item?.__typename === 'Episode'">
                        <h3 class="text-sm text-primary w-full">
                            {{ i.item.season?.show.title
                            }}<span class="ml-1 text-gray"
                                >S{{ i.item.season?.number }}:E{{
                                    i.item.episodeNumber
                                }}</span
                            >
                        </h3>
                        <h1 :class="style.title">
                            {{ i.title }}
                        </h1>
                    </div>
                    <div v-else-if="i.item?.__typename === 'Season'">
                        <h3 class="text-sm text-primary w-full">
                            {{ i.item.show.title
                            }}<span class="ml-1 text-gray"
                                >S{{ i.item.seasonNumber }}</span
                            >
                        </h3>
                        <h1 :class="style.title">
                            {{ i.title }}
                        </h1>
                    </div>
                    <div v-else-if="i.item?.__typename === 'Show'">
                        <h1 :class="style.title">
                            {{ i.title }}
                        </h1>
                        <p class="text-gray">
                            {{ t("section.item.season", i.item.seasonCount) }} -
                            {{ t("section.item.episode", i.item.episodeCount) }}
                        </p>
                    </div>
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

const { t } = useI18n()

const props = defineProps<{
    item: Section & { __typename: "DefaultSection" }
}>()

const modules = [Navigation, Pagination]

const style = computed(() => {
    return {
        small: {
            title: "text-md lg:text-lg",
        },
        medium: {
            title: "text-md lg:text-lg",
        },
    }[props.item.size]
})
</script>
