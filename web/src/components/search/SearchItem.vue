<template>
    <div
        class="flex aspect-video bg-cover bg-center bg-no-repeat rounded rounded-2xl"
        :style="{
            'background-image':
                'linear-gradient(to top, rgba(0, 0, 0, 0.8), rgba(0, 0, 0, 0), rgba(0, 0, 0, 0)), url(\'' +
                item.image +
                '\')',
        }"
    >
        <h1 class="text-lg p-2 text-primary font-semibold mt-auto">{{ item.title }}</h1>
    </div>
</template>
<script lang="ts" setup>
import { SearchQuery } from "@/graph/generated"

defineProps<{
    item: SearchQuery["search"]["result"][0]
}>()
</script>
