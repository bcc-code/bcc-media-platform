<template>
    <div class="max-w-sm">
        <img v-if="item.image" :src="item.image" />
        <div class="flex">
            <h1 class="text-lg text-primary font-bold">{{ item.title }}</h1>
            <p class="ml-auto text-gray">{{ item.__typename }}</p>
        </div>
        <p>{{ item.description }}</p>
    </div>
</template>
<script lang="ts" setup>
import { SearchQuery } from "@/graph/generated"

defineProps<{
    item: SearchQuery["search"]["result"][0]
}>()
</script>
