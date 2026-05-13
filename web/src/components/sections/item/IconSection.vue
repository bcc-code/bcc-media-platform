<script lang="ts" setup>
import { Section } from '../types'

import SectionTitle from './SectionTitle.vue'
import { onMounted, ref } from 'vue'
import { getImageSize } from '@/utils/images'
import Image from '@/components/Image.vue'
import Loader from '@/components/Loader.vue'
import { interceptSpaLinkClick, itemHref } from '@/utils/items'

const props = defineProps<{
    position: number
    item: Section & { __typename: 'IconSection' }
}>()

const emit = defineEmits<{
    (event: 'clickItem', index: number, isModified: boolean): void
}>()

const sectionItem = ref<HTMLElement[] | null>(null)

const imageSize = ref(0)

const clicked = ref(-1)

const handleClick = (event: MouseEvent, index: number, href: string | null) =>
    interceptSpaLinkClick(event, !!href, (modified) => {
        emit('clickItem', index, modified)
        if (!modified) clicked.value = index
    })

const hrefFor = (index: number) =>
    itemHref(props.item.items.items[index], {
        useContext: false,
        collectionId: '',
    })

onMounted(() => {
    const div = sectionItem.value?.[0]

    imageSize.value = getImageSize(div?.getBoundingClientRect().width ?? 100)
})
</script>
<template>
    <section>
        <SectionTitle v-if="item.title">{{ item.title }}</SectionTitle>
        <div class="flex gap-4 items-start flex-wrap">
            <component
                :is="hrefFor(index) ? 'a' : 'button'"
                v-for="(i, index) in item.items.items"
                :key="i.id"
                ref="sectionItem"
                :href="hrefFor(index) ?? undefined"
                class="w-20 shrink-0 2xl:w-32 hover:opacity-90 transition focus-visible:ring-4 focus-visible:ring-white/75 rounded-2xl block"
                @click="handleClick($event, index, hrefFor(index))"
            >
                <div
                    class="bg-slate-800 relative rounded-2xl border-2 border-slate-700 cursor-pointer overflow-hidden aspect-square"
                >
                    <div
                        v-if="clicked === index"
                        class="absolute w-full h-full flex"
                    >
                        <Loader
                            variant="spinner"
                            class="m-auto h-16 w-16"
                        ></Loader>
                    </div>
                    <Image
                        v-if="i.image"
                        class="rounded-lg m-2"
                        :class="{
                            'opacity-50': clicked === index,
                        }"
                        :src="i.image"
                        size-source="width"
                    />
                </div>
                <div class="mx-auto mt-1">
                    <p
                        class="w-full text-center text-style-body-2 line-clamp-2"
                    >
                        {{ i.title }}
                    </p>
                </div>
            </component>
        </div>
    </section>
</template>
