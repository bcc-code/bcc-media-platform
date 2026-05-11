<script lang="ts" setup>
import { GetShowQuery } from '@/graph/generated'
import SectionTitle from '@/components/sections/item/SectionTitle.vue'
import Carousel from '@/components/Carousel.vue'
import CollectionItemThumbnail from '../sections/item/CollectionItemThumbnail.vue'
import { episodeHref, goToEpisode } from '@/utils/items'
import { analytics } from '@/services/analytics'

const props = defineProps<{
    season: GetShowQuery['show']['seasons']['items'][number]
    position: number
}>()

function onClick(
    episode: (typeof props.season.episodes.items)[0],
    index: number,
    isModified: boolean
) {
    analytics.track('section_clicked', {
        elementId: episode.id,
        elementPosition: index,
        elementType: 'Episode',
        pageCode: 'show',
        sectionType: 'DefaultSection',
        sectionId: `ShowSeason-${props.season.id}`,
        sectionPosition: props.position,
    })

    // When the browser handles navigation (modifier/middle click on the <a>),
    // skip the SPA push.
    if (!isModified) {
        goToEpisode(episode.id)
    }
}
</script>

<template>
    <section>
        <SectionTitle>{{ season.title }}</SectionTitle>
        <Carousel v-slot="{ item, index }" :items="season.episodes.items">
            <CollectionItemThumbnail
                :item="item"
                :title="item.title"
                :image="item.image ?? ''"
                :href="episodeHref(item.id)"
                @click="(isModified) => onClick(item, index, isModified)"
            />
        </Carousel>
    </section>
</template>
