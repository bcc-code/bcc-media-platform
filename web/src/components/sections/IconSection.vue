<template>
    <section>
        <SectionTitle v-if="item.title">{{ item.title }}</SectionTitle>
        <div class="flex gap-4">
            <div
                v-for="i in item.items.items"
                class="overflow-clip w-20"
                @click="goToSectionItem(i)"
            >
                <div
                    class="aspect-square bg-slate-800 rounded-2xl border-2 border-slate-700 p-2 cursor-pointer"
                >
                    <img
                        :src="i.image + '?h=150&w=150&fit=crop'"
                        loading="lazy"
                        class="object-cover m-auto rounded-lg"
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
import { Section } from "./types"

import SectionTitle from "./SectionTitle.vue"
import { goToSectionItem } from "@/utils/items"

defineProps<{
    item: Section & { __typename: "IconSection" }
}>()
</script>
