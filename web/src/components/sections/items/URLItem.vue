<template>
    <SectionItem :item="item">
        <template #subtitle>
            <p>Link</p>
        </template>
    </SectionItem>
</template>
<script lang="ts" setup>
import SectionItem, { URLItem } from "../SectionItem.vue"

defineProps<{
    item: URLItem
}>()
</script>
