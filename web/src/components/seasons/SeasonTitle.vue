<template>
    <div>
        <h3 class="text-sm text-primary w-full line-clamp-1">
            {{ season.show.title }}
            <!-- <span class="ml-1 text-gray">S{{ season.seasonNumber }}</span> -->
        </h3>
        <h1 class="text-sm md:text-md lg:text-lg line-clamp-2">
            {{ season.title }}
        </h1>
    </div>
</template>
<script lang="ts" setup>
import { useI18n } from "vue-i18n"

const { t } = useI18n()

defineProps<{
    season: {
        seasonNumber: number
        show: {
            title: string
        }
        title: string
    }
}>()
</script>
