<template>
    <section>
        <SectionTitle v-if="item.title">{{ item.title }}</SectionTitle>
        <Slider
            :section="item"
            v-slot="{ item: i, index }"
            @load-more="$emit('loadMore')"
        >
            <CollectionItemThumbnail
                v-if="isCollectionItem(i.item)"
                :title="i.title"
                :image="i.image"
                :item="i.item"
                @click="$emit('clickItem', index)"
                :secondary-titles="item.metadata?.secondaryTitles === true"
                type="default"
            />
        </Slider>
    </section>
</template>

<script lang="ts" setup>
import { isCollectionItem } from "@/utils/items"
import type { Section } from "../types"
import CollectionItemThumbnail from "./CollectionItemThumbnail.vue"
import SectionTitle from "./SectionTitle.vue"
import Slider from "./Slider.vue"

defineProps<{
    position: number
    item: Section & { __typename: "DefaultSection" | "ListSection" }
}>()

defineEmits<{
    (event: "loadMore"): void
    (event: "clickItem", index: number): void
}>()
</script>
