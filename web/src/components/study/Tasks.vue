<template>
    <div class="w-full h-full">
        <div
            class="inline-flex flex-col space-y-6 items-center justify-start w-full embed:pb-36 embed:hide-scrollbar"
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
            <CompetitionIntro
                v-model:is-done="isCurrentStepDone"
                v-if="hijackWithCompetitionIntro"
            ></CompetitionIntro>
            <div
                v-else-if="
                    currentTask?.__typename == 'AlternativesTask' &&
                    lockData?.lockLessonAnswers
                "
                class="flex flex-col items-center justify-center w-full h-full pb-8 px-4 embed:pb-64 embed:min-h-screen"
            >
                <p class="w-full text-white text-style-headline-1 text-center">
                    {{ t("thankYou") }}
                </p>
                <p
                    class="mt-3 w-full text-white text-style-body-1 text-label-3 text-center"
                >
                    {{ t("yourResponseHasBeenSubmitted") }}
                    <br />
                    <br />
                    {{ t("competition.dontMiss") }}
                </p>
            </div>
            <AlternativesTask
                v-else-if="currentTask?.__typename == 'AlternativesTask'"
                v-model:task="currentTask"
                :key="'alt' + currentTask.id"
                v-model:is-done="isCurrentStepDone"
                @competition-answer="
                    (v) => {
                        competitionAnswers[v.taskId] = v.alternativeId
                    }
                "
            />
            <TextTask
                v-else-if="currentTask?.__typename == 'TextTask'"
                v-model:task="currentTask"
                :key="'text' + currentTask.id"
                v-model:is-done="isCurrentStepDone"
                @next-task="() => nextTask()"
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
            />
            <LinkTask
                v-else-if="currentTask?.__typename == 'LinkTask'"
                v-model:task="currentTask"
                :key="'link' + currentTask.id"
                v-model:is-done="isCurrentStepDone"
            />
            <div v-else>
                {{ (currentTask as any)?.__typename }}
            </div>
        </div>
        <div
            class="flex flex-col space-y-4 items-center justify-end w-full px-4 h-36 pb-16 sticky bottom-0 bg-background-1"
            :class="showAlreadySentHint ? 'h-48' : ''"
            v-if="
                !(currentTask?.__typename == 'TextTask' && !isCurrentStepDone)
            "
        >
            <p
                class="text-style-caption-1 text-tint-3 text-center"
                v-if="showAlreadySentHint"
            >
                {{ t("competition.alreadySent") }}
            </p>
            <div class="inline-flex space-x-2 items-start justify-start w-full">
                <VButton
                    class="w-full"
                    size="large"
                    v-if="tasks.length > 1"
                    @click="previousTask()"
                    :disabled="
                        !(
                            anyPreviousStep ||
                            (currentIsFirstCompetitionTask &&
                                !hijackWithCompetitionIntro)
                        )
                    "
                    color="secondary"
                >
                    {{ t("buttons.back") }}
                </VButton>
                <VButton
                    v-if="hijackWithCompetitionIntro"
                    class="w-full"
                    size="large"
                    @click="() => startCompetition()"
                    :disabled="!isCurrentStepDone || consentLoading"
                    ><Loader
                        v-if="consentLoading"
                        variant="spinner"
                        class="fill-white text-center inline"
                    ></Loader>
                    <template v-if="!competitionLocked">{{
                        t("buttons.start")
                    }}</template>
                    <template v-else>
                        {{ t("buttons.continue") }}
                    </template>
                </VButton>
                <VButton
                    v-else-if="
                        currentIsLastCompetitionTask &&
                        !lockData &&
                        !competitionLocked
                    "
                    class="w-full"
                    size="large"
                    @click="
                        () => {
                            showConfirmModal = true
                        }
                    "
                    :disabled="!isCurrentStepDone"
                >
                    {{ t("buttons.submit") }}
                </VButton>
                <VButton
                    v-else
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
        <ModalBase v-model:visible="showConfirmModal" class="bg-background-2">
            <div class="p-8">
                <h2 class="text-style-headline-2 text-on-tint">
                    {{ t("competition.areYouSure") }}
                </h2>
                <p class="mt-2 text-style-body-2 text-label-3">
                    {{ t("competition.lookThouroughly") }}
                </p>
                <div class="mt-4 flex space-x-4">
                    <VButton
                        class="flex-1"
                        color="secondary"
                        size="large"
                        @click="() => (showConfirmModal = false)"
                        >{{ t("buttons.cancel") }}</VButton
                    >
                    <VButton class="flex-1" size="large" @click="lockAnswers">
                        <svg
                            v-if="lockingInProgress"
                            aria-hidden="true"
                            class="-mt-1 inline w-6 h-6 -ml-1 mr-1 text-transparent animate-spin fill-white"
                            viewBox="0 0 100 101"
                            fill="none"
                            xmlns="http://www.w3.org/2000/svg"
                        >
                            <path
                                d="M100 50.5908C100 78.2051 77.6142 100.591 50 100.591C22.3858 100.591 0 78.2051 0 50.5908C0 22.9766 22.3858 0.59082 50 0.59082C77.6142 0.59082 100 22.9766 100 50.5908ZM9.08144 50.5908C9.08144 73.1895 27.4013 91.5094 50 91.5094C72.5987 91.5094 90.9186 73.1895 90.9186 50.5908C90.9186 27.9921 72.5987 9.67226 50 9.67226C27.4013 9.67226 9.08144 27.9921 9.08144 50.5908Z"
                                fill="currentColor"
                            />
                            <path
                                d="M93.9676 39.0409C96.393 38.4038 97.8624 35.9116 97.0079 33.5539C95.2932 28.8227 92.871 24.3692 89.8167 20.348C85.8452 15.1192 80.8826 10.7238 75.2124 7.41289C69.5422 4.10194 63.2754 1.94025 56.7698 1.05124C51.7666 0.367541 46.6976 0.446843 41.7345 1.27873C39.2613 1.69328 37.813 4.19778 38.4501 6.62326C39.0873 9.04874 41.5694 10.4717 44.0505 10.1071C47.8511 9.54855 51.7191 9.52689 55.5402 10.0491C60.8642 10.7766 65.9928 12.5457 70.6331 15.2552C75.2735 17.9648 79.3347 21.5619 82.5849 25.841C84.9175 28.9121 86.7997 32.2913 88.1811 35.8758C89.083 38.2158 91.5421 39.6781 93.9676 39.0409Z"
                                fill="currentFill"
                            />
                        </svg>
                        <template v-else>
                            {{ t("buttons.submit") }}</template
                        ></VButton
                    >
                </div>
            </div>
        </ModalBase>
        <ModalBase v-model:visible="showConsentModal" class="bg-background-2">
            <div class="p-8 text-center">
                <h2 class="text-style-headline-2 text-on-tint">
                    {{ t("competition.joinCompetition") }}
                </h2>
                <p class="mt-2 text-style-body-2 text-label-3">
                    {{ t("competition.terms") }}
                </p>
                <div class="mt-4 flex space-x-4">
                    <VButton
                        class="flex-1"
                        color="red"
                        size="large"
                        @click="() => skipCompetition()"
                        >{{ t("buttons.skip") }}</VButton
                    >
                    <VButton
                        class="flex-1 bg-separator-on-light"
                        size="large"
                        color="secondary"
                        :disabled="consentSaving"
                        @click="() => consentAndStartCompetition()"
                    >
                        <svg
                            v-if="consentSaving"
                            aria-hidden="true"
                            class="-mt-1 inline w-6 h-6 -ml-1 mr-1 text-transparent animate-spin fill-tint-1"
                            viewBox="0 0 100 101"
                            fill="none"
                            xmlns="http://www.w3.org/2000/svg"
                        >
                            <path
                                d="M100 50.5908C100 78.2051 77.6142 100.591 50 100.591C22.3858 100.591 0 78.2051 0 50.5908C0 22.9766 22.3858 0.59082 50 0.59082C77.6142 0.59082 100 22.9766 100 50.5908ZM9.08144 50.5908C9.08144 73.1895 27.4013 91.5094 50 91.5094C72.5987 91.5094 90.9186 73.1895 90.9186 50.5908C90.9186 27.9921 72.5987 9.67226 50 9.67226C27.4013 9.67226 9.08144 27.9921 9.08144 50.5908Z"
                                fill="currentColor"
                            />
                            <path
                                d="M93.9676 39.0409C96.393 38.4038 97.8624 35.9116 97.0079 33.5539C95.2932 28.8227 92.871 24.3692 89.8167 20.348C85.8452 15.1192 80.8826 10.7238 75.2124 7.41289C69.5422 4.10194 63.2754 1.94025 56.7698 1.05124C51.7666 0.367541 46.6976 0.446843 41.7345 1.27873C39.2613 1.69328 37.813 4.19778 38.4501 6.62326C39.0873 9.04874 41.5694 10.4717 44.0505 10.1071C47.8511 9.54855 51.7191 9.52689 55.5402 10.0491C60.8642 10.7766 65.9928 12.5457 70.6331 15.2552C75.2735 17.9648 79.3347 21.5619 82.5849 25.841C84.9175 28.9121 86.7997 32.2913 88.1811 35.8758C89.083 38.2158 91.5421 39.6781 93.9676 39.0409Z"
                                fill="currentFill"
                            />
                        </svg>
                        <template v-else>
                            {{ t("buttons.join") }}</template
                        ></VButton
                    >
                </div>
            </div>
        </ModalBase>
    </div>
</template>
<script lang="ts" setup>
import { computed, onMounted, ref, watch } from "vue"
import { useI18n } from "vue-i18n"
import { useTitle } from "@/utils/title"
import { analytics } from "@/services/analytics"
import AlternativesTask from "./tasks/AlternativesTask.vue"
import PosterTask from "./tasks/PosterTask.vue"
import { flutterStudy } from "@/utils/flutter"
import {
    GetStudyLessonQuery,
    useCompleteTaskMutation,
    useGetFirstSotmLessonForConsentQuery,
    useLockAnswersMutation,
    useSetStudyConsentTrueMutation,
} from "@/graph/generated"
import TextTask from "./tasks/TextTask.vue"
import { VButton } from ".."
import { Page } from "./Lesson.vue"
import VideoTask from "./tasks/VideoTask.vue"
import LinkTask from "./tasks/LinkTask.vue"
import Loader from "../Loader.vue"
import CompetitionIntro from "./tasks/CompetitionIntro.vue"
import ModalBase from "./ModalBase.vue"
import { findLastIndex } from "@/utils/array"

const props = defineProps<{ lesson: GetStudyLessonQuery }>()
const { executeMutation: completeTask } = useCompleteTaskMutation()
const { t } = useI18n()
const { setTitle } = useTitle()

const { executeMutation: executeLockAnswersMutation, data: lockData } =
    useLockAnswersMutation()

const emit = defineEmits<{
    (e: "navigate", i: Page): any
}>()

const tasks = computed(() => {
    return props.lesson.studyLesson.tasks.items
})

const currentTaskIndex = ref(0)
const currentTask = computed(() => tasks.value[currentTaskIndex.value])
const isLastTask = computed(
    () => currentTaskIndex.value + 1 == tasks.value.length
)

const showConfirmModal = ref(false)
const currentIsFirstCompetitionTask = computed(
    () =>
        tasks.value.findIndex(
            (t) => t.__typename == "AlternativesTask" && t.competitionMode
        ) === currentTaskIndex.value
)
const currentIsLastCompetitionTask = computed(() => {
    return (
        findLastIndex(
            tasks.value,
            (t) => t.__typename == "AlternativesTask" && t.competitionMode
        ) === currentTaskIndex.value
    )
})
const competitionLocked = computed(
    () =>
        currentTask.value.__typename === "AlternativesTask" &&
        currentTask.value.locked
)
const hijackWithCompetitionIntro = ref(false)

watch(
    currentTaskIndex,
    (val, old) => {
        if ((!old || val > old) && currentIsFirstCompetitionTask.value)
            hijackWithCompetitionIntro.value = true
    },
    { immediate: true }
)
const hasConsented = () => {
    return (
        lockData.value?.lockLessonAnswers ||
        competitionLocked.value === true ||
        consentSaveResult.value?.completeTask === true ||
        consent.value?.studyLesson.tasks.items.some(
            (t) =>
                t.__typename === "AlternativesTask" &&
                t.alternatives.find(
                    (a) => a.id === "fe8c23c2-0aab-4853-a75f-f148400d005a"
                )?.selected === true
        )
    )
}

const showAlreadySentHint = computed(
    () => hijackWithCompetitionIntro.value && competitionLocked.value
)
const competitionAnswers = ref<{ [taskId: string]: string }>({})
const showConsentModal = ref(false)
const lockingInProgress = ref(false)
const {
    fetching: consentLoading,
    data: consent,
    executeQuery: refreshConsent,
    resume: resumeConsentQuery,
    stale: staleq,
} = useGetFirstSotmLessonForConsentQuery()
const {
    fetching: consentSaving,
    executeMutation: setConsentTrue,
    data: consentSaveResult,
} = useSetStudyConsentTrueMutation()
const consentAndStartCompetition = async () => {
    var result = await setConsentTrue({})
    if (result.error === null) {
        console.error(result.error)
        return
    }
    showConsentModal.value = false
    startCompetition(true)
}
const startCompetition = async (bypassConsentCheck?: boolean) => {
    if (lockData.value?.lockLessonAnswers) {
        hijackWithCompetitionIntro.value = false
        return
    }
    if (bypassConsentCheck !== true && !hasConsented()) {
        showConsentModal.value = true
        return
    }
    hijackWithCompetitionIntro.value = false
    isCurrentStepDone.value = false
}
//const taskProgress = ref<{ id: string, completed: boolean }[]>([]);

onMounted(() => {
    setTitle("")
    analytics.page({
        id: "study",
        title: t(""),
    })
})

const isCurrentStepDone = ref(false)
const taskPercent = computed(
    () => ((currentTaskIndex.value + 1) / tasks.value.length) * 100
)
const allCompletedBeforeStarting = tasks.value.every((t) => t.completed)

function previousTask() {
    if (hijackWithCompetitionIntro.value && anyPreviousStep.value) {
        hijackWithCompetitionIntro.value = false
        currentTaskIndex.value--
        return
    }
    if (currentIsFirstCompetitionTask.value) {
        hijackWithCompetitionIntro.value = true
        return
    }
    if (currentTaskIndex.value > 0) {
        currentTaskIndex.value -= 1
        isCurrentStepDone.value = true
    }
}

const savingTaskProgress = ref(false)
async function nextTask() {
    const skipSave = currentTask.value.__typename == "AlternativesTask"
    if (!isLastTask.value) {
        // intentionally not awaiting
        if (!skipSave) await completeTask({ taskId: currentTask.value.id })
        currentTask.value.completed = true
        currentTaskIndex.value += 1
        isCurrentStepDone.value = false
        if (
            currentTask.value.__typename == "AlternativesTask" &&
            lockData?.value?.lockLessonAnswers
        ) {
            isCurrentStepDone.value = true
        }
    } else {
        // done with the tasks
        // awaiting to avoid race condition with achievements
        savingTaskProgress.value = true
        if (!skipSave) await completeTask({ taskId: currentTask.value.id })
        await new Promise((r) => setTimeout(r, 100))
        currentTask.value.completed = true
        savingTaskProgress.value = false
        if (!allCompletedBeforeStarting) {
            flutterStudy?.tasksCompleted()
        }
        emit("navigate", "more")
    }
}

const skipCompetition = () => {
    tasks.value
        .filter((t) => t.__typename == "AlternativesTask" && t.competitionMode)
        .forEach(
            async (t) =>
                await completeTask({ taskId: t.id, selectedAlternatives: [] })
        )
    const lastCompetitionTaskIndex = findLastIndex(
        tasks.value,
        (t) => t.__typename == "AlternativesTask" && t.competitionMode
    )
    currentTaskIndex.value = lastCompetitionTaskIndex
    nextTask()
    hijackWithCompetitionIntro.value = false
}

const lockAnswers = async () => {
    lockingInProgress.value = true
    try {
        const answers = competitionAnswers.value
        let promises: Promise<any>[] = []
        for (var taskId in answers) {
            const alternativeId = answers[taskId]
            if (alternativeId == null) {
                throw new Error(
                    `Tried to lock, but ${taskId} has null alternative selected.
                    competitionAnswers: ${JSON.stringify(answers)}`
                )
            }
            promises.push(
                completeTask({
                    taskId,
                    selectedAlternatives: [alternativeId],
                })
            )
        }
        await Promise.all(promises)
        await new Promise((r) => setTimeout(r, 200))
        await executeLockAnswersMutation({
            lessonId: props.lesson.studyLesson.id,
        })
        showConfirmModal.value = false
    } finally {
        lockingInProgress.value = false
    }
}

const anyPreviousStep = computed(() => currentTaskIndex.value > 0)
</script>
