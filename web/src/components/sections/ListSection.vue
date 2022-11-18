<template>
    <section>
        <SectionTitle v-if="item.title">{{ item.title }}</SectionTitle>
        <div class="flex flex-col lg:grid lg:grid-cols-2">
            <div v-for="i in item.items.items" class="relative">
                <NewPill class="absolute top-0 right-0" :item="i"></NewPill>
                <div
                    class="flex flex-col cursor-pointer mx-2 mt-2 hover:opacity-90"
                    @click="goToSectionItem(i, item.metadata?.collectionId)"
                    ref="sectionItem"
                >
                    <div
                        class="relative mb-1 rounded-md w-full aspect-video overflow-hidden transition"
                    >
                        <Image
                            :src="i.image"
                            size-source="width"
                            :ratio="9 / 16"
                        />
                        <ProgressBar
                            class="absolute bottom-0 w-full"
                            v-if="i.item?.__typename === 'Episode'"
                            :item="i.item"
                        />
                    </div>
                    <SectionItemTitle :for="i.id" :i="i"></SectionItemTitle>
                </div>
            </div>
        </div>
    </section>
</template>
<script lang="ts" setup>
import { Section } from "./types"
import SectionTitle from "./SectionTitle.vue"
import { goToSectionItem } from "@/utils/items"
import NewPill from "./NewPill.vue"
import SectionItemTitle from "./SectionItemTitle.vue"
import ProgressBar from "../episodes/ProgressBar.vue"
import { onMounted, ref } from "vue"
import { getImageSize } from "@/utils/images"
import Image from "../Image.vue"

defineProps<{
    item: Section & { __typename: "ListSection" }
}>()

const sectionItem = ref(null as HTMLDivElement[] | null)

const loadImage = ref(false)

const imageSize = ref(0)

onMounted(() => {
    const div = sectionItem.value?.[0]

    imageSize.value = getImageSize(div?.getBoundingClientRect().width ?? 100)
    loadImage.value = true
})
</script>
