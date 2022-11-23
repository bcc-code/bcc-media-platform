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
        :paginate="index.last === index.current"
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
        :paginate="index.last === index.current"
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
import PosterSection from "./item/PosterSection.vue"
import FeaturedSection from "./item/FeaturedSection.vue"
import DefaultSection from "./item/DefaultSection.vue"
import DefaultGridSection from "./item/DefaultGridSection.vue"
import PosterGridSection from "./item/PosterGridSection.vue"
import LabelSection from "./item/LabelSection.vue"
import IconSection from "./item/IconSection.vue"
import IconGridSection from "./item/IconGridSection.vue"
import ListSection from "./item/ListSection.vue"
import WebSection from "./WebSection.vue"

defineProps<{
    section: Section
    index: {
        last: number
        current: number
    }
}>()

const hasItems = (section: {
    items: {
        items: any[]
    }
}) => {
    return section.items.items.length > 0
}
</script>
