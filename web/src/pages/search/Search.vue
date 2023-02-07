<template>
    <section class="p-4 lg:p-20">
        <div class="flex lg:hidden w-full text-xl mb-4">
            <SearchInput class="mx-auto lg:w-96" v-model="query"></SearchInput>
        </div>
        <div v-if="query" class="relative">
            <ShowSearchQuery
                class="mt-2 mb-8"
                :class="{ hidden: !showCount && !episodeCount }"
                :query="queryVariable"
                :pause="pause"
                @item-click=""
                @count="(c) => (showCount = c)"
            ></ShowSearchQuery>
            <EpisodeSearchQuery
                class="mb-2"
                :class="{ hidden: !showCount && !episodeCount }"
                :query="queryVariable"
                :pause="pause"
                @item-click="(i, e) => clickEpisode(i, e.id)"
                @count="(c) => (episodeCount = c)"
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
import { onMounted, ref, watch } from "vue"
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

watch(
    () => query.value,
    () => {
        const v = query.value

        queryString.value = v

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

const queryVariable = ref(queryString.value)

const route = useRoute()
const router = useRouter()

onMounted(() => {
    const q = route.query.q
    if (q && typeof q === "string" && !query.value) {
        query.value = q
        queryVariable.value = q
    }
    setTitle(t("page.search"))
    analytics.page({
        id: "search",
        title: t("page.search"),
    })

    const { setCurrent } = usePage()
    setCurrent("search")
})

watch(
    () => query.value,
    () => {
        router.replace({ query: { q: query.value } })
    }
)

const pause = ref(false)
</script>
