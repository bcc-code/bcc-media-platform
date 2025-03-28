<script lang="ts" setup>
import { computed, onMounted, ref, watch } from 'vue'
import { useI18n } from 'vue-i18n'
import { useTitle } from '@/utils/title'
import { analytics } from '@/services/analytics'
import AlternativesTask from './tasks/AlternativesTask.vue'
import PosterTask from './tasks/PosterTask.vue'
import {
    webViewStudy,
    WebViewStudyHandlerCompletedTask,
} from '@/services/webviews/studyHandler'
import {
    GetStudyLessonQuery,
    useCompleteTaskMutation,
    useGetTaskAlternativesForStudyLessonQuery,
    useLockAnswersMutation,
} from '@/graph/generated'
import TextTask from './tasks/TextTask.vue'
import { VButton } from '..'
import { Page } from './Lesson.vue'
import VideoTask from './tasks/VideoTask.vue'
import LinkTask from './tasks/LinkTask.vue'
import Loader from '../Loader.vue'
import ModalBase from './ModalBase.vue'
import { findLastIndex } from '@/utils/array'
import { Auth } from '@/services/auth'
import { webViewMain } from '@/services/webviews/mainHandler'

const props = defineProps<{ lesson: GetStudyLessonQuery }>()
const { executeMutation: completeTask } = useCompleteTaskMutation()
const { t } = useI18n()
const { setTitle } = useTitle()

const { executeMutation: executeLockAnswersMutation, data: lockData } =
    useLockAnswersMutation()

const { data: alternativesData, executeQuery: executeAlternativesQuery } =
    useGetTaskAlternativesForStudyLessonQuery({
        variables: { lessonId: props.lesson.studyLesson.id },
    })

const alternativesDataComp = computed(() =>
    alternativesData.value?.studyLesson.tasks.items
        .filter((t) => t.__typename === 'AlternativesTask')
        .map((t) => ({ taskId: t.id, alternatives: t.alternatives }))
)

const emit = defineEmits<{
    (e: 'navigate', i: Page): any
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
const currentIsFirstTask = computed(
    () =>
        tasks.value.findIndex((t) => t.__typename == 'AlternativesTask') ===
        currentTaskIndex.value
)
const currentIsLastTask = computed(() => {
    return (
        findLastIndex(
            tasks.value,
            (t) => t.__typename == 'AlternativesTask'
        ) === currentTaskIndex.value
    )
})

const lockingInProgress = ref(false)

onMounted(() => {
    setTitle('')
    analytics.page({
        id: 'study',
        title: t(''),
    })
})

const isCurrentTaskAnswered = ref(false)
const taskPercent = computed(
    () => ((currentTaskIndex.value + 1) / tasks.value.length) * 100
)
const allCompletedBeforeStarting = tasks.value.every((t) => t.completed)

function previousTask() {
    if (anyPreviousStep.value) {
        currentTaskIndex.value--
        return
    }
    if (currentIsFirstTask.value) {
        emit('navigate', 'intro')
        return
    }
    if (currentTaskIndex.value > 0) {
        currentTaskIndex.value -= 1
        isCurrentTaskAnswered.value = true
    }
}

const isCurrentTaskAnswerSelectionConfirmed = ref(false)
function confirmAnswer() {
    isCurrentTaskAnswerSelectionConfirmed.value = true
    isCurrentTaskAnswered.value = true
    currentTask.value.completed = true

    const answer = alternativeAnswers.value[currentTask.value.id]
    if (!answer) {
        analytics.track('error', {
            message: 'lesson task answer is undefined',
            data: {
                taskId: currentTask.value.id,
                alternativeAnswers: alternativeAnswers.value,
            },
        })
        return
    }
    completeTask({
        taskId: answer.taskId,
        selectedAlternatives: [answer.alternativeId],
    })
    sendAnswersToBMM([
        {
            answerId: answer.alternativeId,
            questionId: answer.taskId,
            answeredCorrectly: answer.isCorrect,
        },
    ])
}
watch(
    currentTask,
    () => {
        if (currentTask.value.__typename != 'AlternativesTask') return

        if (currentTask.value.completed) {
            isCurrentTaskAnswerSelectionConfirmed.value = true
        } else {
            isCurrentTaskAnswerSelectionConfirmed.value = false
        }
    },
    {
        immediate: true,
    }
)

const alternativeAnswers = ref<{
    [taskId: string]: {
        taskId: string
        alternativeId: string
        isCorrect: boolean
    }
}>({})

const { locale } = useI18n()
const savingTaskProgress = ref(false)
async function nextTask() {
    const skipSave = currentTask.value.__typename == 'AlternativesTask'
    if (!isLastTask.value) {
        // intentionally not awaiting
        if (!skipSave) await completeTask({ taskId: currentTask.value.id })
        currentTask.value.completed = true
        currentTaskIndex.value += 1
        isCurrentTaskAnswered.value = false
        if (
            currentTask.value.__typename == 'AlternativesTask' &&
            lockData?.value?.lockLessonAnswers
        ) {
            isCurrentTaskAnswered.value = true
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
            const completedTasks: WebViewStudyHandlerCompletedTask[] = []
            await executeAlternativesQuery({ requestPolicy: 'network-only' })

            alternativesDataComp.value?.forEach((task) => {
                task.alternatives
                    .filter((alt) => alt.selected)
                    .forEach((alt) => {
                        completedTasks.push({
                            questionId: task.taskId,
                            answerId: alt.id,
                            answeredCorrectly: alt.isCorrect!,
                        })
                    })
            })

            webViewStudy?.tasksCompleted(completedTasks)
            sendAnswersToBMM(completedTasks)
        }
        emit('navigate', 'more')
    }
}

// Send quiz answers directly to BMM
async function sendAnswersToBMM(answers: WebViewStudyHandlerCompletedTask[]) {
    const token = webViewMain
        ? await webViewMain.getAccessToken()
        : await Auth.getToken()
    fetch('https://bmm-api.brunstad.org/question/answers', {
        method: 'POST',
        body: JSON.stringify(
            answers.map((t) => ({
                question_id: t.questionId,
                selected_answer_id: t.answerId,
                answered_correctly: t.answeredCorrectly,
            }))
        ),
        headers: {
            'Content-Type': 'application/json',
            'Accept-Language': locale.value,
            Authorization: `Bearer ${token}`,
        },
    }).catch((error) => {
        analytics.track('error', { data: { error } })
    })
}

const lockAnswers = async () => {
    lockingInProgress.value = true
    try {
        const answers = alternativeAnswers.value
        let promises: Promise<any>[] = []
        for (var taskId in answers) {
            const alternativeId = answers[taskId].alternativeId
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
<template>
    <div class="w-full h-full">
        <div
            class="inline-flex flex-col space-y-6 items-center justify-start w-full embed:pb-36 embed:hide-scrollbar"
        >
            <div
                v-if="tasks.length > 1"
                class="p-4 flex flex-col space-y-0.5 h-14 w-full"
            >
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
            </div>
            <AlternativesTask
                v-if="currentTask?.__typename == 'AlternativesTask'"
                :key="'alt' + currentTask.id"
                v-model:task="currentTask"
                v-model:is-done="isCurrentTaskAnswered"
                :answer-confirmed="isCurrentTaskAnswerSelectionConfirmed"
                @answer="
                    (v) => {
                        alternativeAnswers[v.taskId] = v
                    }
                "
            />
            <TextTask
                v-else-if="currentTask?.__typename == 'TextTask'"
                :key="'text' + currentTask.id"
                v-model:task="currentTask"
                v-model:is-done="isCurrentTaskAnswered"
                @next-task="() => nextTask()"
            />
            <PosterTask
                v-else-if="
                    currentTask?.__typename == 'PosterTask' ||
                    currentTask?.__typename == 'QuoteTask'
                "
                :key="'poster' + currentTask.id"
                v-model:task="currentTask"
                v-model:is-done="isCurrentTaskAnswered"
            />
            <VideoTask
                v-else-if="currentTask?.__typename == 'VideoTask'"
                :key="'video' + currentTask.id"
                v-model:task="currentTask"
                v-model:is-done="isCurrentTaskAnswered"
            />
            <LinkTask
                v-else-if="currentTask?.__typename == 'LinkTask'"
                :key="'link' + currentTask.id"
                v-model:task="currentTask"
                v-model:is-done="isCurrentTaskAnswered"
            />
            <div v-else>
                {{ (currentTask as any)?.__typename }}
            </div>
        </div>
        <div
            v-if="
                !(
                    currentTask?.__typename == 'TextTask' &&
                    !isCurrentTaskAnswered
                )
            "
            class="flex flex-col space-y-4 items-center justify-end w-full px-4 h-36 pb-16 sticky bottom-0 bg-background-1"
        >
            <div
                class="inline-flex space-x-2 items-start justify-start w-full relative"
            >
                <VButton
                    v-if="
                        !isCurrentTaskAnswerSelectionConfirmed &&
                        currentTask.__typename == 'AlternativesTask' &&
                        currentTask.lockAnswer
                    "
                    class="w-full"
                    size="large"
                    @click="confirmAnswer"
                >
                    {{ t('buttons.confirm') }}
                </VButton>
                <template v-else>
                    <VButton
                        v-if="tasks.length > 1"
                        class="w-full"
                        size="large"
                        color="secondary"
                        @click="previousTask()"
                    >
                        {{ t('buttons.back') }}
                    </VButton>
                    <VButton
                        v-if="currentIsLastTask && !isCurrentTaskAnswered"
                        class="w-full"
                        size="large"
                        :disabled="!isCurrentTaskAnswered"
                        @click="
                            () => {
                                showConfirmModal = true
                            }
                        "
                    >
                        {{ t('buttons.submit') }}
                    </VButton>
                    <VButton
                        v-else
                        class="w-full"
                        size="large"
                        :disabled="!isCurrentTaskAnswered && !lockData"
                        @click="nextTask()"
                    >
                        <template v-if="savingTaskProgress"
                            ><Loader
                                variant="spinner"
                                class="fill-white text-center inline"
                            ></Loader
                        ></template>
                        <template v-else-if="isLastTask">
                            {{ t('buttons.continue') }}
                        </template>
                        <template v-else>{{ t('buttons.next') }}</template>
                    </VButton>
                </template>
            </div>
        </div>
        <ModalBase v-model:visible="showConfirmModal" class="bg-background-2">
            <div class="p-8">
                <h2 class="text-style-headline-2 text-on-tint">
                    {{ t('competition.areYouSure') }}
                </h2>
                <p class="mt-2 text-style-body-2 text-label-3">
                    {{ t('competition.lookThouroughly') }}
                </p>
                <div class="mt-4 flex space-x-4">
                    <VButton
                        class="flex-1"
                        color="secondary"
                        size="large"
                        @click="() => (showConfirmModal = false)"
                        >{{ t('buttons.cancel') }}</VButton
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
                            {{ t('buttons.submit') }}</template
                        ></VButton
                    >
                </div>
            </div>
        </ModalBase>
    </div>
</template>
