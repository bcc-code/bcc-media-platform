<script lang="ts" setup>
import { ChapterListChapterFragment } from "@/graph/generated"
import { computed } from "vue"

const props = defineProps<{
    chapters: ChapterListChapterFragment[]
    currentTime: number
}>()

defineEmits<{
    chapterClick: [ChapterListChapterFragment]
}>()

const showHours = computed(() => {
    return props.chapters.some((chapter) => chapter.start >= 3600)
})

function formatSeconds(seconds: number): string {
    const hours = Math.floor(seconds / 3600)
    const remainder = seconds % 3600
    const minutes = Math.floor(remainder / 60)
    const remainingSeconds = remainder % 60

    if (showHours) {
        return `${hours.toString().padStart(2, "0")}:${minutes.toString().padStart(2, "0")}:${remainingSeconds.toString().padStart(2, "0")}`
    } else {
        return `${minutes.toString().padStart(2, "0")}:${remainingSeconds.toString().padStart(2, "0")}`
    }
}

const isActive = (chapter: ChapterListChapterFragment): boolean => {
    const nextChapter = props.chapters.find((c) => c.start > chapter.start)
    return (
        props.currentTime >= chapter.start &&
        (!nextChapter || props.currentTime < nextChapter.start)
    )
}
</script>

<template>
    <ul class="overflow-hidden rounded-lg grid grid-cols-[auto,1fr]">
        <li
            v-for="chapter in chapters"
            :key="chapter.id"
            class="bg-background-2 hover:brightness-150 p-3 cursor-pointer text-style-body-2 grid gap-4 grid-cols-subgrid col-span-2"
            role="button"
            :class="{
                '': !isActive(chapter),
                'brightness-150': isActive(chapter),
            }"
            @click="$emit('chapterClick', chapter)"
        >
            <div class="col-span-1 text-label-3">
                {{ formatSeconds(chapter.start) }}
            </div>
            <div class="col-span-1">
                {{ chapter.title }}
            </div>
        </li>
    </ul>
</template>
