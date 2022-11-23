<template>
    <section>
        <div class="w-full max-w-xl">

        </div>
    </section>
</template>
<script lang="ts" setup>
import { Section } from "./types"
import { computed, ref } from "vue"

const props = defineProps<{
    item: Section & { __typename: "WebSection" }
}>()

const frame = ref(null as HTMLIFrameElement | null)

const effectiveHeight = computed(() => {
    if (!frame.value) {
        return 0
    }
    const rect = frame.value.getBoundingClientRect()

    return rect.width / props.item.widthRatio
})
</script>
