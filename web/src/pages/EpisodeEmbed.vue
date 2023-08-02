<script lang="ts" setup>
import { useGetLegacyIdQuery } from "@/graph/generated"
import player from "@/services/player"
import { lanTo3letter } from "@/utils/languages"
import { onMounted, ref } from "vue"
import { useGetEpisodeEmbedQuery } from "@/graph/generated"
import EmbedDownloadables from "@/components/embed/EmbedDownloadables.vue"

const props = defineProps<{
    episodeId?: string
    legacyId?: number
    programId?: number
}>()

const episodeId = ref<string>("")

const language = ref<string>()

onMounted(async () => {
    if (props.episodeId) {
        episodeId.value = props.episodeId
    } else if (props.legacyId) {
        const { executeQuery } = useGetLegacyIdQuery({
            pause: true,
            variables: {
                episodeId: props.legacyId,
            },
        })

        const { data } = await executeQuery()

        episodeId.value = data.value?.legacyIDLookup.id ?? ""
    } else if (props.programId) {
        const { executeQuery } = useGetLegacyIdQuery({
            pause: true,
            variables: {
                programId: props.programId,
            },
        })

        const { data } = await executeQuery()

        episodeId.value = data.value?.legacyIDLookup.id ?? ""
    } else {
        throw new Error("Missing episodeId")
    }
    const q = new URLSearchParams(window.location.search)
    const l = q.get("language")
    if (l) {
        language.value = lanTo3letter[l] ?? l
    }
    await load()
})

const { data: episode, executeQuery } = useGetEpisodeEmbedQuery({
    pause: true,
    variables: {
        id: episodeId,
    },
})

const load = async () => {
    if (!episodeId.value) {
        return
    }
    await player.create("embed-video-player", {
        episodeId: episodeId.value,
        overrides: {
            languagePreferenceDefaults: {
                audio: language.value,
                subtitles: language.value,
            },
        },
    })
    await executeQuery()
}
</script>

<template>
    <section>
        <div>
            <div id="embed-video-player"></div>
        </div>
        <EmbedDownloadables
            v-if="episode"
            show-title
            :episode="episode.episode"
        />
    </section>
</template>
