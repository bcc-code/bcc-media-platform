<template>
    <div class="lang-controls">
        <span>UI language:</span>
        <button v-for="l in langs" :key="l" type="button" :aria-pressed="lang === l" @click="setLang(l)">
            {{ l }}
        </button>
    </div>
    <div id="vod-player" />
    <div id="live-player" />
</template>

<script lang="ts" setup>
import { onMounted, ref } from "vue"
import { PlayerFactory, createPlayer, type Player } from "../src"

const factory = new PlayerFactory({
    tokenFactory: null,
    endpoint: "https://api.brunstad.tv/query",
})

const langs = ["en", "no", "nl"] as const
type Lang = (typeof langs)[number]
const lang = ref<Lang>("en")
const players: Player[] = []

function setLang(next: Lang) {
    lang.value = next
    for (const p of players) p.setLanguage(next)
}

onMounted(async () => {
    try {
        const vod = await factory.create("vod-player", {
            episodeId: "1344",
            overrides: {
                languagePreferenceDefaults: {
                    audio: "eng",
                    subtitles: "eng",
                },
            },
        })
        if (vod) {
            players.push(vod)
            ;(window as unknown as { vod: Player }).vod = vod
        }
    } catch (err) {
        console.error("VOD player failed to mount:", err)
    }

    const live = await createPlayer("live-player", {
        src: { src: "" },
        languagePreferenceDefaults: { audio: "eng", subtitles: "eng" },
        live: true,
    })
    players.push(live)
    ;(window as unknown as { live: Player }).live = live
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
    aspect-ratio: 16/9;
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

.lang-controls {
    max-width: 920px;
    margin: 0 auto 0.75rem;
    display: flex;
    align-items: center;
    gap: 0.5rem;
    font-family: ui-sans-serif, system-ui, sans-serif;
    font-size: 0.875rem;
}
.lang-controls button {
    font: inherit;
    padding: 0.25rem 0.6rem;
    border: 1px solid #ccc;
    border-radius: 0.25rem;
    background: white;
    cursor: pointer;
    text-transform: uppercase;
}
.lang-controls button[aria-pressed="true"] {
    background: #222;
    color: #fff;
    border-color: #222;
}
</style>
