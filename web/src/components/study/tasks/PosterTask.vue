<template>
    <div class="p-4 pb-0 w-full h-full">
        <p class="w-full text-white text-style-title-1 text-center">{{ task.title }}</p>
        <p v-if="true"><!--description--></p>
        <div class="w-full mt-6 px-12">
            <img :src="'https://brunstadtv.imgix.net/' + task.image" />
        </div>
        <div class="flex align-center justify-center">
            <VButton @click="download" class="mt-6" size="thin" color="secondary">
                <svg class="-mt-1 inline" width="25" height="24" viewBox="0 0 25 24" fill="none"
                    xmlns="http://www.w3.org/2000/svg">
                    <path d="M21.5 21H3.5M18.5 11L12.5 17M12.5 17L6.5 11M12.5 17V3" stroke="white" stroke-width="2"
                        stroke-linecap="round" stroke-linejoin="round" />
                </svg>
                Download poster
                <sup class="text-style-caption-3 text-label-3">
                    <template v-if="imgSize">({{ imgSize }})</template>
                    <div class="w-8" v-else>(...)</div>
                </sup>
            </VButton>
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

var selectedIndex = ref<number>()

const { t } = useI18n()

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

const imgSize = ref<string>()
const imgUrl = computed(() => 'https://brunstadtv.imgix.net/' + task.value.image);

const task = computed(() => {
    return (props.task.__typename == "PosterTask" ? props.task : undefined)!
})

const download = () => {
    window.location.assign(imgUrl.value + '?&dl=1&launch_url=true');
}
onMounted(async () => {
    emit(`update:isDone`, true);
    const imgInfo = await fetch(imgUrl.value, { method: 'HEAD' });
    const contentLength = imgInfo.headers.get('Content-Length');
    if (contentLength) {
        const bytes = parseFloat(contentLength);
        const megabytes = (bytes / 1024 / 1024).toFixed(0);
        imgSize.value = `${megabytes}mb`;
    }
})
</script>
