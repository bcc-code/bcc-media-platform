<template>
    <section>
        <SectionTitle v-if="section.title">{{ section.title }}</SectionTitle>
        <div
            class="flex flex-col lg:grid lg:grid-cols-2 gap-4 overflow-x-visible"
        >
            <div
                v-for="(item, index) in section.items.items"
                class="relative"
                :key="item.id + item.item.__typename"
            >
                <CollectionItemThumbnail
                    v-if="isCollectionItem(item)"
                    :item="item"
                    :title="item.title"
                    :image="item.image"
                    @click="$emit('clickItem', index)"
                    :secondary-titles="
                        section.metadata?.secondaryTitles === true
                    "
                    type="default"
                />
            </div>
        </div>
    </section>
</template>
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
