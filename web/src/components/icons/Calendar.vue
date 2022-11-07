<template>
    <img :src="'/icons/tabbar/Calendar/' + (!selected ? 'Default.svg' : 'Selected.svg')">
</template>
<script lang="ts" setup>
defineProps<{
    selected?: boolean
}>()
</script>
