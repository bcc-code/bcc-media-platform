<template>
    <div id="vod-player" />
    <div id="live-player" />
</template>

<script lang="ts" setup>
import { onMounted } from "vue"
import { PlayerFactory, createPlayer } from "../src"

const factory = new PlayerFactory({
    tokenFactory: null,
    endpoint: "https://api.brunstad.tv/query",
})

onMounted(async () => {
    // VOD player
    await factory.create("vod-player", {
        episodeId: "865",
        overrides: {
            languagePreferenceDefaults: {
                audio: "eng",
                subtitles: "eng",
            },
        },
    })

    // Live player
    await createPlayer("live-player", {
        src: {
            src: "",
        },
        languagePreferenceDefaults: {
            audio: "eng",
            subtitles: "eng",
        },
    })
})
</script>

<style>
*,
*::before,
*::after {
    box-sizing: border-box;
}

html,
body {
    height: 100%;
    margin: 0;
}

#vod-player,
#live-player {
    max-width: 1920px;
    width: 100%;
    margin-inline: auto;
}
</style>
