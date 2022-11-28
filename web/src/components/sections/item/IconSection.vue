<template>
    <section>
        <SectionTitle v-if="item.title">{{ item.title }}</SectionTitle>
        <div class="flex gap-4">
            <div
                v-for="(i, index) in item.items.items"
                class="overflow-clip w-20 hover:opacity-90 transition"
                @click="$emit('clickItem', index)"
                ref="sectionItem"
            >
                <div
                    class="bg-slate-800 rounded-2xl border-2 border-slate-700 p-2 cursor-pointer overflow-hidden"
                >
                    <Image
                        class="rounded-lg"
                        :src="i.image"
                        size-source="width"
                    />
                </div>
                <div class="mx-auto">
                    <p class="w-full text-center text-lg line-clamp-2">
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
import { onMounted, ref } from "vue"
import { getImageSize } from "@/utils/images"
import Image from "@/components/Image.vue"

defineProps<{
    position: number
    item: Section & { __typename: "IconSection" }
}>()

defineEmits<{
    (event: "clickItem", index: number): void
}>()

const sectionItem = ref(null as HTMLDivElement[] | null)

const imageSize = ref(0)

onMounted(() => {
    const div = sectionItem.value?.[0]

    imageSize.value = getImageSize(div?.getBoundingClientRect().width ?? 100)
})
</script>
