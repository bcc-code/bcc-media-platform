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
    await factory.create("vod-player", {
        episodeId: "865",
        overrides: {
            languagePreferenceDefaults: {
                audio: "eng",
                subtitles: "eng",
            },
        },
    })

    await createPlayer("live-player", {
        src: {
            src: "https://liveoht.brunstad.tv/out/v1/oslofjord-streaming/live/cloudfront/index.m3u8?EncodedPolicy=Policy%3DeyJTdGF0ZW1lbnQiOlt7IlJlc291cmNlIjoiaHR0cHM6Ly9saXZlb2h0LmJydW5zdGFkLnR2L291dC92MS9vc2xvZmpvcmQtc3RyZWFtaW5nL2xpdmUvY2xvdWRmcm9udC8qIiwiQ29uZGl0aW9uIjp7IkRhdGVMZXNzVGhhbiI6eyJBV1M6RXBvY2hUaW1lIjoxNzc4MDc4NDc1fX19XX0_%26Signature%3DCPwzybbSOmz1yKrH5ympEyLQI0nXfSOaJoocccqGdkufyfvJ7SYq278oX~Iw5TqVDHWkpz~XWAf8NOyIV2MGf8HkFNc698~rj37Rdr3blbHK8bBhCSGt98RbQLm2I9UzN-WGb3Eg4JoktZzzCNs0M1KQXchxXPhRmHDiVDD3fvsSddVoeXHFbWxJOPZwNGZU7ajxclrtF4sDP8vmcQs91NdXR2b8ZUCvS7fJzH9layRHphPLjxFGYsd2lwsitOPwxkrW1Qm5wRBep4cuGQQ~6PysE7SSu3-Fkt-Qwz7XqQlK~xI-NZtqqkKM7bmta1e6MbyOLGvHKEGUU5Ixe3gGzg__%26Key-Pair-Id%3DK1GSYT1GS8OW1X",
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
