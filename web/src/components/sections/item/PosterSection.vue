<template>
    <section>
        <SectionTitle v-if="item.title">{{ item.title }}</SectionTitle>
        <Slider
            :item="item"
            v-slot="{ item: i, index }"
            @load-more="$emit('loadMore')"
        >
            <NewPill class="absolute top-0 -right-1" :item="i"></NewPill>
            <div
                class="flex flex-col rounded rounded-md mt-1 cursor-pointer hover:opacity-90 transition"
                @click="$emit('clickItem', index)"
            >
                <div
                    class="relative w-full aspect-[240/357] mb-1 rounded-md overflow-hidden"
                >
                    <Image
                        :src="i.image"
                        size-source="height"
                        :ratio="240 / 357"
                    />
                    <ProgressBar
                        class="absolute bottom-0 w-full"
                        v-if="i.item?.__typename === 'Episode'"
                        :item="i.item"
                    />
                </div>
                <SectionItemTitle
                    :secondary-titles="item.metadata?.secondaryTitles === true"
                    :i="i"
                ></SectionItemTitle>
            </div>
        </Slider>
    </section>
</template>
<script lang="ts" setup>
import { Section } from "../types"

import SectionTitle from "./SectionTitle.vue"
import NewPill from "./NewPill.vue"
import SectionItemTitle from "./SectionItemTitle.vue"
import ProgressBar from "@/components/episodes/ProgressBar.vue"
import Image from "@/components/Image.vue"
import Slider from "./Slider.vue"

defineProps<{
    position: number
    item: Section & { __typename: "PosterSection" }
}>()

defineEmits<{
    (event: "loadMore"): void
    (event: "clickItem", index: number): void
}>()
</script>
