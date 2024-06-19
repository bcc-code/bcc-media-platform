<template>
    <div class="w-full">
        <template v-if="lesson.studyLesson.tasks.items.length > 0">
            <div class="p-4 pt-4">
                <TaskButton
                    title="a"
                    secondary-title="b"
                    @click="() => emit('navigate', 'tasks')"
                ></TaskButton>
                <div class="mt-6">
                    <p class="w-full text-white text-style-title-1">
                        {{ t("lesson.watchAgain.title") }}
                    </p>
                    <p
                        class="mt-1 w-full text-white text-style-body-2 text-label-3"
                    >
                        {{ t("lesson.watchAgain.description") }}
                    </p>
                    <div
                        class="cursor-pointer mt-4 rounded-xl aspect-video bg-background-2 overflow-hidden z-10 relative"
                        @click="playAgain"
                    >
                        <div
                            class="bg-gradient-to-b from-[#ffffff00] to-[#000000B3] flex w-full h-full"
                        >
                            <img
                                class="object-cover relative -z-10"
                                :src="episode.image ?? ''"
                            />
                        </div>
                        <div
                            class="absolute top-0 w-full h-full border border-separator-on-light z-40"
                        ></div>
                        <div
                            class="absolute top-0 flex items-center justify-center w-full h-full"
                        >
                            <VButton
                                size="thin"
                                @click="playAgain"
                                class="z-20"
                            >
                                <svg
                                    class="inline-block mr-2 -mt-1"
                                    width="19"
                                    height="21"
                                    viewBox="0 0 19 21"
                                    fill="none"
                                    xmlns="http://www.w3.org/2000/svg"
                                >
                                    <path
                                        d="M1.30225 11.5C1.30225 15.9183 4.88397 19.5 9.30225 19.5C13.7205 19.5 17.3022 15.9183 17.3022 11.5C17.3022 7.08172 13.7205 3.5 9.30225 3.5"
                                        stroke="white"
                                        stroke-width="2"
                                    />
                                    <path
                                        fill-rule="evenodd"
                                        clip-rule="evenodd"
                                        d="M5.93234 4.49976C5.09222 4.05128 5.09222 2.94872 5.93234 2.50024L9.37608 0.661902C9.80722 0.431749 10.2952 0.460804 10.6722 0.661902C11.0401 0.858223 11.3022 1.21851 11.3022 1.66166V5.33834C11.3022 6.23542 10.2281 6.79294 9.37608 6.3381L5.93234 4.49976Z"
                                        fill="white"
                                    />
                                </svg>
                                <span>{{ t("lesson.watchAgain.button") }}</span>
                            </VButton>
                        </div>
                        <div
                            class="absolute top-0 items-end flex w-full h-full"
                            @click="playAgain"
                        >
                            <div class="mb-5 ml-4 text-style-title-3">
                                {{ episode.title }}
                            </div>
                        </div>
                    </div>
                    <div
                        class="mt-4"
                        v-if="
                            isProbablyAnimation &&
                            (!feedbackSentPreviously || feedbackSentNow)
                        "
                    >
                        <h2 class="text-style-title-2">
                            {{ t("feedback.howEasyToUnderstand") }}
                        </h2>
                        <p class="mt-1 text-style-body-2 text-label-3">
                            {{ t("feedback.anonymousInfo") }}
                        </p>
                        <FeedbackRatingAndForm
                            :episode-id="episode.id"
                            class="mt-2.5"
                            @sent="() => registerFeedbackSent()"
                        >
                        </FeedbackRatingAndForm>
                    </div>
                </div>
            </div>
        </template>
        <div
            class="my-4 embed:mb-24"
            v-if="lesson.studyLesson.links.items.length > 0"
        >
            <p class="ml-4 text-white text-style-title-1">
                {{ t("lesson.related") }}
            </p>
            <LinkListItem
                v-for="link in lesson.studyLesson.links.items"
                :link="link"
            />
        </div>
    </div>
</template>

<script lang="ts" setup>
import { GetStudyLessonQuery } from "@/graph/generated"
import { useI18n } from "vue-i18n"
import LinkListItem from "./LinkListItem.vue"
import TaskButton from "./TaskButton.vue"
import { Page } from "./Lesson.vue"
import { VButton } from ".."
import { computed, ref } from "vue"
import { webViewMain } from "@/services/webviews/mainHandler"
import router from "@/router"
import FeedbackRatingAndForm from "../feedback/FeedbackRatingAndForm.vue"

const { t } = useI18n()
const props = defineProps<{ lesson: GetStudyLessonQuery }>()
const episode = computed(() => props.lesson.episode)

const feedbackSentPreviously =
    localStorage.getItem(episode.value.id + ":feedback_sent") == "true"
const feedbackSentNow = ref(false)

const registerFeedbackSent = () => {
    feedbackSentNow.value = true
    localStorage.setItem(episode.value.id + ":feedback_sent", "true")
}

const isProbablyAnimation = computed(
    () =>
        !episode.value.title.toLowerCase().includes("kåre") &&
        ![
            "1724",
            "1733",
            "1735",
            "1746",
            "1750",
            "1753",
            "1761",
            "1762",
            "1803",
            "1808",
            "1813",
            "1814",
        ].includes(episode.value.id)
)

const emit = defineEmits<{
    (e: "navigate", i: Page): any
}>()

const playAgain = () => {
    if (webViewMain) {
        webViewMain.navigate("/episode/" + episode.value.id)
        return
    }
    router.push("/episode/" + episode.value.id)
}
</script>
