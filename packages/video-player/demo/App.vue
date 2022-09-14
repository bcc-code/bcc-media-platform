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
    endpoint: "http://localhost:8077/query"
})

onMounted(async () => {
    await factory.create("btv-video", {
        episodeId: "1"
    })
})

</script>
