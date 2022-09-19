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
                <div v-if="fetching">Fetching</div>
            </div>
        </div>
        <div class="grid grid-cols-4 gap-4">
            <SearchItem
                v-for="r in result"
                :item="r"
                :key="r.__typename + r.id"
            ></SearchItem>
        </div>
    </div>
</template>
<script lang="ts" setup>
import { useSearchQuery } from "@/graph/generated"
import { computed, ref } from "vue"
import SearchItem from "@/components/search/SearchItem.vue"

const queryString = ref("")

let timeout = null as NodeJS.Timeout | null

const query = computed({
    get() {
        return queryString.value
    },
    set(v) {
        queryString.value = v

        if (v && isPaused.value) {
            resume()
        }
        if (!v) {
            pause()
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

const { data, fetching, pause, resume, isPaused } = useSearchQuery({
    pause: true,
    variables: {
        query: queryVariable,
    },
})

const result = computed(() => {
    return data.value?.search.result ?? []
})
</script>
