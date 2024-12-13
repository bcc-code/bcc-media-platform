<script lang="ts" setup>
import { Section } from '../types'

import SectionTitle from './SectionTitle.vue'
import CollectionItemThumbnail from './CollectionItemThumbnail.vue'
import { goToPage, isCollectionItem } from '@/utils/items'
import { computed } from 'vue'
import VButton from '@/components/VButton.vue'
import { useI18n } from 'vue-i18n'

const props = defineProps<{
    position: number
    section: Section & { __typename: 'ListSection' }
}>()

defineEmits<{
    (event: 'clickItem', index: number): void
}>()

const { t } = useI18n()

const isShowMoreButtonVisible = computed(() => {
    return props.section.items.items.length === props.section.metadata?.limit
})

const pageCode = computed(() => {
    if (!props.section.metadata) return false
    if (!('page' in props.section.metadata)) return false
    return props.section.metadata.page?.code
})
</script>
<template>
    <section>
        <SectionTitle v-if="section.title">{{ section.title }}</SectionTitle>
        <div
            class="flex flex-col lg:grid lg:grid-cols-2 gap-4 overflow-x-visible"
        >
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
                    :secondary-titles="
                        section.metadata?.secondaryTitles === true
                    "
                    type="default"
                    @click="$emit('clickItem', index)"
                />
            </div>
            <VButton
                v-if="isShowMoreButtonVisible && pageCode"
                color="secondary"
                @click="goToPage(pageCode)"
            >
                {{ t('buttons.showMore') }}
            </VButton>
        </div>
    </section>
</template>
