<template>
    <div>
        <div class="flex">
            <div class="text-xl">
                <input
                    v-model="query"
                    class="bg-slate-800 p-2 w-96"
                    type="text"
                    placeholder="Search..."
                />
            </div>
        </div>
        <ShowSearchQuery
            class="mt-2 mb-2"
            :query="queryVariable"
            :pause="pause"
        ></ShowSearchQuery>
        <EpisodeSearchQuery
            class="mb-2"
            :query="queryVariable"
            :pause="pause"
        ></EpisodeSearchQuery>
    </div>
</template>
<script lang="ts" setup>
import { computed, ref } from "vue"
import ShowSearchQuery from "@/components/search/ShowSearchQuery.vue"
import EpisodeSearchQuery from "@/components/search/EpisodeSearchQuery.vue"

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

const pause = ref(true)
</script>
