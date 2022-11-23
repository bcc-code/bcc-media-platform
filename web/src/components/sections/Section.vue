<template>
    <PosterSection
        v-if="section.__typename === 'PosterSection' && hasItems(section)"
        :item="section"
    ></PosterSection>
    <FeaturedSection
        v-else-if="
            section.__typename === 'FeaturedSection' && hasItems(section)
        "
        :item="section"
    ></FeaturedSection>
    <ListSection
        v-else-if="section.__typename === 'ListSection' && hasItems(section)"
        :item="section"
    ></ListSection>
    <DefaultSection
        v-else-if="section.__typename === 'DefaultSection' && hasItems(section)"
        :item="section"
    ></DefaultSection>
    <DefaultGridSection
        v-else-if="
            section.__typename === 'DefaultGridSection' && hasItems(section)
        "
        :item="section"
    ></DefaultGridSection>
    <PosterGridSection
        v-else-if="
            section.__typename === 'PosterGridSection' && hasItems(section)
        "
        :item="section"
    ></PosterGridSection>
    <LabelSection
        v-else-if="section.__typename === 'LabelSection' && hasItems(section)"
        :item="section"
    ></LabelSection>
    <IconSection
        v-else-if="section.__typename === 'IconSection' && hasItems(section)"
        :item="section"
    ></IconSection>
    <IconGridSection
        v-else-if="
            section.__typename === 'IconGridSection' && hasItems(section)
        "
        :item="section"
    ></IconGridSection>
    <WebSection
        v-else-if="section.__typename === 'WebSection'"
        :item="section"
    />
</template>
<script lang="ts" setup>
import { Section } from "./types"
import PosterSection from "./PosterSection.vue"
import FeaturedSection from "./FeaturedSection.vue"
import DefaultSection from "./DefaultSection.vue"
import DefaultGridSection from "./DefaultGridSection.vue"
import PosterGridSection from "./PosterGridSection.vue"
import LabelSection from "./LabelSection.vue"
import IconSection from "./IconSection.vue"
import IconGridSection from "./IconGridSection.vue"
import ListSection from "./ListSection.vue"
import WebSection from "./WebSection.vue"

defineProps<{
    section: Section
}>()

const hasItems = (section: {
    items: {
        items: any[]
    }
}) => {
    return section.items.items.length > 0
}
</script>
