<template>
    <section>
        <SectionTitle v-if="item.title">{{ item.title }}</SectionTitle>
        <div class="grid grid-cols-2 gap-4">
            <div v-for="(i, index) in item.items.items" class="relative">
                <SectionItem
                    :i="i"
                    @click="$emit('clickItem', index)"
                    :secondary-titles="item.metadata?.secondaryTitles === true"
                    type="poster"
                ></SectionItem>
            </div>
        </div>
    </section>
</template>
<script lang="ts" setup>
import { Section } from "../types"

import SectionTitle from "./SectionTitle.vue"
import SectionItem from "./SectionItem.vue"

defineProps<{
    position: number
    item: Section & { __typename: "PosterGridSection" | "PosterSection" }
}>()

defineEmits<{
    (event: "clickItem", index: number): void
}>()
</script>
