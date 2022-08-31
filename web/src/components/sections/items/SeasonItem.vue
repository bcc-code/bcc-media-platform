<template>
    <SectionItem :item="item">
        <template #subtitle>
            <p
                v-if="item.show && item.number"
            >
                {{ item.show }}
                <span class="text-sm text-faded">S{{ item.number }}</span>
            </p>
        </template>
    </SectionItem>
</template>
<script lang="ts" setup>
import SectionItem, { SeasonItem } from "../SectionItem.vue"

defineProps<{
    item: SeasonItem
}>()
</script>
