<template>
    <img :src="!selected ? '/icons/tabbar/Live/Default.svg' : '/icons/tabbar/Live/Selected.svg'">
</template>
<script lang="ts" setup>
defineProps<{
    selected?: boolean
}>()
</script>
