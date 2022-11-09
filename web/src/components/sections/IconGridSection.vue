<template>
    <section>
        <SectionTitle v-if="item.title">{{ item.title }}</SectionTitle>
        <div class="grid grid-cols-2">
            <div
                v-for="i in item.items.items"
                class="relative mb-5 m-2 lg:m-10"
                ref="sectionItem"
                @click="goToSectionItem(i)"
            >
                <div
                    class="aspect-square bg-slate-800 rounded-2xl border-2 border-slate-700 p-4 cursor-pointer"
                >
                    <img
                        :src="
                            i.image + `?h=${imageSize}&w=${imageSize}&fit=crop`
                        "
                        loading="lazy"
                        class="object-cover m-auto rounded-lg"
                    />
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
import { Section } from "./types"

import SectionTitle from "./SectionTitle.vue"
import { goToSectionItem } from "@/utils/items"
import { onMounted, ref } from "vue"
import { getImageSize } from "@/utils/images"

defineProps<{
    item: Section & { __typename: "IconGridSection" }
}>()

const sectionItem = ref(null as HTMLDivElement[] | null)

const imageSize = ref(0)

onMounted(() => {
    const div = sectionItem.value?.[0]

    imageSize.value = getImageSize(div?.getBoundingClientRect().width ?? 100)
})
</script>
