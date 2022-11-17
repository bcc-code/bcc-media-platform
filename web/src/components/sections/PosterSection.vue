<template>
    <section>
        <SectionTitle v-if="item.title">{{ item.title }}</SectionTitle>
        <Slider :item="item" v-slot="{ item: i }">
            <NewPill class="absolute top-0 -right-1" :item="i"></NewPill>
            <div
                class="flex flex-col rounded rounded-md mt-1 cursor-pointer hover:opacity-90 transition"
                @click="goToSectionItem(i)"
            >
                <div
                    class="relative w-full aspect-[9/16] mb-1 rounded-md overflow-hidden"
                >
                    <Image
                        :src="i.image"
                        size-source="height"
                        :ratio="9 / 16"
                    />
                    <ProgressBar
                        class="absolute bottom-0 w-full"
                        v-if="i.item?.__typename === 'Episode'"
                        :item="i.item"
                    />
                </div>
                <SectionItemTitle :i="i"></SectionItemTitle>
            </div>
        </Slider>
    </section>
</template>
<script lang="ts" setup>
import { Section } from "./types"

import SectionTitle from "./SectionTitle.vue"
import { goToSectionItem } from "@/utils/items"
import NewPill from "./NewPill.vue"
import SectionItemTitle from "./SectionItemTitle.vue"
import ProgressBar from "../episodes/ProgressBar.vue"
import Image from "../Image.vue"
import Slider from "./Slider.vue"

defineProps<{
    item: Section & { __typename: "PosterSection" }
}>()
</script>
