<template>
    <div
        class="relative aspect-[16/7] bg-cover bg-center bg-no-repeat rounded rounded-2xl"
        :style="{
            'background-image':
                'linear-gradient(to top, rgba(0, 0, 0, 0.8), rgba(0, 0, 0, 0), rgba(0, 0, 0, 0)), url(\'' +
                item.imageUrl +
                '\')',
        }"
    >
        <div
            class="absolute w-full bottom-0 text-center rounded rounded-2xl pb-4 pb-8 pt-20 mt-2"
        >
            <!-- <div class="text-md truncate text-primary">
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
            </div> -->
            <p class="truncate font-bold text-2xl">{{ item.title }}</p>
        </div>
    </div>
</template>
<script lang="ts" setup>
import { randomImageUrl } from "@/utils/randomImage"
import { SectionItem } from "./types"

const props = defineProps<{
    item: SectionItem
}>()

props.item.imageUrl ??= randomImageUrl()
</script>
