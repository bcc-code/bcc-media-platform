<template>
    <div>
        <HeaderSection
            v-if="section.__typename == 'FeaturedSection'"
            :items="section.items.items"
            :click="view"
        ></HeaderSection>
        <SwiperSection
            v-else-if="section.__typename === 'DefaultSection'"
            :section="section"
            :click="view"
        ></SwiperSection>
        <CardSection
            v-else-if="section.__typename === 'PosterSection'"
            :click="view"
            :section="section"
        >
        </CardSection>
    </div>
</template>
<script lang="ts" setup>
import { Section, SectionItem } from "./types"
import { useRouter } from "vue-router"
import SwiperSection from "./SwiperSection.vue"
import HeaderSection from "./HeaderSection.vue"
import CardSection from "./CardSection.vue"

defineProps<{
    section: Section
}>()

const router = useRouter()

const view = (item: SectionItem) => {
    switch (item.item?.__typename) {
        case "Episode":
            router.push({
                name: "episode-page",
                params: {
                    episodeId: item.id,
                },
            })
            break
        case "Season":
            router.push({
                name: "season-page",
                params: {
                    seasonId: item.id,
                },
            })
            break
        case "Show":
            router.push({
                name: "show-page",
                params: {
                    showId: item.id,
                },
            })
            break
        case "Page":
            router.push({
                name: "page",
                params: {
                    pageId: item.item.code,
                },
            })
            break
    }
}
</script>
