<template>
    <div>
        <div class="rounded bg-primary-light aspect-video">
            <img src="https://brunstadtv.imgix.net/BIHE_S01_E02_MUL.jpg" />
        </div>
        <div class="w-full mt-2 px-1">
            <div class="text-sm truncate text-secondary">
                <p
                    v-if="
                        item.__typename === 'EpisodeItem' &&
                        item.episode.season &&
                        item.episode.number
                    "
                >
                    {{ item.episode.season.show.title }}
                    <span class="text-sm text-faded"
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
                    <span class="text-sm text-faded"
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
import { SectionItem } from "./types"

defineProps<{
    item: SectionItem
}>()
</script>
