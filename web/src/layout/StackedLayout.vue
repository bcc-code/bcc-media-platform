<template>
    <div class="flex flex-col h-screen">
        <div
            v-if="!tLoading"
            class="relative flex-grow flex-shrink-0"
            :class="[
                !loading && shouldSignIn()
                    ? 'overflow-hidden'
                    : 'overflow-auto',
            ]"
        >
            <Navbar class="lg:px-20" v-if="!loading"></Navbar>
            <div
                v-if="!loading"
                class="overflow-x-hidden flex-grow flex-shrink-0"
            >
                <router-view v-slot="{ Component }">
                    <transition name="slide-fade" mode="out-in">
                        <component :key="$route.name" :is="Component" />
                    </transition>
                </router-view>
            </div>
            <div v-if="!loading && shouldSignIn()">
                <div
                    class="fixed inset-0 flex text-2xl w-full h-full bg-black bg-opacity-50 z-50 bg-blur backdrop-blur-sm fixed"
                >
                    <div
                        class="mx-auto my-auto flex flex-col bg-background p-4 rounded-lg gap-4"
                    >
                        <h1 class="text-xl text-center mb-2 mt-2">
                            {{ $t("dashboard.loggedOut") }}
                        </h1>
                        <div class="flex gap-2">
                            <button
                                class="ml-auto text-lg px-2 py-1 bg-primary rounded-lg hover:scale-105"
                                @click="signIn()"
                            >
                                {{ $t("buttons.login") }}
                            </button>
                            <button
                                class="text-lg px-2 py-1 bg-slate-800 rounded-lg hover:scale-105"
                                @click="cancelSignIn()"
                            >
                                {{ $t("buttons.stayLoggedOut") }}
                            </button>
                        </div>
                    </div>
                </div>
            </div>
            <div class="text-red-500" v-if="errors && !loading">
                <p v-for="(error, i) in errors">
                    {{ error.title }}
                    <span @click="removeError(i)" class="cursor-pointer"
                        >X</span
                    >
                </p>
            </div>
            <div v-else class="flex">
                <div class="m-auto">
                    <Loader></Loader>
                </div>
            </div>
        </div>
        <Footer class="flex-shrink-0"></Footer>
        <Cookies v-if="!tLoading" class="bottom-0 fixed w-full z-20"></Cookies>
    </div>
</template>
<script lang="ts" setup>
import Navbar from "@/components/navbar/Navbar.vue"
import { errors, removeError } from "@/utils/error"
import { useAuth } from "@/services/auth"
import Loader from "../components/Loader.vue"

import { init } from "@/services/language"
import { onMounted } from "vue"
import { analytics } from "@/services/analytics"
import { useGetAnalyticsIdQuery } from "@/graph/generated"
import { loading as tLoading } from "@/i18n"
import Footer from "@/components/Footer.vue"
import Cookies from "@/components/Cookies.vue"

const { loading, authenticated, shouldSignIn, signIn, cancelSignIn } = useAuth()

const analyticsQuery = useGetAnalyticsIdQuery({
    pause: true,
})

onMounted(() =>
    analytics.initialize(async () => {
        while (loading.value) {
            await new Promise((r) => setTimeout(r, 100))
        }

        let analyticsId: string | null = null
        if (authenticated.value) {
            const result = await analyticsQuery.executeQuery()
            if (result.data.value?.me.analytics.anonymousId) {
                analyticsId = result.data.value.me.analytics.anonymousId
            }
        }
        return analyticsId
    })
)

init()
</script>
<style>
#stacked-layout {
    flex: 1 0 auto;
}
</style>
