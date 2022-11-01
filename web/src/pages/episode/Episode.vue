<template>
    <section
        class="max-w-screen-2xl mx-auto rounded rounded-2xl"
        v-if="episode"
    >
        <div class="relative aspect-video w-full">
            <div
                class="h-full w-full bg-secondary rounded rounded-xl opacity-10 absolute"
            ></div>
            <EpisodeViewer
                class="drop-shadow-xl overflow-hidden"
                :episode="episode"
            ></EpisodeViewer>
        </div>
        <div class="flex flex-col">
            <div class="bg-primary-light p-4 w-full">
                <h1 class="text-lg lg:text-xl font-medium">
                    {{ episode.title }}
                </h1>
                <div class="flex">
                    <h1 class="my-auto">
                        <span
                            class="text-sm border px-1.5 border-gray border-opacity-50 rounded-full"
                            >{{ episode.ageRating }}</span
                        >
                        <span v-if="episode.season" class="text-primary ml-2">{{
                            episode.season.show.title
                        }}</span>
                        <span
                            v-if="episode.productionDate"
                            class="text-gray ml-1"
                            >{{ episode.productionDate }}</span
                        >
                        <span v-else-if="episode.season" class="text-gray ml-1"
                            >S{{ episode.season.number }}:E{{
                                episode.number
                            }}</span
                        >
                        <span v-else class="text-gray ml-1">{{
                            episode.publishDate
                        }}</span>
                    </h1>
                </div>
                <div class="text-white mt-2 opacity-70 text-lg">
                    {{ episode.description }}
                </div>
            </div>
            <div>
                <div class="m-2">
                    <button
                        class="opacity-50 uppercase border-gray border px-2 rounded-xl"
                        @click="view = 'episodes'"
                    >
                        {{ t("episode.episodes") }}
                    </button>
                    <button
                        class="opacity-50 uppercase border-gray border px-2 rounded-xl"
                        @click="view = 'details'"
                    >
                        {{ t("episode.details") }}
                    </button>
                </div>
                <hr class="border-gray border-opacity-70" />
                <div>
                    <transition name="slide-fade" mode="out-in">
                        <EpisodeDetails
                            v-if="view === 'details'"
                            :episode="episode"
                        ></EpisodeDetails>
                        <div
                            v-else-if="view === 'episodes'"
                            class="lg:grid grid-cols-2"
                        >
                            <div
                                v-for="e in episode.season?.episodes.items"
                                class="flex p-2 gap-2 cursor-pointer border-l-8 border-red hover:bg-red hover:bg-opacity-10 hover:border-opacity-100 transition duration-200"
                                :class="[
                                    e.id === episode.id
                                        ? 'border-l-8 bg-red bg-opacity-20 hover:bg-opacity-20'
                                        : 'border-opacity-0',
                                ]"
                                @click="
                                    $router.push({
                                        name: 'episode-page',
                                        params: { episodeId: e.id },
                                    })
                                "
                            >
                                <img
                                    class="w-1/3 aspect-video object-contain"
                                    v-if="e.image"
                                    :src="e.image"
                                />
                                <div>
                                    <h3 class="text-md text-primary">
                                        {{ t("episode.episode") }}
                                        {{ e.number }}
                                    </h3>
                                    <h1 class="text-md lg:text-lg">
                                        {{ e.title }}
                                    </h1>
                                    <AgeRating>{{ e.ageRating }}</AgeRating>
                                </div>
                            </div>
                        </div>
                    </transition>
                </div>
            </div>
        </div>
        <div v-if="error" class="text-red">{{ error.message }}</div>
    </section>
</template>
<script lang="ts" setup>
import { useGetEpisodeQuery } from "@/graph/generated"
import { computed, ref, watch } from "vue"
import { useRoute } from "vue-router"
import EpisodeViewer from "@/components/EpisodeViewer.vue"
import { useI18n } from "vue-i18n"
import EpisodeDetails from "@/components/episodes/EpisodeDetails.vue"
import AgeRating from "@/components/episodes/AgeRating.vue"

const route = useRoute()

const { t } = useI18n()

const episodeId = ref(route.params.episodeId as string)

const { data, error } = useGetEpisodeQuery({
    variables: {
        episodeId,
    },
})

const episode = computed(() => {
    return data.value?.episode ?? null
})

watch(
    () => route.params.episodeId,
    () => {
        episodeId.value = route.params.episodeId as string
    }
)

const view = ref("episodes" as "episodes" | "details")
</script>
