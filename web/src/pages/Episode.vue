<template>
    <div>
        <h1 class="text-xl">{{ title }}</h1>
    </div>
</template>
<script lang="ts" setup>
import { useGetEpisodeQuery } from "@/graph/generated"
import { addError } from "@/utils/error"
import { ref } from "vue"
import { useRoute } from "vue-router"

const route = useRoute()

const query = useGetEpisodeQuery({
    variables: {
        episodeId: route.params.episodeId as string,
    },
})

const title = ref("")

query.then((r) => {
    if (query.error.value) {
        addError(query.error.value.message)
        return
    }
    const episode = r.data.value?.episode
    if (episode) {
        title.value = episode.title
    }
})
</script>
