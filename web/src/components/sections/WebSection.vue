<script lang="ts" setup>
import type { Section } from './types'
import SectionTitle from './item/SectionTitle.vue'
import { ref } from 'vue'
import Loader from '../Loader.vue'

defineProps<{
    item: Section & { __typename: 'WebSection' }
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
                v-if="!iframeLoaded"
                class="flex items-center justify-center w-full h-full absolute"
            >
                <Loader variant="spinner" />
            </div>
            <iframe
                ref="frame"
                class="w-full h-full"
                :src="item.url"
                @load="iframeLoaded = true"
            ></iframe>
        </div>
    </section>
</template>
