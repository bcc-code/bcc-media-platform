<template>
    <section>
        <SectionTitle v-if="item.title">{{ item.title }}</SectionTitle>
        <div
            class="flex flex-col lg:grid lg:grid-cols-2 gap-4 overflow-x-visible"
        >
            <div
                v-for="(i, index) in item.items.items"
                class="relative"
                :key="i.id + i.item.__typename"
            >
                <SectionItem
                    :i="i"
                    @click="$emit('clickItem', index)"
                    :secondary-titles="item.metadata?.secondaryTitles === true"
                    type="default"
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
    item: Section & { __typename: "ListSection" }
}>()

defineEmits<{
    (event: "clickItem", index: number): void
}>()
</script>
