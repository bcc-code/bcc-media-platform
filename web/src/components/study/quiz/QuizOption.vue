<template>
    <div
        :class="('inline-flex space-x-4 items-center justify-start w-full h-16 pl-4 bg-indigo-200 bg-opacity-10 rounded-xl border-2 ' + borderClass)">
        <p class="w-5 text-2xl font-extrabold leading-7 text-center text-gray-300">{{ letter }}</p>
        <p class="flex-1 text-base font-bold leading-tight text-white">{{ text }}</p>

        <div v-if="wrong" class="flex items-center justify-center p-1.5 pr-4">
            <svg width="14" height="14" viewBox="0 0 14 14" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M13 1L1 13" stroke="#E63C62" stroke-width="2" />
                <path d="M1 1L13 13" stroke="#E63C62" stroke-width="2" />
            </svg>
        </div>
    </div>

</template>

<script setup lang="ts">
import { computed } from 'vue';


const props = defineProps<{
    letter: String,
    text: String,
    selected: Boolean,
    wrong: Boolean,
    correct: Boolean
}>();

const borderClass = computed(() => {
    if (props.correct) {
        return 'border-green-600'
    } else if (props.wrong) {
        return 'border-pink-600'
    }
    return 'border-transparent';
})

</script>