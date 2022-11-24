<template>
    <section>
        <SectionTitle v-if="item.title">{{ item.title }}</SectionTitle>
        <div
            class="flex flex-col lg:grid lg:grid-cols-2 overflow-y-scroll"
        >
            <div
                v-for="i in page.items"
                class="relative"
                :key="i.id + i.item.__typename"
            >
                <NewPill class="absolute top-0 right-0" :item="i"></NewPill>
                <div
                    class="flex flex-col cursor-pointer mx-2 mt-2 hover:opacity-90"
                    @click="goToSectionItem(i, item.metadata?.collectionId)"
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
import { Section } from "../types"
import SectionTitle from "./SectionTitle.vue"
import { goToSectionItem } from "@/utils/items"
import NewPill from "./NewPill.vue"
import SectionItemTitle from "./SectionItemTitle.vue"
import ProgressBar from "@/components/episodes/ProgressBar.vue"
import { ref } from "vue"
import Image from "@/components/Image.vue"

const props = defineProps<{
    item: Section & { __typename: "ListSection" }
}>()

const page = ref(props.item.items)
</script>
