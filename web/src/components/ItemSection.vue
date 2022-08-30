<template>
    <div>
        <div v-if="loading">
        </div>
        <div v-else-if="section">
            <h1 class="text-xl">{{section.title}}</h1>
            <div>
                <p v-for="i in section.items">
                    {{i.title}}
                </p>
            </div>
        </div>
        <div v-else>
            Invalid section
        </div>
    </div>
</template>
<script lang="ts" setup>
import { useGetSectionQuery } from '@/graph/generated';
import { ref } from 'vue';

export type Section = {
    title: string;
    items: {
        title: string;
        image?: string;
    }[]
}

const props = defineProps<{
    section: Section
}>()


const loading = ref(false)
</script>
