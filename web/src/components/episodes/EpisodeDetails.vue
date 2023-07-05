<template>
    <section class="flex flex-col gap-4">
        <div v-for="d in details" class="flex flex-col gap-1">
            <h1 class="text-lg font-semibold">{{ d.title }}</h1>
            <p>{{ d.value }}</p>
        </div>
        <div class="flex flex-col gap-1">
            <h1 class="text-lg font-semibold">{{ t("episode.ageRating") }}</h1>
            <p class="flex">
                <AgeRating :episode="episode" />
            </p>
        </div>
    </section>
</template>
<script lang="ts" setup>
import { GetEpisodeQuery } from "@/graph/generated"
import { computed } from "vue"
import { useI18n } from "vue-i18n"
import AgeRating from "./AgeRating.vue"

const { t } = useI18n()

const props = defineProps<{
    episode: GetEpisodeQuery["episode"]
}>()

const details = computed(() => {
    const lines: { title: string; value: string }[] = []

    if (props.episode.season) {
        lines.push({
            title: t("episode.seriesDescription"),
            value: props.episode.season.show.description,
        })
    }

    const publishDate = new Date(props.episode.publishDate)
    lines.push({
        title: t("episode.releaseDate"),
        value: publishDate.toLocaleDateString(),
    })
    const availableFrom = new Date(props.episode.availableFrom)
    if (availableFrom.getTime() > new Date("2000-01-01").getTime()) {
        lines.push({
            title: t("episode.availableFrom"),
            value:
                availableFrom.toLocaleDateString() +
                " " +
                availableFrom.toLocaleTimeString(),
        })
    }
    const availableTo = new Date(props.episode.availableTo)
    if (availableTo.getTime() < new Date("2030-01-01").getTime()) {
        lines.push({
            title: t("episode.availableTo"),
            value:
                availableTo.toLocaleDateString() +
                " " +
                availableTo.toLocaleTimeString(),
        })
    }
    return lines
})
</script>
