<template>
    <div class="p-4 pb-0  w-full h-full">
        <template v-if="fetching">
            <div class="w-full h-full flex items-center justify-center">

                <Loader></Loader>
            </div>
        </template>
        <template v-else-if="error">
            <div class="text-style-title-1">Something went wrong</div>
            <div class="text-red mt-4">{{ error.message }}</div>
            <div class="text-red mt-2">{{ error.stack }}</div>
            <VButton class="mt-4" @click="() => error = undefined">Retry</VButton>
        </template>
        <template v-else-if="isDone">
            <div class="flex flex-col items-center justify-center w-full h-full">
                <p class="w-full text-white text-style-title-1 text-center">{{ t('thankYou') }}</p>
                <p class="w-full text-white text-style-body-1 text-label-3 text-center">{{
                        t('yourResponseHasBeenSubmitted')
                }}</p>
            </div>
        </template>
        <template v-else>
            <p class="w-full text-white text-style-title-1">{{ task.title }}</p>
            <p v-if="true"><!--description--></p>
            <div class="w-full mt-6">
                <textarea v-model="messageInput" name="" id="messageInput" cols="20" rows="10"
                    :placeholder="$t('lesson.textTaskPlaceholder')"
                    class="w-full ellipsis rounded text-lg p-4 pr-6 bg-background-2 rounded-xl text-label-1 placeholder-label-4 text-style-body-1 outline-tint-1 focus:outline outline-2 outline-offset-0 resize-none"></textarea>
                <p class="mt-2">
                    Your response will be
                    <span class="font-bold">anonymous</span>.
                </p>
            </div>
            <div class="flex-1"></div>
            <VButton :disabled="!messageInput" @click="submit" class="w-full mt-4" size="large">Send</VButton>
        </template>
    </div>
</template>

<script lang="ts" setup>
import { VButton } from "@/components"
import {
    TaskFragment,
    useCompleteTaskMutation,
    useSendTaskMessageMutation,
} from "@/graph/generated"
import { computed, getCurrentInstance, Ref, ref, watch } from "vue"
import { useI18n } from "vue-i18n";
import Alternative from "./Alternative.vue"
import Loader from "@/components/Loader.vue";

var selectedIndex = ref<number>()

const { t } = useI18n();

const { fetching, executeMutation, error } = useSendTaskMessageMutation()
const { executeMutation: completeTask } = useCompleteTaskMutation()

const props = defineProps<{
    task: TaskFragment
    isDone: boolean
}>()
const emit = defineEmits<{
    (event: "change"): void
    (event: "update:isDone", val: boolean): void
}>()

const messageInput = ref<string>()

const isDone = computed({
    get() {
        return props.isDone
    },
    set(value) {
        emit(`update:isDone`, value)
    },
})

const task = computed(() => {
    return (props.task.__typename == "TextTask" ? props.task : undefined)!
})

const submit = () => {
    if (!messageInput.value) { return; }
    executeMutation({
        message: messageInput.value,
        taskId: task.value.id,
    }).then((val) => {
        if (val.error != null) {
            return;
        }
        completeTask({ taskId: task.value.id })
        isDone.value = true
        val.data?.sendTaskMessage
    })
}
</script>