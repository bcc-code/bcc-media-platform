<template>
    <div>
        <PosterSection
            v-if="section.__typename === 'PosterSection'"
            :item="section"
        ></PosterSection>
        <FeaturedSection
            v-if="section.__typename === 'FeaturedSection'"
            :item="section"
        ></FeaturedSection>
        <DefaultSection
            v-if="section.__typename === 'DefaultSection'"
            :item="section"
        ></DefaultSection>
        <DefaultGridSection
            v-if="section.__typename === 'DefaultGridSection'"
            :item="section"
        ></DefaultGridSection>
        <PosterGridSection
            v-if="section.__typename === 'PosterGridSection'"
            :item="section"
        ></PosterGridSection>
        <LabelSection
            v-if="section.__typename === 'LabelSection'"
            :item="section"
        ></LabelSection>
        <IconSection
            v-if="section.__typename === 'IconSection'"
            :item="section"
        ></IconSection>
    </div>
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

defineProps<{
    section: Section
}>()
</script>
