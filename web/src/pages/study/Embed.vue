<template>
    <div class="inline-flex flex-col space-y-6 items-center justify-start w-full h-screen">
        <div class="p-4 flex flex-col space-y-0.5  h-14  w-full">
            <div class="w-full right-0 bottom-0">
                <div class="flex items-center justify-start flex-1 h-full pr-56 bg-black bg-opacity-50 rounded-full">
                    <div>
                        <div class="w-28 h-[5px] bg-tint-1 rounded-full"></div>
                    </div>
                </div>
            </div>
            <p class="w-full text-lg leading-normal text-label-3">1 / 3</p>
        </div>
        <QuizQuestion v-model:is-done="isCurrentStepDone"> </QuizQuestion>
        <div class="flex-1"></div>
        <div class="flex flex-col space-y-4 items-center justify-end w-full px-4 h-24">
            <div class="inline-flex space-x-2 items-start justify-start w-full">
                <QuizNavButton @click="nextStep()" :disabled="!anyPreviousStep">Back</QuizNavButton>
                <QuizNavButton @click="nextStep()" :disabled="!isCurrentStepDone">Next</QuizNavButton>
            </div>
            <div class=" inline-flex items-end justify-center w-32 h-8 pt-5 pb-2">
                <div class="flex-1 h-full bg-white rounded-full"></div>
            </div>
        </div>
    </div>
</template>
<script lang="ts" setup>
import { computed, onMounted, ref } from "vue"
import { useI18n } from "vue-i18n"
import { useTitle } from "@/utils/title"
import { analytics } from "@/services/analytics"
import router from "@/router"
import QuizQuestion from "../../components/study/tasks/QuizQuestion.vue"
import { flutterStudy } from "@/utils/flutter"
import QuizNavButton from '../../components/study/LargeButton.vue';

const { t } = useI18n()

const { setTitle } = useTitle()

onMounted(() => {
    setTitle(t("page.study"))
    analytics.page({
        id: "study",
        title: t("page.study"),
    })
})

const isCurrentStepDone = ref(false)

if (!!router.currentRoute.value.query["bg"]) {
    document.body.style.setProperty("--tw-bg-opacity", "1")
}

function nextStep() {
    console.log(`flutterStudy ${flutterStudy}`)
    flutterStudy?.tasksCompleted()
}

const anyPreviousStep = computed(() => false);

</script>

<style>
.bg-background {
    --tw-bg-opacity: 0;
}
</style>
