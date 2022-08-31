<template>
    <div class="p-2">
        <div class="rounded bg-primary-light aspect-video">
            <img src="https://brunstadtv.imgix.net/BIHE_S01_E02_MUL.jpg" />
        </div>
        <div class="w-full mt-2">
            <slot name="subtitle"></slot>
            <p class="truncate">{{item.title}}</p>
        </div>
    </div>
</template>
<script lang="ts" setup>

export type Item = EpisodeItem | SeasonItem | ShowItem | PageItem | URLItem

export type EpisodeItem = {
    title: string;
    image?: string;
    type: "episode"
    show?: string;
    season?: number;
    number?: number;
}

export type SeasonItem = {
    title: string;
    image?: string;
    type: "season",
    show: string;
    number: number;
}

export type ShowItem = {
    title: string;
    image?: string;
    type: "show",
}

export type PageItem = {
    title: string;
    image?: string;
    type: "page",
}

export type URLItem = {
    title: string;
    image?: string;
    type: "url",
}

defineProps<{
    item: Item
}>()

</script>