<template>
    <SectionItem :item="item">
        <template #subtitle>
            <p
                v-if="item.show && item.season && item.number"
            >
                {{ item.show }}
                <span class="text-sm text-faded"
                    >S{{ item.season }}:E{{ item.number }}</span
                >
            </p>
        </template>
    </SectionItem>
</template>
<script lang="ts" setup>
import SectionItem, { EpisodeItem } from "../SectionItem.vue"

defineProps<{
    item: EpisodeItem
}>()
</script>
