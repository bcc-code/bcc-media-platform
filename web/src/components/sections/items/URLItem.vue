<template>
    <SectionItem :item="item">
        <template #subtitle>
            <div class="w-full"> 
                <p class="text-sm truncate text-secondary">Link</p>
            </div>
        </template>
    </SectionItem>
</template>
<script lang="ts" setup>
import SectionItem, { URLItem } from "../SectionItem.vue"

defineProps<{
    item: URLItem
}>()
</script>