<template>
    <section>
        <SectionTitle v-if="item.title">{{ item.title }}</SectionTitle>
        <div class="grid grid-cols-2">
            <div
                v-for="(i, index) in item.items.items"
                class="relative"
            >
                <NewPill class="absolute top-0 -right-1" :item="i"></NewPill>
                <div
                    class="flex flex-col rounded rounded-md mx-2 mt-1 hover:opacity-90 transition"
                    :class="{
                        'cursor-pointer': !itemDisabled(i),
                        'pointer-events-none': itemDisabled(i)
                    }"
                    @click="!itemDisabled(i) ? $emit('clickItem', index) : undefined"
                >
                    <div
                        class="relative aspect-[240/357] rounded-md object-cover mb-1"
                    >
                        <Image
                            :src="i.image"
                            size-source="height"
                            :ratio="240 / 357"
                        />
                        <ProgressBar
                            class="absolute bottom-0 w-full"
                            v-if="i.item?.__typename === 'Episode'"
                            :item="i.item"
                        />
                        <div v-if="(itemDisabled(i) && i.item.__typename === 'Episode')" class="absolute flex top-0 h-full w-full bg-black bg-opacity-80">
                            <div class="mx-auto my-auto text-center items-center flex flex-col">
                                <LockClosedIcon class="h-8 fill-gray my-auto"></LockClosedIcon>
                                <p class="font-semibold text-sm text-slate-300">{{$t("episode.comingSoon")}}</p>
                                <p class="text-base font-semibold text-slate-300">{{new Date(i.item.publishDate).toLocaleString()}}</p>
                            </div>
                        </div>
                    </div>
                    <SectionItemTitle
                        :secondary-titles="
                            item.metadata?.secondaryTitles === true
                        "
                        :i="i"
                    ></SectionItemTitle>
                </div>
            </div>
        </div>
    </section>
</template>
<script lang="ts" setup>
import { Section } from "../types"

import SectionTitle from "./SectionTitle.vue"
import NewPill from "./NewPill.vue"
import SectionItemTitle from "./SectionItemTitle.vue"
import ProgressBar from "@/components/episodes/ProgressBar.vue"
import Image from "@/components/Image.vue"
import { itemDisabled } from "@/utils/items"
import { LockClosedIcon } from "@heroicons/vue/24/solid"

defineProps<{
    position: number
    item: Section & { __typename: "PosterGridSection" | "PosterSection" }
}>()

defineEmits<{
    (event: "clickItem", index: number): void
}>()
</script>
