<script lang="ts" setup>
import Pill from "@/components/Pill.vue"
import type { CollectionItemThumbnailFragment } from "@/graph/generated"
import { computed } from "vue"
import { useI18n } from "vue-i18n"

const props = defineProps<{
    item: CollectionItemThumbnailFragment
}>()

const { t } = useI18n()

const NEW_DAYS_THRESHOLD = 7

const newString = computed(() => {
    const date = new Date()
    date.setDate(date.getDate() - NEW_DAYS_THRESHOLD)
    switch (props.item?.__typename) {
        case "Episode":
            if (props.item.progress) {
                return ""
            }
            return new Date(props.item.publishDate).getTime() > date.getTime()
                ? t("common.new")
                : ""
        case "Season":
            const d = props.item.episodes.items[0]?.publishDate
            return d
                ? new Date(d).getTime() > date.getTime()
                    ? t("common.newEpisodes")
                    : ""
                : ""
        case "Show":
            const episode = props.item.seasons.items[0]?.episodes.items[0]
            if (!episode) break
            return new Date(episode.publishDate).getTime() > date.getTime()
                ? t("common.newEpisodes")
                : ""
    }
})
</script>

<template>
    <Pill v-if="newString" color="bg-red">
        {{ newString }}
    </Pill>
</template>
