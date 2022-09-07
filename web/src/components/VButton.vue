<template>
    <button
        class="cursor-pointer rounded-full border border-gray py-2 px-3 text-left shadow-sm hover:border-indigo-500 focus:border-indigo-500 focus:outline-none focus:ring-1 focus:ring-indigo-500 sm:text-sm"
        :class="[styles.background, styles.text]"
        :disabled="disabled"
    >
        <slot></slot>
    </button>
</template>
<script lang="ts" setup>
import { computed } from "vue"

type Color = "default" | "red" | "green" | "secondary"

const props = defineProps<{
    color?: Color
    disabled?: boolean
}>()

const styles = computed(() => {
    if (props.disabled) {
        return {
            background: "bg-background",
            text: "text-gray",
        }
    }

    switch (props.color) {
        case "red":
            return {
                background: "bg-red hover:bg-red-hover",
                text: "text-white",
            }
        case "green":
            return {
                background: "bg-green hover:bg-green-hover",
                text: "text-white",
            }
        case "secondary":
            return {
                background: "bg-secondary hover:bg-secondary-hover",
                text: "text-white",
            }
        default:
            return {
                background: "bg-primary hover:bg-primary-hover",
                text: "text-white",
            }
    }
})
</script>
