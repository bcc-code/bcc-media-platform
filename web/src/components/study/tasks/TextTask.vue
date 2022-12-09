<template>
    <div class="p-4 pb-0 flex flex-col items-start justify-start w-full h-full">
        <template v-if="!isDone">
            <p class="w-full text-white text-style-title-1">{{ task.title }}</p>
            <p v-if="true"><!--description--></p>
            <div class="w-full mt-6">
                <textarea
                    v-model="messageInput"
                    name=""
                    id="messageInput"
                    cols="20"
                    rows="10"
                    :placeholder="$t('study.textTaskPlaceholder')"
                    class="w-full ellipsis rounded text-lg p-4 pr-6 bg-primary bg-opacity-10 rounded-xl text-label-1 placeholder-label-4 text-style-body-1 outline-tint-1 focus:outline outline-1 outline-offset-0"
                ></textarea>
                <p class="mt-2">
                    Your response will be
                    <span class="font-bold">anonymous</span>.
                </p>
            </div>
            <div class="flex-1"></div>
            <VButton
                :disabled="!messageInput"
                @click="submit"
                class="w-full"
                size="large"
                >Send</VButton
            >
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
import Alternative from "./Alternative.vue"

var selectedIndex = ref<number>()

const { fetching, executeMutation } = useSendTaskMessageMutation()
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
    executeMutation({
        message: messageInput.value!,
        taskId: task.value.id,
    }).then(() => {
        completeTask({ taskId: task.value.id })
        isDone.value = true
    })
}
</script>
