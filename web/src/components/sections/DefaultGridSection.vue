<template>
    <section>
        <SectionTitle v-if="item.title">{{ item.title }}</SectionTitle>
        <div class="grid grid-cols-2">
            <div v-for="i in page.items" class="relative mb-5">
                <NewPill class="absolute top-0 -right-1" :item="i"></NewPill>
                <div
                    class="flex flex-col cursor-pointer mx-2 mt-2 hover:opacity-90 transition"
                    @click="goToSectionItem(i, item.metadata?.collectionId)"
                >
                    <div
                        class="relative mb-1 rounded-md w-full aspect-video overflow-hidden"
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
                    <SectionItemTitle :i="i"></SectionItemTitle>
                </div>
            </div>
        </div>
    </section>
</template>
<script lang="ts" setup>
import { Section } from "./types"

import SectionTitle from "./SectionTitle.vue"
import NewPill from "./NewPill.vue"
import { goToSectionItem } from "@/utils/items"
import SectionItemTitle from "./SectionItemTitle.vue"
import ProgressBar from "../episodes/ProgressBar.vue"
import Image from "../Image.vue"
import { computed, nextTick, onUnmounted, ref } from "vue"
import { useGetSectionQuery } from "@/graph/generated"

const props = defineProps<{
    item: Section & { __typename: "DefaultGridSection" }
    paginate?: boolean
}>()

const page = ref(props.item.items)

const first = ref(20);
const offset = ref(0);

const sectionId = computed(() => props.item.id)

const sectionQuery = useGetSectionQuery({
    pause: true,
    variables: {
        id: sectionId,
        first,
        offset,
    }
})

if(props.paginate) {
    document.body.onscroll = async () => {
        let bottomOfWindow = document.documentElement.scrollTop + window.innerHeight === document.documentElement.offsetHeight;

        if (bottomOfWindow && (page.value.total > (page.value.offset + page.value.first)) && !sectionQuery.fetching.value) {
            console.log(page.value)

            offset.value += page.value.first

            await nextTick()

            const { data } = await sectionQuery.executeQuery()

            if (data.value?.section.__typename === "DefaultGridSection") {
                const p = data.value.section.items;
                page.value.items.push(...p.items)
                page.value.first = p.first
                page.value.offset = p.offset
            }

            console.log(page.value);
        }
    }

    onUnmounted(() => document.body.onscroll = null)
}
</script>
