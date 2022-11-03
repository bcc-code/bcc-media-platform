<template>
    <p
        class="text-md lg:text-lg font-normal text-primary"
        v-if="item.__typename === 'EpisodeCalendarEntry' && item.episode"
    >
        {{
            !item.episode.season || item.episode.productionDate ? new Date(item.episode.publishDate).toLocaleDateString() : item.episode.season.show.title
        }}
        <span class="text-gray text-md" v-if="item.episode.season"
            >S{{ item.episode?.season?.number }}:E{{
                item.episode?.number
            }}</span
        >
    </p>
</template>
<script lang="ts" setup>
import { GetLiveCalendarDayQuery } from "@/graph/generated"

defineProps<{
    item: NonNullable<GetLiveCalendarDayQuery["calendar"]>["day"]["entries"][0]
}>()
</script>
