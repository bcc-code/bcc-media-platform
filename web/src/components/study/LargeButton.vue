<template>
    <button
        class="flex items-center justify-center flex-1 h-full px-5 py-3 border rounded-full border-indigo-200 border-opacity-10 transition-colors ease-in-out duration-200 text-style-button-1"
        :class="[styles.background, styles.text, !disabled ? 'active:opacity-80' : null]" :disabled="disabled">
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
