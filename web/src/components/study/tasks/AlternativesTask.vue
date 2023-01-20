<template>
    <div class="p-4 flex flex-col space-y-8 items-start justify-start w-full">
        <p class="w-full text-white text-style-title-1">{{ task.title }}</p>
        <div class="flex flex-col space-y-2 items-start justify-start w-full">
            <Alternative
                v-for="(alt, i) in task.alternatives"
                :key="alt.title"
                :letter="getLetter(i)"
                :text="alt.title"
                :correct="noWrongAnswers ? undefined : alt.isCorrect"
                :competition-mode="task.competitionMode"
                @click="() => selectAnswer(alt.id)"
                :selected="selectedIndex == i"
                :class="
                    selectedIndex != i && selectedIndex != null
                        ? 'opacity-50'
                        : ''
                "
            />
        </div>
    </div>
</template>

<script lang="ts" setup>
import { TaskFragment } from "@/graph/generated"
import { computed, getCurrentInstance, Ref, ref, watch } from "vue"
import Alternative from "./Alternative.vue"
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
        isDone.value = alternative?.isCorrect ?? false
    },
    { immediate: true }
)

function selectAnswer(id: string) {
    for (const alt of task.value.alternatives) {
        alt.selected = id == alt.id
    }
    const alt = task.value.alternatives.find((alt) => alt.id == id)
    executeMutation({ taskId: task.value.id, selectedAlternatives: [id] })
}
</script>
