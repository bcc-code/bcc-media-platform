<script lang="ts" setup>
defineProps<{
    selected?: boolean
}>()
</script>
<template>
    <img
        :src="
            !selected
                ? '/icons/tabbar/Search/Default.svg'
                : '/icons/tabbar/Search/Selected.svg'
        "
    />
</template>
