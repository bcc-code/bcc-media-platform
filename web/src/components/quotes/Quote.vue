<script lang="ts" setup>
const props = defineProps<{
    quote: string
    author: string | undefined
    source: string | undefined
}>()

const size = props.quote.length > 20 ? "text-style-body-3" : "text-style-body-2"
</script>
<template>
    <div class="text-center flex items-center flex-col justify-center">
        <div class="mb-2" :class="size">«{{ quote }}»</div>
        <div v-if="author" class="pt-1 text-style-body-2 !font-bold">
            {{ author }}
        </div>
        <div v-if="source" class="pt-1 text-style-body-2">{{ source }}</div>
    </div>
</template>
