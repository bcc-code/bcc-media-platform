<template>
    <Navbar class="lg:px-20" v-if="!loading"></Navbar>
    <div v-if="!loading">
        <router-view v-slot="{ Component }">
            <transition name="slide-fade" mode="out-in">
                <component :key="$route.name" :is="Component" />
            </transition>
        </router-view>
    </div>
    <div class="text-red-500" v-if="errors && !loading">
        <p v-for="(error, i) in errors">
            {{ error.title }}
            <span @click="removeError(i)" class="cursor-pointer">X</span>
        </p>
    </div>
    <div v-else class="flex">
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

import { provideClient } from "@urql/vue"
import client from "@/graph/client"
import { init } from "@/services/language"
provideClient(client)

const loading = Auth.loading()

init()
</script>
