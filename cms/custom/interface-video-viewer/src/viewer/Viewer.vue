<template>
</template>
<script lang="ts" setup>
import { useApi } from '@directus/extensions-sdk';

const { get } = useApi();

const test = await get("/preview/10100");
console.log(test);
</script>