<template>
    <section>
        <SectionTitle v-if="item.title">{{ item.title }}</SectionTitle>
        <div class="flex flex-col">
            <div v-for="i in item.items.items" class="relative">
                <NewPill class="absolute top-0 right-0" :item="i"></NewPill>
                <div
                    class="flex flex-col cursor-pointer mx-2 mt-2"
                    @click="goToSectionItem(i)"
                >
                    <div class="relative mb-1">
                        <img
                            :id="i.id"
                            :src="
                                i.image +
                                `?h=225&w=400&fit=crop&crop=faces`
                            "
                            loading="lazy"
                            class="rounded-md top-0 w-full object-cover aspect-video"
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

defineProps<{
    item: Section & { __typename: "ListSection" }
}>()
</script>
