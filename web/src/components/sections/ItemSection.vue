<template>
    <div>
        <div v-if="section" class="overflow-hidden" >
            <h1 class="text-xl">{{section.title}}</h1>
            <div class="whitespace-nowrap overflow-auto">
                <component class="m-2 w-64 top-0 h-full inline-block" v-for="item in section.items" :is="components[item.type]" :item="item"></component>
            </div>
        </div>
        <div v-else>
            Invalid section
        </div>
    </div>
</template>
<script lang="ts" setup>
import EpisodeItem from './items/EpisodeItem.vue';
import PageItem from './items/PageItem.vue';
import SeasonItem from './items/SeasonItem.vue';
import ShowItem from './items/ShowItem.vue';
import URLItem from './items/URLItem.vue';
import { Item } from './SectionItem.vue';

export type Section = {
    title: string;
    items: Item[]
}

const components = {
    "episode": EpisodeItem,
    "season": SeasonItem,
    "show": ShowItem,
    "page": PageItem,
    "url": URLItem,
}

defineProps<{
    section: Section
}>()
</script>
