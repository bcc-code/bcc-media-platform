<template>
    <button
        class="cursor-pointer rounded-md border border-primary py-2 px-3 text-left shadow-sm hover:border-indigo-500 focus:border-indigo-500 focus:outline-none focus:ring-1 focus:ring-indigo-500 sm:text-sm"
        :class="[styles.background, styles.text]"
    >
        <slot></slot>
    </button>
</template>
<script lang="ts" setup>
import { computed } from "vue"

type Types = "default" | "error" | "warning" | "info"

const props = defineProps<{
    theme?: Types
}>()

const styles = computed(() => {
    switch (props.theme) {
        case "error":
            return {
                background: "bg-red-500 hover:bg-red-700",
                text: "text-white",
            }
        case "warning":
            return {
                background: "bg-yellow-500 hover:bg-yellow-700",
                text: "text-white",
            }
        case "info":
            return {
                background: "bg-primary hover:bg-primary-light",
                text: "text-white",
            }
        default:
            return {
                background: "bg-green-500 hover:bg-green-700",
                text: "text-white",
            }
    }
})
</script>
