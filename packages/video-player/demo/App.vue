<template>
    <div id="vod-player"  />
    <div id="live-player"  />
</template>

<script lang="ts" setup>
import {  onMounted } from "vue"
import { PlayerFactory, createPlayer } from "../src"

const factory = new PlayerFactory({
    tokenFactory: null,
    endpoint: "https://api.brunstad.tv/query",
})

onMounted(async () => {
    try {
        await factory.create("vod-player", {
            episodeId: "2988",
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

.theme-controls {
    max-width: 920px;
    margin: 0 auto 0.75rem;
    display: flex;
    align-items: center;
    gap: 0.75rem;
    font-family: ui-sans-serif, system-ui, sans-serif;
    font-size: 0.875rem;
}

.theme-controls label {
    display: inline-flex;
    align-items: center;
    gap: 0.5rem;
}

.theme-controls input[type="color"] {
    width: 2rem;
    height: 2rem;
    padding: 0;
    border: 1px solid #ccc;
    border-radius: 0.25rem;
    cursor: pointer;
}

.theme-controls__preset {
    display: inline-flex;
    align-items: center;
    gap: 0.4rem;
    font: inherit;
    padding: 0.25rem 0.6rem;
    border: 1px solid #ccc;
    border-radius: 0.25rem;
    background: white;
    cursor: pointer;
}
.theme-controls__preset::before {
    content: "";
    width: 0.75rem;
    height: 0.75rem;
    border-radius: 100%;
    border: 1px solid rgba(0, 0, 0, 0.15);
    background: var(--swatch, #fff);
}

.theme-controls code {
    font-family: ui-monospace, SFMono-Regular, Menlo, monospace;
    color: #666;
}

</style>
