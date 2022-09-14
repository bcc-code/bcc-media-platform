<template>
    <div>
        <HeaderSection
            v-if="section.style === 'featured'"
            :items="section.items.items"
            :click="view"
        ></HeaderSection>
        <SwiperSection
            v-else-if="
                section.style === 'slider' || section.style === 'carousel'
            "
            :section="section"
            :click="view"
        ></SwiperSection>
        <CardSection
            v-else-if="section.style === 'cards'"
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
    switch (item.__typename) {
        case "EpisodeItem":
            router.push({
                name: "episode-page",
                params: {
                    episodeId: item.id,
                },
            })
            break
        case "SeasonItem":
            router.push({
                name: "season-page",
                params: {
                    seasonId: item.id,
                },
            })
            break
        case "ShowItem":
            router.push({
                name: "show-page",
                params: {
                    showId: item.id,
                },
            })
            break
        case "PageItem":
            router.push({
                name: "page",
                params: {
                    pageId: item.page.code,
                },
            })
            break
        case "URLItem":
            // router.push({
            //     name: "episode-page",
            //     params: {
            //         episodeId: item.id,
            //     }
            // })
            break
    }
}
</script>
