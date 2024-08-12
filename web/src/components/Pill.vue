<script lang="ts" setup>
defineProps<{
    color?: string
}>()
</script>

<template>
    <span
        class="rounded-xl text-sm px-2 z-10 font-medium"
        :class="color ?? 'bg-slate-800'"
    >
        <slot />
    </span>
</template>
w
