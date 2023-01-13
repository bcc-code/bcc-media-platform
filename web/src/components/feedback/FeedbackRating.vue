<template>
    <div class="flex gap-x-1">
        <div
            v-for="opt in [0, 1, 2, 3, 4]"
            class="flex-1 h-16 w-16 p-3 flex items-center justify-center bg-background-2 text-3xl"
            :class="[
                opt === 0 ? 'rounded-l-xl' : '',
                opt === 4 ? 'rounded-r-xl' : '',
                props.selected != null && opt <= props.selected
                    ? 'bg-tint-1'
                    : '',
                props.selected != null && opt > props.selected
                    ? 'opacity-70'
                    : '',
            ]"
            :key="opt"
            @click="() => setRating(opt)"
        >
            <svg
                width="31"
                height="29"
                viewBox="0 0 31 29"
                :class="
                    props.selected != null && opt <= props.selected
                        ? 'text-on-tint'
                        : 'text-label-2'
                "
                fill="none"
                xmlns="http://www.w3.org/2000/svg"
            >
                <path
                    class="stroke-current fill-current"
                    d="M15.7005 1.66699L19.8205 10.0137L29.0339 11.3603L22.3672 17.8537L23.9405 27.027L15.7005 22.6937L7.46052 27.027L9.03385 17.8537L2.36719 11.3603L11.5805 10.0137L15.7005 1.66699Z"
                    fill="inherit"
                    stroke="inherit"
                    stroke-width="3.04762"
                    stroke-linecap="round"
                    stroke-linejoin="round"
                />
            </svg>
        </div>
    </div>
</template>

<script lang="ts" setup>
import { ref } from "vue"
import FeedbackBottomSheet from "../feedback/FeedbackBottomSheet.vue"

const props = defineProps<{
    selected: number | null
}>()
const emit = defineEmits<{
    (event: "change"): void
    (event: "update:selected", val: number | null): void
}>()

const setRating = (i: number) => {
    emit("update:selected", props.selected !== i ? i : null)
}
</script>
