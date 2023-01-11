<template>
    <div class="p-4 pb-0 w-full h-full">
        <p
            class="w-full text-white text-style-title-1 text-center h-full max-h-24"
        >
            {{ task.title }}
        </p>
        <p v-if="true"><!--description--></p>
        <div class="mx-12">
            <div
                class="cursor-pointer mt-4 relative z-10 relative"
                v-if="task.link.image"
            >
                <div
                    class="absolute top-0 w-full h-full rounded-xl border-[1.5px] border-white opacity-10 z-40"
                >
                    &nbsp;
                </div>
                <div class="flex w-full h-full rounded-xl overflow-hidden">
                    <img
                        class="object-cover relative -z-10"
                        :src="task.link.image ?? ''"
                    />
                </div>
            </div>
            <h2 class="text-style-title-2 text-on-tint text-center mt-2">
                {{ task.link.title }}
            </h2>
            <h2 class="mt-1 text-style-caption-1 text-label-3 text-center">
                {{ task.link.description }}
            </h2>
            <div class="mt-6 flex align-center justify-center">
                <VButton @click="openLink" size="thin" color="secondary">
                    <svg
                        class="inline -mt-1"
                        width="25"
                        height="24"
                        viewBox="0 0 25 24"
                        fill="none"
                        xmlns="http://www.w3.org/2000/svg"
                    >
                        <path
                            d="M19.5 9C19.5 9.55229 19.9477 10 20.5 10C21.0523 10 21.5 9.55229 21.5 9V5C21.5 3.89543 20.6046 3 19.5 3H15.5C14.9477 3 14.5 3.44772 14.5 4C14.5 4.55228 14.9477 5 15.5 5L18.0858 5L11.7929 11.2929C11.4024 11.6834 11.4024 12.3166 11.7929 12.7071C12.1834 13.0976 12.8166 13.0976 13.2071 12.7071L19.5 6.41421V9Z"
                            fill="white"
                        />
                        <path
                            fill-rule="evenodd"
                            clip-rule="evenodd"
                            d="M3.5 6C3.5 4.34315 4.84315 3 6.5 3H11.5C12.0523 3 12.5 3.44772 12.5 4C12.5 4.55228 12.0523 5 11.5 5H6.5C5.94772 5 5.5 5.44772 5.5 6V18C5.5 18.5523 5.94772 19 6.5 19H18.5C19.0523 19 19.5 18.5523 19.5 18V13C19.5 12.4477 19.9477 12 20.5 12C21.0523 12 21.5 12.4477 21.5 13V18C21.5 19.6569 20.1569 21 18.5 21H6.5C4.84315 21 3.5 19.6569 3.5 18V6Z"
                            fill="white"
                        />
                    </svg>

                    {{ t("buttons.goTo") }}
                </VButton>
            </div>
        </div>
    </div>
</template>

<script lang="ts" setup>
import { VButton } from "@/components"
import { TaskFragment, useCompleteTaskMutation } from "@/graph/generated"
import { computed, onMounted } from "vue"
import { useI18n } from "vue-i18n"
import { openInBrowser } from "@/utils/flutter"

const { t } = useI18n()
const { executeMutation: completeTask } = useCompleteTaskMutation()

const props = defineProps<{
    task: TaskFragment
    isDone: boolean
}>()
const emit = defineEmits<{
    (event: "change"): void
    (event: "update:isDone", val: boolean): void
    (event: "nextTask"): void
}>()

const task = computed(() => {
    return (props.task.__typename == "LinkTask" ? props.task : undefined)!
})
console.log(task.value.title)

const openLink = () => {
    completeTask({ taskId: task.value.id })
    openInBrowser(task.value.link.url)
}
onMounted(async () => {
    emit(`update:isDone`, true)
})
</script>
