<template>
    <div v-if="!loading">
        <Navbar></Navbar>
        <div class="p-4">
            <router-view :key="route.fullPath"> 
            </router-view>
        </div>
        <div class="text-red-500" v-if="errors">
            <p v-for="(error, i) in errors">
                {{ error.title }}
                <span @click="removeError(i)" class="cursor-pointer">X</span>
            </p>
        </div>
    </div>
    <div v-else class="flex h-screen">
        <div class="m-auto">
            <Loader></Loader>
        </div>
    </div>
</template>
<script lang="ts" setup>
import Navbar from "@/components/navbar/Navbar.vue"
import { errors, removeError } from "@/utils/error"
import Auth from "@/services/auth"
import Loader from "../components/Loader.vue"
import { useRoute } from "vue-router"

import { provideClient } from "@urql/vue"
import client from "@/graph/client"
provideClient(client)

const route = useRoute()

const loading = Auth.loading()
</script>
