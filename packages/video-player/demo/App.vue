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
    try {
        await factory.create("vod-player", {
            episodeId: "865",
            overrides: {
                languagePreferenceDefaults: {
                    audio: "eng",
                    subtitles: "eng",
                },
            },
        })
    } catch (err) {
        console.error("VOD player failed to mount:", err)
    }

    await createPlayer("live-player", {
        src: {
            src: "",
        },
        languagePreferenceDefaults: {
            audio: "eng",
            subtitles: "eng",
        },
        live: true,
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
    padding: 0.5rem;
}

#vod-player,
#live-player {
    max-width: 920px;
    width: 100%;
    margin-inline: auto;
    margin-block-end: 1rem;
}

</style>
