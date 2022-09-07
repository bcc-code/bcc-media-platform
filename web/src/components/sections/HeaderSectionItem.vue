<template>
    <div class="relative aspect-video bg-cover bg-center bg-no-repeat mt-2" :style="{
        'background-image': 'url(\'' + randomImageUrl() + '\')'
    }">
        <div class="absolute bottom-0 w-full text-center pb-4 bg-gradient-to-t from-black pt-8 mt-2">
            <div class="text-md truncate text-primary">
                <p
                    v-if="
                        item.__typename === 'EpisodeItem' &&
                        item.episode.season &&
                        item.episode.number
                    "
                >
                    {{ item.episode.season.show.title }}
                    <span class="text-sm text-gray"
                        >S{{ item.episode.season.number }}:E{{
                            item.episode.number
                        }}</span
                    >
                </p>
                <p
                    v-else-if="
                        item.__typename === 'SeasonItem' &&
                        item.season.show &&
                        item.season.number
                    "
                >
                    {{ item.season.show.title }}
                    <span class="text-sm text-gray"
                        >S{{ item.season.number }}</span
                    >
                </p>
                <p v-else-if="item.__typename === 'PageItem'">
                    {{ item.page.code }}
                </p>
                <p v-else>
                    {{ item.__typename }}
                </p>
            </div>
            <p class="truncate text-lg">{{ item.title }}</p>
        </div>
    </div>
</template>
<script lang="ts" setup>
import { randomImageUrl } from "@/utils/randomImage";
import { SectionItem } from "./types"

defineProps<{
    item: SectionItem
}>()
</script>
