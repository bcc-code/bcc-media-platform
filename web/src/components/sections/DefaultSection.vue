<template>
    <section>
        <SectionTitle v-if="item.title">{{ item.title }}</SectionTitle>
        <Slide :item="item" v-slot="{ item: i }">
            <NewPill class="absolute top-0 right-0" :item="i"></NewPill>
            <div
                class="flex flex-col cursor-pointer mt-2"
                @click="goToSectionItem(i)"
            >
                <div
                    class="relative mb-1 rounded-md w-full aspect-video overflow-hidden hover:opacity-90 transition"
                >
                    <Image
                        :src="i.image"
                        class="rounded-md"
                        loading="lazy"
                        size-source="width"
                        :ratio="9 / 16"
                    />
                    <ProgressBar
                        class="absolute bottom-0 w-full"
                        v-if="i.item?.__typename === 'Episode'"
                        :item="i.item"
                    />
                </div>
                <SectionItemTitle :for="i.id" :i="i"></SectionItemTitle>
            </div>
        </Slide>
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
import Slide from "./Slider.vue"

defineProps<{
    item: Section & { __typename: "DefaultSection" }
}>()
</script>
