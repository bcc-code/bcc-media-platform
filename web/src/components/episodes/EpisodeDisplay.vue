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
                        v-if="seasonId"
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
                                        @click="episodeId = e.id"
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
</template>
<script lang="ts" setup>
import {
EpisodeContext,
    useGetEpisodeQuery,
    useGetSeasonOnEpisodePageQuery,
} from "@/graph/generated"
import { computed, onMounted, ref, watch } from "vue"
import EpisodeViewer from "@/components/EpisodeViewer.vue"
import { useI18n } from "vue-i18n"
import EpisodeDetails from "@/components/episodes/EpisodeDetails.vue"
import AgeRating from "@/components/episodes/AgeRating.vue"
import WithProgressBar from "@/components/episodes/WithProgressBar.vue"
import SeasonSelector from "@/components/SeasonSelector.vue"
import { useTitle } from "@/utils/title"
import Image from "../Image.vue"

const { t } = useI18n()

const props = defineProps<{
    episodeId: string
    context?: EpisodeContext
    autoPlay?: boolean
}>()

const emit = defineEmits<{
    (e: "update:episodeId", v: string): void
}>()

const episodeId = computed({
    get() {
        return props.episodeId
    },
    set(v) {
        emit("update:episodeId", v)
    },
})

const context = ref(props.context)

watch(() => props.context, () => {
    context.value = props.context
})

const { data, error, then } = useGetEpisodeQuery({
    variables: {
        episodeId,
        context,
    },
})

const episode = computed(() => {
    return data.value?.episode ?? null
})

const seasonId = ref("")

then(() => {
    seasonId.value = data.value?.episode.season?.id ?? ""
    if (seasonId.value) {
        seasonQuery.resume()
    }
})

const seasonQuery = useGetSeasonOnEpisodePageQuery({
    pause: !seasonId.value,
    variables: {
        seasonId,
        firstEpisodes: 50,
    },
})

const { setTitle } = useTitle()

onMounted(() => {
    if (episode.value?.title) {
        setTitle(episode.value.title)
    }
})

watch(
    () => episode.value?.title,
    () => {
        if (episode.value?.title) {
            setTitle(episode.value.title)
        }
    }
)

const view = ref(null as "episodes" | "details" | null)

const effectiveView = computed({
    get() {
        return view.value ?? (!episode.value?.season ? "details" : "episodes")
    },
    set(v) {
        view.value = v
    },
})
</script>
