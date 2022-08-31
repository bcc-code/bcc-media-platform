<template>
    <div>
        <div v-if="section" class="overflow-hidden">
            <h1 class="text-xl">{{ section.title }}</h1>
            <div class="whitespace-nowrap overflow-auto">
                <SectionItem
                    class="m-1 w-64 top-0 h-full inline-block cursor-pointer shadow hover:shadow-lg hover:shadow-inner"
                    v-for="item in section.items.items"
                    :item="item"
                    @click="view(item)"
                ></SectionItem>
            </div>
        </div>
        <div v-else>Invalid section</div>
    </div>
</template>
<script lang="ts" setup>
import { Section, SectionItem as TSectionItem } from "./types"
import SectionItem from "./SectionItem.vue"
import { useRouter } from "vue-router";

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
                }
            })
            break;
            case "SeasonItem":
            router.push({
                name: "season-page",
                params: {
                    seasonId: item.id,
                }
            })
            break;
            case "ShowItem":
            router.push({
                name: "show-page",
                params: {
                    showId: item.id,
                }
            })
            break;
            case "PageItem":
            router.push({
                name: "page",
                params: {
                    pageId: item.page.code,
                }
            })
            break;
            case "URLItem":
            // router.push({
            //     name: "episode-page",
            //     params: {
            //         episodeId: item.id,
            //     }
            // })
            break;
    }
}
</script>
