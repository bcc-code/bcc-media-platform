<template>
    <div>
        <h1 class="text-lg lg:text-xl line-clamp-2">{{ show.title }}</h1>
        <p class="text-gray line-clamp-1">
            {{ t("section.item.season", show.seasonCount) }} -
            {{ t("section.item.episode", show.episodeCount) }}
        </p>
    </div>
</template>
<script lang="ts" setup>
import { useI18n } from "vue-i18n"

const { t } = useI18n()

defineProps<{
    show: {
        title: string
        seasonCount: number
        episodeCount: number
    }
}>()
</script>
