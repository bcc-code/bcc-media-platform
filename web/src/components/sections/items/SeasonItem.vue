<template>
    <SectionItem :item="item">
        <template #subtitle>
            <div class="w-full"> 
                <p v-if="item.show && item.number" class="text-sm truncate text-secondary">{{item.show}} <span class="text-sm text-faded">S{{item.number}}</span></p>
            </div>
        </template>
    </SectionItem>
</template>
<script lang="ts" setup>
import SectionItem, { SeasonItem } from "../SectionItem.vue"

defineProps<{
    item: SeasonItem
}>()
</script>