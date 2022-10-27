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
                <div
                    class="flex flex-col aspect-[9/16] rounded rounded-md mx-2 mt-1"
                >
                    <img
                        :src="i.image ?? ''"
                        class="rounded-md top-0 h-full w-full object-cover mb-1"
                    />
                    <SectionItemTitle :i="i"></SectionItemTitle>
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
import SectionItemTitle from "./SectionItemTitle.vue"

const { t } = useI18n()

defineProps<{
    item: Section & { __typename: "PosterGridSection" }
}>()
</script>
