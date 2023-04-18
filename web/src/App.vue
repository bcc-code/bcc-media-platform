<script setup lang="ts">
import { provideClient } from "@urql/vue"
import client from "@/graph/client"
import { useAuth } from "@/services/auth"

const { loading } = useAuth()

provideClient(client)
</script>

<template>
    <router-view v-if="!loading"></router-view>
</template>

<style lang="css">
/* width */
::-webkit-scrollbar {
    width: 10px;
}

/* Track */
::-webkit-scrollbar-track {
    background: unset;
    border-radius: 10px;
}

/* Handle */
::-webkit-scrollbar-thumb {
    background: #888;
    width: 5px;
    border-radius: 10px;
}

/* Handle on hover */
::-webkit-scrollbar-thumb:hover {
    background: #555;
}
</style>
