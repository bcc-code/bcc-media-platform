<script lang="ts" setup>
import { getImageSize } from "@/utils/images"
import { useElementSize, useParentElement, watchDebounced } from "@vueuse/core"
import { computed, ref } from "vue"

const props = withDefaults(
    defineProps<{
        src?: string | null
        sizeSource: "width" | "height"
        ratio?: number
        loading?: "lazy" | "eager"
        draggable?: boolean
    }>(),
    {
        loading: "lazy",
    }
)

const loaded = ref(false)
const loadStart = ref(false)
const onLoaded = () => {
    loaded.value = true
}
const onLoadStart = () => {
    loadStart.value = true
}

const imageContainer = ref(null as HTMLDivElement | null)

const { height, width } = useElementSize(useParentElement())

const effectiveSrc = computed(() => {
    if (!props.src || !effectiveSize.value) {
        return "null"
    }
    return (
        props.src +
        `?w=${effectiveSize.value.width}&h=${effectiveSize.value.height}&fit=crop&crop=faces`
    )
})

const effectiveSize = ref<{
    width: number
    height: number
}>()
watchDebounced(
    [height, width],
    () => {
        let w = Math.floor(
            props.sizeSource === "height"
                ? getImageSize(height.value) * (props.ratio ?? 1)
                : getImageSize(width.value)
        )
        if (effectiveSize.value && w < effectiveSize.value.width) {
            w = effectiveSize.value.width
        }

        let h = Math.floor(
            props.sizeSource === "height"
                ? getImageSize(height.value)
                : w * (props.ratio ?? 1)
        )
        if (effectiveSize.value && h < effectiveSize.value.height) {
            h = effectiveSize.value.height
        }

        effectiveSize.value = { width: w, height: h }
    },
    {
        debounce: computed(() => {
            return loaded.value ? 300 : 0
        }),
    }
)
</script>

<template>
    <div
        ref="imageContainer"
        class="bg-primary-light overflow-hidden relative"
        :class="[!loaded ? 'border-1 border border-slate-700 opacity-50' : '']"
    >
        <img
            class="object-cover w-full transition"
            :class="[!loaded ? 'opacity-0' : 'opacity-100']"
            :height="effectiveSize?.height"
            :width="effectiveSize?.width"
            :loading="loading"
            :draggable="draggable"
            :src="effectiveSrc"
            @loadstart="onLoadStart"
            @load="onLoaded"
        />
    </div>
</template>
