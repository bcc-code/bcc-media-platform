<template>
    <div
        :class="('inline-flex space-x-4 items-center justify-start w-full h-16 pl-4 bg-separator-on-light bg-opacity-10 rounded-xl border-2 ' + conditionalClass)">
        <p class="w-5 text-2xl font-extrabold leading-7 text-center text-label-3">{{ letter }}</p>
        <p class="flex-1 text-label-1 text-style-title-3">{{ text }}</p>

        <div class="flex items-center justify-center p-1.5 pr-4">
            <svg v-if="wrong" width="14" height="14" viewBox="0 0 14 14" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M13 1L1 13" stroke="#E63C62" stroke-width="2" />
                <path d="M1 1L13 13" stroke="#E63C62" stroke-width="2" />
            </svg>
            <svg v-if="correct" width="15" height="12" viewBox="0 0 15 12" fill="none"
                xmlns="http://www.w3.org/2000/svg">
                <path d="M13.7887 1.3033L5.30337 9.78858L1.00007 5.48528" stroke="#71D2A4" stroke-width="2" />
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

const conditionalClass = computed(() => {
    if (props.correct) {
        return 'border-tint-3 cursor-default'
    } else if (props.wrong) {
        return 'border-tint-2 cursor-default'
    }
    return 'border-transparent cursor-pointer';
})

</script>