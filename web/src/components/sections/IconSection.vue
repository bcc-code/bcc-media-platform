<template>
    <section>
        <SectionTitle v-if="item.title">{{ item.title }}</SectionTitle>
        <div class="flex">
            <div v-for="i in item.items.items">
                <div
                    class="bg-slate-800 aspect-square rounded-xl border-2 border-slate-700 p-4 h-24 cursor-pointer"
                    @click="goToSectionItem(i)"
                >
                    <img :src="i.image + '?h=400'" />
                </div>
                <label class="text-center mx-auto">
                    <h1>
                        {{ i.title }}
                    </h1>
                </label>
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
