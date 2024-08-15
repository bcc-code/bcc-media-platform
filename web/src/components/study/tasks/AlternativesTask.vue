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
                :key="alt.title"
                :letter="getLetter(i)"
                :text="alt.title"
                :locked="task.locked"
                :correct="
                    noWrongAnswers || task.competitionMode
                        ? undefined
                        : alt.isCorrect
                "
                :competition-mode="task.competitionMode"
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

<script lang="ts" setup>
import { TaskFragment } from "@/graph/generated"
import { computed, getCurrentInstance, Ref, ref, watch } from "vue"
import Alternative from "./Alternative.vue"
import ModalBase from "../ModalBase.vue"
import { useCompleteTaskMutation } from "@/graph/generated"
import { Vue3Lottie as LottieAnimation } from "vue3-lottie"
import confettiAnimation from "./confetti.json"

const { executeMutation } = useCompleteTaskMutation()

const props = defineProps<{
    task: TaskFragment
    isDone: boolean
}>()
const emit = defineEmits<{
    (event: "change"): void
    (event: "update:isDone", val: boolean): void
    (
        event: "competitionAnswer",
        val: { taskId: string; alternativeId: string }
    ): void
}>()

const noWrongAnswers = computed(() =>
    task.value.alternatives.every((alt) => alt.isCorrect)
)

const task = computed(() => {
    return (
        props.task.__typename == "AlternativesTask" ? props.task : undefined
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

const getLetter = (index: number) => ["A", "B", "C", "D", "E", "F", "G"][index]

watch(
    selectedIndex,
    (after, before) => {
        let alternative = after == null ? null : task.value.alternatives[after]
        if (alternative && task.value.competitionMode) {
            isDone.value = true
        } else if (alternative && alternative.isCorrect) {
            isDone.value = true
        } else {
            isDone.value = false
        }
    },
    { immediate: true }
)

function selectAnswer(id: string) {
    if (task.value.locked) return
    for (const alt of task.value.alternatives) {
        alt.selected = id == alt.id
    }
    if (task.value.competitionMode) {
        emit("competitionAnswer", { taskId: task.value.id, alternativeId: id })
    } else {
        executeMutation({ taskId: task.value.id, selectedAlternatives: [id] })
    }
}
</script>
