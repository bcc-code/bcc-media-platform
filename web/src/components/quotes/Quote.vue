<script lang="ts" setup>
const props = defineProps<{
    author: string
    quote: string
}>()

const size =
    props.quote.length > 20 ? "text-style-title-3" : "text-style-title-2"
</script>
<template>
    <div class="text-center flex items-center flex-col justify-center">
        <div :class="size">«{{ quote }}»</div>
        <div class="pt-2 text-style-body-2">{{ author }}</div>
    </div>
</template>
