<template>
    <div class="inline-flex flex-col space-y-6 items-center justify-start w-full bg-gray-900 h-screen">
        <div class="p-4 flex flex-col space-y-0.5  h-14  w-full">
            <div class="w-full h-1 right-0 bottom-0">
                <div class="flex items-center justify-start flex-1 h-full pr-56 bg-black bg-opacity-50 rounded-full">
                    <div>
                        <div class="w-28 h-1 bg-blue-400 rounded-full"></div>
                    </div>
                </div>
            </div>
            <p class="w-full text-lg leading-normal text-gray-300">Question 1 / 3</p>
        </div>
        <div class="p-4 flex flex-col space-y-8 items-start justify-start w-full">
            <p class="w-full text-2xl font-extrabold leading-7 text-white">How would you do this, that, and something
                else?</p>
            <div class="flex flex-col space-y-2 items-start justify-start w-full">
                <QuizOption letter="A" text="Option number 1" @click="() => selectAnswer('A')"
                    :selected="selectedAnswer == 'A'" :wrong="(selectedAnswer == 'A' && 'A' != correctAnswer)"
                    :correct="(selectedAnswer == 'A' && 'A' == correctAnswer)" />
                <QuizOption letter="B" text="Option number 2" @click="() => selectAnswer('B')"
                    :selected="selectedAnswer == 'B'" :wrong="(selectedAnswer == 'B' && 'B' != correctAnswer)"
                    :correct="(selectedAnswer == 'B' && 'B' == correctAnswer)" />
                <QuizOption letter="C" text="Option 3 with two sentences and a long description"
                    @click="() => selectAnswer('C')" :wrong="(selectedAnswer == 'C' && 'C' != correctAnswer)"
                    :selected="selectedAnswer == 'C'" :correct="(selectedAnswer == 'C' && 'C' == correctAnswer)" />
                <QuizOption letter="D" text="Option 4 with two sentences and a long description"
                    :selected="selectedAnswer == 'D'" @click="() => selectAnswer('D')"
                    :wrong="(selectedAnswer == 'D' && 'D' != correctAnswer)"
                    :correct="(selectedAnswer == 'D' && 'D' == correctAnswer)" />
            </div>
        </div>
        <div class="flex-1"></div>
        <div class="flex flex-col space-y-4 items-center justify-end w-80 h-24">
            <div class="inline-flex space-x-2 items-start justify-start w-full">
                <div
                    class="flex items-center justify-center flex-1 h-full px-5 py-3 border rounded-full border-indigo-200 border-opacity-10">
                    <p class="flex-1 text-lg font-bold leading-normal text-center text-gray-500">Back</p>
                </div>
                <div
                    class="flex items-center justify-center flex-1 h-full px-5 py-3 border rounded-full border-indigo-200 border-opacity-10">
                    <p class="flex-1 text-lg font-bold leading-normal text-center text-gray-500">Next</p>
                </div>
            </div>
            <div class="inline-flex items-end justify-center w-32 h-8 pt-5 pb-2">
                <div class="flex-1 h-full bg-white rounded-full" />
            </div>
        </div>
    </div>
</template>
<script lang="ts" setup>
import { ChevronLeft, ChevronRight } from "@/components/icons"
import Player from "@/components/live/Player.vue"
import { getWeek } from "@/utils/date"
import { computed, onMounted, Ref, ref } from "vue"
import { useGetLiveCalendarRangeQuery } from "@/graph/generated"
import DayQuery from "@/components/calendar/DayQuery.vue"
import { useI18n } from "vue-i18n"
import { useTitle } from "@/utils/title"
import { analytics } from "@/services/analytics"
import router from "@/router"
import QuizOption from "@/components/study/quiz/QuizOption.vue"

const { t } = useI18n()

const { setTitle } = useTitle()

onMounted(() => {
    setTitle(t("page.study"))
    analytics.page({
        id: "study",
        title: t("page.study"),
    })
})

let correctAnswer = 'C';
var selectedAnswer: Ref<String> = ref('');

function selectAnswer(answer: String) {
    selectedAnswer.value = answer;
    console.log(selectedAnswer)
    if (answer == correctAnswer) {

    }
}

if (!!router.currentRoute.value.query["bg"]) {
    document.body.style.setProperty("--tw-bg-opacity", "1");
}
</script>

<style>
.bg-background {
    --tw-bg-opacity: 0;
}
</style>