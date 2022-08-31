<template>
    <div>
        <div v-if="section" class="overflow-hidden">
            <h1 class="text-xl">{{ section.title }}</h1>
            <div class="whitespace-nowrap overflow-auto">
                <SectionItem
                    class="m-1 w-64 top-0 h-full inline-block cursor-pointer shadow hover:shadow-lg hover:shadow-inner"
                    v-for="item in section.items.items"
                    :item="item"
                ></SectionItem>
            </div>
        </div>
        <div v-else>Invalid section</div>
    </div>
</template>
<script lang="ts" setup>
import { Section } from "./types"
import SectionItem from "./SectionItem.vue"

defineProps<{
    section: Section
}>()
</script>
