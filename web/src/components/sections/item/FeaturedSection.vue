<template>
    <section>
        <SectionTitle v-if="item.title">{{ item.title }}</SectionTitle>
        <Slider
            :section="item"
            v-slot="{ item: i, index }"
            :breakpoints="options"
            @load-more="$emit('loadMore')"
        >
            <div
                class="lg:hidden relative h-full cursor-pointer max-h-[60vh] overflow-hidden"
                @click="$emit('clickItem', index)"
            >
                <Image
                    :src="i.image"
                    size-source="width"
                    :ratio="9 / 16"
                    class="rounded-xl h-full object-cover"
                />
                <div
                    class="absolute bottom-0 w-full text-center bg-gradient-to-t h-full to-70% text-balance from-background/50 to-transparent -outline-offset-1 outline outline-2 outline-separator-on-light focus-visible:outline-tint-1 rounded-xl"
                >
                    <div
                        class="bottom-0 absolute pt-8 pb-6 px-8 gap-2 flex flex-col items-center w-full"
                    >
                        <h1 class="text-style-headline-2">
                            {{ i.title }}
                        </h1>
                        <p
                            v-if="(i as any).description"
                            class="opacity-80 line-clamp-2 px-8 text-style-body-2"
                        >
                            {{ (i as any).description }}
                        </p>
                    </div>
                </div>
            </div>

            <div
                class="hidden lg:block relative h-full cursor-pointer max-h-[60vh] overflow-hidden group -outline-offset-1 outline outline-2 outline-separator-on-light rounded-xl focus-visible:outline-tint-1 transition ease-out-expo duration-300"
                @click="$emit('clickItem', index)"
            >
                <Image
                    :src="i.image"
                    size-source="width"
                    :ratio="9 / 16"
                    class="rounded-xl h-full object-cover group-hover:scale-[102%] transition ease-out-expo duration-1000 group-hover:brightness-110"
                />
                <div
                    class="absolute w-full bottom-0 left-0 bg-gradient-to-t h-full to-60% from-background/20 to-transparent"
                >
                    <div
                        class="absolute backdrop-blur-3xl -bottom-1 h-2/5 w-full to-transparent"
                        style="
                            mask: linear-gradient(
                                180deg,
                                transparent,
                                black 70%
                            );
                            -webkit-mask: linear-gradient(
                                180deg,
                                transparent,
                                black 70%
                            );
                        "
                    ></div>
                    <div
                        class="absolute bottom-0 flex h-full items-end justify-between z-10 w-full gap-4"
                        :class="{
                            'px-8 py-6': props.item.size === 'medium',
                            'px-6 py-4': props.item.size === 'small',
                        }"
                    >
                        <div>
                            <h1
                                class="font-bold"
                                :class="{
                                    'text-style-title-1':
                                        props.item.size === 'medium',
                                    'text-style-title-2':
                                        props.item.size === 'small',
                                }"
                            >
                                {{ i.title }}
                            </h1>
                            <p
                                v-if="(i as any).description"
                                class="opacity-80 line-clamp-2 max-w-lg"
                                :class="{
                                    'text-style-body-2':
                                        props.item.size === 'medium',
                                    'text-style-caption-1':
                                        props.item.size === 'small',
                                }"
                            >
                                {{ (i as any).description }}
                            </p>
                        </div>
                        <div>
                            <VButton
                                @click="$emit('clickItem', index)"
                                color="secondary"
                                size="thin"
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
                                    ><span class="ml-1 truncate">{{
                                        $t("page.watchNow")
                                    }}</span>
                                </div>
                                <div class="flex" v-else>
                                    {{ $t("page.explore") }}
                                </div>
                            </VButton>
                        </div>
                    </div>
                </div>
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
import VButton from "@/components/VButton.vue"

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
                    slidesPerView: 1,
                    spaceBetween: 4,
                },
                768: {
                    slidesPerView: 2,
                    spaceBetween: 4,
                },
                1280: {
                    slidesPerView: 3,
                    spaceBetween: 8,
                },
                1920: {
                    slidesPerView: 3,
                    spaceBetween: 8,
                },
                2100: {
                    slidesPerView: 4,
                    spaceBetween: 8,
                },
            }
        case "medium":
            return {
                400: {
                    slidesPerView: 1,
                    spaceBetween: 6,
                },
                768: {
                    slidesPerView: 1,
                    spaceBetween: 6,
                },
                1280: {
                    slidesPerView: 2,
                    spaceBetween: 8,
                },
                1920: {
                    slidesPerView: 2,
                    spaceBetween: 8,
                },
                2100: {
                    slidesPerView: 3,
                    spaceBetween: 8,
                },
            }
    }
})
</script>
