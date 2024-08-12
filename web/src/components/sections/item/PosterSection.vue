<template>
    <section>
        <SectionTitle v-if="section.title">{{ section.title }}</SectionTitle>
        <Slider
            :section="section"
            v-slot="{ item, index }"
            @load-more="$emit('loadMore')"
        >
            <CollectionItemThumbnail
                v-if="isCollectionItem(item)"
                :item="item"
                :title="item.title"
                :image="item.image"
                @click="$emit('clickItem', index)"
                :secondary-titles="section.metadata?.secondaryTitles === true"
                type="poster"
            />
        </Slider>
    </section>
</template>
<script lang="ts" setup>
import { isCollectionItem } from "@/utils/items"
import { Section } from "../types"
import CollectionItemThumbnail from "./CollectionItemThumbnail.vue"
import SectionTitle from "./SectionTitle.vue"
import Slider from "./Slider.vue"

defineProps<{
    position: number
    section: Section & { __typename: "PosterSection" }
}>()

defineEmits<{
    (event: "loadMore"): void
    (event: "clickItem", index: number): void
}>()
</script>
