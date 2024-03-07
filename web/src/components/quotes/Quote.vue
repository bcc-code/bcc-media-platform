<script lang="ts" setup>
defineProps<{
    author: string
    quote: string
}>()
</script>
<template>
    <div
        class="inline-flex flex-col items-center justify-center w-full h-full bg-background-2 rounded-2xl"
    >
        <div class="p-4 text-style-body-2 text-center">«{{ quote }}»</div>
        <div>{{ author }}</div>
    </div>
</template>
