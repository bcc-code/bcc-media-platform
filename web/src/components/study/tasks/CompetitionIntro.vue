<template>
    <div
        class="p-4 pb-0 w-full h-full flex flex-col items-center justify-center pb-12 embed:min-h-screen embed:pb-64"
    >
        <p class="w-full text-white text-style-title-1">
            {{ t("competition.title") }}
        </p>
        <p v-html="t('competition.description')"></p>
        <div class="w-full mt-6"></div>
    </div>
</template>

<script lang="ts" setup>
import {
    TaskFragment,
    useCompleteTaskMutation,
    useSendTaskMessageMutation,
} from "@/graph/generated"
import { computed, ref } from "vue"
import { useI18n } from "vue-i18n"

const { t } = useI18n()

const props = defineProps<{
    isDone: boolean
}>()
const emit = defineEmits<{
    (event: "change"): void
    (event: "nextTask"): void
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

isDone.value = true
</script>
