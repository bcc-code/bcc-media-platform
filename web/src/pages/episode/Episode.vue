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
                <div class="flex gap-2 p-2 font-semibold">
                    <button
                        class="bg-primary-light uppercase border-gray border px-3 py-1 rounded-full transition duration-100"
                        :class="[
                            view === 'episodes'
                                ? 'opacity-100 border-opacity-40 '
                                : 'opacity-50 bg-opacity-0 border-opacity-0',
                        ]"
                        @click="view = 'episodes'"
                    >
                        {{ t("episode.episodes") }}
                    </button>
                    <button
                        class="bg-primary-light uppercase border-gray border px-3 py-1 rounded-full transition duration-100"
                        :class="[
                            view === 'details'
                                ? 'opacity-100 border-opacity-40'
                                : 'opacity-50 bg-opacity-0 border-opacity-0',
                        ]"
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
                            class="flex flex-col"
                        >
                            <Listbox
                                as="div"
                                v-model="seasonId"
                                class="mb-2 font-medium"
                            >
                                <div class="relative mt-1">
                                    <ListboxButton
                                        class="relative w-full border-0 cursor-default rounded-md border py-2 pl-3 pr-10 text-left shadow-sm sm:text-sm"
                                    >
                                        <span class="flex items-center">
                                            <span
                                                class="block truncate uppercase"
                                                >{{
                                                    seasonQuery.data.value
                                                        ?.season.title
                                                }}</span
                                            >
                                            <ChevronDown
                                                class="text-gray-400 stroke-white"
                                                aria-hidden="true"
                                            />
                                        </span>
                                    </ListboxButton>

                                    <transition
                                        leave-active-class="transition ease-in duration-100"
                                        leave-from-class="opacity-100"
                                        leave-to-class="opacity-0"
                                    >
                                        <ListboxOptions
                                            class="absolute z-10 mt-1 max-h-56 w-full overflow-auto rounded-md bg-slate-900 py-1 text-base shadow-lg ring-1 ring-black ring-opacity-5 focus:outline-none sm:text-sm"
                                        >
                                            <ListboxOption
                                                as="template"
                                                v-for="s in episode.season?.show
                                                    .seasons.items"
                                                :key="s.id"
                                                :value="s.id"
                                                v-slot="{ active, selected }"
                                            >
                                                <li
                                                    :class="[
                                                        active
                                                            ? 'text-white bg-primary'
                                                            : 'opacity-80',
                                                        'relative cursor-default select-none bg-opacity-20 py-2 pl-3 pr-9',
                                                    ]"
                                                >
                                                    <div
                                                        class="flex items-center"
                                                    >
                                                        <span
                                                            :class="[
                                                                selected
                                                                    ? 'font-semibold'
                                                                    : 'font-normal',
                                                                'ml-3 block truncate uppercase',
                                                            ]"
                                                            >{{ s.title }}</span
                                                        >
                                                    </div>
                                                </li>
                                            </ListboxOption>
                                        </ListboxOptions>
                                    </transition>
                                </div>
                            </Listbox>
                            <div class="lg:grid grid-cols-2">
                                <transition-group
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
                                        @click="
                                            $router.push({
                                                name: 'episode-page',
                                                params: { episodeId: e.id },
                                            })
                                        "
                                    >
                                        <WithProgressBar
                                            :item="e"
                                            class="w-1/3 aspect-video"
                                        >
                                            <img
                                                class="object-contain"
                                                v-if="e.image"
                                                :src="e.image"
                                            />
                                        </WithProgressBar>
                                        <div>
                                            <h3
                                                class="text-sm lg:text-md text-primary"
                                            >
                                                {{ t("episode.episode") }}
                                                {{ e.number }}
                                            </h3>
                                            <h1 class="text-md lg:text-lg">
                                                {{ e.title }}
                                            </h1>
                                            <AgeRating>{{
                                                e.ageRating
                                            }}</AgeRating>
                                        </div>
                                    </div>
                                </transition-group>
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
import {
    useGetEpisodeQuery,
    useGetSeasonOnEpisodePageQuery,
} from "@/graph/generated"
import { computed, ref, watch } from "vue"
import { useRoute } from "vue-router"
import EpisodeViewer from "@/components/EpisodeViewer.vue"
import { useI18n } from "vue-i18n"
import EpisodeDetails from "@/components/episodes/EpisodeDetails.vue"
import AgeRating from "@/components/episodes/AgeRating.vue"
import {
    Listbox,
    ListboxButton,
    ListboxOption,
    ListboxOptions,
} from "@headlessui/vue"
import { ChevronDown } from "@/components/icons"
import WithProgressBar from "@/components/episodes/WithProgressBar.vue"

const route = useRoute()

const { t } = useI18n()

const episodeId = ref(route.params.episodeId as string)

const { data, error, then } = useGetEpisodeQuery({
    variables: {
        episodeId,
    },
})

const episode = computed(() => {
    return data.value?.episode ?? null
})

const seasonId = ref("")

then(() => {
    seasonId.value = data.value?.episode.season?.id ?? ""
})

const seasonQuery = useGetSeasonOnEpisodePageQuery({
    pause: true,
    variables: {
        seasonId,
    },
})

watch(
    () => seasonId.value,
    () => {
        if (seasonId.value) {
            seasonQuery.resume()
        } else {
            seasonQuery.pause()
        }
    }
)

watch(
    () => route.params.episodeId,
    () => {
        episodeId.value = route.params.episodeId as string
    }
)

const view = ref("episodes" as "episodes" | "details")
</script>
