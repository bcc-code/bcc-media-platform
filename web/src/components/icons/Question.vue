<script lang="ts" setup>
defineProps<{
    selected?: boolean
}>()
</script>
<template>
    <img
        :src="
            '/icons/module/Medium/Question/' +
            (!selected ? 'White.svg' : 'White.svg')
        "
    />
</template>
