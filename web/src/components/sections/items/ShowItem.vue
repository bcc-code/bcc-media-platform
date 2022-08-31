<template>
    <SectionItem :item="item">
        <template #subtitle>
            <p>Show</p>
        </template>
    </SectionItem>
</template>
<script lang="ts" setup>
import SectionItem, { ShowItem } from "../SectionItem.vue"

defineProps<{
    item: ShowItem
}>()
</script>
