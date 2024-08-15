<script lang="ts" setup>
import { CollectionItemThumbnailFragment } from '@/graph/generated'
import { useI18n } from 'vue-i18n'

const { t } = useI18n()

defineProps<{
    title: string
    show: CollectionItemThumbnailFragment & {
        __typename: 'Show'
    }
}>()
</script>
<template>
    <div>
        <p class="text-style-title-3">
            {{ title }}
        </p>
        <p class="text-label-3 type-body-2 line-clamp-1">
            {{ t('section.item.season', show.seasonCount) }} -
            {{ t('section.item.episode', show.episodeCount) }}
        </p>
    </div>
</template>
