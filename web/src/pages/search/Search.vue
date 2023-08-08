<template>
    <section class="p-4 lg:p-20">
        <div class="flex lg:hidden w-full text-xl mb-4">
            <SearchInput class="mx-auto lg:w-96" v-model="query"></SearchInput>
        </div>
        <div v-if="query && loaded" class="relative">
            <ShowSearchQuery
                v-if="showSearchQuery.data.value"
                class="mt-2 mb-8"
                :queryString="queryVariable"
                :result="showSearchQuery.data.value"
            ></ShowSearchQuery>
            <EpisodeSearchQuery
                v-if="episodeSearchQuery.data.value"
                class="mb-2"
                :queryString="queryVariable"
                :result="episodeSearchQuery.data.value"
                @item-click="clickEpisode"
            ></EpisodeSearchQuery>
            <NotFound
                :link="false"
                class="transition opacity-100"
                :class="{ 'opacity-0': showCount !== 0 || episodeCount !== 0 }"
            >
                <template #title>{{ $t("search.noResults") }}</template>
                <template #description>{{
                    $t("search.tryAdjustingQuery")
                }}</template>
            </NotFound>
        </div>
        <div v-else class="w-full text-center">
            <p class="text-lg text-gray">{{ $t("search.emptyQuery") }}</p>
        </div>
    </section>
</template>
<script lang="ts" setup>
import { nextTick, onMounted, ref, watch } from "vue"
import ShowSearchQuery from "@/components/search/ShowSearchQuery.vue"
import EpisodeSearchQuery from "@/components/search/EpisodeSearchQuery.vue"
import { useRoute, useRouter } from "vue-router"
import { useSearch } from "@/utils/search"
import { setTitle } from "@/utils/title"
import { useI18n } from "vue-i18n"
import SearchInput from "@/components/SearchInput.vue"
import { analytics } from "@/services/analytics"
import { goToEpisode } from "@/utils/items"
import NotFound from "@/components/NotFound.vue"
import { usePage } from "@/utils/page"
import { useSearchQuery } from "@/graph/generated"

const { t } = useI18n()
const { query } = useSearch()
const queryString = ref(query.value)

const showCount = ref(null as number | null)
const episodeCount = ref(null as number | null)

const clickEpisode = (index: number, id: string) => {
    analytics.track("searchresult_clicked", {
        group: "episodes",
        elementId: id,
        elementPosition: index,
        elementType: "Episode",
        searchText: queryVariable.value,
    })

    goToEpisode(id)
}

let timeout = null as NodeJS.Timeout | null

const queryVariable = ref(queryString.value)

const route = useRoute()
const router = useRouter()

const loaded = ref(false)

onMounted(async () => {
    const q = route.query.q
    queryVariable.value = ""
    await nextTick()
    if (q && typeof q === "string") {
        queryVariable.value = q
    }
    setTitle(t("page.search"))
    analytics.page({
        id: "search",
        title: t("page.search"),
    })

    const { setCurrent } = usePage()
    setCurrent("search")

    pause.value = false
    loaded.value = true
})

watch(
    () => query.value,
    () => {
        router.replace({ query: { q: query.value } })

        const v = query.value

        queryString.value = v

        console.log("SET FROM QUERY")

        if (v && pause.value) {
            pause.value = false
        }

        // Delay the query itself, in case you add more characters to the string
        if (timeout !== null) {
            clearTimeout(timeout)
        }
        timeout = setTimeout(() => {
            queryVariable.value = v
        }, 150)
    }
)

const pause = ref(false)

const showSearchQuery = useSearchQuery({
    variables: {
        query: queryVariable,
        type: "show",
    },
})

const episodeSearchQuery = useSearchQuery({
    variables: {
        query: queryVariable,
        type: "episode",
    },
})
</script>
