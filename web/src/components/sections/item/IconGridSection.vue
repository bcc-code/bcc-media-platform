<template>
    <section class="w-full">
        <SectionTitle v-if="item.title">{{ item.title }}</SectionTitle>
        <div
            class="grid w-full grid-flow-dense grid-cols-[repeat(auto-fill,8rem)] lg:grid-cols-[repeat(auto-fill,10rem)]"
        >
            <div
                v-for="(i, index) in item.items.items"
                class="relative mb-5 m-2"
                @click="$emit('clickItem', index)"
            >
                <div
                    class="aspect-square bg-slate-800 rounded-2xl border-2 border-slate-700 p-4 cursor-pointer"
                >
                    <Image :src="i.image" size-source="width" />
                </div>
                <div class="mx-auto mt-2">
                    <p
                        class="w-full text-center text-ellipsis text-style-body-1 line-clamp-2"
                    >
                        {{ i.title }}
                    </p>
                </div>
            </div>
        </div>
    </section>
</template>
<script lang="ts" setup>
import { Section } from "../types"

import SectionTitle from "./SectionTitle.vue"
import Image from "@/components/Image.vue"

defineProps<{
    position: number
    item: Section & { __typename: "IconGridSection" }
}>()

defineEmits<{
    (event: "clickItem", index: number): void
}>()
</script>
