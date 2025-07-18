<script lang="ts" setup>
import { VButton } from '@/components'
import { TaskFragment, useCompleteTaskMutation } from '@/graph/generated'
import { computed, onMounted, ref } from 'vue'
import { useI18n } from 'vue-i18n'
import { webViewMain } from '@/services/webviews/mainHandler'

const { t } = useI18n()

const { executeMutation: completeTask } = useCompleteTaskMutation()

const props = defineProps<{
    task: TaskFragment
    isDone: boolean
}>()
const emit = defineEmits<{
    (event: 'change'): void
    (event: 'update:isDone', val: boolean): void
}>()

const task = computed(() => {
    return (props.task.__typename == 'VideoTask' ? props.task : undefined)!
})

const openLink = async () => {
    await completeTask({ taskId: task.value.id })
    if (webViewMain) {
        var promise = webViewMain.push(
            `/embed/${task.value.episode.id}?hide_bottom_section=true&autoplay=true`
        )
        if (promise?.then != null) {
            await promise
        }
    } else {
        window
            .open(`/episode/${task.value.episode.id}?autoplay=true`, '_blank')
            ?.focus()
    }
}
onMounted(async () => {
    emit(`update:isDone`, true)
})
</script>

<template>
    <div class="p-4 pb-0 w-full h-full flex flex-col">
        <p
            class="w-full text-white text-style-title-1 text-center h-full max-h-24"
        >
            {{ task.title }}
        </p>
        <p v-if="true"><!--description--></p>
        <div class="mx-12">
            <div
                v-if="task.episode.image"
                class="cursor-pointer mt-4 relative z-10 relative"
            >
                <div
                    class="absolute top-0 w-full h-full rounded-xl border-[1.5px] border-white opacity-10 z-40"
                >
                    &nbsp;
                </div>
                <div class="flex w-full h-full rounded-xl overflow-hidden">
                    <img
                        class="object-cover relative -z-10"
                        :src="task.episode.image ?? ''"
                    />
                </div>
            </div>
            <h2 class="text-style-title-2 text-on-tint text-center mt-3">
                {{ task.episode.title }}
            </h2>
            <h2 class="text-style-caption-1 text-label-3">
                {{ task.episode.description }}
            </h2>
            <div class="flex align-center justify-center">
                <VButton
                    class="mt-6"
                    size="thin"
                    color="secondary"
                    @click="openLink"
                >
                    <svg
                        class="inline -mt-1 mr-1"
                        width="20"
                        height="20"
                        viewBox="0 0 20 20"
                        fill="none"
                        xmlns="http://www.w3.org/2000/svg"
                    >
                        <path
                            fill-rule="evenodd"
                            clip-rule="evenodd"
                            d="M17.8997 13.3325C20.7001 11.8376 20.7001 8.1624 17.8997 6.66748L6.42056 0.539675C3.58041 -0.976456 0 0.881915 0 3.87219V16.1278C0 19.1181 3.58041 20.9765 6.42056 19.4603L17.8997 13.3325Z"
                            fill="white"
                        />
                    </svg>

                    Se nå
                </VButton>
            </div>
        </div>
    </div>
</template>
@/services/webviews/mainHandler
