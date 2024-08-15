<script lang="ts" setup>
import { Section } from "../types"

import SectionTitle from "./SectionTitle.vue"
import CollectionItemThumbnail from "./CollectionItemThumbnail.vue"
import { isCollectionItem } from "@/utils/items"

defineProps<{
    position: number
    section: Section & { __typename: "ListSection" }
}>()

defineEmits<{
    (event: "clickItem", index: number): void
}>()
</script>
<template>
    <section>
        <SectionTitle v-if="section.title">{{ section.title }}</SectionTitle>
        <div
            class="flex flex-col lg:grid lg:grid-cols-2 gap-4 overflow-x-visible"
        >
            <div
                v-for="(item, index) in section.items.items"
                :key="item.id + item.item.__typename"
                class="relative"
            >
                <CollectionItemThumbnail
                    v-if="isCollectionItem(item)"
                    :item="item"
                    :title="item.title"
                    :image="item.image"
                    :secondary-titles="
                        section.metadata?.secondaryTitles === true
                    "
                    type="default"
                    @click="$emit('clickItem', index)"
                />
            </div>
        </div>
    </section>
</template>
