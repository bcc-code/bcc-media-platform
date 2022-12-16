<template>
    <section>
        <SectionTitle v-if="item.title">{{ item.title }}</SectionTitle>
        <div class="w-full">
            <iframe
                ref="frame"
                class="w-full"
                :src="item.url"
                :height="effectiveHeight"
            ></iframe>
        </div>
    </section>
</template>
<script lang="ts" setup>
import { Section } from "./types"
import SectionTitle from "./item/SectionTitle.vue"
import { computed, ref } from "vue"

const props = defineProps<{
    item: Section & { __typename: "WebSection" }
}>()

const frame = ref(null as HTMLIFrameElement | null)

const effectiveHeight = computed(() => {
    if (props.item.height) {
        return props.item.height
    }
    if (!frame.value) {
        return 0
    }
    const rect = frame.value?.getBoundingClientRect()
    if (!rect) {
        return 0
    }

    return rect.width / (props.item.aspectRatio ?? 1)
})
</script>
