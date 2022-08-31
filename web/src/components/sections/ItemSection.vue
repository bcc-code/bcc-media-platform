<template>
    <div>
        <div v-if="section" class="overflow-hidden">
            <h1 class="text-xl">{{ section.title }}</h1>
            <div class="whitespace-nowrap overflow-auto">
                <component class="m-1 w-64 top-0 h-full inline-block cursor-pointer shadow hover:shadow-lg hover:shadow-inner" v-for="item in section.items"
                    @click="view(item)"
                    :is="components[item.type]" :item="item"></component>
            </div>
        </div>
        <div v-else>Invalid section</div>
    </div>
</template>
<script lang="ts" setup>
import { useRouter } from "vue-router"
import EpisodeItem from "./items/EpisodeItem.vue"
import PageItem from "./items/PageItem.vue"
import SeasonItem from "./items/SeasonItem.vue"
import ShowItem from "./items/ShowItem.vue"
import URLItem from "./items/URLItem.vue"
import { Item } from "./SectionItem.vue"

export type Section = {
    title: string
    items: Item[]
}

const router = useRouter()

const components = {
    episode: EpisodeItem,
    season: SeasonItem,
    show: ShowItem,
    page: PageItem,
    url: URLItem,
}

defineProps<{
    section: Section
}>()


const view = async (item: Item) => {
    switch (item.type) {
        case "episode":
            await router.push({
                name: "episode-page",
                params: {
                    episodeId: item.id,
                }
            })
            break;
        case "season":
            await router.push({
                name: "season-page",
                params: {
                    seasonId: item.id,
                }
            })
            break;
        case "show":
            await router.push({
                name: "show-page",
                params: {
                    showId: item.id,
                }
            })
            break;
        case "page":
            await router.push({
                name: "page",
                params: {
                    pageId: item.code,
                }
            })
            break;
        case "url":
            await router.push({
                name: "url",
                params: {
                    url: item.id
                }
            })
            break;
        }
}

</script>
