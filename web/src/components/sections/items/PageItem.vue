<template>
    <SectionItem :item="item">
        <template #subtitle>
            <p>{{item.code}}</p>
        </template>
    </SectionItem>
</template>
<script lang="ts" setup>
import SectionItem, { PageItem } from "../SectionItem.vue"

defineProps<{
    item: PageItem
}>()
</script>
