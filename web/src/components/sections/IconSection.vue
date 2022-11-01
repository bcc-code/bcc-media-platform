<template>
    <section>
        <SectionTitle v-if="item.title">{{ item.title }}</SectionTitle>
        <div class="flex gap-4">
            <div v-for="i in item.items.items" class="overflow-hidden">
                <div
                    class="aspect-square bg-slate-800 rounded-2xl border-2 border-slate-700 p-4 cursor-pointer"
                    @click="goToSectionItem(i)"
                >
                    <img
                        :src="i.image + '?h=150&w=150&fit=crop'"
                        loading="lazy"
                        class="object-cover m-auto"
                    />
                </div>
                <div class="w-40 mx-auto">
                    <p class="w-full text-center break-normal ellipsis text-lg">
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

defineProps<{
    item: Section & { __typename: "IconSection" }
}>()
</script>
