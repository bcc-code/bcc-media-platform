<template>
    <section>
        <SectionTitle v-if="item.title">{{ item.title }}</SectionTitle>
        <Slider
            :item="item"
            v-slot="{ item: i, index }"
            @load-more="$emit('loadMore')"
        >
            <NewPill class="absolute top-0 -right-1" :item="i"></NewPill>
            <div
                class="flex flex-col mt-2"
                :class="{
                    'cursor-pointer': !itemDisabled(i),
                    'pointer-events-none': itemDisabled(i),
                }"
                @click="
                    !itemDisabled(i) ? $emit('clickItem', index) : undefined
                "
            >
                <div
                    class="relative mb-1 rounded-md w-full aspect-video overflow-hidden hover:opacity-90 transition"
                >
                    <Image
                        :src="i.image"
                        class="rounded-md"
                        loading="lazy"
                        size-source="width"
                        :ratio="9 / 16"
                    />
                    <ProgressBar
                        class="absolute bottom-0 w-full"
                        v-if="i.item?.__typename === 'Episode'"
                        :item="i.item"
                    />
                    <div
                        v-if="
                            itemDisabled(i) && i.item.__typename === 'Episode'
                        "
                        class="absolute flex top-0 h-full w-full bg-black bg-opacity-80"
                    >
                        <div
                            class="mx-auto my-auto text-center items-center flex flex-col"
                        >
                            <LockClosedIcon
                                class="h-8 fill-gray my-auto"
                            ></LockClosedIcon>
                            <p class="font-semibold text-sm text-slate-300">
                                {{ $t("episode.comingSoon") }}
                            </p>
                            <p class="text-base font-semibold text-slate-300">
                                {{
                                    new Date(
                                        i.item.publishDate
                                    ).toLocaleString()
                                }}
                            </p>
                        </div>
                    </div>
                </div>
                <SectionItemTitle
                    :secondary-titles="item.metadata?.secondaryTitles === true"
                    :for="i.id"
                    :i="i"
                ></SectionItemTitle>
            </div>
        </Slider>
    </section>
</template>
<script lang="ts" setup>
import { Section } from "../types"

import SectionTitle from "./SectionTitle.vue"
import NewPill from "./NewPill.vue"
import SectionItemTitle from "./SectionItemTitle.vue"
import ProgressBar from "@/components/episodes/ProgressBar.vue"
import Image from "@/components/Image.vue"
import Slider from "./Slider.vue"
import { itemDisabled } from "@/utils/items"
import { LockClosedIcon } from "@heroicons/vue/24/solid"

defineProps<{
    position: number
    item: Section & { __typename: "DefaultSection" }
}>()

defineEmits<{
    (event: "loadMore"): void
    (event: "clickItem", index: number): void
}>()
</script>
