<script lang="ts" setup>
import { Section } from '../types'

import SectionTitle from './SectionTitle.vue'
import CollectionItemThumbnail from './CollectionItemThumbnail.vue'
import { isCollectionItem } from '@/utils/items'

defineProps<{
    section: Section & { __typename: 'DefaultGridSection' }
}>()

defineEmits<{
    (event: 'clickItem', index: number): void
}>()
</script>

<template>
    <section>
        <SectionTitle v-if="section.title">{{ section.title }}</SectionTitle>
        <div class="grid grid-cols-2 xl:grid-cols-4 gap-4 xl:gap-6">
            <div
                v-for="(item, index) in section.items.items"
                class="relative mb-5"
            >
                <CollectionItemThumbnail
                    v-if="isCollectionItem(item)"
                    :title="item.title"
                    :image="item.image"
                    :item="item"
                    :secondary-titles="
                        section.metadata?.secondaryTitles === true
                    "
                    type="default"
                    @click="$emit('clickItem', index)"
                />
            </div>
        </div>
    </section>
</template>
