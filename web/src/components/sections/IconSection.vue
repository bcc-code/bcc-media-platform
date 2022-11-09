<template>
    <section>
        <SectionTitle v-if="item.title">{{ item.title }}</SectionTitle>
        <div class="flex gap-4">
            <div
                v-for="i in item.items.items"
                class="overflow-clip w-20"
                @click="goToSectionItem(i)"
                ref="sectionItem"
            >
                <div
                    class="aspect-square bg-slate-800 rounded-2xl border-2 border-slate-700 p-2 cursor-pointer"
                >
                    <Image :src="i.image" size-source="width"/>
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
import { Section } from "./types"

import SectionTitle from "./SectionTitle.vue"
import { goToSectionItem } from "@/utils/items"
import { onMounted, ref } from "vue"
import { getImageSize } from "@/utils/images"
import Image from "../Image.vue"

defineProps<{
    item: Section & { __typename: "IconSection" }
}>()

const sectionItem = ref(null as HTMLDivElement[] | null)

const imageSize = ref(0)

onMounted(() => {
    const div = sectionItem.value?.[0]

    imageSize.value = getImageSize(div?.getBoundingClientRect().width ?? 100)
})
</script>
