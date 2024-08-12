<template>
    <section>
        <SectionTitle v-if="section.title">{{ section.title }}</SectionTitle>
        <div class="grid grid-cols-2 gap-4">
            <div
                v-for="(item, index) in section.items.items"
                class="relative mb-5"
            >
                <CollectionItemThumbnail
                    v-if="isCollectionItem(item)"
                    :title="item.title"
                    :image="item.image"
                    :item="item"
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
    section: Section & { __typename: "DefaultGridSection" }
}>()

defineEmits<{
    (event: "clickItem", index: number): void
}>()
</script>
