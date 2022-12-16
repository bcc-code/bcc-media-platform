<template>
    <div
        class="bg-primary-light overflow-hidden"
        :class="[!loaded ? 'border-1 border border-slate-700 opacity-50' : '']"
        ref="container"
    >
        <img
            ref="image"
            class="object-cover w-full transition"
            :class="[!loaded ? 'opacity-0' : 'opacity-100']"
            :height="effectiveHeight"
            :width="effectiveWidth"
            :loading="loading"
        />
    </div>
</template>
<script lang="ts" setup>
import { getImageSize } from "@/utils/images"
import { computed, onMounted, ref } from "vue"

const props = defineProps<{
    src?: string | null
    sizeSource: "width" | "height"
    ratio?: number
    loading?: "lazy" | "eager"
}>()

const loaded = ref(false)

const image = ref(null as HTMLImageElement | null)
const container = ref(null as HTMLDivElement | null)

onMounted(() => {
    const i = image.value
    if (!i) {
        return
    }
    i.onerror = () => {}
    i.onload = () => {
        loaded.value = true
    }
    if (props.src) {
        i.src = effectiveSrc.value
    }
})

const parentDimensions = computed(() => {
    const dimensions = {
        height: 100,
        width: 100,
    }
    const rect = container.value?.parentElement?.getBoundingClientRect()
    if (rect) {
        dimensions.height = rect.height
        dimensions.width = rect.width
    }
    return dimensions
})

const effectiveSrc = computed(() => {
    return props.src
        ? props.src +
              `?w=${effectiveWidth.value}&h=${effectiveHeight.value}&fit=crop&crop=faces`
        : "null"
})

const effectiveWidth = computed(() => {
    return Math.floor(
        props.sizeSource === "height"
            ? getImageSize(parentDimensions.value.height) * (props.ratio ?? 1)
            : getImageSize(parentDimensions.value.width)
    )
})

const effectiveHeight = computed(() => {
    return Math.floor(
        props.sizeSource === "height"
            ? getImageSize(parentDimensions.value.height)
            : getImageSize(parentDimensions.value.width) * (props.ratio ?? 1)
    )
})
</script>
