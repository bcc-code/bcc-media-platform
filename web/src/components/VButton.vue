<template>
    <button
        class="cursor-pointer rounded-full font-bold leading-normal text-on-tint text-style-button-1 border border-separator-on-light select-none"
        :class="styles"
        :disabled="disabled"
    >
        <slot></slot>
    </button>
</template>
<script lang="ts" setup>
import { computed } from "vue"

type Color = "default" | "red" | "green" | "secondary"
type Size = "default" | "large" | "thin"

const props = defineProps<{
    color?: Color
    disabled?: boolean
    size?: Size
}>()

const styles = computed(() => {
    var styles = ""

    const apply = (str: string) => (styles += ` ${str}`)

    if (props.disabled) {
        apply("bg-background text-label-4 cursor-default")
    } else {
        switch (props.color) {
            case "red":
                apply("bg-red hover:bg-red-hover")
                break
            case "green":
                apply("bg-green hover:bg-green-hover")
                break
            case "secondary":
                apply("bg-secondary hover:bg-secondary-hover")
                break
            default:
                apply("bg-primary hover:bg-primary-hover")
                break
        }
    }

    switch (props.size) {
        case "large":
            apply("px-5 py-3")
            break
        case "thin":
            apply("px-4 py-1")
            break
        default:
            apply("px-4 py-2 ")
            break
    }

    return styles
})
</script>
