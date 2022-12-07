<template>
    <div class="p-4 flex flex-col space-y-8 items-start justify-start w-full">
        <p class="w-full text-2xl font-extrabold leading-7 text-white">
            How would you do this, that, and something else?
        </p>
        <div class="flex flex-col space-y-2 items-start justify-start w-full">
            <QuizOption
                letter="A"
                text="Option number 1"
                @click="() => selectAnswer('A')"
                :selected="selectedAnswer == 'A'"
                :wrong="selectedAnswer == 'A' && 'A' != correctAnswer"
                :correct="selectedAnswer == 'A' && 'A' == correctAnswer"
            />
            <QuizOption
                letter="B"
                text="Option number 2"
                @click="() => selectAnswer('B')"
                :selected="selectedAnswer == 'B'"
                :wrong="selectedAnswer == 'B' && 'B' != correctAnswer"
                :correct="selectedAnswer == 'B' && 'B' == correctAnswer"
            />
            <QuizOption
                letter="C"
                text="Option 3 with two sentences and a long description"
                @click="() => selectAnswer('C')"
                :wrong="selectedAnswer == 'C' && 'C' != correctAnswer"
                :selected="selectedAnswer == 'C'"
                :correct="selectedAnswer == 'C' && 'C' == correctAnswer"
            />
            <QuizOption
                letter="D"
                text="Option 4 with two sentences and a long description"
                :selected="selectedAnswer == 'D'"
                @click="() => selectAnswer('D')"
                :wrong="selectedAnswer == 'D' && 'D' != correctAnswer"
                :correct="selectedAnswer == 'D' && 'D' == correctAnswer"
            />
        </div>
    </div>
</template>

<script lang="ts" setup>
import QuizOption from "@/components/study/quiz/QuizOption.vue"
import { computed, getCurrentInstance, Ref, ref, watch } from "vue"

let correctAnswer = "C"
var selectedAnswer: Ref<String> = ref("")

const props = defineProps<{
    isDone: boolean
}>()
const emit = defineEmits<{
    (event: "change"): void
    (event: "update:isDone", val: boolean): void
}>()

const isDone = computed({
    get() {
        return props.isDone
    },
    set(value) {
        emit(`update:isDone`, value)
    },
})

watch(selectedAnswer, (after, before) => {
    console.log(after == correctAnswer)
    isDone.value = after == correctAnswer
})

function selectAnswer(answer: String) {
    selectedAnswer.value = answer
    console.log(selectedAnswer)
    if (answer == correctAnswer) {
    }
}
</script>
