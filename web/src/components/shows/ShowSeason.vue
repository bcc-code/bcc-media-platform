<script lang="ts" setup>
import { GetShowQuery } from "@/graph/generated"
import SectionTitle from "@/components/sections/item/SectionTitle.vue"
import Carousel from "@/components/Carousel.vue"
import CollectionItemThumbnail from "../sections/item/CollectionItemThumbnail.vue"
import { goToEpisode, isNewEpisode } from "@/utils/items"
import { computed } from "vue"

const props = defineProps<{
    season: GetShowQuery["show"]["seasons"]["items"][number]
}>()

const hasNewEpisodes = computed(() =>
    props.season.episodes.items.some(isNewEpisode)
)

const sortedItems = computed(() =>
    hasNewEpisodes.value
        ? props.season.episodes.items.toReversed()
        : props.season.episodes.items
)
</script>

<template>
    <section>
        <SectionTitle>{{ season.title }}</SectionTitle>
        <Carousel :items="sortedItems" v-slot="{ item }">
            <CollectionItemThumbnail
                :item="item"
                :title="item.title"
                :image="item.image ?? ''"
                @click="goToEpisode(item.id)"
            />
        </Carousel>
    </section>
</template>
