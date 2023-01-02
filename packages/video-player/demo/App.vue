<template>
    <div>
        <div id="btv-video">

        </div>
    </div>
</template>
<script lang="ts" setup>
import { onMounted } from "vue";
import { PlayerFactory } from "../src";

const factory = new PlayerFactory({
    tokenFactory: null,
    endpoint: "https://api.brunstad.tv/query"
})

onMounted(async () => {
    const player = await factory.create("btv-video", {
        episodeId: "1705",
        overrides: {
            languagePreferenceDefaults: {
                audio: "eng",
                subtitle: "eng",
            },
        }
    })

    player.on("loadedmetadata", () => {
        console.log(player.audioTracks())
        player.setAudioTrackToLanguage("eng")
        console.log(player.audioTracks())
    })
})

</script>
