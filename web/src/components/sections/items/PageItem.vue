<template>
    <SectionItem :item="item">
        <template #subtitle>
            <div class="w-full">
                <p class="text-sm truncate text-secondary">Page</p>
            </div>
        </template>
    </SectionItem>
</template>
<script lang="ts" setup>
import SectionItem, { PageItem } from "../SectionItem.vue"

defineProps<{
    item: PageItem
}>()
</script>
