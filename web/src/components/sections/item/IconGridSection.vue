<template>
    <section>
        <SectionTitle v-if="item.title">{{ item.title }}</SectionTitle>
        <div class="grid grid-cols-2">
            <div
                v-for="(i, index) in item.items.items"
                class="relative mb-5 m-2 lg:m-10"
                @click="$emit('clickItem', index)"
            >
                <div
                    class="aspect-square bg-slate-800 rounded-2xl border-2 border-slate-700 p-4 cursor-pointer"
                >
                    <Image :src="i.image" size-source="width" />
                </div>
                <div class="mx-auto">
                    <p
                        class="w-full text-center text-ellipsis text-lg line-clamp-2"
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
