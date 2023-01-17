<template>
    <div class="relative">
        <slot></slot>
        <ProgressBar
            v-if="item"
            class="absolute bottom-0 w-full"
            :item="item"
        ></ProgressBar>
    </div>
</template>
<script lang="ts" setup>
import ProgressBar from "./ProgressBar.vue"

defineProps<{
    item?: { id: string; progress?: number | null; duration: number }
}>()
</script>
