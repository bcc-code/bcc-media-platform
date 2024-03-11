<script lang="ts" setup>
import { Section } from "./types"
import SectionTitle from "./item/SectionTitle.vue"
import { ref } from "vue"
import Loader from "../Loader.vue"

defineProps<{
    item: Section & { __typename: "WebSection" }
}>()

const iframeLoaded = ref(false)
</script>

<template>
    <section>
        <SectionTitle v-if="item.title">{{ item.title }}</SectionTitle>
        <div
            class="w-full md:w-1/2 xl:w-1/4 xl:min-w-[400px] relative"
            :style="{
                aspectRatio: item.aspectRatio ?? undefined,
                height: item.height ?? undefined,
            }"
        >
            <div
                class="flex items-center justify-center w-full h-full absolute"
                v-if="!iframeLoaded"
            >
                <Loader variant="spinner" />
            </div>
            <iframe
                ref="frame"
                class="w-full h-full"
                @load="iframeLoaded = true"
                :src="item.url"
            ></iframe>
        </div>
    </section>
</template>
