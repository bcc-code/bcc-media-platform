<template>
    <section>
        <SectionTitle v-if="item.title">{{ item.title }}</SectionTitle>
        <div class="grid grid-cols-2">
            <div v-for="i in item.items.items" class="relative mb-5">
                <NewPill class="absolute top-0 right-0" :item="i"></NewPill>
                <div
                    class="flex flex-col cursor-pointer mx-2 mt-2"
                    @click="goToSectionItem(i)"
                >
                    <div class="relative mb-1 rounded-md top-0 w-full object-cover aspect-video overflow-hidden">
                        <Image :src="i.image" size-source="width" :ratio="9/16" />
                        <ProgressBar
                            class="absolute bottom-0 w-full"
                            v-if="i.item?.__typename === 'Episode'"
                            :item="i.item"
                        />
                    </div>
                    <SectionItemTitle :i="i"></SectionItemTitle>
                </div>
            </div>
        </div>
    </section>
</template>
<script lang="ts" setup>
import { Section } from "./types"

import { computed } from "vue"
import SectionTitle from "./SectionTitle.vue"
import NewPill from "./NewPill.vue"
import { goToSectionItem } from "@/utils/items"
import SectionItemTitle from "./SectionItemTitle.vue"
import ProgressBar from "../episodes/ProgressBar.vue"
import Image from "../Image.vue"

const props = defineProps<{
    item: Section & { __typename: "DefaultGridSection" }
}>()

const imageSize = computed(() => {
    return {
        half: {
            height: 450,
            width: 800,
        },
    }[props.item.gridSize]
})
</script>
