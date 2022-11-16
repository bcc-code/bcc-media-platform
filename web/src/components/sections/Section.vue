<template>
    <PosterSection
        v-if="section.__typename === 'PosterSection'"
        :item="section"
    ></PosterSection>
    <FeaturedSection
        v-else-if="section.__typename === 'FeaturedSection'"
        :item="section"
    ></FeaturedSection>
    <ListSection
        v-else-if="section.__typename === 'ListSection'"
        :item="section"
    ></ListSection>
    <DefaultSection
        v-else-if="section.__typename === 'DefaultSection'"
        :item="section"
    ></DefaultSection>
    <DefaultGridSection
        v-else-if="section.__typename === 'DefaultGridSection'"
        :item="section"
    ></DefaultGridSection>
    <PosterGridSection
        v-else-if="section.__typename === 'PosterGridSection'"
        :item="section"
    ></PosterGridSection>
    <LabelSection
        v-else-if="section.__typename === 'LabelSection'"
        :item="section"
    ></LabelSection>
    <IconSection
        v-else-if="section.__typename === 'IconSection'"
        :item="section"
    ></IconSection>
    <IconGridSection
        v-else-if="section.__typename === 'IconGridSection'"
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
</script>
