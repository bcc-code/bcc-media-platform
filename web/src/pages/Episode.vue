<template>
    <div>
        <h1 class="text-xl">Episode</h1>
        <div>
            {{ episodeId }}
        </div>
    </div>
</template>
<script lang="ts" setup>
import { ref, watch } from "vue"
import { useRoute } from "vue-router"

const route = useRoute()

const episodeId = ref(route.params.episodeId)
watch(
    () => route.params.episodeId,
    () => {
        episodeId.value = route.params.episodeId
    }
)
</script>
