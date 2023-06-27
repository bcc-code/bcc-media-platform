<template>
    <div
        class="p-x4 py-0 w-full h-full flex flex-col items-center justify-center pb-8 embed:min-h-screen embed:pb-64"
    >
        <p class="w-full text-white text-style-title-1 text-center">
            {{ task.title }}
        </p>
        <div v-if="!imgLoaded" class="h-96 flex items-center justify-center">
            <Loader variant="spinner"></Loader>
        </div>
        <div v-show="imgLoaded">
            <div class="w-full mt-6 px-12">
                <img
                    @load="() => (imgLoaded = true)"
                    :src="task.image"
                    style="max-height: 35vh"
                    class=""
                />
            </div>
            <div class="flex align-center justify-center">
                <VButton
                    @click="download"
                    class="mt-6"
                    size="thin"
                    color="secondary"
                >
                    <svg
                        v-if="downloading"
                        aria-hidden="true"
                        class="-mt-1 inline w-6 h-6 -ml-1 mr-1 text-transparent animate-spin fill-tint-1"
                        viewBox="0 0 100 101"
                        fill="none"
                        xmlns="http://www.w3.org/2000/svg"
                    >
                        <path
                            d="M100 50.5908C100 78.2051 77.6142 100.591 50 100.591C22.3858 100.591 0 78.2051 0 50.5908C0 22.9766 22.3858 0.59082 50 0.59082C77.6142 0.59082 100 22.9766 100 50.5908ZM9.08144 50.5908C9.08144 73.1895 27.4013 91.5094 50 91.5094C72.5987 91.5094 90.9186 73.1895 90.9186 50.5908C90.9186 27.9921 72.5987 9.67226 50 9.67226C27.4013 9.67226 9.08144 27.9921 9.08144 50.5908Z"
                            fill="currentColor"
                        />
                        <path
                            d="M93.9676 39.0409C96.393 38.4038 97.8624 35.9116 97.0079 33.5539C95.2932 28.8227 92.871 24.3692 89.8167 20.348C85.8452 15.1192 80.8826 10.7238 75.2124 7.41289C69.5422 4.10194 63.2754 1.94025 56.7698 1.05124C51.7666 0.367541 46.6976 0.446843 41.7345 1.27873C39.2613 1.69328 37.813 4.19778 38.4501 6.62326C39.0873 9.04874 41.5694 10.4717 44.0505 10.1071C47.8511 9.54855 51.7191 9.52689 55.5402 10.0491C60.8642 10.7766 65.9928 12.5457 70.6331 15.2552C75.2735 17.9648 79.3347 21.5619 82.5849 25.841C84.9175 28.9121 86.7997 32.2913 88.1811 35.8758C89.083 38.2158 91.5421 39.6781 93.9676 39.0409Z"
                            fill="currentFill"
                        />
                    </svg>
                    <svg
                        v-else
                        class="-mt-1 inline"
                        width="25"
                        height="24"
                        viewBox="0 0 25 24"
                        fill="none"
                        xmlns="http://www.w3.org/2000/svg"
                    >
                        <path
                            d="M21.5 21H3.5M18.5 11L12.5 17M12.5 17L6.5 11M12.5 17V3"
                            stroke="white"
                            stroke-width="2"
                            stroke-linecap="round"
                            stroke-linejoin="round"
                        />
                    </svg>
                    {{ t("buttons.download") }}
                    <sup class="text-style-caption-3 text-label-3">
                        <template v-if="imgSize">({{ imgSize }})</template>
                        <div class="w-8" v-else>(...)</div>
                    </sup>
                </VButton>
            </div>
        </div>
    </div>
</template>

<script lang="ts" setup>
import { VButton } from "@/components"
import {
    TaskFragment,
    useCompleteTaskMutation,
    useSendTaskMessageMutation,
} from "@/graph/generated"
import { computed, getCurrentInstance, onMounted, Ref, ref, watch } from "vue"
import { useI18n } from "vue-i18n"
import Alternative from "./Alternative.vue"
import Loader from "@/components/Loader.vue"
import { webViewMain, openInBrowser } from "@/services/webviews/mainHandler"

var selectedIndex = ref<number>()

const { t } = useI18n()

const { fetching, executeMutation, error } = useSendTaskMessageMutation()
const { executeMutation: completeTask } = useCompleteTaskMutation()

const imgLoaded = ref(false)

const props = defineProps<{
    task: TaskFragment
    isDone: boolean
}>()
const emit = defineEmits<{
    (event: "change"): void
    (event: "update:isDone", val: boolean): void
}>()

const imgSize = ref<string>()
const downloading = ref<boolean>()

const task = computed(() => {
    return (
        props.task.__typename == "PosterTask" ||
        props.task.__typename == "QuoteTask"
            ? props.task
            : undefined
    )!
})

const download = async () => {
    downloading.value = true
    const response = await webViewMain?.shareImage(task.value.image)
    downloading.value = false
    if (response == null || response == false) {
        openInBrowser(task.value.image + "?&dl")
    }
}
onMounted(async () => {
    emit(`update:isDone`, true)
    const imgInfo = await fetch(task.value.image, { method: "HEAD" })
    const contentLength = imgInfo.headers.get("Content-Length")
    if (contentLength) {
        const bytes = parseFloat(contentLength)
        const megaBytes = (bytes / 1024 / 1024).toFixed(1)
        imgSize.value = `${megaBytes} mb`
    }
})
</script>
@/services/webviews/mainHandler
