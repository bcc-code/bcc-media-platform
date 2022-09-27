<template>
    <div>
        <h1
            class="text-xl font-semibold text-primary mb-2"
            :class="{
                hidden: result.length === 0,
            }"
        >
            Episodes
        </h1>
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
import { computed, ref, watch } from "vue"
import SearchItem from "./SearchItem.vue"

const props = defineProps<{
    query: string
    pause: boolean
}>()

const queryString = ref(props.query)

const { data, pause, resume } = useSearchQuery({
    pause: props.pause,
    variables: {
        query: queryString,
        type: "episode",
    },
})

watch(
    () => props.query,
    () => {
        queryString.value = props.query
    }
)

watch(
    () => props.pause,
    () => {
        if (props.pause) {
            pause()
        } else {
            resume()
        }
    }
)

const result = computed(() => {
    return data.value?.search.result ?? []
})
</script>
