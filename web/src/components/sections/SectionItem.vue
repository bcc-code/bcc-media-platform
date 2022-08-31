<template>
    <div>
        <div class="rounded bg-primary-light aspect-video">
            <img src="https://brunstadtv.imgix.net/BIHE_S01_E02_MUL.jpg" />
        </div>
        <div class="w-full mt-2 px-1">
            <div class="text-sm truncate text-secondary">
                <slot name="subtitle">
                    <p>{{item.type}}</p>
                </slot>
            </div>
            <p class="truncate">{{ item.title }}</p>
        </div>
    </div>
</template>
<script lang="ts" setup>
export type Item = EpisodeItem | SeasonItem | ShowItem | PageItem | URLItem

export type EpisodeItem = {
    id: string,
    title: string
    image?: string
    type: "episode"
    show?: string
    season?: number
    number?: number
}

export type SeasonItem = {
    id: string,
    title: string
    image?: string
    type: "season"
    show: string
    number: number
}

export type ShowItem = {
    id: string,
    title: string
    image?: string
    type: "show"
}

export type PageItem = {
    id: string,
    title: string
    image?: string
    code: string
    type: "page"
}

export type URLItem = {
    id: string,
    title: string
    image?: string
    type: "url"
}

defineProps<{
    item: Item
}>()
</script>
