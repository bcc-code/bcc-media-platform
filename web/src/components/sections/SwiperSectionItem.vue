<template>
    <div>
        <div
            class="rounded rounded-xl aspect-video bg-cover bg-center bg-no-repeat"
            :style="{
                'background-image': 'url(\'' + item.imageUrl + '\')',
            }"
        ></div>
        <div class="mt-2">
            <div class="text-sm truncate text-primary">
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
            <p class="truncate">{{ item.title }}</p>
        </div>
    </div>
</template>
<script lang="ts" setup>
import { randomImageUrl } from "@/utils/randomImage"
import { SectionItem } from "./types"

const props = defineProps<{
    item: SectionItem
}>()

if (!props.item.imageUrl) {
    props.item.imageUrl = randomImageUrl()
}
</script>
