<template>
    <section>
        <SectionTitle v-if="item.title">{{ item.title }}</SectionTitle>
        <div class="w-full mx-auto max-w-xl">
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
import SectionTitle from "./SectionTitle.vue"
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
