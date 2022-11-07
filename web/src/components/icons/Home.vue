<template>
    <img :src="!selected ? '/icons/tabbar/Home/Default.svg' : '/icons/tabbar/Home/Selected.svg'">
</template>
<script lang="ts" setup>
defineProps<{
    selected?: boolean
}>()
</script>
