<template>
    <SwiperSection
        v-if="section.style === 'slider'"
        :section="section"
        :click="view"
    ></SwiperSection>
    <HeaderSection
        v-else-if="section.style === 'header'"
        :items="section.items.items"
        :click="view"
    ></HeaderSection>
</template>
<script lang="ts" setup>
import { Section, SectionItem as TSectionItem } from "./types"
import { useRouter } from "vue-router"
import SwiperSection from "./SwiperSection.vue"
import HeaderSection from "./HeaderSection.vue"

defineProps<{
    section: Section
}>()

const router = useRouter()

const view = (item: TSectionItem) => {
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
