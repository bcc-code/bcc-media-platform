<template>
    <div>
        <FeedbackRating
            v-model:selected="selectedRating"
            :class="!sent ? '' : 'pointer-events-none opacity-30'"
        />

        <FeedbackBottomSheet
            v-model:visible="bottomSheet"
            v-model:selected="selectedRating"
            :episode-id="episodeId"
            @sent="registerSent"
        />
    </div>
</template>
<script lang="ts" setup>
import { ref, watch } from "vue"
import FeedbackRating from "./FeedbackRating.vue"

import FeedbackBottomSheet from "./FeedbackBottomSheet.vue"

defineProps<{
    episodeId: string
}>()

const emit = defineEmits<{
    (e: "sent"): void
}>()

const selectedRating = ref<number | null>(null)
const bottomSheet = ref(false)
const sent = ref(false)
const registerSent = () => {
    sent.value = true
    emit("sent")
}

watch(selectedRating, (value) => {
    if (value != null) {
        bottomSheet.value = true
    }
})
</script>
