<template>
    <div
        class="bg-primary-light overflow-hidden"
        :class="[!loaded ? 'border-1 border border-slate-700 opacity-50' : '']"
        ref="imageContainer"
    >
        <img
            class="object-cover w-full transition"
            :class="[!loaded ? 'opacity-0' : 'opacity-100']"
            :height="effectiveHeight"
            :width="effectiveWidth"
            :loading="loading"
            :draggable="draggable"
            @load="loaded = true"
            :src="effectiveSrc"
        />
    </div>
</template>

<script lang="ts" setup>
import { getImageSize } from "@/utils/images"
import { computed, onMounted, ref, onBeforeUnmount } from "vue"

const props = defineProps<{
    src?: string | null
    sizeSource: "width" | "height"
    ratio?: number
    loading?: "lazy" | "eager"
    draggable?: boolean
}>()

const loaded = ref(false)

const imageContainer = ref(null as HTMLDivElement | null)
const parentDimensions = ref({
    height: 100,
    width: 100,
})

const handleResize = () => {
    const dimensions = {
        height: 100,
        width: 100,
    }
    const parent = imageContainer.value
    if (parent) {
        dimensions.height = parent.clientHeight
        dimensions.width = parent.clientWidth
    }
    parentDimensions.value = dimensions
}

onMounted(() => {
    handleResize()
    window.addEventListener("resize", handleResize)
})

onBeforeUnmount(() => {
    window.removeEventListener("resize", handleResize)
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
