<template>
    <div class="w-full h-full">
        <div
            class="inline-flex flex-col space-y-6 items-center justify-start w-full h-full overflow-auto embed:hide-scrollbar"
        >
            <div class="p-4 flex flex-col space-y-0.5 h-14 w-full">
                <template v-if="tasks.length > 1">
                    <div class="w-full right-0 bottom-0">
                        <div
                            class="flex-1 h-full bg-black bg-opacity-50 rounded-full"
                        >
                            <div>
                                <div
                                    class="w-28 h-[5px] bg-tint-1 rounded-full"
                                    :style="{ width: `${taskPercent}%` }"
                                ></div>
                            </div>
                        </div>
                    </div>
                    <p class="w-full text-lg leading-normal text-label-3">
                        {{ currentTaskIndex + 1 }} / {{ tasks.length }}
                    </p>
                </template>
            </div>
            <TextTask
                v-if="currentTask?.__typename == 'TextTask'"
                v-model:task="currentTask"
                :key="'text' + currentTask.id"
                v-model:is-done="isCurrentStepDone"
            />
            <AlternativesTask
                v-else-if="currentTask?.__typename == 'AlternativesTask'"
                v-model:task="currentTask"
                :key="'alt' + currentTask.id"
                v-model:is-done="isCurrentStepDone"
            />
            <PosterTask
                v-else-if="
                    currentTask?.__typename == 'PosterTask' ||
                    currentTask?.__typename == 'QuoteTask'
                "
                v-model:task="currentTask"
                :key="'poster' + currentTask.id"
                v-model:is-done="isCurrentStepDone"
            />
            <VideoTask
                v-else-if="currentTask?.__typename == 'VideoTask'"
                v-model:task="currentTask"
                :key="'video' + currentTask.id"
                v-model:is-done="isCurrentStepDone"
                @next-task="() => nextTask()"
            />
            <LinkTask
                v-else-if="currentTask?.__typename == 'LinkTask'"
                v-model:task="currentTask"
                :key="'link' + currentTask.id"
                v-model:is-done="isCurrentStepDone"
                @next-task="() => nextTask()"
            />
            <div v-else>
                {{ (currentTask as any)?.__typename }}
            </div>
        </div>
        <div
            class="flex flex-col space-y-4 items-center justify-end w-full px-4 h-36 pb-16 sticky bottom-0 bg-background-1"
            v-if="
                !(currentTask?.__typename == 'TextTask' && !isCurrentStepDone)
            "
        >
            <div class="inline-flex space-x-2 items-start justify-start w-full">
                <VButton
                    class="w-full"
                    size="large"
                    v-if="tasks.length > 1"
                    @click="previousTask()"
                    :disabled="!anyPreviousStep"
                    color="secondary"
                >
                    {{ t("buttons.back") }}
                </VButton>
                <VButton
                    class="w-full"
                    size="large"
                    @click="nextTask()"
                    :disabled="!isCurrentStepDone"
                >
                    <template v-if="savingTaskProgress"
                        ><Loader
                            variant="spinner"
                            class="fill-white text-center inline"
                        ></Loader
                    ></template>
                    <template v-else-if="isLastTask">{{
                        t("buttons.continue")
                    }}</template>
                    <template v-else>{{ t("buttons.next") }}</template>
                </VButton>
            </div>
        </div>
    </div>
</template>
<script lang="ts" setup>
import { computed, onMounted, ref } from "vue"
import { useI18n } from "vue-i18n"
import { useTitle } from "@/utils/title"
import { analytics } from "@/services/analytics"
import AlternativesTask from "./tasks/AlternativesTask.vue"
import PosterTask from "./tasks/PosterTask.vue"
import { flutterStudy } from "@/utils/flutter"
import {
    GetStudyLessonQuery,
    useCompleteTaskMutation,
    useGetStudyLessonQuery,
} from "@/graph/generated"
import { useRoute } from "vue-router"
import TextTask from "./tasks/TextTask.vue"
import { VButton } from ".."
import { Page } from "./Lesson.vue"
import VideoTask from "./tasks/VideoTask.vue"
import LinkTask from "./tasks/LinkTask.vue"
import Loader from "../Loader.vue"

const props = defineProps<{ lesson: GetStudyLessonQuery }>()
const { executeMutation } = useCompleteTaskMutation()
const { t } = useI18n()
const { setTitle } = useTitle()

const emit = defineEmits<{
    (e: "navigate", i: Page): any
}>()

function moveToEnd(array: any[], index: number) {
    return array.push(array.splice(index, 1)[0])
}

const tasks = computed(() => {
    return props.lesson.studyLesson.tasks.items
})

const currentTaskIndex = ref(0)
const currentTask = computed(() => tasks.value[currentTaskIndex.value])
const isLastTask = computed(
    () => currentTaskIndex.value + 1 == tasks.value.length
)
//const taskProgress = ref<{ id: string, completed: boolean }[]>([]);

onMounted(() => {
    setTitle(t("page.study"))
    analytics.page({
        id: "study",
        title: t("page.study"),
    })
})

const isCurrentStepDone = ref(false)
const taskPercent = computed(
    () => ((currentTaskIndex.value + 1) / tasks.value.length) * 100
)

function previousTask() {
    if (currentTaskIndex.value > 0) {
        currentTaskIndex.value -= 1
        isCurrentStepDone.value = true
    }
}

const savingTaskProgress = ref(false)
async function nextTask() {
    if (!isLastTask.value) {
        // intentionally not awaiting
        executeMutation({ taskId: currentTask.value.id })
        currentTaskIndex.value += 1
        isCurrentStepDone.value = false
    } else {
        // done with the tasks
        // awaiting to avoid race condition with achievements
        savingTaskProgress.value = true
        await executeMutation({ taskId: currentTask.value.id })
        await new Promise((r) => setTimeout(r, 100))
        savingTaskProgress.value = false
        flutterStudy?.tasksCompleted()
        emit("navigate", "more")
    }
}

const anyPreviousStep = computed(() => currentTaskIndex.value > 0)
</script>
