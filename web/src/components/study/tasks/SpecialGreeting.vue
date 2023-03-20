<template>
    <div
        class="h-48 w-screen max-w-screen-sm mx-auto h-full bg-[#FEECD0] z-50 text-[#422E1C] overflow-hidden font-['Palatino'] italic"
    >
        <Swiper
            :parallax="true"
            :scrollbar="false"
            :modules="[Mousewheel, Parallax]"
            ref="swiperEl"
            style="overflow: hidden"
            :lazy="false"
            direction="vertical"
            :mousewheel="true"
            :height="height"
            @swiper="onswipe"
            :auto-height="true"
            :speed="700"
            :touch-release-on-edges="true"
            :threshold="1"
        >
            <SwiperSlide>
                <Page1 :display-name="displayName"></Page1>
            </SwiperSlide>
            <SwiperSlide>
                <Page2></Page2>
            </SwiperSlide>
            <SwiperSlide>
                <Page3></Page3>
            </SwiperSlide>
            <SwiperSlide>
                <Page4></Page4>
            </SwiperSlide>
            <SwiperSlide>
                <Page5></Page5>
            </SwiperSlide>
            <SwiperSlide>
                <Page6></Page6>
            </SwiperSlide>
            <SwiperSlide>
                <Page7 :display-name="displayName"></Page7>
            </SwiperSlide>
        </Swiper>
    </div>
</template>

<script lang="ts" setup>
import Auth from "@/services/auth"
import { ref } from "vue"
import TSwiper, { Parallax, Mousewheel } from "swiper"
import { Swiper, SwiperSlide } from "swiper/vue"
import Page1 from "./greeting/Page1.vue"
import Page2 from "./greeting/Page2.vue"
import Page3 from "./greeting/Page3.vue"
import Page4 from "./greeting/Page4.vue"
import Page5 from "./greeting/Page5.vue"
import Page6 from "./greeting/Page6.vue"
import Page7 from "./greeting/Page7.vue"
import { useRoute } from "vue-router"

const height = window.innerHeight
const route = useRoute()
const displayName = ref<string | undefined>(route.query["name"]?.toString())
const getUserInfo = async () => {
    let res = await fetch("https://login2.bcc.no/userinfo", {
        headers: { Authorization: "Bearer " + (await Auth.getToken()) },
    })
    let response = await res.json()
    console.log(response)
    displayName.value = response.given_name
}
getUserInfo()

const onswipe = (swiper: TSwiper) => {}

const animate = (ratio: number) => (diff: number) => {
    console.log(diff)
    return `transform: translate(0, ${-diff * ratio}px);`
}
</script>

<style>
@import url("https://fonts.googleapis.com/css2?family=Work+Sans:ital,wght@0,300;0,400;0,500;0,600;0,700;1,300;1,400;1,500;1,700&display=block");
</style>
