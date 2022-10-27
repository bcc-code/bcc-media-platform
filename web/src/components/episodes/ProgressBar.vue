<template>
    <span
        class="p-2 text-sm"
    >
        <div
            v-if="item.progress || item.progress === 0"
            class="flex bg-black bg-opacity-50 px-2 rounded"
        >
            <div
                class="w-full bg-gray rounded h-1.5 bg-opacity-50 my-auto"
            >
                <div
                    class="bg-white h-1.5 rounded"
                    :style="
                        percentageWidth(
                            item.duration,
                            item.progress
                        )
                    "
                ></div>
            </div>
            <span class="ml-2">{{
                secondsToTime(item.duration)
            }}</span>
        </div>
        <div
            v-else
            class="flex bg-black bg-opacity-60 px-2 rounded ml-auto mr-0 float-right"
        >
            <span>{{
                secondsToTime(item.duration)
            }}</span>
        </div>
    </span>
</template>
<script lang="ts" setup>
import { percentageWidth, secondsToTime } from '@/utils/time';

defineProps<{
    item: {progress?: number | null, duration: number}
}>()
</script>