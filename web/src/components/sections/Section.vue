<template>
    <DefaultSection
        v-if="
            (section.__typename === 'DefaultSection' && hasItems(section)) ||
            (isLargeScreen &&
                section.__typename === 'ListSection' &&
                hasItems(section))
        "
        :item="section"
        :position="index.current"
        @click-item="(i) => $emit('clickItem', i)"
        @load-more="$emit('loadMore')"
    ></DefaultSection>
    <ListSection
        v-else-if="section.__typename === 'ListSection' && hasItems(section)"
        :item="section"
        :paginate="index.last === index.current"
        :position="index.current"
        @click-item="(i) => $emit('clickItem', i)"
    ></ListSection>
    <DefaultGridSection
        v-else-if="
            section.__typename === 'DefaultGridSection' && hasItems(section)
        "
        :item="section"
        :paginate="index.last === index.current"
        :position="index.current"
        @click-item="(i) => $emit('clickItem', i)"
    ></DefaultGridSection>
    <PosterSection
        v-else-if="section.__typename === 'PosterSection' && hasItems(section)"
        :item="section"
        :position="index.current"
        @click-item="(i) => $emit('clickItem', i)"
        @load-more="$emit('loadMore')"
    ></PosterSection>
    <PosterGridSection
        v-else-if="
            section.__typename === 'PosterGridSection' && hasItems(section)
        "
        :item="section"
        :position="index.current"
        @click-item="(i) => $emit('clickItem', i)"
    ></PosterGridSection>
    <FeaturedSection
        v-else-if="
            section.__typename === 'FeaturedSection' && hasItems(section)
        "
        :item="section"
        :position="index.current"
        @click-item="(i) => $emit('clickItem', i)"
        @load-more="$emit('loadMore')"
    ></FeaturedSection>
    <IconSection
        v-else-if="section.__typename === 'IconSection' && hasItems(section)"
        :item="section"
        :position="index.current"
        @click-item="(i) => $emit('clickItem', i)"
    ></IconSection>
    <IconGridSection
        v-else-if="
            section.__typename === 'IconGridSection' && hasItems(section)
        "
        :item="section"
        :position="index.current"
        @click-item="(i) => $emit('clickItem', i)"
    ></IconGridSection>
    <LabelSection
        v-else-if="section.__typename === 'LabelSection' && hasItems(section)"
        :item="section"
        :position="index.current"
        @click-item="(i) => $emit('clickItem', i)"
    ></LabelSection>
    <WebSection
        v-else-if="section.__typename === 'WebSection'"
        :item="section"
    />
    <MessageSection
        v-else-if="section.__typename === 'MessageSection'"
        :item="section"
    ></MessageSection>
    <CardSection
        v-else-if="
            section.__typename === 'CardSection' && section.cardSize == 'large'
        "
        :item="section"
        @click-item="(i) => $emit('clickItem', i)"
    ></CardSection>
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
import MessageSection from "./MessageSection.vue"
import CardSection from "./item/CardSection.vue"
import { useWindowSize } from "@vueuse/core"
import { computed } from "vue"

defineProps<{
    section: Section
    index: {
        last: number
        current: number
    }
}>()

defineEmits<{
    (e: "loadMore"): void
    (e: "clickItem", index: number): void
}>()

const hasItems = (section: {
    items: {
        items: any[]
    }
}) => {
    return section.items.items.length > 0
}

const { width } = useWindowSize()
const isLargeScreen = computed(() => width.value > 768)
</script>
