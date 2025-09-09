<script lang="ts" setup>
import type { TaskFragment } from '@/graph/generated'
import { computed, watch } from 'vue'
import Alternative from './Alternative.vue'
import { analytics } from '@/services/analytics'

const props = defineProps<{
    task: TaskFragment
    isDone: boolean
    answerConfirmed: boolean
}>()

const emit = defineEmits<{
    (event: 'change'): void
    (event: 'update:isDone', val: boolean): void
    (
        event: 'answer',
        val: { taskId: string; alternativeId: string; isCorrect: boolean }
    ): void
}>()

const noWrongAnswers = computed(() =>
    task.value.alternatives.every((alt) => alt.isCorrect)
)

const task = computed(() => {
    return (
        props.task.__typename == 'AlternativesTask' ? props.task : undefined
    )!
})

const selectedIndex = computed(() => {
    const index = task.value.alternatives.findIndex((s) => s.selected)
    if (index === -1) return undefined
    return index
})

const isDone = computed({
    get() {
        return props.isDone
    },
    set(value) {
        emit(`update:isDone`, value)
    },
})

const getLetter = (index: number) =>
    ['A', 'B', 'C', 'D', 'E', 'F', 'G'][index] ?? ''

watch(
    selectedIndex,
    (after) => {
        let alternative = after == null ? null : task.value.alternatives[after]
        if (alternative && task.value.lockAnswer && props.answerConfirmed) {
            isDone.value = true
        } else if (alternative) {
            isDone.value = true
        } else {
            isDone.value = false
        }
    },
    { immediate: true }
)

function selectAnswer(id: string) {
    if (task.value.locked) return
    if (task.value.lockAnswer && task.value.completed) return
    for (const alt of task.value.alternatives) {
        alt.selected = id == alt.id
    }

    const alternative = task.value.alternatives.find((a) => a.id == id)
    const isCorrect = alternative?.isCorrect
    if (isCorrect === undefined || isCorrect === null) {
        analytics.track('error', { data: alternative })
        return
    }
    emit('answer', {
        alternativeId: id,
        taskId: task.value.id,
        isCorrect,
    })
}
</script>

<template>
    <div
        class="p-4 flex flex-col space-y-8 items-start justify-start w-full embed:min-h-screen"
    >
        <p
            class="w-full text-white"
            :class="
                task.title.length > 100
                    ? 'text-style-title-3'
                    : 'text-style-title-1'
            "
        >
            {{ task.title }}
        </p>
        <div
            class="flex flex-col space-y-2 items-start justify-start w-full h-full"
        >
            <Alternative
                v-for="(alt, i) in task.alternatives"
                :key="alt.id"
                :letter="getLetter(i)"
                :text="alt.title"
                :locked="task.locked || (task.completed && task.lockAnswer)"
                :correct="
                    noWrongAnswers || !task.showAnswer
                        ? undefined
                        : alt.isCorrect
                "
                :show-answer="
                    (task.showAnswer && task.completed && answerConfirmed) ||
                    (task.showAnswer &&
                        task.completed &&
                        answerConfirmed &&
                        alt.isCorrect === true)
                "
                :selected="selectedIndex == i"
                :class="
                    selectedIndex != i && selectedIndex != null
                        ? 'opacity-50'
                        : ''
                "
                @click="() => selectAnswer(alt.id)"
            />
        </div>
    </div>
</template>
