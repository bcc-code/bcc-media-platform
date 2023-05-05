<template>
    <div
        class="bg-primary-light overflow-hidden"
        :class="[!loaded ? 'border-1 border border-slate-700 opacity-50' : '']"
        ref="imageContainer"
    >
        <img
            ref="image"
            class="object-cover w-full transition"
            :class="[!loaded ? 'opacity-0' : 'opacity-100']"
            :height="effectiveHeight"
            :width="effectiveWidth"
            :loading="loading"
            :draggable="draggable"
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
    draggable?: boolean
}>()

const loaded = ref(false)

const image = ref(null as HTMLImageElement | null)
const imageContainer = ref(null as HTMLDivElement | null)
const parentDimensions = ref({
    height: 100,
    width: 100,
})

onMounted(() => {
    setTimeout(() => {
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
    }, 50)
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
