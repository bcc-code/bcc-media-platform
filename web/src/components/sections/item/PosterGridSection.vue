<template>
    <section>
        <SectionTitle v-if="section.title">{{ section.title }}</SectionTitle>
        <div class="grid grid-cols-2 gap-4">
            <div v-for="(item, index) in section.items.items" class="relative">
                <CollectionItemThumbnail
                    v-if="isCollectionItem(item)"
                    :item="item"
                    :title="item.title"
                    :image="item.image"
                    :secondary-titles="
                        section.metadata?.secondaryTitles === true
                    "
                    type="poster"
                    @click="$emit('clickItem', index)"
                />
            </div>
        </div>
    </section>
</template>
<script lang="ts" setup>
import { Section } from "../types"

import { isCollectionItem } from "@/utils/items"
import CollectionItemThumbnail from "./CollectionItemThumbnail.vue"
import SectionTitle from "./SectionTitle.vue"

defineProps<{
    position: number
    section: Section & { __typename: "PosterGridSection" | "PosterSection" }
}>()

defineEmits<{
    (event: "clickItem", index: number): void
}>()
</script>
