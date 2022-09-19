<template>
    <section
        class="max-w-screen-2xl mx-auto p-10 rounded rounded-2xl"
        v-if="episode"
    >
        <EpisodeViewer
            class="drop-shadow-xl"
            :episode-id="(route.params.episodeId as string)"
        ></EpisodeViewer>
        <div class="flex mt-5">
            <div class="flex gap-4" v-if="episode.season">
                <div class="max-w-sm rounded rounded-lg bg-slate-800">
                    <img
                        v-if="episode.imageUrl"
                        class="rounded rounded-lg"
                        :src="episode.imageUrl"
                    />
                    <img
                        v-else-if="episode.season.imageUrl"
                        class="rounded rounded-lg"
                        :src="episode.season.imageUrl"
                    />
                    <div class="p-4">
                        <h1 class="text-primary text-xl">
                            Episoder ({{ episode.season.episodes.total }})
                        </h1>
                        <hr class="border-primary" />
                        <p
                            v-for="e in episode.season.episodes.items"
                            class="cursor-pointer"
                            @click="
                                $router.push({
                                    name: 'episode-page',
                                    params: { episodeId: e.id },
                                })
                            "
                        >
                            {{ e.number }}
                            {{ e.title }}
                        </p>
                    </div>
                </div>
                <div>
                    <h3 class="text-sm text-primary">
                        {{ episode.season?.show.title }}
                        <span>{{ episode.season?.title }}</span>
                    </h3>
                    <h1 class="text-xl">{{ episode.title }}</h1>
                    <p>{{ episode.description }}</p>
                </div>
            </div>
        </div>
        <div v-if="error" class="text-red">{{ error.message }}</div>
    </section>
</template>
<script lang="ts" setup>
import { useGetEpisodeQuery } from "@/graph/generated"
import { computed } from "vue"
import { useRoute } from "vue-router"
import EpisodeViewer from "@/components/EpisodeViewer.vue"

const route = useRoute()

const { data, error } = useGetEpisodeQuery({
    variables: {
        episodeId: route.params.episodeId as string,
    },
})

const episode = computed(() => {
    return data.value?.episode ?? null
})
</script>
