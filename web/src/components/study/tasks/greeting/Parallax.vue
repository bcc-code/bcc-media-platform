<template>
    <div :style="style" ref="root"><slot> </slot></div>
</template>

<script setup lang="ts">
import { onMounted, onUnmounted, ref, StyleValue, VNodeRef, watch } from "vue"

const props = defineProps<{
    scrollHandler: Function
    parentScrollEl: Element
    targetScrollEl: Element
}>()
const style = ref<StyleValue>()
const root = ref<HTMLElement | undefined>(undefined)

const getRelativeCoords = (el: Element): { top: number; left: number } => {
    const box = el.getBoundingClientRect()
    const scrollTop = props.parentScrollEl.scrollTop
    const scrollLeft = props.parentScrollEl.scrollLeft

    const clientTop = props.parentScrollEl.clientTop || 0
    const clientLeft = props.parentScrollEl.clientLeft || 0

    const top = box.top + scrollTop - clientTop
    const left = box.left + scrollLeft - clientLeft
    return { top: Math.round(top), left: Math.round(left) }
}

const positionOriginal = ref(getRelativeCoords(props.targetScrollEl).top)
const scrollOriginal = ref(props.parentScrollEl.scrollTop)

const setStyle = () => {
    style.value = props.scrollHandler(
        positionOriginal.value +
            scrollOriginal.value -
            props.parentScrollEl.scrollTop
    )
}

const init = () => {
    console.log("init")
    props.parentScrollEl.addEventListener("scroll", () => setStyle())
}

onMounted(() => {
    if (typeof window === "undefined") {
        return
    }
    if (document.readyState === "complete") {
        init()
    } else {
        /*  window.addEventListener("load", init)
        window.addEventListener("resize", init) */
    }
})
onUnmounted(() => {
    props.parentScrollEl.removeEventListener("scroll", setStyle)
})
</script>
