<template>
    <section>
        <SectionTitle v-if="item.title">{{ item.title }}</SectionTitle>
        <Slider
            :item="item"
            v-slot="{ item: i, index }"
            :breakpoints="options"
            @load-more="$emit('loadMore')"
        >
            <div
                class="relative h-full cursor-pointer max-h-[60vh] overflow-hidden"
                @click="$emit('clickItem', index)"
            >
                <Image
                    :src="i.image"
                    size-source="width"
                    :ratio="9 / 16"
                    class="lg:hidden rounded-xl h-full object-cover"
                />
                <Image
                    :src="i.image"
                    size-source="width"
                    :ratio="5 / 11"
                    class="hidden lg:block rounded-xl h-full object-cover"
                />
                <div
                    class="lg:hidden absolute bottom-0 w-full text-center bg-gradient-to-t from-background to-transparent pt-8"
                >
                    <h1 class="text-2xl font-bold">
                        {{ i.title }}
                    </h1>
                    <p
                        v-if="(i as any).description"
                        class="opacity-80 line-clamp-2 px-8 lg:px-16"
                    >
                        {{ (i as any).description }}
                    </p>
                </div>
                <div
                    class="hidden lg:block absolute w-full -bottom-1 left-0 bg-gradient-to-t from-background to-transparent"
                    :class="{
                        'p-20': props.item.size === 'medium',
                        'p-10': props.item.size === 'small',
                    }"
                >
                    <h1 class="text-3xl font-bold">
                        {{ i.title }}
                    </h1>
                    <p
                        v-if="(i as any).description"
                        class="opacity-80 text-lg line-clamp-2 max-w-lg"
                    >
                        {{ (i as any).description }}
                    </p>
                    <button
                        class="bg-slate-800 px-4 py-2 rounded-full font-bold text-lg hover:scale-105 mt-4"
                        @click="$emit('clickItem', index)"
                    >
                        <div
                            class="flex"
                            v-if="
                                ['Episode', 'Show', 'Season'].includes(
                                    i.item.__typename
                                )
                            "
                        >
                            <Play></Play
                            ><span class="ml-1">{{ $t("page.watchNow") }}</span>
                        </div>
                        <div class="flex" v-else>
                            {{ $t("page.explore") }}
                        </div>
                    </button>
                </div>
            </div>
            <div class="lg:hidden text-center mt-2">
                <button
                    class="bg-slate-800 px-4 py-1 rounded-full font-bold text-lg flex mx-auto hover:scale-105"
                    @click="$emit('clickItem', index)"
                >
                    <div
                        class="flex"
                        v-if="
                            ['Episode', 'Show', 'Season'].includes(
                                i.item.__typename
                            )
                        "
                    >
                        <Play></Play
                        ><span class="ml-1">{{ $t("page.watchNow") }}</span>
                    </div>
                    <div class="flex" v-else>
                        {{ $t("page.explore") }}
                    </div>
                </button>
            </div>
        </Slider>
    </section>
</template>
<script lang="ts" setup>
import { Section } from "../types"

import { computed } from "vue"
import SectionTitle from "./SectionTitle.vue"
import Play from "@/components/icons/Play.vue"
import Image from "@/components/Image.vue"
import Slider from "./Slider.vue"

const props = defineProps<{
    position: number
    item: Section & { __typename: "FeaturedSection" }
}>()

defineEmits<{
    (event: "loadMore"): void
    (event: "clickItem", index: number): void
}>()

const options = computed(() => {
    switch (props.item.size) {
        case "small":
            return {
                400: {
                    slidesPerView: 2,
                    spaceBetween: 4,
                },
                1280: {
                    slidesPerView: 2,
                    spaceBetween: 4,
                },
                1920: {
                    slidesPerView: 2,
                    spaceBetween: 4,
                },
            }
        case "medium":
            return {
                400: {
                    slidesPerView: 1,
                    spaceBetween: 4,
                },
                1280: {
                    slidesPerView: 1,
                    spaceBetween: 4,
                },
                1920: {
                    slidesPerView: 1,
                    spaceBetween: 4,
                },
            }
    }
})
</script>
