<template>
    <div class="max-w-screen-sm mx-auto px-32">
        <router-link
            :to="`/episode/${episodeId}`"
            class="mx-4 flex items-center text-tint-1 text-style-button-2"
        >
            <svg
                class="mr-2"
                width="11"
                height="18"
                viewBox="0 0 11 18"
                fill="none"
                xmlns="http://www.w3.org/2000/svg"
            >
                <path d="M10 1L2 9L10 17" stroke="#6EB0E6" stroke-width="2" />
            </svg>
            {{ t("episode.episode") }}
        </router-link>
        <Lesson
            :episodeId="episodeId"
            :lessonId="lessonId"
            :subRoute="subRoute"
        ></Lesson>
    </div>
</template>
<script lang="ts" setup>
import Lesson, { Page } from "@/components/study/Lesson.vue"
import { useI18n } from "vue-i18n"
const { t } = useI18n()
const props = defineProps<{
    episodeId: string
    lessonId: string
    subRoute: Page
}>()
</script>
