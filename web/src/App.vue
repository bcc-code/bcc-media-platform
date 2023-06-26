<script setup lang="ts">
import { provideClient } from "@urql/vue"
import client from "@/graph/client"
import { useAuth } from "@/services/auth"
import { watch } from "vue"
import { useRouter } from "vue-router"

const { loading } = useAuth()

provideClient(client)

const router = useRouter()

const checkRedirect = () => {
    const redirect = localStorage.getItem("redirect")
    if (redirect) {
        localStorage.removeItem("redirect")
        router.push(redirect)
    }
}

watch(() => loading.value, checkRedirect)

checkRedirect()
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
