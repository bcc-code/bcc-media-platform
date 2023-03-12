<template>
    <div
        class="fixed top-0 left-0 w-screen h-screen bg-[#FEECD0] z-50 text-[#422E1C] overflow-y-scroll overflow-x-hidden hide-scrollbar snap-mandatory snap-y"
        :ref="(el) => (parentScrollEl = el as any)"
    >
        <template v-if="parentScrollEl != null">
            <Page1 :parent-scroll-el="parentScrollEl" />
            <Page2 :parent-scroll-el="parentScrollEl" />
            <Page3 :parent-scroll-el="parentScrollEl" />
            <Page4 :parent-scroll-el="parentScrollEl" />
        </template>
    </div>
</template>

<script lang="ts" setup>
import Auth from "@/services/auth"
import { onMounted, onUnmounted, ref } from "vue"
import SotmShapeLong from "./greeting/SotmShapeLong.vue"
import { init } from "@sentry/vue"
import Parallax from "./greeting/Parallax.vue"
import Page1 from "./greeting/Page1.vue"
import Page2 from "./greeting/Page2.vue"
import Page3 from "./greeting/Page3.vue"
import Page4 from "./greeting/Page4.vue"

const pages = [""]
const displayName = ref("")
const parentScrollEl = ref<Element | null>(null)
const targetScrollEl = ref<Element | null>(null)
const targetScrollEl2 = ref<Element | null>(null)

const getUserInfo = async () => {
    let res = await fetch("https://login.bcc.no/userinfo", {
        headers: { Authorization: "Bearer " + (await Auth.getToken()) },
    })
    let response = await res.json()
    console.log(response)
    displayName.value = response.given_name
}

getUserInfo()

const animate = (ratio: number) => (diff: number) => {
    console.log(diff)
    return `transform: translate(0, ${-diff * ratio}px);`
}
</script>
