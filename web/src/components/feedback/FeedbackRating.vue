<template>
    <div class="flex gap-x-1">
        <div
            v-for="(option, i) in ['😩', '🙁', '😐', '🙂', '😃']"
            class="flex-1 h-16 w-16 p-4 pb-5 flex items-center justify-center bg-background-2 text-3xl"
            :class="[
                i === 0 ? 'rounded-l-xl' : '',
                i === 4 ? 'rounded-r-xl' : '',
                i === props.selected ? 'bg-[#ccddff80]' : '',
                i !== props.selected && props.selected != null
                    ? 'opacity-70'
                    : '',
            ]"
            @click="() => setRating(i)"
        >
            {{ option }}
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
