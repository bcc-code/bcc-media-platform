<script lang="ts" setup>
import { Section } from '../types'

import SectionTitle from './SectionTitle.vue'
import Image from '@/components/Image.vue'
import { interceptSpaLinkClick, itemHref } from '@/utils/items'

const props = defineProps<{
    position: number
    item: Section & { __typename: 'IconGridSection' }
}>()

const emit = defineEmits<{
    (event: 'clickItem', index: number, isModified: boolean): void
}>()

const handleClick = (event: MouseEvent, index: number, href: string | null) =>
    interceptSpaLinkClick(event, !!href, (modified) => {
        emit('clickItem', index, modified)
    })

const hrefFor = (index: number) =>
    itemHref(props.item.items.items[index], {
        useContext: false,
        collectionId: '',
    })
</script>
<template>
    <section class="w-full">
        <SectionTitle v-if="item.title">{{ item.title }}</SectionTitle>
        <div
            class="grid w-full grid-flow-dense grid-cols-[repeat(auto-fill,8rem)] lg:grid-cols-[repeat(auto-fill,10rem)]"
        >
            <component
                :is="hrefFor(index) ? 'a' : 'div'"
                v-for="(i, index) in item.items.items"
                :key="i.id"
                :href="hrefFor(index) ?? undefined"
                class="relative mb-5 m-2 block"
                @click="handleClick($event, index, hrefFor(index))"
            >
                <div
                    class="aspect-square bg-slate-800 rounded-2xl border-2 border-slate-700 p-4 cursor-pointer"
                >
                    <Image :src="i.image" size-source="width" />
                </div>
                <div class="mx-auto mt-2">
                    <p
                        class="w-full text-center text-ellipsis text-style-body-1 line-clamp-2"
                    >
                        {{ i.title }}
                    </p>
                </div>
            </component>
        </div>
    </section>
</template>
