<template>
    <section class="px-4">
        <div class="flex">
            <div class="text-xl w-full">
                <input
                    v-model="query"
                    class="bg-slate-800 p-2 px-4 w-full lg:w-96 rounded-full"
                    type="text"
                    placeholder="Search..."
                />
            </div>
        </div>
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
    </section>
</template>
<script lang="ts" setup>
import { computed, onMounted, ref, watch } from "vue"
import ShowSearchQuery from "@/components/search/ShowSearchQuery.vue"
import EpisodeSearchQuery from "@/components/search/EpisodeSearchQuery.vue"
import { useRoute, useRouter } from "vue-router"

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
