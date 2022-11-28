<template>
    <section>
        <SectionTitle v-if="item.title">{{ item.title }}</SectionTitle>
        <div class="grid grid-cols-2">
            <div
                v-for="(i, index) in item.items.items"
                class="relative"
                @click="$emit('clickItem', index)"
            >
                <NewPill class="absolute top-0 -right-1" :item="i"></NewPill>
                <div
                    class="flex flex-col rounded rounded-md mx-2 mt-1 hover:opacity-90 transition"
                >
                    <div
                        class="relative aspect-[9/16] rounded-md object-cover mb-1"
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
                    <SectionItemTitle
                        :secondary-titles="
                            item.metadata?.secondaryTitles === true
                        "
                        :i="i"
                    ></SectionItemTitle>
                </div>
            </div>
        </div>
    </section>
</template>
<script lang="ts" setup>
import { Section } from "../types"

import SectionTitle from "./SectionTitle.vue"
import NewPill from "./NewPill.vue"
import SectionItemTitle from "./SectionItemTitle.vue"
import ProgressBar from "@/components/episodes/ProgressBar.vue"
import Image from "@/components/Image.vue"

defineProps<{
    position: number
    item: Section & { __typename: "PosterGridSection" | "PosterSection" }
}>()

defineEmits<{
    (event: "clickItem", index: number): void
}>()
</script>
