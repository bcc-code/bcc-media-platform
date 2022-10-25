<template>
    <section>
        <SectionTitle v-if="item.title">{{ item.title }}</SectionTitle>
        <div class="grid grid-cols-2">
            <div
                v-for="i in item.items.items"
                class="relative"
                @click="goToSectionItem(i)"
            >
                <NewPill class="absolute top-0 right-0" :item="i"></NewPill>
                <div class="flex flex-col aspect-[9/16] rounded rounded-md mx-2 mt-1">
                    <img
                        :src="i.image ?? ''"
                        class="rounded-md top-0 h-full w-full object-cover mb-1"
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
                </div>
            </div>
        </div>
    </section>
</template>
<script lang="ts" setup>
import { Section } from "./types"

import { useI18n } from "vue-i18n"

import SectionTitle from "./SectionTitle.vue"
import { goToSectionItem } from "@/utils/items"
import NewPill from "./NewPill.vue"

const { t } = useI18n()

defineProps<{
    item: Section & { __typename: "PosterGridSection" }
}>()
</script>
