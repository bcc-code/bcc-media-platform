<template>
    <section class="px-4 mt-2">
        <div class="flex w-full text-xl">
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
        <div v-else>
            <h1 class="text-xl font-bold">kategorier og sånt</h1>
        </div>
    </section>
</template>
<script lang="ts" setup>
import { computed, onMounted, ref, watch } from "vue"
import ShowSearchQuery from "@/components/search/ShowSearchQuery.vue"
import EpisodeSearchQuery from "@/components/search/EpisodeSearchQuery.vue"
import { useRoute, useRouter } from "vue-router"
import SearchInput from "@/components/SearchInput.vue";

const queryString = ref("")

let timeout = null as NodeJS.Timeout | null

const query = computed({
    get() {
        return queryString.value
    },
    set(v) {
        queryString.value = v

        if (v && pause.value) {
            pause.value = false
        }
        if (!v) {
            pause.value = true
        }

        // Delay the query itself, in case you add more characters to the string
        if (timeout !== null) {
            clearTimeout(timeout)
        }
        timeout = setTimeout(() => {
            queryVariable.value = v
        }, 100)
    },
})

const queryVariable = ref("")

const route = useRoute()
const router = useRouter()

onMounted(() => {
    const q = route.query.q
    if (q && typeof q === "string") {
        query.value = q
    }
})

watch(
    () => query.value,
    () => {
        router.replace({ query: { q: query.value } })
    }
)

const pause = ref(true)
</script>
