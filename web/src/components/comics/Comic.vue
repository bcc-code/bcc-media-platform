<script setup lang="ts">
defineProps<{
    comicId: string
}>()
</script>

<template>
    <div class="inline-flex flex-col items-center justify-start w-full h-full">
        <div>Comic here. {{ comicId }}</div>
    </div>
</template>
