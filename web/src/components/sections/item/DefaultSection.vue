<script lang="ts" setup>
import { goToPage, isCollectionItem } from '@/utils/items'
import type { Section } from '../types'
import CollectionItemThumbnail from './CollectionItemThumbnail.vue'
import SectionTitle from './SectionTitle.vue'
import Slider from './Slider.vue'
import VButton from '@/components/VButton.vue'
import { computed } from 'vue'

const props = defineProps<{
    position: number
    item: Section & { __typename: 'DefaultSection' | 'ListSection' }
}>()

defineEmits<{
    (event: 'loadMore'): void
    (event: 'clickItem', index: number): void
}>()

const isShowMoreButtonVisible = computed(() => {
    if (!props.item.metadata) return false
    if (!('limit' in props.item.metadata)) return false
    return props.item.items.items.length === props.item.metadata.limit
})

const pageCode = computed(() => {
    if (!props.item.metadata) return false
    if (!('page' in props.item.metadata)) return false
    return props.item.metadata.page?.code
})
</script>

<template>
    <section>
        <header
            class="flex items-baseline justify-between gap-6 xl:justify-start"
        >
            <SectionTitle v-if="item.title">{{ item.title }}</SectionTitle>
            <VButton
                v-if="isShowMoreButtonVisible && pageCode"
                class="xl:hidden"
                color="secondary"
                size="thin"
                @click="goToPage(pageCode)"
            >
                {{ $t('buttons.showMore') }}
            </VButton>
        </header>
        <Slider :section="item" @load-more="$emit('loadMore')">
            <template #default="{ item: i, index }">
                <CollectionItemThumbnail
                    v-if="isCollectionItem(i.item)"
                    :title="i.title"
                    :image="i.image"
                    :item="i.item"
                    :secondary-titles="item.metadata?.secondaryTitles === true"
                    type="default"
                    @click="$emit('clickItem', index)"
                />
            </template>
            <template #end>
                <div
                    v-if="isShowMoreButtonVisible && pageCode"
                    class="w-full h-full place-items-center mt-[25%] hidden xl:grid"
                >
                    <VButton
                        class="mt-4"
                        color="secondary"
                        size="thin"
                        @click="goToPage(pageCode)"
                    >
                        {{ $t('buttons.showMore') }}
                    </VButton>
                </div>
            </template>
        </Slider>
    </section>
</template>
