<template>
    <section>
        <SectionTitle v-if="item.title">{{ item.title }}</SectionTitle>
        <div
            class="w-full md:w-1/2 xl:w-1/4 xl:min-w-[400px]"
            :style="{
                aspectRatio: item.aspectRatio ?? undefined,
                height: item.height ?? undefined,
            }"
        >
            <iframe ref="frame" class="w-full h-full" :src="item.url"></iframe>
        </div>
    </section>
</template>
<script lang="ts" setup>
import { Section } from "./types"
import SectionTitle from "./item/SectionTitle.vue"

defineProps<{
    item: Section & { __typename: "WebSection" }
}>()
</script>
