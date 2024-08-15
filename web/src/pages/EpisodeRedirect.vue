<script lang="ts" setup>
import { useGetLegacyIdQuery } from "@/graph/generated"

const props = defineProps<{
    episodeId?: number
    programId?: number
}>()

const { data, then } = useGetLegacyIdQuery({
    variables: {
        episodeId: props.episodeId ? Number(props.episodeId) : undefined,
        programId: props.programId ? Number(props.programId) : undefined,
    },
})

then(() => {
    if (data.value?.legacyIDLookup.id) {
        location.href = "/episode/" + data.value.legacyIDLookup.id
    } else {
        location.href = "/"
    }
})
</script>
<template></template>
