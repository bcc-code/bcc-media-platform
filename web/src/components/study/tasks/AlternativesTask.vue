<template>
    <div class="p-4 flex flex-col space-y-8 items-start justify-start w-full">
        <p class="w-full text-white text-style-title-1">{{ task.title }}</p>
        <div class="flex flex-col space-y-2 items-start justify-start w-full">

            <Alternative v-for="(alt, i) in task.alternatives" :key="alt.title" :letter="getLetter(i)" :text="alt.title"
                :correct="alt.isCorrect" @click="() => selectAnswer(i)" :selected="(selectedIndex == i)" />
        </div>
    </div>
</template>

<script lang="ts" setup>
import { TaskFragment } from '@/graph/generated';
import { computed, getCurrentInstance, Ref, ref, watch } from 'vue';
import Alternative from "./Alternative.vue";

var selectedIndex = ref<number>()

const props = defineProps<{
    task: TaskFragment,
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

const task = computed(() => {
    return ((props.task.__typename == 'AlternativesTask') ? props.task : undefined)!;
});

const getLetter = (index: number) => ['A', 'B', 'C', 'D', 'E', 'F', 'G'][index];

watch(selectedIndex, (after, before) => {
    isDone.value = selectedIndex.value != null ? task.value.alternatives[selectedIndex.value].isCorrect : false;
})

function selectAnswer(answer: number) {
    selectedIndex.value = answer
}
</script>
