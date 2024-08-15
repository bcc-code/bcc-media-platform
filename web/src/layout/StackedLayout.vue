<template>
    <div class="flex flex-col h-screen">
        <div
            v-if="!tLoading"
            class="relative flex-grow flex-shrink-0"
            :class="[!shouldSignIn() ? '' : 'overflow-auto']"
        >
            <Navbar class="lg:px-20"></Navbar>
            <div class="overflow-x-hidden flex-grow flex-shrink-0">
                <router-view v-slot="{ Component }">
                    <transition name="fade" mode="out-in">
                        <component :is="Component" :key="$route.name" />
                    </transition>
                </router-view>
            </div>
            <ShouldSignInPopup></ShouldSignInPopup>
            <div v-if="errors" class="text-red-500">
                <p v-for="(error, i) in errors">
                    {{ error.title }}
                    <span class="cursor-pointer" @click="removeError(i)"
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
import { useGetMeQuery } from "@/graph/generated"
import { loading as tLoading } from "@/i18n"
import Footer from "@/components/Footer.vue"
import Cookies from "@/components/Cookies.vue"
import ShouldSignInPopup from "@/components/ShouldSignInPopup.vue"

const { authenticated, shouldSignIn } = useAuth()

const analyticsQuery = useGetMeQuery({
    pause: true,
    variables: {},
})

onMounted(async () => {
    analytics.initialize(async () => {
        let analyticsId: string | null = null
        if (authenticated.value) {
            const result = await analyticsQuery.executeQuery()
            if (result.data.value?.me.analytics.anonymousId) {
                analyticsId = result.data.value.me.analytics.anonymousId
            }
        }
        return analyticsId
    })
})

init()
</script>
<style>
#stacked-layout {
    flex: 1 0 auto;
}
</style>
