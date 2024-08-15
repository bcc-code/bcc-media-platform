<script lang="ts" setup>
import Loader from '@/components/Loader.vue'
import ShowSeason from '@/components/shows/ShowSeason.vue'
import {
    type GetSeasonEpisodesQuery,
    GetSeasonEpisodesDocument,
    ShowSeasonFragment,
    useGetShowQuery,
} from '@/graph/generated'
import { isNewEpisode } from '@/utils/items'
import { useClientHandle } from '@urql/vue'
import { ref } from 'vue'

const props = defineProps<{
    showId: string
}>()

const seasons = ref<ShowSeasonFragment[]>([])
const { data: show, then } = useGetShowQuery({
    variables: { id: props.showId },
})

const { client } = useClientHandle()

const loading = ref(true)

then(async ({ data }) => {
    seasons.value = data.value?.show.seasons.items ?? []

    if (!data.value) {
        return
    }

    const promises = data.value.show.seasons.items.map(async (season) => {
        if (!season.episodes.items.some(isNewEpisode)) {
            return season
        }

        return (
            (
                await client.query<GetSeasonEpisodesQuery>(
                    GetSeasonEpisodesDocument,
                    {
                        id: season.id,
                        dir: 'desc',
                    }
                )
            ).data?.season ?? season
        )
    })

    seasons.value = await Promise.all(promises)
    loading.value = false
})
</script>

<template>
    <div v-if="show && !loading" class="px-2 lg:px-20">
        <div class="my-8">
            <h1 class="text-style-headline-1 mb-2">
                {{ show.show.title }}
            </h1>
            <p class="text-style-body-2 text-label-3">
                {{ show.show.description }}
            </p>
        </div>

        <ShowSeason
            v-for="(season, index) in seasons"
            :key="season.id"
            :season="season"
            :position="index"
            class="mb-6"
        />
    </div>
    <div v-else class="flex w-full h-48 items-center justify-center">
        <Loader variant="spinner" />
    </div>
</template>
