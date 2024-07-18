<template>
    <section>
        <SectionTitle v-if="item.title">{{ item.title }}</SectionTitle>
        <Slider
            :section="item"
            v-slot="{ item: i, index }"
            @load-more="$emit('loadMore')"
        >
            <SectionItem
                :i="i"
                @click="$emit('clickItem', index)"
                :secondary-titles="item.metadata?.secondaryTitles === true"
                type="poster"
            ></SectionItem>
        </Slider>
    </section>
</template>
<script lang="ts" setup>
import { Section } from "../types"
import SectionTitle from "./SectionTitle.vue"
import Slider from "./Slider.vue"
import SectionItem from "./SectionItem.vue"

defineProps<{
    position: number
    item: Section & { __typename: "PosterSection" }
}>()

defineEmits<{
    (event: "loadMore"): void
    (event: "clickItem", index: number): void
}>()
</script>
