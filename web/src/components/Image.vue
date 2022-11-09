<template>
    <img ref="image" :src="effectiveSrc" loading="lazy" />
</template>
<script lang="ts" setup>
import { getImageSize } from "@/utils/images";
import { computed, ref } from "vue"

const props = defineProps<{
    src?: string | null
    sizeSource: "width" | "height"
    ratio?: number
}>()

const image = ref(null as HTMLImageElement | null)

const parentDimensions = computed(() => {
    const dimensions = {
        height: 100,
        width: 100
    }
    const rect = image.value?.parentElement?.getBoundingClientRect()
    if (rect) {
        dimensions.height = rect.height
        dimensions.width = rect.width
    }
    return dimensions
})

const effectiveSrc = computed(() => {
    return (
        props.src +
        `?w=${effectiveWidth.value}&h=${effectiveHeight.value}&fit=crop&crop=faces`
    )
})

const effectiveWidth = computed(() => {
    return props.sizeSource === "height" ? getImageSize(parentDimensions.value.height) * (props.ratio ?? 1) : getImageSize(parentDimensions.value.width)
})

const effectiveHeight = computed(() => {
    return props.sizeSource === "height" ? getImageSize(parentDimensions.value.height) : getImageSize(parentDimensions.value.width) * (props.ratio ?? 1)
})
</script>
