<template>
    <section class="max-w-screen-lg mx-auto rounded-2xl" v-if="episode">
        <div class="relative aspect-video w-full">
            <div
                class="h-full w-full bg-secondary rounded-xl opacity-10 absolute"
            ></div>
            <EpisodeViewer
                ref="viewerRef"
                :context="context"
                :auto-play="true"
                class="drop-shadow-xl overflow-hidden"
                :episode="episode"
                @next="loadNext"
            ></EpisodeViewer>
        </div>
        <div class="flex flex-col">
            <div class="bg-primary-light p-4 w-full">
                <div class="flex">
                    <h1
                        class="text-style-title-2 lg:text-style-headline-2 text-customWhite cursor-text"
                    >
                        {{ episode.title }}
                    </h1>
                    <div class="ml-auto">
                        <SharePopover :episode="episode"></SharePopover>
                    </div>
                </div>
                <div class="flex pt-2">
                    <h1 class="my-auto flex gap-1">
                        <AgeRating
                            :episode="episode"
                            :show-a="true"
                            class="mr-1 text-style-caption-2 lg:text-style-caption-1 mt-0.5"
                        />
                        <span
                            v-if="episode.season"
                            class="text-primary text-style-caption-1 lg:text-style-body-2"
                            >{{ episode.season.show.title }}</span
                        >
                        <span
                            v-if="episode.productionDateInTitle"
                            class="text-label-4 text-style-caption-2 lg:text-style-caption-1 ml-1 mt-0.5"
                            >{{
                                new Date(episode.productionDate).toDateString()
                            }}</span
                        >
                    </h1>
                </div>
                <div
                    class="text-label-3 mt-4 cursor-text text-style-body-2 lg:text-style-body-2 [&_a]:text-tint-1 [&_a]:underline"
                    v-html="mdToHTML(episode.description)"
                ></div>
                <!-- class="text-white mt-2 opacity-70 text-md lg:text-lg" -->
                <LessonButton
                    v-if="lesson && !episodeComingSoon(episode)"
                    class="mt-4"
                    :lesson="lesson"
                    :episode-id="episode.id"
                    @click="openLesson"
                />
            </div>
            <div class="flex flex-col gap-2 mt-4">
                <div class="flex gap-4 p-2 font-semibold text-style-button-2">
                    <button
                        v-if="
                            episode.context?.__typename === 'ContextCollection'
                        "
                        class="bg-primary-light uppercase border-separator-on-light border px-3 py-1 rounded-full transition duration-100"
                        :class="[
                            effectiveView === 'context'
                                ? 'opacity-100 border-opacity-40 '
                                : 'opacity-50 bg-opacity-0 border-opacity-0',
                        ]"
                        @click="effectiveView = 'context'"
                    >
                        {{ $t("episode.videos") }}
                    </button>
                    <button
                        v-else-if="seasonId"
                        class="bg-primary-light uppercase border-separator-on-light border px-3 py-1 rounded-full transition duration-100"
                        :class="[
                            effectiveView === 'episodes'
                                ? 'opacity-100 border-opacity-40 '
                                : 'opacity-50 bg-opacity-0 border-opacity-0',
                        ]"
                        @click="effectiveView = 'episodes'"
                    >
                        {{ $t("episode.episodes") }}
                    </button>
                    <button
                        v-if="episode.chapters.length > 0"
                        class="bg-primary-light uppercase border-separator-on-light border px-3 py-1 rounded-full transition duration-100"
                        :class="[
                            effectiveView === 'chapters'
                                ? 'opacity-100 border-opacity-40 '
                                : 'opacity-50 bg-opacity-0 border-opacity-0',
                        ]"
                        @click="effectiveView = 'chapters'"
                    >
                        {{ $t("episode.chapters") }}
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
                        {{ $t("episode.details") }}
                    </button>
                    <button
                        v-if="episode.files.length > 0"
                        class="bg-primary-light uppercase border-gray border px-3 py-1 rounded-full transition duration-100"
                        :class="[
                            effectiveView === 'download'
                                ? 'opacity-100 border-opacity-40'
                                : 'opacity-50 bg-opacity-0 border-opacity-0',
                        ]"
                        @click="effectiveView = 'download'"
                    >
                        {{ $t("buttons.download") }}
                    </button>
                </div>
                <hr class="border-separator-on-light" />
                <div>
                    <Transition name="fade" mode="out-in">
                        <EpisodeDetails
                            v-if="effectiveView === 'details'"
                            :episode="episode"
                        />
                        <EpisodeChapterList
                            v-else-if="effectiveView === 'chapters'"
                            :chapters="episode.chapters"
                            :current-time="currentTime"
                            @chapter-click="onChapterClick"
                        />
                        <div v-else-if="effectiveView === 'context'">
                            <ItemList
                                :items="
                                    toListItems(
                                        episode.context?.__typename ===
                                            'ContextCollection'
                                            ? episode.context.items?.items ?? []
                                            : []
                                    )
                                "
                                :current-id="episode.id"
                                @item-click="
                                    (i) =>
                                        setEpisode(
                                            uuid ? (i as any).uuid : i.id
                                        )
                                "
                            ></ItemList>
                        </div>
                        <div
                            v-else-if="effectiveView === 'episodes'"
                            class="flex flex-col"
                        >
                            <SeasonSelector
                                v-if="episode.season"
                                :items="episode.season?.show.seasons.items"
                                v-model="seasonId"
                            ></SeasonSelector>
                            <ItemList
                                :items="seasonEpisodes"
                                :current-id="episode.id"
                                @item-click="
                                    (i) =>
                                        setEpisode(
                                            uuid ? (i as any).uuid : i.id
                                        )
                                "
                            ></ItemList>
                        </div>
                        <div v-else-if="effectiveView === 'download'">
                            <EmbedDownloadables :episode="episode" />
                        </div>
                    </Transition>
                </div>
            </div>
        </div>
        <div v-if="error" class="text-red">{{ error.message }}</div>
    </section>
    <LoginToView v-else-if="noAccess && !authenticated"> </LoginToView>
    <NotFound v-else-if="!loading" :title="$t('episode.notFound')"></NotFound>
</template>
<script lang="ts" setup>
import {
    ChapterListChapterFragment,
    EpisodeContext,
    GetEpisodeQuery,
    GetSeasonOnEpisodePageQuery,
    useGetEpisodeQuery,
    useGetSeasonOnEpisodePageQuery,
} from "@/graph/generated"
import { computed, nextTick, onMounted, onUnmounted, ref, watch } from "vue"
import EpisodeViewer from "@/components/EpisodeViewer.vue"
import EpisodeDetails from "@/components/episodes/EpisodeDetails.vue"
import AgeRating from "@/components/episodes/AgeRating.vue"
import SeasonSelector from "@/components/SeasonSelector.vue"
import ItemList from "../sections/ItemList.vue"
import NotFound from "../NotFound.vue"
import LoginToView from "./LoginToView.vue"
import { episodesToListItems, toListItems } from "@/utils/lists"
import { useAuth } from "@/services/auth"
import SharePopover from "./SharePopover.vue"
import LessonButton from "../study/LessonButton.vue"
import EpisodeChapterList from "./EpisodeChapterList.vue"
import router from "@/router"
import { episodeComingSoon } from "../../utils/items"
import EmbedDownloadables from "../embed/EmbedDownloadables.vue"
import { mdToHTML } from "@/services/converter"
import { usePlayerTime } from "@/composables/usePlayerTime"

const props = defineProps<{
    initialEpisodeId: string
    context: EpisodeContext
    uuid?: boolean
    autoPlay?: boolean
}>()

const viewerRef = ref<InstanceType<typeof EpisodeViewer> | null>(null)

const seekTo = (seconds: number) => {
    viewerRef.value?.player?.currentTime(seconds)
}
const { currentTime } = usePlayerTime(computed(() => viewerRef.value?.player))

const { authenticated } = useAuth()

const emit = defineEmits<{
    (e: "episode", v: GetEpisodeQuery["episode"]): void
}>()

const episode = ref(null as GetEpisodeQuery["episode"] | null)
const season = ref(null as GetSeasonOnEpisodePageQuery["season"] | null)

const seasonId = ref("")
const loading = ref(true)

const context = ref(props.context)

const episodeId = ref(props.initialEpisodeId)

const setEpisode = (id: string) => {
    episodeId.value = id
    nextTick()
        .then(load)
        .then(() => {
            if (episode.value) {
                emit("episode", episode.value)
            }
        })
}

const { error, executeQuery } = useGetEpisodeQuery({
    pause: true,
    variables: {
        episodeId,
        context,
    },
    requestPolicy: "network-only",
})

const lesson = computed(() => episode.value?.lessons.items[0])
const openLesson = () =>
    router.push("/ep/" + episode.value?.id + "/lesson/" + lesson.value?.id)

const noAccess = computed(() => {
    return error.value?.graphQLErrors.some(
        (e) => e.extensions.code === "item/no-access"
    )
})

const seasonQuery = useGetSeasonOnEpisodePageQuery({
    pause: true,
    variables: {
        seasonId,
        firstEpisodes: 100,
    },
})

const seasonEpisodes = computed(() => {
    return episodesToListItems(
        seasonQuery.data.value?.season.episodes.items ?? []
    )
})

const loadSeason = async () => {
    season.value = null
    if (seasonId.value) {
        await nextTick()
        const r = await seasonQuery.executeQuery()
        season.value = r.data.value?.season ?? null
    }
}

watch(seasonId, loadSeason)

const load = async () => {
    loading.value = true
    season.value = null
    seasonId.value = ""
    const r = await executeQuery()
    if (r.data.value?.episode) {
        episode.value = r.data.value.episode

        if (!context.value?.collectionId && !context.value?.playlistId) {
            if (episode.value.season?.id) {
                seasonId.value = episode.value.season.id
                await nextTick()
            }
        }
        await loadSeason()
    }
    loading.value = false
}

load()
const view = ref(
    null as "episodes" | "details" | "context" | "download" | "chapters" | null
)

const effectiveView = computed({
    get() {
        const v = view.value
        switch (v) {
            case "context":
                if (
                    episode.value?.context?.__typename === "ContextCollection"
                ) {
                    return "context"
                }
                break
            case "episodes":
                if (episode.value?.season) {
                    return "episodes"
                }
                break
            case "chapters":
                if (episode.value?.chapters.length) {
                    return "chapters"
                }
                break
            case "details":
            case "download":
                return v
        }

        if (episode.value?.context?.__typename === "ContextCollection") {
            return "context"
        }
        return (view.value = !episode.value?.season ? "details" : "episodes")
    },
    set(v) {
        view.value = v
    },
})

const loadNext = async () => {
    const nextId = episode.value?.next[0]?.id
    if (nextId) {
        episodeId.value = nextId
        await nextTick()
        await load()
    }
}

const onChapterClick = (chapter: ChapterListChapterFragment) => {
    seekTo(chapter.start)
    scrollTo({
        behavior: "smooth",
        top: 0,
    })
}
</script>
