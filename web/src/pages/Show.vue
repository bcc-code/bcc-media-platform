<template>
    <div v-if="show">
        <h1 class="text-xl">{{ show.title }}</h1>
        <p>{{ show.description }}</p>
    </div>
    <div v-if="fetching">Loading...</div>
</template>
<script lang="ts" setup>
import { useGetShowQuery } from "@/graph/generated"
import { computed } from "vue"
import { useRoute } from "vue-router"

const route = useRoute()

const showId = route.params.showId as string

const { data, fetching } = useGetShowQuery({
    variables: {
        id: showId,
    },
})

const show = computed(() => {
    return data.value?.show ?? null
})
</script>
