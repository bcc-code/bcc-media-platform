<template>
    <section>
        <SectionTitle v-if="item.title">{{ item.title }}</SectionTitle>
        <div class="flex gap-4 flex-wrap">
            <div
                v-for="(i, index) in item.items.items"
                class="w-20 shrink-0 2xl:w-32 hover:opacity-90 transition"
                @click="click(index)"
                ref="sectionItem"
            >
                <div
                    class="bg-slate-800 relative rounded-2xl border-2 border-slate-700 cursor-pointer overflow-hidden"
                >
                    <div
                        v-if="clicked === index"
                        class="absolute w-full h-full flex"
                    >
                        <Loader
                            variant="spinner"
                            class="m-auto h-16 w-16"
                        ></Loader>
                    </div>
                    <Image
                        class="rounded-lg m-2"
                        :class="{
                            'opacity-50': clicked === index,
                        }"
                        :src="i.image"
                        size-source="width"
                    />
                </div>
                <div class="mx-auto mt-1">
                    <p
                        class="w-full text-center text-style-body-2 line-clamp-2"
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
import { onMounted, ref } from "vue"
import { getImageSize } from "@/utils/images"
import Image from "@/components/Image.vue"
import Loader from "@/components/Loader.vue"

defineProps<{
    position: number
    item: Section & { __typename: "IconSection" }
}>()

const emit = defineEmits<{
    (event: "clickItem", index: number): void
}>()

const sectionItem = ref(null as HTMLDivElement[] | null)

const imageSize = ref(0)

const clicked = ref(-1)

const click = (index: number) => {
    emit("clickItem", index)
    clicked.value = index
}

onMounted(() => {
    const div = sectionItem.value?.[0]

    imageSize.value = getImageSize(div?.getBoundingClientRect().width ?? 100)
})
</script>
