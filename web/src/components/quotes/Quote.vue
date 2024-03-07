<script lang="ts" setup>
defineProps<{
    author: string
    quote: string
}>()
</script>
<template>
    <div class="text-left flex">
        <div class="w-0.5 rounded-full bg-white shrink-0"></div>
        <div class="pl-3 pb-2">
            <div class="text-style-body-1">«{{ quote }}»</div>
            <div class="pt-2 text-style-body-2">{{ author }}</div>
        </div>
    </div>
</template>
