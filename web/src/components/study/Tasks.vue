<template>
    <div class="inline-flex flex-col space-y-6 items-center justify-start w-full h-screen">
        <div class="p-4 flex flex-col space-y-0.5  h-14  w-full">
            <template v-if="(tasks.length > 1)">
                <div class="w-full right-0 bottom-0">
                    <div class="flex-1 h-full bg-black bg-opacity-50 rounded-full">
                        <div>
                            <div class="w-28 h-[5px] bg-tint-1 rounded-full" :style="{ width: `${taskPercent}%` }">
                            </div>
                        </div>
                    </div>
                </div>
                <p class="w-full text-lg leading-normal text-label-3">{{ (currentTaskIndex + 1)
                }} / {{ tasks.length }}</p>
            </template>
        </div>
        <AlternativesTask v-if="currentTask?.__typename == 'AlternativesTask'" v-model:task="currentTask"
            :key="currentTask.id" v-model:is-done="isCurrentStepDone" />
        <div class="flex-1"></div>
        <div class="flex flex-col space-y-4 items-center justify-end w-full px-4 h-24" v-if="(tasks.length > 1)">
            <div class="inline-flex space-x-2 items-start justify-start w-full">
                <QuizNavButton @click="previousStep()" :disabled="!anyPreviousStep" color="secondary">Back
                </QuizNavButton>
                <QuizNavButton @click="nextStep()" :disabled="!isCurrentStepDone">
                    <template v-if="isLastTask">Done</template>
                    <template v-else>Next</template>
                </QuizNavButton>
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
import AlternativesTask from "./tasks/AlternativesTask.vue"
import { flutterStudy } from "@/utils/flutter"
import QuizNavButton from '../../components/study/LargeButton.vue';
import {
    GetStudyLessonQuery,
    useGetStudyLessonQuery
} from "@/graph/generated"
import { useRoute } from "vue-router"

const props = defineProps<{ lesson: GetStudyLessonQuery }>()
const { error, fetching, data, executeQuery, ...lessonQuery } = useGetStudyLessonQuery({ pause: props.lesson.studyLesson.id == null, variables: { id: props.lesson.studyLesson.id.toString() } });

const { t } = useI18n()

const { setTitle } = useTitle()

const currentTaskIndex = ref(0);
const tasks = computed(() => props.lesson.studyLesson.tasks.items)
const currentTask = computed(() => tasks.value[currentTaskIndex.value]);
const isLastTask = computed(() => currentTaskIndex.value + 1 == tasks.value.length);
//const taskProgress = ref<{ id: string, completed: boolean }[]>([]);

onMounted(() => {
    setTitle(t("page.study"))
    analytics.page({
        id: "study",
        title: t("page.study"),
    })
    lessonQuery.then((val) => {
        const data = val.data.value;
        if (data == null) return;
        //taskProgress.value = data.studyLesson.tasks.items.map((task) => ({ id: task.id, completed: task.completed }));
    })
})

const isCurrentStepDone = ref(false)
const taskPercent = computed(() => (currentTaskIndex.value + 1) / tasks.value.length * 100);


function previousStep() {
    console.log(`flutterStudy ${flutterStudy}`)
    if (currentTaskIndex.value > 0) {
        currentTaskIndex.value -= 1;
    }
}
function nextStep() {
    console.log(`flutterStudy ${flutterStudy}`)
    if (!isLastTask.value) {
        currentTaskIndex.value += 1;
    } else {
        flutterStudy?.tasksCompleted()
    }
}

const anyPreviousStep = computed(() => currentTaskIndex.value > 0);

</script>