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
                :auto-play="autoPlay"
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
                    <h1 class="my-auto flex">
                        <AgeRating v-if="episode.ageRating">{{
                            episode.ageRating
                        }}</AgeRating>
                        <span v-if="episode.season" class="text-primary ml-1">{{
                            episode.season.show.title
                        }}</span>
                        <span
                            v-if="episode.productionDate"
                            class="text-gray ml-1"
                            >{{
                                new Date(episode.productionDate).toDateString()
                            }}</span
                        >
                        <span v-else-if="episode.season" class="text-gray ml-1"
                            >S{{ episode.season.number }}:E{{
                                episode.number
                            }}</span
                        >
                    </h1>
                </div>
                <div class="text-white mt-2 opacity-70 text-lg">
                    {{ episode.description }}
                </div>
            </div>
            <div>
                <div class="flex gap-2 p-2 font-semibold">
                    <button
                        v-if="episode.context"
                        class="bg-primary-light uppercase border-gray border px-3 py-1 rounded-full transition duration-100"
                        :class="[
                            effectiveView === 'context'
                                ? 'opacity-100 border-opacity-40 '
                                : 'opacity-50 bg-opacity-0 border-opacity-0',
                        ]"
                        @click="effectiveView = 'context'"
                    >
                        {{ t("episode.videos") }}
                    </button>
                    <button
                        v-else-if="seasonId"
                        class="bg-primary-light uppercase border-gray border px-3 py-1 rounded-full transition duration-100"
                        :class="[
                            effectiveView === 'episodes'
                                ? 'opacity-100 border-opacity-40 '
                                : 'opacity-50 bg-opacity-0 border-opacity-0',
                        ]"
                        @click="effectiveView = 'episodes'"
                    >
                        {{ t("episode.episodes") }}
                    </button>
                    <button
                        class="bg-primary-light uppercase border-gray border px-3 py-1 rounded-full transition duration-100"
                        :class="[
                            effectiveView === 'details'
                                ? 'opacity-100 border-opacity-40'
                                : 'opacity-50 bg-opacity-0 border-opacity-0',
                        ]"
                        @click="effectiveView = 'details'"
                    >
                        {{ t("episode.details") }}
                    </button>
                </div>
                <hr class="border-gray border-opacity-70" />
                <div>
                    <Transition name="slide-fade" mode="out-in">
                        <EpisodeDetails
                            v-if="effectiveView === 'details'"
                            :episode="episode"
                        ></EpisodeDetails>
                        <div v-else-if="effectiveView === 'context'">
                            <ItemList
                                :items="episode.context?.items ?? []"
                                :current-id="episode.id"
                                @set-current="(i) => setEpisode(i.id)"
                            ></ItemList>
                        </div>
                        <div
                            v-else-if="effectiveView === 'episodes'"
                            class="flex flex-col"
                        >
                            <SeasonSelector
                                v-if="episode.season"
                                :items="episode.season?.show.seasons.items"
                                v-model:value="seasonId"
                            ></SeasonSelector>
                            <div class="lg:grid grid-cols-2">
                                <TransitionGroup
                                    name="slide-fade"
                                    mode="out-in"
                                >
                                    <div
                                        v-for="e in seasonQuery.data.value
                                            ?.season.episodes.items"
                                        class="flex p-2 gap-2 cursor-pointer border-l-8 border-red hover:bg-red hover:bg-opacity-10 hover:border-opacity-100 transition duration-200"
                                        :class="[
                                            e.id === episode.id
                                                ? 'border-l-8 bg-red bg-opacity-20 hover:bg-opacity-20'
                                                : 'border-opacity-0',
                                        ]"
                                        @click="setEpisode(e.id)"
                                        :key="e.id"
                                    >
                                        <WithProgressBar
                                            class="w-1/3 aspect-video text-xs"
                                            :item="e"
                                            ref="episodeImage"
                                        >
                                            <Image
                                                v-if="e.image"
                                                :src="e.image"
                                                size-source="width"
                                                :ratio="9 / 16"
                                            />
                                        </WithProgressBar>
                                        <div class="w-2/3">
                                            <h3
                                                class="text-sm lg:text-md text-primary line-clamp-1 text-xs"
                                            >
                                                {{ t("episode.episode") }}
                                                {{ e.number }}
                                            </h3>
                                            <h1
                                                class="text-sm lg:text-lg line-clamp-2"
                                            >
                                                {{ e.title }}
                                            </h1>
                                            <AgeRating>{{
                                                e.ageRating
                                            }}</AgeRating>
                                        </div>
                                    </div>
                                </TransitionGroup>
                            </div>
                        </div>
                    </Transition>
                </div>
            </div>
        </div>
        <div v-if="error" class="text-red">{{ error.message }}</div>
    </section>
    <NotFound v-else-if="!loading" :title="$t('episode.notFound')"></NotFound>
</template>
<script lang="ts" setup>
import {
    EpisodeContext,
    GetEpisodeQuery,
    GetSeasonOnEpisodePageQuery,
    useGetEpisodeQuery,
    useGetSeasonOnEpisodePageQuery,
} from "@/graph/generated"
import { computed, nextTick, onMounted, ref, watch } from "vue"
import EpisodeViewer from "@/components/EpisodeViewer.vue"
import { useI18n } from "vue-i18n"
import EpisodeDetails from "@/components/episodes/EpisodeDetails.vue"
import AgeRating from "@/components/episodes/AgeRating.vue"
import WithProgressBar from "@/components/episodes/WithProgressBar.vue"
import SeasonSelector from "@/components/SeasonSelector.vue"
import { useTitle } from "@/utils/title"
import Image from "../Image.vue"
import ItemList from "../sections/ItemList.vue"
import NotFound from "../NotFound.vue"

const props = defineProps<{
    episodeId: string
    context?: EpisodeContext
    autoPlay?: boolean
}>()

const emit = defineEmits<{
    (e: "update:episodeId", v: string): void
}>()

const { t } = useI18n()
const { setTitle } = useTitle()
const episode = ref(null as NonNullable<GetEpisodeQuery["episode"]> | null)
const season = ref(
    null as NonNullable<GetSeasonOnEpisodePageQuery["season"]> | null
)

const seasonId = ref("")
const loading = ref(true)

const context = ref(props.context)

const episodeId = ref(props.episodeId)

const setEpisode = (id: string) => {
    episodeId.value = id
    emit("update:episodeId", id)
    nextTick().then(() => {
        load()
    })
}

const { error, executeQuery } = useGetEpisodeQuery({
    pause: true,
    variables: {
        episodeId,
        context,
    },
})

const seasonQuery = useGetSeasonOnEpisodePageQuery({
    pause: true,
    variables: {
        seasonId,
        firstEpisodes: 50,
    },
})

const load = async () => {
    loading.value = true
    const r = await executeQuery()
    if (r.data.value?.episode) {
        episode.value = r.data.value.episode

        setTitle(episode.value.title)

        if (!context.value) {
            if (episode.value.season?.id) {
                seasonId.value = episode.value.season.id

                const sr = await seasonQuery.executeQuery()
                seasonQuery.pause()
                if (sr.data.value?.season) {
                    season.value = sr.data.value.season
                }
            }
        }
    }
    loading.value = false
}

load()
const view = ref(null as "episodes" | "details" | "context" | null)

const effectiveView = computed({
    get() {
        const v = view.value
        switch (v) {
            case "context":
                if (episode.value?.context) {
                    return "context"
                }
                break
            case "episodes":
                if (episode.value?.season) {
                    return "episodes"
                }
                break
            case "details":
                return "details"
        }

        if (episode.value?.context) {
            return "context"
        }
        return (view.value = !episode.value?.season ? "details" : "episodes")
    },
    set(v) {
        view.value = v
    },
})
</script>
