<script lang="ts" setup>
import { Section } from '../types'

import { isCollectionItem, itemHref } from '@/utils/items'
import CollectionItemThumbnail from './CollectionItemThumbnail.vue'
import SectionTitle from './SectionTitle.vue'

defineProps<{
    position: number
    section: Section & { __typename: 'PosterGridSection' | 'PosterSection' }
}>()

defineEmits<{
    (event: 'clickItem', index: number, isModified: boolean): void
}>()
</script>
<template>
    <section>
        <SectionTitle v-if="section.title">{{ section.title }}</SectionTitle>
        <div class="grid grid-cols-2 gap-4">
            <div
                v-for="(item, index) in section.items.items"
                :key="item.id + item.item.__typename"
                class="relative"
            >
                <CollectionItemThumbnail
                    v-if="isCollectionItem(item)"
                    :item="item"
                    :title="item.title"
                    :image="item.image"
                    :href="
                        itemHref(item, {
                            useContext:
                                section.metadata?.useContext === true,
                            collectionId:
                                section.metadata?.collectionId ?? '',
                        })
                    "
                    :secondary-titles="
                        section.metadata?.secondaryTitles === true
                    "
                    type="poster"
                    @click="
                        (isModified) =>
                            $emit('clickItem', index, isModified)
                    "
                />
            </div>
        </div>
    </section>
</template>
