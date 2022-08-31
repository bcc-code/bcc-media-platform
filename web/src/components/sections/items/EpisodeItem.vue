<template>
    <SectionItem :item="item">
        <template #subtitle>
            <div class="w-full"> 
                <p v-if="item.show && item.season && item.number" class="text-sm truncate text-secondary">{{item.show}} <span class="text-sm text-faded">S{{item.season}}:E{{item.number}}</span></p>
            </div>
        </template>
    </SectionItem>
</template>
<script lang="ts" setup>
import SectionItem, { EpisodeItem } from "../SectionItem.vue"

defineProps<{
    item: EpisodeItem
}>()
</script>