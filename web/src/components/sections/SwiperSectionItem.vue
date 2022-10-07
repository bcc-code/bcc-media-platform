<template>
    <div>
        <div
            class="rounded rounded-xl aspect-video bg-cover bg-center bg-no-repeat"
            :style="{
                'background-image': 'url(\'' + item.image + '\')',
            }"
        ></div>
        <div class="mt-2">
            <div class="text-sm truncate text-primary">
                <p
                    v-if="
                        item.item?.__typename == 'Episode' &&
                        item.item.season &&
                        item.item.episodeNumber
                    "
                >
                    {{ item.item.season.show.title }}
                    <span class="text-sm text-gray"
                        >S{{ item.item.season.number }}:E{{
                            item.item.episodeNumber
                        }}</span
                    >
                </p>
                <p
                    v-else-if="
                        item.item?.__typename === 'Season' &&
                        item.item.show &&
                        item.item.seasonNumber
                    "
                >
                    {{ item.item.show.title }}
                    <span class="text-sm text-gray"
                        >S{{ item.item.seasonNumber }}</span
                    >
                </p>
                <p v-else-if="item.item?.__typename === 'Page'">
                    {{ item.item.code }}
                </p>
                <p v-else>
                    {{ item.item?.__typename }}
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

if (!props.item.image) {
    props.item.image = randomImageUrl()
}
</script>
