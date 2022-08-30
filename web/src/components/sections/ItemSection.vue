<template>
    <div>
        <div v-if="section" class="overflow-hidden" >
            <h1 class="text-xl">{{section.title}}</h1>
            <div class="overflow-auto whitespace-nowrap">
                <SectionItem class="m-2 h-full inline-block" :item="item" v-for="item in section.items"></SectionItem>
            </div>
        </div>
        <div v-else>
            Invalid section
        </div>
    </div>
</template>
<script lang="ts" setup>
import SectionItem, { Item } from './SectionItem.vue';

export type Section = {
    title: string;
    items: Item[]
}

defineProps<{
    section: Section
}>()
</script>
