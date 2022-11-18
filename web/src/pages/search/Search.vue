<template>
    <section>
        <div class="flex lg:hidden w-full text-xl mb-4">
            <SearchInput class="mx-auto lg:w-96" v-model="query"></SearchInput>
        </div>
        <div v-if="query">
            <ShowSearchQuery
                class="mt-2 mb-8"
                :query="queryVariable"
                :pause="pause"
            ></ShowSearchQuery>
            <EpisodeSearchQuery
                class="mb-2"
                :query="queryVariable"
                :pause="pause"
            ></EpisodeSearchQuery>
        </div>
        <div v-else-if="data?.application.searchPage?.code">
            <Page :page-id="data?.application.searchPage?.code"></Page>
        </div>
        <div v-else>
            <div>Search page is not configured</div>
        </div>
    </section>
</template>
<script lang="ts" setup>
import { onMounted, ref, watch } from "vue"
import ShowSearchQuery from "@/components/search/ShowSearchQuery.vue"
import EpisodeSearchQuery from "@/components/search/EpisodeSearchQuery.vue"
import { useRoute, useRouter } from "vue-router"
import { useSearch } from "@/utils/search"
import Page from "@/components/page/Page.vue"
import { useApplicationQuery } from "@/graph/generated"
import { useTitle } from "@/utils/title"
import { useI18n } from "vue-i18n"
import SearchInput from "@/components/SearchInput.vue"

const { setTitle } = useTitle()

const { t } = useI18n()

const { data } = useApplicationQuery()

const queryString = ref("")

const { query } = useSearch()

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
        }, 100)
    }
)

const queryVariable = ref("")

const route = useRoute()
const router = useRouter()

onMounted(() => {
    const q = route.query.q
    if (q && typeof q === "string") {
        query.value = q
        queryVariable.value = q
    }
    setTitle(t("page.search"))
})

watch(
    () => query.value,
    () => {
        router.replace({ query: { q: query.value } })
    }
)

const pause = ref(false)
</script>
