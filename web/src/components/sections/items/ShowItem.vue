<template>
    <SectionItem :item="item">
        <template #subtitle>
            <div class="w-full"> 
                <p class="text-sm truncate text-secondary">Show</p>
            </div>
        </template>
    </SectionItem>
</template>
<script lang="ts" setup>
import SectionItem, { ShowItem } from "../SectionItem.vue"

defineProps<{
    item: ShowItem
}>()
</script>