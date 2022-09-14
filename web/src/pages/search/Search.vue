<template>
    <div>
        <h1>Search</h1>
        <input v-model="queryString" type="text" placeholder="Search..." />
    </div>
</template>
<script lang="ts" setup>
import { useSearchQuery } from '@/graph/generated';
import { ref } from 'vue';

const queryString = ref("")

const {} = useSearchQuery()
</script>
