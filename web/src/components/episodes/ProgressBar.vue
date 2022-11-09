<template>
    <span class="p-1 md:p-2 text-xs md:text-sm">
        <div
            v-if="progress || progress === 0"
            class="flex bg-black bg-opacity-50 px-2 rounded"
        >
            <div class="w-full bg-gray rounded h-1 md:h-1.5 bg-opacity-50 my-auto">
                <div
                    class="bg-white h-1 md:h-1.5 rounded"
                    :style="percentageWidth(item.duration, progress)"
                ></div>
            </div>
            <div>
                <span class="ml-2 my-auto">{{ secondsToTime(item.duration) }}</span>
            </div>
        </div>
        <div
            v-else
            class="flex bg-black bg-opacity-60 px-2 rounded ml-auto mr-0 float-right"
        >
            <span>{{ secondsToTime(item.duration) }}</span>
        </div>
    </span>
</template>
<script lang="ts" setup>
import { getProgress } from "@/utils/episodes"
import { percentageWidth, secondsToTime } from "@/utils/time"
import { computed } from "vue"

const props = defineProps<{
    item: { id: string; progress?: number | null; duration: number }
}>()

const progress = computed(() => {
    return getProgress(props.item)
})
</script>
